*==============================================================================*
* 0324 SUBTASK: EXPORT INDICATOR SERIES FOR WDI (WB API)
*==============================================================================*

 
  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference 	= ${chosen_preference}
  local timewindow 			 ${timewindow}
  local enrollment_def 	"${enrollment_def}"
  local anchoryear 		 ${anchor_year}
  local enrollmentyr 		"${enrollmentyr}"
 

  
  *-----------------
  * Population year. Use global if anchor year is not specified
  *-----------------

  if ("`populationyr'" == "") {
	local populationyr `anchoryear'
	noi dis in y "Population Year is the same as Anchor Year: `anchoryear'"
  }  
  
  
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
  population_weights, countryfilter(lendingtype!="LNX")
  gen part2 = "WBC"

  * Creates aggregated values of Learning Poverty, Below Minimum Prof and Enrollment by gender subgroups
  local possible_subgroups "all fe ma"
  foreach subgroup of local possible_subgroups {
    egen part2_lpov_`subgroup' = wtmean(lpv_`subgroup'),	weight(global_weight)
    egen part2_bmp_`subgroup'  = wtmean(ld_`subgroup'),		weight(global_weight)
    egen part2_oos_`subgroup'  = wtmean(sd_`subgroup'),		weight(global_weight)
  }


  * Get proper regional and incomelevel averages - WORLD
  population_weights
  gen global = "WLD"

  * Creates aggregated values of Learning Poverty, Below Minimum Prof and Enrollment by gender subgroups
  local possible_subgroups    "all fe ma"
  local possible_aggregations "global region adminregion incomelevel lendingtype"
  foreach aggregation of local possible_aggregations {
    foreach subgroup of local possible_subgroups {
      bys `aggregation': egen `aggregation'_lpov_`subgroup' = wtmean(lpv_`subgroup'),	weight(`aggregation'_weight)
      bys `aggregation': egen `aggregation'_bmp_`subgroup'  = wtmean(ld_`subgroup'),    weight(`aggregation'_weight)
      bys `aggregation': egen `aggregation'_oos_`subgroup'  = wtmean(sd_`subgroup'), 	weight(`aggregation'_weight)
    }
  }
 * Keep only variables that matter
    local possible_aggregations "global region adminregion incomelevel lendingtype"

  keep part2 `possible_aggregations' *_lpov_* *_bmp_* *_oos_* 

  * Drop duplicates (started at country level but only want aggregates)*
  duplicates drop

  * Reshape dataset long in gender
  reshape long part2_lpov  part2_bmp  part2_oos  global_lpov global_bmp global_oos ///
               region_lpov region_bmp region_oos ///
			   adminregion_lpov adminregion_bmp adminregion_oos ///
               incomelevel_lpov incomelevel_bmp incomelevel_oos ///
			   incomelevel_fgt1 ///
               lendingtype_lpov lendingtype_bmp lendingtype_oos ///
			   , ///
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
  replace indicator = indicator + ".SD" if aux=="_oos"
  replace indicator = indicator + ".LD" if aux=="_bmp"
  replace indicator = indicator + ".FE"  if subgroup=="_fe"
  replace indicator = indicator + ".MA"  if subgroup=="_ma"

  gen str value_metadata = ""
  replace value_metadata = "Aggregated Learning Poverty; reporting window 2011-2021"            if aux=="_lpov"
  replace value_metadata = "Aggregated Schooling Deprivation; reporting window 2011-2021"                         if aux=="_oos"
  replace value_metadata = "Aggregated Learning Deprivation in reading per GAML MPL; reporting window 2011-2021" if aux=="_bmp"

  * Final touches
  gen year = 2019
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
  drop if missing(ld_all)
  keep countrycode test nla_code subject idgrade

  describe
  noi disp as txt "{phang}Generating Learning Poverty indicators for `r(N)' countries for WDI{p_end}"

  * Saves a mask of country-assessment-subject that will go into WDI
  save "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_mask.dta", replace



  *--------------------
  * Country Level (data)
  *--------------------
  
    local anchoryear 		 ${anchor_year}

  * Starts from rawfull, to have multiple years of LPOV data whenever possible
  use "${clone}/01_data/013_outputs/rawfull.dta", clear
  
 rename nonprof_* ld_*
 rename fgt1_* ldgap_*
 rename fgt2_* ldsev_*
 
 rename se_nonprof_* se_ld_*
 *rename se_fgt1_* se_ldgap_*
 *rename se_fgt2_* se_ldsev_*
 

  * Only keep country-assessment-subject in the mask
  merge m:1 countrycode test nla_code subject idgrade using "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_mask.dta", gen(merge1) keep(match)
 rename year_assessment year
 rename countryname country
 rename regionname region_
 drop merge1
 
   merge m:1 countrycode test nla_code subject idgrade using "${clone}/01_data/013_outputs/rawlatest.dta", gen(merge2) keepusing(year_assessment countryname regionname enrollment_flag sd_all sd_ma sd_fe ld_all ld_ma ld_fe ldgap_all ldsev_all ldgap_fe ldgap_ma ldsev_fe ldsev_ma enrollment_definition)
   drop population_*
   
   * Rename gap and severity 
    *rename (fgt1_* fgt2_*) (lpgap_* lpsev_*)

 
	preserve 
 
	use "${clone}/01_data/013_outputs/population.dta", clear
	keep if year_population == `anchoryear' // 2019 
 
	tempfile population
	save `population', replace

	restore
	* Merge population data
	merge m:1 countrycode using `population', nogen keep(match master)
  
  
/* 	* Merge LD Gap and Severity Data 
	merge 1:1 countrycode idgrade year test subject using "${clone}/01_data/011_rawdata/proficiency_from_GLAD.dta", keep(matched master) ///
 keepusing(fgt*)
 
	*rename (fgt1_* fgt2_*) (ldgap_* ldsev_*) */


 replace year = year_assessment if year == .
 replace country = countryname if country == ""
 replace region_ = regionname if region_ == ""

 
 drop year_assessment countryname regionname
 rename year year_assessment
 rename country countryname
 rename region_ regionname
 
   foreach subgroup in all fe ma { 
	 gen double lpgap_`subgroup' = sd_`subgroup'+ldgap_`subgroup' 
     gen double lpsev_`subgroup' = (((sd_`subgroup'/100)^2)+ldsev_`subgroup')*100 
   }

   order countrycode year_assessment enrollment_flag sd_all sd_ma sd_fe ld_all ld_ma ld_fe ldgap* ldsev* lpgap* lpsev* population*
 
  * Drop and rename variables
  * - drop most metadata and population variables, which are to the right of enrollment
  keep countrycode-surveyid countryname regionname population*
  * - drop standard errors of non proficiency, which are in the middle
  drop se_*
  
  *  - only keep enrollment validated variables, which is the one used in rawlatest
  drop   enrollment_interpolated*
  rename enrollment_validated_* enrollment_*
  * - drop and rename other enrollment variables that could cause trouble in reshape
  //drop   enrollment_flag
  rename enrollment_definition definition_enrollment
  rename enrollment_source     source_enrollment
 
 
  * Adjusts non-proficiency by out-of school (only rawlatest has LPov, not in rawfull)
  foreach subgroup in all fe ma {
    gen lpv_`subgroup' = 100 * (((1-sd_`subgroup'/100)*(ld_`subgroup'/100))+(sd_`subgroup'/100))
  }
  rename population_source source_population
 
 rename (population_all_* population_fe_* population_ma_*) (population_*_all population_*_fe population_*_ma)

 * This is the data we have to export, now we need to reshape it
  reshape long lpv sd ld ldgap ldsev lpgap lpsev population_10 population_0516 population_9plus population_primary population_1014, i(countrycode idgrade test nla_code subject year_assessment min_proficiency_threshold source_assessment definition_enrollment source_enrollment) j(subgroup) string
  
  * Will only generate series if has learning poverty data for the subgroup
  drop if missing(lpv)
    

  *----------------------------------------------------------------------------*
  * Manual corrections that need to be done to rawlatest wrt "exceptions"
  * that were disguised as NLAs (Mali)
  replace test = "PASEC"         if inlist(countrycode,"MLI")
  *----------------------------------------------------------------------------*
 
 ** keep only required variables
 keep countrycode  countryname regionname  idgrade test nla_code subject year_assessment min_proficiency_threshold source_assessment definition_enrollment source_enrollment subgroup source_population lpv sd ld ldgap ldsev lpgap lpsev population_10 population_0516 population_9plus population_primary population_1014 

