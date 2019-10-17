*==============================================================================*
* PROGRAMS: CREATES TABLES WITH CONFIDENCE INTERVAL FOR TECHNICAL PAPER
*==============================================================================*

* 0.3.1 fixed typo on output line
* 0.3 add anchor year; and select variable closest to the anchore year
* 0.2 add the counstruction of Global weights + Global Weight Window + Global Weights Filter
* 0.1 run quietly with a NOIsily option JPA

*Author: Brian Stacy; Hongxi Zhao; Diana Goldberg; Kristopher Bjarkefur; Joao Pedro Azevedo


/*This an ado file:
1)Develops database for preferred list
The user must specify a number of options.
(1) nla() 		-	which dictates that the countries in the list are to use the National Learning Assessment.  This option takes countrycodes.
(2) threshold() - 	which dictates which threshold to use for the proficiency levels.  Current options are 0, I, II, IIB.
(3) droplist() 	-	which dictate which countries to not calculate proficiency levels.  This option takes country codes
(4) dropassess() 	-	which dictate which assessments to not calculate proficiency levels.  This option takes assessment names
(5) runname()	-	which dictates the name of the run.  It also identifies the run in the rawlatest file (i.e. preference="912")
(6) TIMSS()-dictates either math or science for TIMSS.  either enter string "math" or "science"
(7) enrollment()	-dictates which enrollment to use.  original enrollment, validated, or interpolated
(8) EGRADROP()	-drop specific EGRAs, 3rd grade, 4th grade, non-nationally representative.
As an example:  _preferred_list, nla(BGD CHN IND PAK) threshold(IIB) droplist(NGA PAK) dropassess(SACMEQ) runname(912) timss_subject(science)
Specifies that Bangladesh, China, India, and Pakistan use National Learning Assessments.  Threshold IIB is applied for all assessments.
*/
cap  program drop _preferred_list_tables_ci
program define _preferred_list_tables_ci, rclass
  version 14
    syntax  [,                          ///
            PREFERENCE(string)          ///
            POPULATION(string)          ///
            NOIsily                     ///
            GLOBALWEIGHT(string)        ///
            GLOBALWEIGHTWINDOW(string)  ///
            GLOBALWEIGHTFILTER(string)  ///
            ANCHORYEAR(string)          ///
            REPETITIONS(string)         ///
            RUNNAME(string)             ///
            ]

  * Apply checks

  if "`noisily'" != "" {
    local noi "noi"
  }
  else {
    local noi "qui"
  }

  * Rawlatest with merged non-proficiency split by gender from CLO
  use "${clone}/01_data/013_outputs/preference`preference'.dta", clear

  * Generate dummy on whether assessment is inside TIMEWINDOW()
  cap drop include_assessment
  if "`globalweightwindow'" == "" {
    * If not specified, all observations are included by default
    gen byte include_assessment = 1
  }
  else {
    * If specified, apply the condition to create a dummy
    cap gen byte include_assessment = (`globalweightwindow') & !missing(year_assessment)
    if _rc != 0 {
      noi di as err `"The option TIMEWINDOW() is incorrectly specified. Good example: timewindow(year_assessment>=2011)"'
      break
    }
  }


  * Generate dummy on whether country is inside COUNTRYFILTER()
  cap drop include_country
  if "`globalweightfilter'" == "" {
    * If not specified, all observations are included
    gen byte include_country = 1
  }
  else {
    * If specified, apply the condition to create a dummy
    cap gen byte include_country = (`globalweightfilter')
    if _rc != 0 {
      noi di as err `"The option COUNTRYFILTER() is incorrectly specified. Good example: countryfilter(incomelevel!="HIC" & lendingtype!="LNX")"'
      break
    }
  }

  // * Whether or not the confidence intervals will be calculated
  // if "`ci_repetitions'" != "" {
  //   local CI = 1
  // }
  // else {
  //   local CI = 0
  // }


  *----------------------------*
  * Calculation of pop weights *
  *----------------------------*

  * Tentatively drop pre-existing auxiliary and final variables to avoid errors:
  foreach var in wgt_included  wgt_population_total wgt_population_assessed wgt_scaling_factor weight_global_number {
    cap drop `var'
  }

  * The main variable we're set to build is wgt_pop, which is integer so we can use as frequency weights
  gen long  weight_global_number = .
  label var weight_global_number "Population scaled as weights for global/regional aggregations"

  * A country learning poverty number is POTENTIALLY included only if it satisfies both the TIMEWINDOWN() and COUNTRYFILTER()
  gen byte  wgt_included = include_country * include_assessment
  label var wgt_included "Observation is considered in global/regional aggregations"
  * Total 2015 population 10-14 years old that matters for the global number
  egen wgt_population_total    = total(anchor_population * include_country), by(`globalweight')
  * Total population for which some assessment data will be used in the calculation
  egen wgt_population_assessed = total(anchor_population_w_assessment * wgt_included), by(`globalweight')
  * Scaling factor (would be 1 if all kids were assessed, but it's more than 1)
  gen  wgt_scaling_factor = wgt_population_total / wgt_population_assessed
  label var wgt_scaling_factor "Scaling factor of population in global/regional aggregations"

  * The weight to use is the scaling up of those numbers:
  replace weight_global_number = round(anchor_population_w_assessment * wgt_included * wgt_scaling_factor) //if preference == "`preference'"
  * Except when there is no learning_poverty (prof)
  replace weight_global_number = . if adj_nonprof_all == .

  * Calculate population coverage
  gen pop_cov=100*wgt_population_assessed/wgt_population_total


  if "`globalweightfilter'" == ""  {
    * If not specified, all observations are included
    gen ctry_selected 			= 1
    gen ctry_assessment 			= 1 if (adj_nonprof_all != .) & ctry_selected == 1
    gen ctry_assessment_prefered 	= ctry_assessment if (`globalweightwindow') &  ctry_selected == 1
    egen countries=total(ctry_assessment_prefered), by(preference `globalweight')
  }
  else {
    * Countries
    gen ctry_selected 			= 1 if (`globalweightfilter')
    gen ctry_assessment 			= 1 if (adj_nonprof_all != .) & ctry_selected == 1
    gen ctry_assessment_prefered 	= ctry_assessment if (`globalweightwindow') & ctry_selected == 1
    egen countries=total(ctry_assessment_prefered), by(preference `globalweight')
  }

  **************************************************************************
  *Calculate Std Errors
  **************************************************************************

  * Bootstrap approach for std errors

  if "`repetitions'"!="" {
    forv i=1/`repetitions'  {

      preserve

        * Form new adjprof based on random draw in boostrap sim
        gen adj_nonprof_bs=100 * ( 1 - (enrollment_all/100) * (1 - rnormal(nonprof_all, se_nonprof_all)/100))
        collapse adj_nonprof_all adj_nonprof_bs  [fw=weight_global_number], by(`globalweight')
        gen rep=`i'
        tempfile temp`i'
        save "`temp`i''"

      restore

    }

    * Produce global total in similar way
    forv i=1/`repetitions'  {

      preserve

        * Form new adjprof based on random draw in boostrap sim
        gen adj_nonprof_bs=100 * ( 1 - (enrollment_all/100) * (1 - rnormal(nonprof_all, se_nonprof_all)/100))
        collapse adj_nonprof_all adj_nonprof_bs  [fw=weight_global_number],
        gen rep=`i'
        gen `globalweight' = "Global"
        tempfile temp`i'_total
        save "`temp`i'_total'"

      restore

    }

  }

  *****************************************
  ** Results
  *****************************************

  if ("`globalweight'" != "") {

    noi di ""
    noi di in g "runame: " in y "`runname'"
    noi di in g "weigths: " in y "weight_global_number by `globalweight'"
    noi di in g "filters: " in y `"`globalweightfilter'"'
    noi di in g "window: " in y "`globalweightwindow'"

    * Formatting for wgt_population_assessed wgt_population_total
    replace wgt_population_assessed=wgt_population_assessed/1000000
    replace wgt_population_total=wgt_population_total/1000000

    putexcel set "${clone}/03_export_tables/033_outputs/tabs_5_6_`runname'.xlsx", modify
    putexcel A1 = ("Tables 5 & 6 Combined")
    putexcel A2 = ("Country Groups")
    putexcel B2 = ("Learning Poverty")
    putexcel C2 = ("Population Coverage")
    putexcel D2 = ("Population w/ Assessment")
    putexcel E2 = ("Regional Population")
    putexcel F2 = ("Countries")
    putexcel G2 = ("Enrollment")

    putexcel H1 = ("Learning Poverty")
    putexcel H2 = ("Min")
    putexcel I2 = ("Max")
    putexcel J2 = ("S.E.")

    if "`globalweight'"=="region" {
      mat drop _all
      noi tabstat adj_nonprof_all pop_cov wgt_population_assessed wgt_population_total countries enrollment_all [fw=weight_global_number], by(`globalweight') missing format(%20.1fc) save

      * Because # of regions may change based on settings, rename matrices after tabstat
      forval i=1/8 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }

      return list
      // Mean
      putexcel A3 = ("By Region")
      putexcel A4 = (" EAP")	B4 = matrix(M_EAS)
      putexcel A5 = (" ECA")	B5 = matrix(M_ECS)
      putexcel A6 = (" LAC")	B6 = matrix(M_LCN)
      putexcel A7 = (" MNA")	B7 = matrix(M_MEA)
      cap putexcel A8 = (" NAC")	B8 = matrix(M_NAC)
      putexcel A9 = (" SAR")	B9 = matrix(M_SAS)
      putexcel A10 = (" SSF")	B10 = matrix(M_SSF)

      // Min
      mat drop _all
      noi tabstat adj_nonprof_all [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save missing stat(min)

      *Because # of regions may change based on settings, rename matrices after tabstat
      forval i=1/8 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }

      putexcel A4 = (" EAP")	H4 = matrix(M_EAS)
      putexcel A5 = (" ECA")	H5 = matrix(M_ECS)
      putexcel A6 = (" LAC")	H6 = matrix(M_LCN)
      putexcel A7 = (" MNA")	H7 = matrix(M_MEA)
      cap putexcel A8 = (" NAC")	H8 = matrix(M_NAC)
      putexcel A9 = (" SAR")	H9 = matrix(M_SAS)
      putexcel A10 = (" SSF")	H10 = matrix(M_SSF)

      // Max
      mat drop _all
      noi tabstat adj_nonprof_all  [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save missing stat(max)

      * Because # of regions may change based on settings, rename matrices after tabstat
      forval i=1/8 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }
      putexcel A4 = (" EAP")	I4 = matrix(M_EAS)
      putexcel A5 = (" ECA")	I5 = matrix(M_ECS)
      putexcel A6 = (" LAC")	I6 = matrix(M_LCN)
      putexcel A7 = (" MNA")	I7 = matrix(M_MEA)
      cap putexcel A8 = (" NAC")	I8 = matrix(M_NAC)
      putexcel A9 = (" SAR")	I9 = matrix(M_SAS)
      putexcel A10 = (" SSF")	I10 = matrix(M_SSF)

      // S.E.
      if "`repetitions'"!="" {

        preserve
          //Code on appending files together to produce S.E.
          clear
          use "`temp1'"
          append using "`temp1_total'"
          forv i=2/`repetitions'  {
            append using "`temp`i''"
            append using "`temp`i'_total'"
          }
          save "${clone}/03_export_tables/033_outputs/bs_reps_`globalweight'.dta", replace
          mat drop _all
          tabstat  adj_nonprof_bs, by(`globalweight') stat(sd) missing save

          *Because # of regions may change based on settings, rename matrices after tabstat
          forval i=1/8 {
            di "`r(name`i')'"
            local matname M_`r(name`i')'
            matrix `matname' = r(Stat`i')
          }

          noi return list
        restore

        putexcel A4 = (" EAP")					J4 = matrix(M_EAS)
        putexcel A5 = (" ECA")					J5 = matrix(M_ECS)
        putexcel A6 = (" LAC")					J6 = matrix(M_LCN)
        putexcel A7 = (" MNA")					J7 = matrix(M_MEA)
        cap putexcel A8 = (" NAC")				J8 = matrix(M_NAC)
        putexcel A9 = (" SAR")					J9 = matrix(M_SAS)
        putexcel A10 = (" SSF")					J10 = matrix(M_SSF)
        putexcel A21 = ("Total")				J21=matrix(M_Global)

      }

    }

    if "`globalweight'"=="lendingtype" {
      mat drop _all
      noi tabstat adj_nonprof_all pop_cov wgt_population_assessed wgt_population_total countries enrollment_all [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save
      return list
      * Because # of groups may change based on settings, rename matrices after tabstat
      forval i=1/5 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }

      putexcel A11 = ("By Lending Type")
      putexcel A12 = (" IBRD") 			B12 = matrix(M_IBD)
      putexcel A13 = (" Blend" )			B13 = matrix(M_IDB)
      putexcel A14 = (" IDA")				B14 = matrix(M_IDX)
      cap putexcel A15 = (" Not classified")	B15 = matrix(M_LNX)

      // Min
      mat drop _all
      noi tabstat adj_nonprof_all  [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save stat(min)

      * Because # of groups may change based on settings, rename matrices after tabstat
      forval i=1/5 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }
      putexcel A12 = (" IBRD") 	H12 = matrix(M_IBD)
      putexcel A13 = (" Blend" )	H13 = matrix(M_IDB)
      putexcel A14 = (" IDA")		H14 = matrix(M_IDX)
      cap putexcel A15 = (" Not classified")	H15 = matrix(M_LNX)

      // Max
      mat drop _all
      noi tabstat adj_nonprof_all  [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save stat(max)
      * Because # of groups may change based on settings, rename matrices after tabstat
      forval i=1/5 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }
      putexcel A12 = (" IBRD") 	I12 = matrix(M_IBD)
      putexcel A13 = (" Blend" )	I13 = matrix(M_IDB)
      putexcel A14 = (" IDA")		I14 = matrix(M_IDX)
      cap putexcel A15 = (" Not classified")	I15 = matrix(M_LNX)

      // S.E.
      if "`repetitions'"!="" {

        preserve

          * Code on appending files together to produce S.E.
          clear
          use "`temp1'"
          forv i=2/`repetitions'  {
            append using "`temp`i''"
          }
          save "${clone}/03_export_tables/033_outputs/bs_reps_`globalweight'.dta", replace
          tabstat  adj_nonprof_bs, by(`globalweight') stat(sd) save
          * Because # of groups may change based on settings, rename matrices after tabstat
          forval i=1/5 {
            di "`r(name`i')'"
            local matname M_`r(name`i')'
            matrix `matname' = r(Stat`i')
          }
          noi return list

        restore

        putexcel A12 = (" IBRD") 	J12 = matrix(M_IBD)
        putexcel A13 = (" Blend" )	J13 = matrix(M_IDB)
        putexcel A14 = (" IDA")		J14 = matrix(M_IDX)
        cap putexcel A15 = (" Not classified")	J15 = matrix(M_LNX)

      }

    }

    if "`globalweight'"=="incomelevel" {

      mat drop _all
      noi tabstat adj_nonprof_all pop_cov wgt_population_assessed wgt_population_total countries enrollment_all [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save
      * Because # of groups may change based on settings, rename matrices after tabstat
      forval i=1/5 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }
      return list
      putexcel A16  = ("By Income Level")
      cap putexcel A17 = (" High Income")			B17 = matrix(M_HIC)
      putexcel A18 = (" Upper middle income")	B18 = matrix(M_UMC)
      putexcel A19 = (" Lower middle income")	B19 = matrix(M_LMC)
      putexcel A20 = (" Low income")			B20 = matrix(M_LIC)

      // Min
      mat drop _all
      noi tabstat adj_nonprof_all  [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save stat(min)
      * Because # of groups may change based on settings, rename matrices after tabstat
      forval i=1/5 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }
      return list
      putexcel A16  = ("By Income Level")
      cap putexcel A17 = (" High Income")			H17 = matrix(M_HIC)
      putexcel A18 = (" Upper middle income")	H18 = matrix(M_UMC)
      putexcel A19 = (" Lower middle income")	H19 = matrix(M_LMC)
      putexcel A20 = (" Low income")			H20 = matrix(M_LIC)

      // Max
      mat drop _all
      noi tabstat adj_nonprof_all  [fw=weight_global_number], by(`globalweight')  format(%20.1fc) save stat(max)
      * Because # of groups may change based on settings, rename matrices after tabstat
      forval i=1/5 {
        di "`r(name`i')'"
        local matname M_`r(name`i')'
        matrix `matname' = r(Stat`i')
      }
      return list
      putexcel A16  = ("By Income Level")
      cap putexcel A17 = (" High Income")			I17 = matrix(M_HIC)
      putexcel A18 = (" Upper middle income")	I18 = matrix(M_UMC)
      putexcel A19 = (" Lower middle income")	I19 = matrix(M_LMC)
      putexcel A20 = (" Low income")			I20 = matrix(M_LIC)

      // S.E.
      if "`repetitions'"!="" {

        preserve

          //Code on appending files together to produce S.E.
          clear
          use "`temp1'"
          forv i=2/`repetitions'  {
            append using "`temp`i''"
          }
          save "${clone}/03_export_tables/033_outputs/bs_reps_`globalweight'.dta", replace
          mat drop _all
          tabstat  adj_nonprof_bs, by(`globalweight') stat(sd) save
          * Because # of groups may change based on settings, rename matrices after tabstat
          forval i=1/5 {
            di "`r(name`i')'"
            local matname M_`r(name`i')'
            matrix `matname' = r(Stat`i')
          }
          noi return list

        restore

        cap putexcel A17 = (" High Income")			J17 = matrix(M_HIC)
        putexcel A18 = (" Upper middle income")	J18 = matrix(M_UMC)
        putexcel A19 = (" Lower middle income")	J19 = matrix(M_LMC)
        putexcel A20 = (" Low income")			J20 = matrix(M_LIC)

      }

    }


    if "`globalweight'"=="region" {
      mat drop _all
      noi tabstat adj_nonprof_all pop_cov [fw=weight_global_number],   format(%20.1fc) save
      return list
      putexcel A21 = ("Total")				B21=matrix(r(StatTotal))
    }
  }

  else {
    noi di ""
    noi di in g "runame: " in y "`runname'"
    noi di in g "weigths: " in y "population_2015_all"
    noi di in g "filters: " in y "none"
    noi di in g "window: " in y "none"
    noi tabstat adj_nonprof_all population_2015_all [fw=population_2015_all], by(region)  format(%20.1fc)
  }

  *****************************************

  *****************************************


  *****************************************
  ** Results for log decomposition
  *****************************************
  if ("`globalweight'" != "") {
    noi di ""
    noi di in g "runame: " in y "`runname'"
    noi di in g "weigths: " in y "weight_global_number by `globalweight'"
    noi di in g "filters: " in y `"`globalweightfilter'"'
    noi di in g "window: " in y "`globalweightwindow'"

    gen adj_pct_reading_low=100-adj_nonprof_all
    gen pct_reading_low_target=1-nonprof_all/100

    foreach var in adj_pct_reading_low pct_reading_low_target enrollment_all {
      gen log_`var'=log(`var')
    }

    gen frac_enrollment=100*log_enrollment_all/(log_enrollment_all+log_pct_reading_low_target)
    gen frac_proficiency=100*log_pct_reading_low_target/(log_enrollment_all+log_pct_reading_low_target)

    if "`globalweight'"=="region" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8_`runname'_country.xlsx", firstrow(varl) replace
    }

    if "`globalweight'"=="lendingtype" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8b_`runname'_country.xlsx", firstrow(varl)  replace
    }

    if "`globalweight'"=="incomelevel" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8c_`runname'_country.xlsx", firstrow(varl)  replace
    }

    tempfile temp
    preserve
      collapse  adj_pct_reading_low pct_reading_low_target enrollment_all pop_cov wgt_population_assessed wgt_population_total countries [fw=weight_global_number]
      gen `globalweight'="Overall"
      save `temp'
    restore

    mat drop _all

    collapse adj_pct_reading_low pct_reading_low_target enrollment_all pop_cov wgt_population_assessed wgt_population_total countries [fw=weight_global_number], by(`globalweight')

    append using `temp'
    replace adj_pct_reading_low=adj_pct_reading_low/100
    replace enrollment_all=enrollment_all/100

    * Generate log learning poverty measures
    foreach var in adj_pct_reading_low pct_reading_low_target enrollment_all {
      gen log_`var'=log(`var')
    }

    gen frac_enrollment=100*log_enrollment_all/(log_enrollment_all+log_pct_reading_low_target)
    gen frac_proficiency=100*log_pct_reading_low_target/(log_enrollment_all+log_pct_reading_low_target)

    label var `globalweight' "Group"
    label var adj_pct_reading_low "Adjusted Proficiency"
    label var pct_reading_low_target "Proficiency"
    label var enrollment_all "Enrollment"
    label var pop_cov "Percent of Population Covered"
    label var wgt_population_assessed "Total population for which assessment will be included"
    label var wgt_population_total "Total population 10-14 years old"
    label var countries "Number of Countries"
    label var log_adj_pct_reading_low "Log Adjusted Proficiency"
    label var log_pct_reading_low_target "Log Proficiency"
    label var log_enrollment_all "Log Enrollment"
    label var frac_enrollment "Percentage of Log Adj Proficiency Explained by Enrollment"
    label var frac_proficiency "Percentage of Log Adj Proficiency Explained by Proficiency"

    if "`globalweight'"=="region" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8_`runname'.xlsx", firstrow(varl) replace
    }

    if "`globalweight'"=="lendingtype" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8b_`runname'.xlsx", firstrow(varl)  replace
    }

    if "`globalweight'"=="incomelevel" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8c_`runname'.xlsx", firstrow(varl)  replace
    }

    loc preference `preference'
    loc enrollment validated
    loc inputfolder clone

    use "${`inputfolder'}/01_data/013_outputs/rawfull.dta", clear
    gen year=year_assessment
    *nla_code should be distributed over s rather than being available in each .

    *temporarily rename test to assessment and idgrade to grade, change back after merge.
    rename test assessment
    rename idgrade grade

    *------------------------------*
    * Learning poverty calculation
    *------------------------------*
    * Adjusts non-proficiency by out-of school
    foreach subgroup in all fe ma {
      gen adj_nonprof_`subgroup' = 100 * ( 1 - (enrollment_validated_`subgroup'/100) * (1 - nonprof_`subgroup'/100))
      label var adj_nonprof_`subgroup' "Learning Poverty (adjusted non-proficiency, `subgroup')"
    }

    gen adj_pct_reading_low_rawfull= 100-adj_nonprof_all

    merge m:1 countrycode   using "${`inputfolder'}/01_data/013_outputs/preference`preference'.dta", keepusing(test idgrade incomelevel lendingtype nonprof_all)
    gen adj_pct_reading_low= 100-adj_nonprof_all

    * Change name in rawlatest of assessment to test_rawlatest, and revert back to test from assessment
    rename adj_pct_reading_low adj_pct_reading_low_rawlatest
    rename adj_pct_reading_low_rawfull adj_pct_reading_low

    gen initial_poverty_level_temp=100-adj_pct_reading_low_rawlatest
    cap gen initial_poverty_level="0-25% Learning Poverty"
    cap replace initial_poverty_level="25-50% Learning Poverty" if initial_poverty_level_temp>=25
    cap replace initial_poverty_level="50-75% Learning Poverty" if initial_poverty_level_temp>=50
    cap replace initial_poverty_level="75-100% Learning Poverty"  if initial_poverty_level_temp>=75

    rename test test_rawlatest
    rename assessment test

    *Same for grade
    rename idgrade idgrade_rawlatest
    rename grade idgrade

    drop if _merge==1

    gen enrollment=enrollment_validated_all
    drop if subject!="science" & test=="TIMSS"  & countrycode!="JOR"

    sort countrycode nla_code idgrade  test subject
    count

    cap gen adj_pct_reading_low=100-adj_nonprof_all
    cap gen pct_reading_low_target=100-nonprof_all

    * Cleaning the data file
    keep region regionname countrycode countryname incomelevel incomelevelname lendingtype ///
         lendingtypename year_population year_assessment idgrade test source_assessment  	///
         enrollment  	///
         adj_pct_reading_low* pct_reading_low_target enrollment* subject nla_code  initial_poverty_level

    * Generating all possible combinations of forward spells:
    sort countrycode nla_code idgrade  test subject    year_assessment
    bysort countrycode nla_code idgrade  test subject   : gen spell_c1 =  string(year_assessment[_n-1]) + "-" + string(year_assessment)

    bysort countrycode nla_code idgrade  test subject   : gen spell_c2 = string(year_assessment[_n-2]) + "-" + string(year_assessment)
    bysort countrycode nla_code idgrade  test subject   : gen spell_c3 = string(year_assessment[_n-3]) + "-" + string(year_assessment)
    bysort countrycode nla_code idgrade  test subject   : gen spell_c4 = string(year_assessment[_n-4]) + "-" + string(year_assessment)

    reshape long spell_c, i(countrycode nla_code idgrade  test subject year_assessment subject) j(lag)
    ren spell_c spell

    * Tag if actual spell:
    gen spell_exists=(length(spell) == 9 )

    **********************************************
    *Preparing the data for simulations:
    **********************************************
    *The data should be restructured for unique identifiers:
    sort countrycode nla_code idgrade  test subject    year_assessment spell lag

    *Rules for cleaning the spell data:
    *Bringing in the list of countries and spells for which the data is not comparable:

    merge m:1 countrycode idgrade test year_assessment spell using  "${clone}\02_simulation\021_rawdata\comparability_TIMSS_PIRLS_yr.dta", assert(master match using) keep(master match) keepusing(comparable) nogen
    drop if comparable == 0

    *Generating preferred consecutive spells:
    sort countrycode nla_code idgrade  test subject    year_assessment
    bysort countrycode nla_code idgrade  test subject   : egen lag_min = min(lag)
    *Keeping the comparable consecutive spells
    keep if lag == lag_min

    *All comparable spells for TIMSS/PIRLS
    assert comparable == 1 if !missing(comparable)

    *Annual change in enrollment, adjusted proficiency and proficiency
    sort countrycode nla_code idgrade  test subject   year_assessment
    bysort countrycode nla_code idgrade  test subject  : gen delta_adj_pct = ((adj_pct_reading_low-adj_pct_reading_low[_n-1])/(year_assessment-year_assessment[_n-1]))
    bysort countrycode nla_code idgrade  test subject   : gen initial_adj_pct = adj_pct_reading_low[_n-1]
    bysort countrycode nla_code idgrade  test subject   : gen final_adj_pct = adj_pct_reading_low

    *Annualized log change for decomposition
    bysort countrycode nla_code idgrade  test subject   : gen delta_log_adj_pct = ((log(adj_pct_reading_low)-log(adj_pct_reading_low[_n-1]))/(year_assessment-year_assessment[_n-1]))
    bysort countrycode nla_code idgrade  test subject   : gen delta_log_prof = ((log(pct_reading_low_target)-log(pct_reading_low_target[_n-1]))/(year_assessment-year_assessment[_n-1]))
    bysort countrycode nla_code idgrade  test subject   : gen delta_log_enrollment = ((log(enrollment)-log(enrollment[_n-1]))/(year_assessment-year_assessment[_n-1]))

    bysort countrycode nla_code idgrade  test subject   : gen delta_prof = (pct_reading_low_target-pct_reading_low_target[_n-1])/(year_assessment-year_assessment[_n-1])
    bysort countrycode nla_code idgrade  test subject   : gen delta_enrollment_all = (enrollment_interpolated_all-enrollment_interpolated_all[_n-1])/(year_assessment-year_assessment[_n-1])

    *drop observatoins specified by [if] [in].
    if `"`ifspell'"'!=""  {
      di `"`ifspell'"'
      keep `ifspell'
    }


    /* weights */

    if ("`weight'" == "") {
      cap tempname wtg
      cap gen `wtg' = 1
      local weight2 ""
      loc weight "fw"
      loc exp    "=`wtg'"
    }


    * Generating deltas in terms of reduction of gap to the frontier
    gen gap_to_frontier = 100-adj_pct_reading_low
    bysort countrycode nla_code idgrade  test subject   : gen red_gap_frontier = -1*(gap_to_frontier-gap_to_frontier[_n-1])/(year_assessment-year_assessment[_n-1])
    bysort countrycode nla_code idgrade  test subject   : gen pct_red_gap = (red_gap_frontier/gap_to_frontier[_n-1])
    gen pct_red_gap_100 = pct_red_gap*100


    *Following threshold IIB specification as the baseline file to be used will be threshold IIB.
    *Not using spell data for SACMEQ 2007 - SACMEQ 2013:
    *replace delta_adj_pct = . if test == "SACMEQ" & year == 2013
    *replace pct_red_gap_100 = . if test == "SACMEQ" & year == 2013

    * Generating categories of countries
    gen catinitial = .
    foreach var in 25 50 75 100 {
      replace catinitial= `var' if initial_adj_pct  <= `var' & catinitial== .
    }

    gen initial_learning_poverty = 100-initial_adj_pct


    ****************************************************************
    * Identify only selected spells (n=71)

    keep if test != "no assessment" & test != "EGRA" & delta_adj_pct != . & delta_adj_pct > -2 & delta_adj_pct < 4 & test != "PASEC" & year_assessment>2000 & lendingtype!="LNX" & test!="NLA"
    bysort countrycode : gen tot = _N
    gen wtg = 1/tot

    preserve

      keep countrycode countryname region incomelevel idgrade test year_assessment spell adj_pct_reading_low pct_reading_low_target enrollment_interpolated_all  delta_adj_pct delta_prof delta_enrollment_all delta_log_adj_pct delta_log_prof delta_log_enrollment

      keep if !missing(delta_adj_pct)

      gen frac_proficiency=100*delta_log_prof/(delta_log_prof+delta_log_enrollment)
      gen frac_enrollment_all=100*delta_log_enrollment/(delta_log_prof+delta_log_enrollment)

      label var adj_pct_reading_low "Adjusted Proficiency"
      label var pct_reading_low_target "Proficiency"
      label var enrollment_interpolated_all "Enrollment"
      label var delta_adj_pct "Annualized Change in Adjusted Proficiency"
      label var delta_prof "Annualized Change in Proficiency"
      label var delta_enrollment_all "Annualized Change in Enrollment"

      label var delta_log_adj_pct "Log Annualized Change in Adjusted Proficiency"
      label var delta_log_prof "Log Annualized Change in Proficiency"
      label var delta_log_enrollment "Log Annualized Change in Enrollment"
      label var frac_enrollment_all "Percentage of Log Annualized Change in Adjusted Proficiency due to Enrollment"
      label var frac_proficiency "Percentage of Log Annualized Change in Adjusted Proficiency due to Proficiency"

      if "`globalweight'"=="region" {
        export excel using "${clone}/03_export_tables/033_outputs/tabs_8_spells_country_`runname'.xlsx", firstrow(varl) replace
      }

    restore

    tempfile temp2

    preserve
      collapse  adj_pct_reading_low pct_reading_low_target enrollment_interpolated_all  delta_adj_pct delta_prof delta_enrollment_all delta_log_adj_pct delta_log_prof delta_log_enrollment [aw=wtg]
      gen `globalweight'="Overall"
      save `temp2'
    restore

    collapse  adj_pct_reading_low pct_reading_low_target enrollment_interpolated_all  delta_adj_pct delta_prof delta_enrollment_all delta_log_adj_pct delta_log_prof delta_log_enrollment [aw=wtg], by(`globalweight')

    append using `temp2'

    replace pct_reading_low_target=pct_reading_low_target
    replace delta_prof=delta_prof

    keep if !missing(delta_adj_pct)


    gen frac_proficiency=100*delta_log_prof/(delta_log_prof+delta_log_enrollment)
    gen frac_enrollment_all=100*delta_log_enrollment/(delta_log_prof+delta_log_enrollment)

    label var `globalweight' "Group"
    label var adj_pct_reading_low "Adjusted Proficiency"
    label var pct_reading_low_target "Proficiency"
    label var enrollment_interpolated_all "Enrollment"
    label var delta_adj_pct "Annualized Change in Adjusted Proficiency"
    label var delta_prof "Annualized Change in Proficiency"
    label var delta_enrollment_all "Annualized Change in Enrollment"

    label var delta_log_adj_pct "Log Annualized Change in Adjusted Proficiency"
    label var delta_log_prof "Log Annualized Change in Proficiency"
    label var delta_log_enrollment "Log Annualized Change in Enrollment"
    label var frac_enrollment_all "Percentage of Log Annualized Change in Adjusted Proficiency due to Enrollment"
    label var frac_proficiency "Percentage of Log Annualized Change in Adjusted Proficiency due to Proficiency"

    if "`globalweight'"=="region" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8_spells_`runname'.xlsx", firstrow(varl) replace
    }

    if "`globalweight'"=="lendingtype" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8b_spells_`runname'.xlsx", firstrow(varl)  replace
    }

    if "`globalweight'"=="incomelevel" {
      export excel using "${clone}/03_export_tables/033_outputs/tabs_8c_spells_`runname'.xlsx", firstrow(varl)  replace
    }

  }

end
