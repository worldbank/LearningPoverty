*==============================================================================*
* 0324 SUBTASK: EXPORT INDICATOR SERIES FOR WDI (WB API)
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference

  * Countries we don't want to report
  local countries_not_reported "CUB"

  *--------------------
  * Aggregates
  *--------------------

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear

  * Excludes any countries that we want to avoid reporting
  * NOTE: they are being dropped both from the aggregate and cty level
  foreach country of local countries_not_reported {
    drop if countrycode == "`country'"
  }

  * Get proper regional and incomelevel averages - PART2 countries
  population_weights, timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")
  gen part2 = "WBC"

  * Creates aggregated values of Learning Poverty, Below Minimum Prof and Enrollment by gender subgroups
  local possible_subgroups "all fe ma"
  foreach subgroup of local possible_subgroups {
    egen part2_lpov_`subgroup' = wtmean(adj_nonprof_`subgroup'), weight(global_weight)
    egen part2_bmp_`subgroup'  = wtmean(nonprof_`subgroup'),     weight(global_weight)
    egen part2_enr_`subgroup'  = wtmean(enrollment_`subgroup'),  weight(global_weight)
    * From Enrollment to Out-of-School
    gen part2_oos_`subgroup' = 100 - part2_enr_`subgroup'
  }


  * Get proper regional and incomelevel averages - WORLD
  population_weights, timewindow(year_assessment>=2013)
  gen global = "WLD"

  * Creates aggregated values of Learning Poverty, Below Minimum Prof and Enrollment by gender subgroups
  local possible_subgroups    "all fe ma"
  local possible_aggregations "global region adminregion incomelevel lendingtype"
  foreach aggregation of local possible_aggregations {
    foreach subgroup of local possible_subgroups {
      bys `aggregation': egen `aggregation'_lpov_`subgroup' = wtmean(adj_nonprof_`subgroup'), weight(`aggregation'_weight)
      bys `aggregation': egen `aggregation'_bmp_`subgroup'  = wtmean(nonprof_`subgroup'),     weight(`aggregation'_weight)
      bys `aggregation': egen `aggregation'_enr_`subgroup'  = wtmean(enrollment_`subgroup'),  weight(`aggregation'_weight)
      * From Enrollment to Out-of-School
      gen  `aggregation'_oos_`subgroup' = 100 - `aggregation'_enr_`subgroup'
    }
  }

  * Keep only variables that matter
  keep part2 `possible_aggregations' *_lpov_* *_bmp_* *_oos_*

  * Drop duplicates (started at country level but only want aggregates)*
  duplicates drop

  * Reshape dataset long in gender
  reshape long part2_lpov  part2_bmp  part2_oos  global_lpov global_bmp global_oos ///
               region_lpov region_bmp region_oos adminregion_lpov adminregion_bmp adminregion_oos ///
               incomelevel_lpov incomelevel_bmp incomelevel_oos ///
               lendingtype_lpov lendingtype_bmp lendingtype_oos, ///
               i(part2 global region adminregion incomelevel lendingtype) j(subgroup) string

  * Reshape dataset long in aggregation
  rename (part2      global      region      adminregion      incomelevel      lendingtype) ///
         (part2_code global_code region_code adminregion_code incomelevel_code lendingtype_code)

  preserve
    clear
    save "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta", emptyok replace
  restore

  foreach aggregation in part2 global region adminregion incomelevel lendingtype {
    preserve
      keep   subgroup `aggregation'_code `aggregation'_bmp `aggregation'_oos `aggregation'_lpov
      rename `aggregation'_* *
      append using "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta"
      save "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta", replace
    restore
  }

  use "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta", clear
  duplicates drop
  drop if missing(lpov) | missing(code)

  rename (lpov bmp oos) (value_lpov value_bmp value_oos)
  reshape long value, i(code subgroup) j(aux) string
  gen str indicator = "SE.LPV.PRIM"
  replace indicator = indicator + ".OOS" if aux=="_oos"
  replace indicator = indicator + ".BMP" if aux=="_bmp"
  replace indicator = indicator + ".FE"  if subgroup=="_fe"
  replace indicator = indicator + ".MA"  if subgroup=="_ma"

  gen str value_metadata = ""
  replace value_metadata = "Aggregated Learning Poverty; reporting window 2011-2019"            if aux=="_lpov"
  replace value_metadata = "Aggregated OOS; reporting window 2011-2019"                         if aux=="_oos"
  replace value_metadata = "Aggregated BMP in reading per GAML MPL; reporting window 2011-2019" if aux=="_bmp"

  * Final touches
  gen year = 2017
  rename code countrycode
  keep  countrycode year indicator value value_metadata
  gen str cty_or_agg = "agg"

  save "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta", replace

  noi disp as txt _newline "{phang}Generated aggregated Learning Poverty indicators for WDI{p_end}"


  *--------------------
  * Country Level (mask)
  *--------------------

  * Starts from chosen preference to build a mask of preferred
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear

  * Excludes any countries that we want to avoid reporting
  * NOTE: they are being dropped both from the aggregate and cty level
  foreach country of local countries_not_reported {
    drop if countrycode == "`country'"
  }

  * Only keep countries with LP data and variables that matter
  drop if missing(nonprof_all)
  keep countrycode test nla_code subject idgrade

  describe
  noi disp as txt "{phang}Generating Learning Poverty indicators for `r(N)' countries for WDI{p_end}"

  * Saves a mask of country-assessment-subject that will go into WDI
  save "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_mask.dta", replace


  *--------------------
  * Country Level (data)
  *--------------------

  * Starts from rawfull, to have multiple years of LPOV data whenever possible
  use "${clone}/01_data/013_outputs/rawfull.dta", clear

  * Only keep country-assessment-subject in the mask
  merge m:1 countrycode test nla_code subject idgrade using "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_mask.dta", nogen keep(match)

  * Drop and rename variables
  * - drop most metadata and population variables, which are to the right of enrollment
  keep countrycode-surveyid countryname regionname
  * - drop standard errors of non proficiency, which are in the middle
  drop se_*
  *  - only keep enrollment validated variables, which is the one used in rawlatest
  drop   enrollment_interpolated*
  rename enrollment_validated_* enrollment_*
  * - drop and rename other enrollment variables that could cause trouble in reshape
  drop   enrollment_flag
  rename enrollment_definition definition_enrollment
  rename enrollment_source     source_enrollment

  * Adjusts non-proficiency by out-of school (only rawlatest has LPov, not in rawfull)
  foreach subgroup in all fe ma {
    gen adj_nonprof_`subgroup' = 100 * ( 1 - (enrollment_`subgroup'/100) * (1 - nonprof_`subgroup'/100))
  }

  * This is the data we have to export, now we need to reshape it
  reshape long adj_nonprof enrollment nonprof, i(countrycode idgrade test nla_code subject year_assessment min_proficiency_threshold source_assessment definition_enrollment source_enrollment) j(subgroup) string

  * Will only generate series if has learning poverty data for the subgroup
  drop if missing(adj_nonprof)


  *----------------------------------------------------------------------------*
  * Manual corrections that need to be done to rawlatest wrt "exceptions"
  * that were disguised as NLAs (Mali Madagascar) and with recent year (Congo)
  replace year_assessment = 2010 if countrycode == "COD"
  replace test = "PASEC"         if inlist(countrycode,"MLI","MDG","COD")
  *----------------------------------------------------------------------------*


  * Creates fields that will be exported to WDI
  * Indicator follows grammar in: https://datahelpdesk.worldbank.org/knowledgebase/articles/201175-how-does-the-world-bank-code-its-indicators
  * with topic = SE (social: education); general subject = LPV (learning poverty); specific subject (primary)
  * this will be followed by specific subject = nothing (LP) / BMP / OOS + extension nothing (all) / FE / MA
  gen str indicator = "SE.LPV.PRIM"
  gen float value = .
  gen str value_metadata = ""

  * Auxiliary variables for metadata (cannot concatenate numeric variables)
  gen str_grade = string(int(idgrade),"%01.0f")
  gen str_year  = string(int(year_assessment),"%04.0f")
  replace subject = "reading" if subject == "read"

  * Separate the indicators that are wide into long
  * by repeatedly expanding the dataset
  expand 2, gen(expanded)
  * - Learning Poverty
  replace value = adj_nonprof   if expanded == 0
  replace value_metadata = "OOS: " + definition_enrollment + "; BMP: " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject if expanded == 0
  * - Out-of-School
  replace value = 100 - enrollment       if expanded == 1
  replace indicator = indicator + ".OOS" if expanded == 1
  replace value_metadata  = definition_enrollment if expanded == 1
  * - Below Minimum proficiency
  expand 2 if expanded == 0, gen(expanded_again)
  replace value = nonprof                if expanded_again == 1
  replace indicator = indicator + ".BMP" if expanded_again == 1
  replace value_metadata = test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject if expanded_again == 1

  * Add sufix for gender in the indicator (subgroup == "_all" has no sufix )
  replace indicator = indicator + ".FE"     if subgroup == "_fe"
  replace indicator = indicator + ".MA"     if subgroup == "_ma"

  * Final touches
  rename year_assessment year
  keep  countrycode countryname regionname year indicator value value_metadata
  gen str cty_or_agg = "cty"

  * Save dataset for WDI at the country level
  compress
  save "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_level.dta", replace

  noi disp as txt "{phang}Generated country level Learning Poverty indicators for WDI{p_end}"

  *--------------------
  * Append both
  *--------------------
  append using "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta"

  * Final touches
  order countrycode cty_or_agg year indicator value value_metadata
  sort  countrycode year indicator
  * Check that it is uniquely identified
  isid  countrycode year indicator

  save "${clone}/03_export_tables/033_outputs/WDI_indicators.dta", replace
  export delimited "${clone}/03_export_tables/033_outputs/WDI_indicators.csv", replace

  * Quality assurance display
  noi disp as txt _newline "{phang}QA: observation breakdown by first/single year vs other years {p_end}"
  bys countrycode indicator:  gen tag_first_obs = (_n == 1)
  noi tab cty_or_agg tag_first_obs if indicator == "SE.LPV.PRIM"

  /********************************************************
    Create an Excel file that will not be used in any way
    by the script, nor tracked in the repo, but is meant
    to be used as a convinent way to share all the data
    produced to someone that prefers Excel versus csv
  ********************************************************/
  * List of csv files to be added to the excel file
  local csvfiles "lpv_metadata WDI_indicators"

  * Loop over each csv file and add it to the Excel sheet
  noi di ""
  foreach csvfile of local csvfiles {
    noi di as text "{phang}Exporting `csvfile' to lpv_edstats.xls{p_end}"
    if ("lpv_metadata" == "`csvfile'") {
      import delimited using "${clone}/03_export_tables/031_rawdata/`csvfile'.csv",  clear  varnames(1) case(preserve) encoding("utf-8")
      export excel using "${clone}/03_export_tables/033_outputs/lpv_edstats.xls",  sheet("`csvfile'", replace) firstrow(variables)
    }
    else {
      import delimited using "${clone}/03_export_tables/033_outputs/`csvfile'.csv",  clear  varnames(1) case(preserve)
      export excel using "${clone}/03_export_tables/033_outputs/lpv_edstats.xls",  sheet("`csvfile'", replace) firstrow(variables)
    }
  }

  foreach wdi_temp in WDI_TEMP_aggregates WDI_TEMP_country_level WDI_TEMP_country_mask {
    cap erase "${clone}/03_export_tables/033_outputs/`wdi_temp'.dta"
  }

  noi disp as res _newline "{phang}Exported all Learning Poverty indicators for WDI{p_end}"

}