** Order dataset
 order countrycode  countryname regionname idgrade test nla_code subject year_assessment min_proficiency_threshold source_assessment definition_enrollment source_enrollment subgroup source_population lpv sd ld ldgap ldsev lpgap lpsev population_10 population_0516 population_9plus population_primary population_1014 

 foreach var in lpv sd ld ldgap ldsev lpgap lpsev population_10 population_0516 population_9plus population_primary population_1014 {
	 rename `var' value_`var'
 }

** sort data with unique id
sort countrycode idgrade test year_assessment nla_code subject subgroup 

** save tempfile with metadata
preserve 
   tempfile metadata
	keep countrycode  countryname regionname idgrade test year_assessment nla_code subject subgroup min_proficiency_threshold source_assessment definition_enrollment source_enrollment source_population
    sort countrycode idgrade test year_assessment nla_code subject subgroup 
   save `metadata'
restore


  reshape long value_ , i(countrycode idgrade test year_assessment nla_code subject subgroup ) j(indicator) string
  sort countrycode idgrade test year_assessment nla_code subject subgroup 
  merge countrycode idgrade test year_assessment nla_code subject subgroup using `metadata'

  tab indicator subgroup
  
  drop _merge 
  rename value_ value
  
  drop if value == .
  
  * Creates fields that will be exported to WDI
  * Indicator follows grammar in: https://datahelpdesk.worldbank.org/knowledgebase/articles/201175-how-does-the-world-bank-code-its-indicators
  * with topic = SE (social: education); general subject = LPV (learning poverty); specific subject (primary)
  * this will be followed by specific subject = nothing (LP) / BMP / OOS + extension nothing (all) / FE / MA
  gen str indicatorcode = "SE.LPV"
  
  replace indicatorcode = indicatorcode + ".PRIM"      	if indicator == "lpv"
  replace indicatorcode = indicatorcode + ".PRIM.SD" 	if indicator == "sd"
  replace indicatorcode = indicatorcode + ".PRIM.LD" 	if indicator == "ld"
  replace indicatorcode = indicatorcode + ".PRIM.LDGAP" if indicator == "ldgap"
  replace indicatorcode = indicatorcode + ".PRIM.LDSEV" if indicator == "ldsev"
  replace indicatorcode = indicatorcode + ".PRIM.LPGAP" if indicator == "lpgap"
  replace indicatorcode = indicatorcode + ".PRIM.LPSEV" if indicator == "lpsev"

  replace indicatorcode = indicatorcode + ".POP.0516"  	if indicator == "population_0516"
  replace indicatorcode = indicatorcode + ".POP.10"    	if indicator == "population_10"
  replace indicatorcode = indicatorcode + ".POP.1014"  	if indicator == "population_1014"
  replace indicatorcode = indicatorcode + ".POP.9PLUS" 	if indicator == "population_9plus"
  replace indicatorcode = indicatorcode + ".POP.PRIM"  	if indicator == "population_primary"
  

  * Add sufix for gender in the indicator (subgroup == "_all" has no sufix )
  replace indicatorcode = indicatorcode + ".FE"  if subgroup == "_fe"
  replace indicatorcode = indicatorcode + ".MA"  if subgroup == "_ma"

  tab indicatorcode subgroup


  * variables for metadata (cannot concatenate numeric variables)
  gen str value_metadata = ""
  gen str subgroup_str = ""
  replace subgroup_str = "Female" if subgroup == "_fe"
  replace subgroup_str = "Male" if subgroup == "_ma"  
  replace subgroup_str = "" if subgroup == "_all"
  
  * Auxiliary variables for metadata (cannot concatenate numeric variables)
  gen str_grade = string(int(idgrade),"%01.0f")
  gen str_year  = string(int(year_assessment),"%04.0f")
  replace subject = "reading" if subject == "read"
  * - Learning Poverty
  replace value_metadata = "LP = SD: " + definition_enrollment + "; LD: " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject + "; " + subgroup_str if indicator == "lpv"
  * - Out-of-School
  replace value_metadata  = "SD = " + definition_enrollment + "; " + subgroup_str if indicator == "sd"
  * - Below Minimum proficiency
  replace value_metadata = "LD = " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject + "; " + subgroup_str if indicator == "ld"


  * - LD Severity, LP Gap and Severity
  replace value_metadata = "LDGAP: " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject + "; " + subgroup_str if indicator == "ldgap" 
  replace value_metadata = "LDSEV: " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject + "; " + subgroup_str if indicator == "ldsev" 
  
  replace value_metadata = "LPGAP = SD: " + definition_enrollment + "; LD: " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject + "; " + subgroup_str if indicator == "lpgap"
  replace value_metadata = "LPSEV = SD: " + definition_enrollment + "; LD: " + test + " " + str_year + " for grade " + str_grade + " using MPL " + min_proficiency_threshold + " for " + subject + "; " + subgroup_str if indicator == "lpsev"

  * - Population
   local possible_ages "10 0516 9plus primary 1014"
   foreach pop in `possible_ages' {
      replace value_metadata = "Population Age `pop' for Reference Year `anchoryear'" + "; " + subgroup_str  if value_metadata == "" & indicator == "population_`pop'"
    }
	
  * Final touches
  rename year_assessment year
  keep  countrycode countryname regionname year indicatorcode value value_metadata
  gen str cty_or_agg = "cty"
   
  gen indicator = upper(indicatorcode)
  
  drop indicatorcode
  
  

  * Save dataset for WDI at the country level
  compress
  save "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_level.dta", replace

  noi disp as txt "{phang}Generated country level Learning Poverty indicators for WDI{p_end}"
 

 //drop if year == .
  *--------------------
  * Append both
  *--------------------
  * load country level dataset    
  use  "${clone}/03_export_tables/033_outputs/WDI_TEMP_country_level.dta", clear
  * append aggregates
  append using "${clone}/03_export_tables/033_outputs/WDI_TEMP_aggregates.dta"

  * For country level updates, we remove aggregates. To keep, comment out drop if line   
  global aggregates cty_or_agg
  drop if $aggregates == "agg"

  * Final touches
  order countrycode cty_or_agg year indicator value value_metadata
  sort  countrycode year indicator
  
  * Check that it is uniquely identified
  isid  countrycode year indicator
  save "${clone}/03_export_tables/033_outputs/WDI_indicators_`chosen_preference'.dta", replace
  export delimited "${clone}/03_export_tables/033_outputs/WDI_indicators_`chosen_preference'.csv", replace

  * Quality assurance display
  noi disp as txt _newline "{phang}QA: observation breakdown by first/single year vs other years {p_end}"
  bys countrycode indicator:  gen tag_first_obs = (_n == 1)
  noi tab cty_or_agg tag_first_obs if indicator == "SE.LPV.PRIM"

  /********************************************************
    Create an Excel file that is meant
    to be used as a convinent way to share all the data
    produced to someone that prefers Excel versus csv and is 
	used in task 0325 to produce the WDI data based on the 
	DCS format
  ********************************************************/
  * List of csv files to be added to the excel file
  local csvfiles "lpv_metadata WDI_indicators"

  * Loop over each csv file and add it to the Excel sheet
  noi di ""
  foreach csvfile of local csvfiles {
    noi di as text "{phang}Exporting `csvfile' to lpv_edstats_`chosen_preference'.xls{p_end}"
    if ("lpv_metadata" == "`csvfile'") {
      import delimited using "${clone}/03_export_tables/031_rawdata/`csvfile'.csv",  clear  varnames(1) case(preserve) encoding("utf-8")
      export excel using "${clone}/03_export_tables/033_outputs/lpv_edstats_`chosen_preference'.xls",  sheet("`csvfile'", replace) firstrow(variables)
    }
    else {
      import delimited using "${clone}/03_export_tables/033_outputs/`csvfile'_`chosen_preference'.csv",  clear  varnames(1) case(preserve)
      export excel using "${clone}/03_export_tables/033_outputs/lpv_edstats_`chosen_preference'.xls",  sheet("`csvfile'", replace) firstrow(variables)
    }
  }

  foreach wdi_temp in WDI_TEMP_aggregates WDI_TEMP_country_level WDI_TEMP_country_mask {
    cap erase "${clone}/03_export_tables/033_outputs/`wdi_temp'.dta"
  }

  noi disp as res _newline "{phang}Exported all Learning Poverty indicators for WDI{p_end}"

