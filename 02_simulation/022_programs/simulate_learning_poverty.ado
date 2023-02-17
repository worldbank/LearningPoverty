/* This ADO was inspired by the _simulation_dataset that can be found
   in old_version. But it has far fewer options, with the upside of a
   more transparent calculation proceess. It only works from a prior
   calculation and classification of all spells (0220_create_all_spells)
   and a MANDATORY usefile option. Preference is also MANDATORY.
*/

cap  program drop simulate_learning_poverty
program define    simulate_learning_poverty, rclass

  version 15
  syntax  ,                       ///
          FILENAME(string)        ///
          GROUPINGSPELLS(string)  ///
          USEFILE(string)         ///
          PREFERENCE(string)      ///
          [                       ///
          COUNTRYFILTER(string)   ///
          TIMEWINDOW(string)      ///
          IFSPELL(string)         ///
          MINSPELL(integer 1)     ///
          PERCENTILE(string)      ///
          GROUPINGSIM(string)     ///
          quiet                   ///
          ]

  quietly {

    ***********************************************
    ********** OPTION CHECKING & SETUP ************
    ***********************************************

    if "`quiet'" == "" {
      local qui "noi "
    }

    if "`percentile'" == "" {
      local percentile "50(10)90"
    }

    * Valid options are: region incomelevel initial_poverty_level
    if "`groupingspells'" == "initial_poverty_level" {
      local growthdynamics "Yes"
    }

    * Valid options are: region adminregion incomelevel lendingtype
    if "`groupingsim'" == "" {
      local groupingsim "region"
    }

    * Import growth rates defined in a markdown file if the usefile() option is specified
    *------------------------------------------------------
    if "`usefile'" != "" {

      import delimited "`usefile'", delimiter("|") varnames(1) clear

      cap drop v1
      cap drop v9
      drop if _n==1

      replace `groupingspells' = strtrim(`groupingspells')
      replace `groupingspells' = subinstr(`groupingspells', "`=char(9)'", "", .)

      describe delta_reg_?_??, varlist
      foreach var in `r(varlist)' {
        destring  `var', replace
        label var `var' "Annualized learning poverty change for group and percentile"
      }
      destring n_spells, replace
      label var n_spells "N spells in the group"

      * Weighted and unweighted variables had been given different names
      cap rename  delta_reg_w_*  delta_reg_*
      cap rename  delta_reg_u_*  delta_reg_*

      local  usefile2 = subinstr("`usefile'", ".md", ".dta",.)
      save "`usefile2'", replace

      * Display values that will be used
      cap replace `groupingspells' = "_Overall" if `groupingspells' == "Overall"
      `qui' display _n "Spells assigned in simulation (N countries, BaU and High)"
      `qui' tabstat n_spells delta_reg_50 delta_reg_80, by(`groupingspells') nototal format(%4.2fc)
    }

    * Gets country own rates from full spell database
    *------------------------------------------------------
    * Starts with all the spells
    use "${clone}/02_simulation/023_outputs/all_spells.dta", clear

    * Keep only observations specified by. Ie: "if used sim == 1"
    if `"`ifspell'"' != ""  keep `ifspell'

    * Does not need to be weighted, as it collapses by country
    collapse (mean) delta_lp_own = delta_lp (count) n_spells_own = delta_lp , by(countrycode)

    * Country own number will be discarded if composed by less than the minimum number of spells
    drop if n_spells_own < `minspell'

    `qui' disp as result _n "N countries with own spell used in BaU `=_N' (n_spells_own >= `minspell')"

    * Save list of all countries with some own spell
    label var n_spells_own "N own country spells"
    label var delta_lp_own "Average own country spells"
    save "${clone}/02_simulation/023_outputs/`filename'_ownspells.dta", replace emptyok


    ***********************************************
    ********** PART 1 - BASELINE 2015  ************
    ***********************************************

    * Starting point is a given preference with the time and countryfilters
    * Note that this ado already opens the preference file
    population_weights, preference(`preference') timewindow(`timewindow') countryfilter(`countryfilter') combine_ida_blend

    * Creates initial learning poverty level
    gen initial_poverty_level = ""
    replace initial_poverty_level = "0-25% Learning Poverty"   if !missing(lpv_all)
    replace initial_poverty_level = "25-50% Learning Poverty"  if lpv_all >= 25 & !missing(lpv_all)
    replace initial_poverty_level = "50-75% Learning Poverty"  if lpv_all >= 50 & !missing(lpv_all)
    replace initial_poverty_level = "75-100% Learning Poverty" if lpv_all >= 75 & !missing(lpv_all)
    label var initial_poverty_level "Categorical string variable on initial Learning Poverty (2015)"

    * Complement from learning poverty
    gen baseline = 100 - lpv_all
    label var baseline "Adjusted proficiency at baseline"
    rename lpv_all lpv_baseline
    label var lpv_baseline "Learning poverty at baseline"
    format %3.1f *baseline

    * Only relevant variables
    order countrycode baseline lpv_baseline included_in_weights include_country ///
          region incomelevel lendingtype initial_poverty_level preference
    keep countrycode - preference

    * Brings in own spells (delta_lp_own)
    merge 1:1 countrycode using "${clone}/02_simulation/023_outputs/`filename'_ownspells.dta", keep(master match) nogen

    * Brings in grouping spells from md (delta_reg_??)
    merge m:1 `groupingspells' using "`usefile2'", keep(master match) keepusing(delta_reg*) nogen

    * Combines both spells info
    forvalues i = `percentile' {
      * Replaces group by own value if available (regardless of value)
      if `i'<=50   replace delta_reg_`i' = delta_lp_own if !missing(delta_lp_own)
      * Replaces group by own value only if bigger, that is, don't slow down
      * countries that have growth rates higher than the group average
      else         replace delta_reg_`i' = delta_lp_own if delta_lp_own > delta_reg_`i' & !missing(delta_lp_own)
    }
    * Replaces own value for p50 of group if own is not available
    replace delta_lp_own = delta_reg_50 if missing(delta_lp_own)

    * Save baseline simulation file
    compress
    save "${clone}/02_simulation/023_outputs/`filename'_baseline.dta", replace

    ****************************************************************************

    * Some wild renaming. See if could rather change names in the start.
    * Rename variables in a consistent logic to be able to reshape long
    rename delta_lp_own         growei_own
    forvalues i = `percentile' {
      rename delta_reg_`i'      growei_r`i'
    }
    drop n_spells_own

    * Transform the dataset in long
    reshape long growei, i(countrycode `groupingspells' baseline) j(benchmark) string
    rename ( growei ) ( rategrowei )
    label var benchmark "Benchmark (ie: own, r80)"

    * This is reminescent of a time when there were 7 rate_flavors
    reshape long rate, i(countrycode `groupingspells' baseline benchmark) j(rate_flavor) string
    label var rate         "Rate used in simulation"
    label var rate_flavor "Rate flavor (ie: growth, growei, reduct) "

    * Describes input flavor
    gen str50 input_flavor = "preference: " + preference
    replace input_flavor = input_flavor + " | rate_flavor: " + rate_flavor
    replace input_flavor = input_flavor + " | benchmark: " + benchmark
    label var input_flavor "Short for: Benchmark Scenario | Rate Method | Latest Prefence"


    /* At some point we had 21 different versions of simulation methods
      7 possible "benchmark"
      - own = own country historical, business as usual
      - r70, r80, r90 = region percentiles 70, 80, 90
      - g70, g80, g90 = global percentiles 70, 80, 90
      3 possible "rateflavor"
      - reduct = rate applied in (100 - baseline), hopefully a negative rate
      - growth = rate applied in baseline, hopefully a positive rate
      - growei = rate applied in baseline (same as above), but constructed from weighted something

      But now we have set into 2 benchmarks (own = BaU and r80 = High)
      and a single rateflavor = growei
    */

    * Dynamically calculated growth rates (particularly for growth rates based on initial learning poverty categories)
    *==================================================
    if "`groupingspells'" == "initial_poverty_level" {
      levelsof initial_poverty_level, local(pov_levels)
      levelsof input_flavor, local(flavors)
      local counter=1
      foreach pov_lev of local pov_levels {
        gen rate_`counter' = .
        label var rate_`counter' "`pov_lev'"
        foreach flav of local flavors {
          sum rate if input_flavor == "`flav'" & initial_poverty_level == "`pov_lev'"
          replace rate_`counter'=`r(mean)' if input_flavor == "`flav'"
        }
        replace rate_`counter'=rate if benchmark=="_own"
        local counter = `counter' + 1
      }
    }


    ***********************************************
    ********** PART 2 - NOW SIMULATE  *************
    ***********************************************


    * Step 1. Simulate future adjusted proficiency
    *==================================================

    * Advances adjusted proficiency (adjpro) for all year_populations to simulate
    * Each adjpro_year_population is created as column, then it is reshaped to long

    forvalues i = 2015/2050 {     // CHANGE HERE FOR A LONGER HORIZON

      gen adjpro`i' = .
      gen rate`i'   = rate
      * Flavor that uses a MULTIPLICATIVE rate (reduct)
      replace adjpro`i' = 100 - (100-baseline)*((1-rate)^(`i'-2015))  if ( strpos(input_flavor, "reduct")  & !missing(baseline))
      * Flavors that use an ADDITIVE rate (growth or growei)
      replace adjpro`i' = baseline + rate*(`i'-2015)                  if (!strpos(input_flavor, "reduct")  & !missing(baseline))

      *Add dynamics to simulations based on initial poverty level
      if "`groupingspells'" == "initial_poverty_level" & "`growthdynamics'" == "Yes"{
        if `i'>2015 {
          local j=`i'-1
          replace adjpro`i' = adjpro`j' + rate_4      if (!strpos(input_flavor, "reduct") & !missing(baseline))
          replace adjpro`i' = adjpro`j' + rate_3      if adjpro`j'>=25 & (!strpos(input_flavor, "reduct") & !missing(baseline))
          replace adjpro`i' = adjpro`j' + rate_2      if adjpro`j'>=50 & (!strpos(input_flavor, "reduct") & !missing(baseline))
          replace adjpro`i' = adjpro`j' + rate_1      if adjpro`j'>=75 & (!strpos(input_flavor, "reduct") & !missing(baseline))
        }
      }

      replace adjpro`i' = 100 if ( adjpro`i' > 100  &  !missing(adjpro`i') )   // Upper bound is 100
      replace adjpro`i' = 0   if ( adjpro`i' < 0    &  !missing(adjpro`i') )  // Lower bound is 0
    }

    reshape long adjpro, i(countrycode input_flavor baseline rate) j(year)
    label var year "Year"

    * Housekeeping and save intermediate file
    label var adjpro "Share of non learning poor"
    gen lpv = 100 - adjpro
    label var lpv "Share of learning poor"
    format lpv adjpro %4.2f

    compress
    save "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace


    * Step 2. Merge Population projections (1960-2050)
    *==================================================
    use  "${clone}/01_data/013_outputs/population.dta" , clear
    clonevar population = population_all_1014
    clonevar year = year_population
    keep countrycode year population
    tempfile popdata
    save `popdata', replace

    * Open long learning poverty rates to merge population
    use "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace
    merge m:1 countrycode year using `popdata', keep(master match) nogen

    * Save long dataset with all countries and population info
    order countrycode year population included_in_weights include_country ///
          adjpro lpv baseline lpv_baseline  rate ///
          region incomelevel lendingtype initial_poverty_level ///
          rate_flavor benchmark preference input_flavor rate????
    save "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace


    * Step 3. Add weights to enable groupingspells (ie: regions) overall achievement
    *===============================================================================

    * Adapted from 01262_population_weights

    * Error check - the below tables will only be correct if this is true
    isid countrycode year input_flavor

    * Truly total population (regardless of filter)
    egen group_unfiltered_population = total(population),                   by(`groupingsim' year input_flavor)
    * Total population in the aggregation (ie: not excluded in the country filter)
    egen group_total_population  = total(population * include_country),     by(`groupingsim' year input_flavor)
    * Population in the aggregation for which we have and will use learning poverty data (ie: also in the time windown)
    egen group_population_w_data = total(population * included_in_weights), by(`groupingsim' year input_flavor)
    * The coverage is the ratio of population with data over total population
    gen  group_coverage = group_population_w_data / group_total_population

    * The weight we want is the population included, scaled by coverage
    * It is rounded to an integer number so it can be used as frequency weights
    * and interpreted as number of late primary age children
    gen long  `groupingsim'_weight = round(included_in_weights * population / group_coverage)

    * Save the long file with weights
    save "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace




    * Step 4. Collapse values by groupingspells (ie: regions) into new file
    *===============================================================================
    * As of now the code is only creating growei, but just to be safe
    keep if (preference == "`preference'" & rate_flavor == "growei")
    isid countrycode year benchmark

    collapse (mean) lpv (first) total_population = group_total_population ///
              [fw = `groupingsim'_weight], ///
              by(`groupingsim' year benchmark)

    gen learning_poor = total_population * lpv / 100
    replace benchmark = benchmark + "_"

    * Creates line with goverall
    tempfile overall

    preserve
      collapse (mean) lpv [fw = total_population], by(year benchmark)
      save `overall', replace
    restore
    preserve
      collapse (sum) total_population learning_poor, by(year benchmark)
      merge 1:1 year benchmark using "`overall'", nogen
      gen `groupingsim' = "_Overall"
      save `overall', replace
    restore

    append using `overall'

    save "${clone}/02_simulation/023_outputs/`filename'_fulltable.dta", replace


    * Step 5. Creates a summary of file with just what is displayed in the paper
    *===============================================================================

    * Only keep years and scenarios (what will actually be displayed in paper)
    keep if year==2015 | year==2030
    keep if inlist(benchmark, "_own_", "_r80_")
    reshape wide lpv  learning_poor , i(`groupingsim' total_population year) j(benchmark) string
    reshape wide lpv* learning_poor* total_population, i(`groupingsim') j(year)

    * Population in millions
    gen pop_2015 = total_population2015 / 1E6
    gen pop_2030 = total_population2030  / 1E6
    label var pop_2015 "Population 2015 (millions)"
    label var pop_2030 "Population 2030 (millions)"

    label var lpv_own_2015  "Learning Poverty 2015, base (%)"
    label var lpv_own_2030  "Learning Poverty 2030, BaU (%)"
    label var lpv_r80_2030  "Learning Poverty 2030, High (%)"

    * Learning poor as share of total
    foreach snapshot in own_2015 own_2030 r80_2030 {
      sum learning_poor_`snapshot' if region == "_Overall"
      gen lps_`snapshot' = 100 * learning_poor_`snapshot' / `r(sum)'
    }
    label var lps_own_2015  "Share of Learning Poor 2015, base (%)"
    label var lps_own_2030  "Share of Learning Poor 2030, BaU (%)"
    label var lps_r80_2030  "Share of Learning Poor, High (%)"

    order `groupingsim' pop_2015 pop_2030 lpv_own_2015 lpv_own_2030 lpv_r80_2030 lps_own_2015 lps_own_2030 lps_r80_2030
    keep  `groupingsim' - lps_r80_2030

    * Saves this summary version as a csv and dta
    save "${clone}/02_simulation/023_outputs/`filename'_summarytable.dta", replace
    export delimited using "${clone}/02_simulation/023_outputs/`filename'_summarytable.csv", replace

    * Display results for 2030
    drop if `groupingsim' == "_Overall" // since this line will be calculated with tabstats

    `qui' di ""
    `qui' di as res  "Learning Poverty Simulated Global Numbers"
    `qui' di as txt  "  preference:   `preference'"
    `qui' di as txt `"  time window:  `timewindow'"'
    `qui' di as txt `"  cty filters:  `countryfilter'"'
    `qui' di as res _n "Baseline (2015)"
    `qui' tabstat lpv_own_2015 [aw = pop_2015], by(`groupingsim')  format(%4.2fc)
    `qui' di as res _n "BaU (2030) | High (2030)"
    `qui' tabstat lpv_own_2030 lpv_r80_2030 [aw = pop_2030], by(`groupingsim')  format(%4.2fc)


    noi di _n as res "This simulation concluded."

    * Close the quietly
  }

end
