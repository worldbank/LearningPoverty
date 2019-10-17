*==============================================================================*
* PROGRAM: SELECTS DATABASE FROM RAWFULL ACCORDING TO PREFERENCE
*==============================================================================*

cap program drop population_weights
program define   population_weights, rclass
  syntax , [                  ///
       PREFERENCE(string)			///
       TIMEwindow(string)     ///
       COUNTRYfilter(string)  ///
       ]

  qui {

  *-----------------
  * Check options
  *-----------------
  * If no preference is specified, uses the file in memory
  if "`preference'" == "" {
    * Check that the file contains a unique preference, or the code should break
    tab preference
    assert `r(r)'==1
    noi disp as txt "Applying weights to the already loaded file"
  }
  * If preference is specified, open that file from outputs
  else {
    use "${clone}/01_data/013_outputs/preference`preference'.dta", clear
  }

  * Generate dummy on whether assessment data in LP is inside TIMEWINDOW()
  * note that missing data on LP is considered outside the TIMEWINDOW()
  cap drop include_assessment
  if "`timewindow'" == "" {
    * If not specified, this becomes a simple test for whether LP data is available
    gen byte include_assessment = !missing(adj_nonprof_all)
  }
  else {
    * If specified, apply the condition to create the dummy
    cap gen byte include_assessment = (`timewindow') & !missing(adj_nonprof_all)
    if _rc != 0 {
      noi di as err `"The option TIMEWINDOW() is incorrectly specified. Good example: timewindow(year_assessment>=2011)"'
      break
    }
  }

  * Generate dummy on whether country is inside COUNTRYFILTER()
  cap drop include_country
  if "`countryfilter'" == "" {
    * If not specified, all observations are included
    gen byte include_country = 1
  }
  else {
    * If specified, apply the condition to create a dummy
    cap gen byte include_country = (`countryfilter')
    if _rc != 0 {
      noi di as err `"The option COUNTRYFILTER() is incorrectly specified. Good example: countryfilter(incomelevel!="HIC" & lendingtype!="LNX")"'
      break
    }
  }

  * A country learning poverty number is included only if it satisfies both the TIMEWINDOWN() and COUNTRYFILTER()
  cap drop  included_in_weights
  gen byte  included_in_weights = include_country * include_assessment
  label var included_in_weights "Observation is considered for aggregation weights"

  * Before we can create weights for each aggregation, we need this aux var
  * so that global is as much as a group as 'region' or 'incomelevel'
  * and we can do a single loop
  gen str global = "TOTAL"


  *--------------------
  * Aggregation weights
  *--------------------
  * For each possible aggregation level, the same calculation is performed
  local possible_aggregations "global region adminregion incomelevel lendingtype"
  foreach aggregation of local possible_aggregations {

    * Preemptly drop variable that will be created if they existed
    foreach ending in n_countries total_population population_w_data coverage weight {
      cap drop `aggregation'_`ending'
    }

    * The number of countries that will be used in the aggregation
    egen int  `aggregation'_n_countries = total(included_in_weights), by(`aggregation')
    label var `aggregation'_n_countries "Number of countries included in aggregation by `aggregation'"

    * Total population in the aggregation (ie: not excluded in the country filter)
    egen `aggregation'_total_population  = total(anchor_population * include_country), by(`aggregation')
    label var `aggregation'_total_population "Total population represented in aggregation by `aggregation'"

    * Population in the aggregation for which we have and will use learning poverty data (ie: also in the time windown)
    egen `aggregation'_population_w_data = total(anchor_population * included_in_weights), by(`aggregation')
    label var `aggregation'_population_w_data "Population with learning poverty data in aggregation by `aggregation'"

    * The coverage is the ratio of population with data over total population
    gen `aggregation'_coverage = `aggregation'_population_w_data / `aggregation'_total_population
    label var `aggregation'_coverage "Population coverage in aggregation by `aggregation'"

    * The weight we want is the population included, scaled by coverage
    * It is rounded to an integer number so it can be used as frequency weights
    * and interpreted as number of late primary age children
    gen long  `aggregation'_weight = round(included_in_weights * anchor_population / `aggregation'_coverage)
    label var `aggregation'_weight "Population scaled as weights for aggregation by `aggregation'"

  }

  * For global_weight, it was decided that we should use region_weights,
  * ie: a country with missing data in SSA is proxied by SSA average,
  * to avoid regional bias according to region _coverage
  replace global_weight = region_weight

  * Drop excessive amount of auxiliary variables created
  drop include_country include_assessment global



  *--------------------------------
  * Display number by region
  *--------------------------------
  local aggregation "region"
  if `"`countryfilter'"' == ""   local countryfilter "none (WORLD)"
  sum included_in_weights
  local n_included_countries = r(sum)

  noi di ""
  noi di as res  "Learning Poverty Global Number"
  noi di as res  "  preference:   `preference'"
  noi di as res `"  time window:  `timewindow'"'
  noi di as res `"  cty filters:  `countryfilter'"'
  noi di as res  "  # countries:  `n_included_countries'"
  noi tabstat adj_nonprof_all `aggregation'_population_w_data `aggregation'_total_population  [fw = `aggregation'_weight], by(`aggregation')  format(%20.1fc)

}

end
