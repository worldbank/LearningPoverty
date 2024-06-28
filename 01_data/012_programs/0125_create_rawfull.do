*==============================================================================*
* 0125 SUBTASK: MERGE PROFICIENCY, ENROLLMENT AND POPULATION INTO RAWFULL
*==============================================================================*
qui {

  noi di _newline "{phang}Creating rawfull...{p_end}"

  /* The anchor year is set as a global in the 012_run.do, for it affects
     several files. When Learning Poverty numbers were first released
     in Sep 2019, the chosen anchor year was 2015. */

  *-----------------------------*
  * Create Enrollment Wide      *
  *-----------------------------*
  
  use "${clone}/01_data/013_outputs/enrollment.dta", clear
  keep if year >= 1990 
  
  sum year_enrollment
  local max_enr = r(max)
	
  foreach var of varlist enrollment_validated_all - enrollment_interpolated_ma year_enrollment  {
	rename `var' `var'_
  }
  order countrycode enrollment_source enrollment_definition year
  reshape wide enrollment_validated_all_ - year_enrollment_ , i(countrycode enrollment_source enrollment_definition) j(year)
  
  local check = _N 
  if (`check' != 217) { 
	collapse (mean) enrollment_inte* enrollment_val*  (first) enrollment_definition , by(countrycode enrollment_source)
	noi di in y "Enrollment database had more than 1 observation per country. Collapse applied."
  }
  save "${clone}/01_data/013_outputs/enrollment_wide.dta", replace 

  *-----------------------------*
  * Create Population Wide      *
  *-----------------------------*

  * Open population for anchor year only
  * Note that population.dta is LONG on year, WIDE on population definitions and gender
  use "${clone}/01_data/013_outputs/population.dta" , clear
  keep if year_population >= 2010 & year_population <= 2030
  foreach var of varlist population_fe_10 - population_all_1014 {
	rename `var' `var'_
  }
  reshape wide population_fe_10_ - population_all_1014_ , i(countrycode population_source) j(year_population)
  save "${clone}/01_data/013_outputs/population_wide.dta", replace 

  *-----------------------------*
  * Dataset WITHOUT proficiency *
  *-----------------------------*

  * Open population for anchor year only
  * Note that population.dta is LONG on year, WIDE on population definitions and gender
  use "${clone}/01_data/013_outputs/population_wide.dta" , clear
  
  * Brings in Enrollment
  * Note that enrollment.dta is LONG on year, WIDE on enrollment definiions and gender
  merge 1:1 countrycode using "${clone}/01_data/013_outputs/enrollment_wide.dta", keep(master match) nogen

  * This dataset purposefully will be saved without proficiency data
  gen str test     = "None"
  gen str nla_code = "N.A."
  gen str subject  = "N.A."
  gen int idgrade  = -999

  * Save the dataset with only population and enrollment, which still has 1 obs = 1 cty, all for 2015
  save "${clone}/01_data/013_outputs/population_enrollment.dta", replace

  *-------------------------------*
  * Dataset WITH proficiency data *
  *-------------------------------*
  * Open population for multiple years default 2010 to 2030
  * Note that population.dta is LONG on year, WIDE on population definitions and gender
  * Population year is now a sufix and can be changed in 0126
  use "${clone}/01_data/013_outputs/population_wide.dta" , clear
  
  *** Brings in Proficiency (LONG)
  merge 1:m countrycode using "${clone}/01_data/013_outputs/proficiency.dta", keep(match) nogen

  * Brings in Enrollment (WIDE)
  merge m:1 countrycode using "${clone}/01_data/013_outputs/enrollment_wide.dta", keep(master match) nogen

  *---------------------------------*
  * Appends both, bring in metadata *
  *---------------------------------*

  * This would be rawfull, except that it doesn't have all the countries.
  * So appends the 1st dataset, population_enrollment.dta (without proficiency),
  * so every country has 1 obs with test="None" plus as many others as there are assessments
  append using "${clone}/01_data/013_outputs/population_enrollment.dta"
  rename year year_assessment

  * Brings in country metadata. Assert all match (metadata has chosen 217 countries)
  merge m:1 countrycode using "${clone}/01_data/011_rawdata/country_metadata.dta", assert(match) nogen

  replace year_assessment = -9999 if year_assessment == .
  
 
  *-------------------------------*
  * Unit of Observation Explainer *
  *-------------------------------*
  * Observations are uniquely identified by:
  isid  countrycode test nla_code subject idgrade year_assessment

  * Organizing the dataset
  local assessment_vars "test nla_code subject idgrade year_assessment nonprof** min_proficiency_threshold source_assessment"
  unab enrollment_vars : *enrollment*
  unab population_vars : *population*
  order countrycode `assessment_vars' `enrollment_vars' `population_vars'
 
 	* Before beginning the rawlatest exercise, there are some cases where
	* assessment data is available before the latest enrollment year is available 
	* For example, AMPLB 2023 was released before UIS released 2023 enrolment estimates 
	* In this case, we'll implement a short fix to make sure the code doesn't break
	
	* First, check the maximum year of the database and save it 
	sum year_assessment
	local max = r(max)
	local latestenryear = `max'-1
	local latestenryear2 = `max'-2
	local latestenryear3 = `max'-3


	* Then check if the variable for this year exists
	cap tab year_enrollment_`max'
	
	* If it does not exist, create a variable for the year, denoting no values available.
	if _rc != 0 {
			
		gen year_enrollment_`max' = year_enrollment_`max_enr'
		cap gen year_enrollment_`latestenryear' = year_enrollment_`max_enr'
		cap gen year_enrollment_`latestenryear2' = year_enrollment_`max_enr'
		cap gen year_enrollment_`latestenryear3' = year_enrollment_`max_enr'
		
		foreach g in all fe ma {
		foreach var in validated interpolated {
			gen enrollment_`var'_`g'_`max' = enrollment_`var'_`g'_`max_enr'
			cap gen enrollment_`var'_`g'_`latestenryear' = enrollment_`var'_`g'_`max_enr'
			cap gen enrollment_`var'_`g'_`latestenryear2' = enrollment_`var'_`g'_`max_enr'
			cap gen enrollment_`var'_`g'_`latestenryear3' = enrollment_`var'_`g'_`max_enr'

		}
		}
		
		* for flags 
		gen enrollment_validated_flag_`max' = enrollment_validated_flag_`max_enr'
		gen enrollment_interpolated_flag`max' = enrollment_interpolated_flag`max_enr'
		
		cap gen enrollment_validated_flag_`latestenryear' = enrollment_validated_flag_`max_enr'
		cap gen enrollment_interpolated_flag`latestenryear' = enrollment_interpolated_flag`latestenryear'
		
		cap gen enrollment_validated_flag_`latestenryear2' = enrollment_validated_flag_`max_enr'
		cap gen enrollment_interpolated_flag`latestenryear2' = enrollment_interpolated_flag`max_enr'
		
		cap gen enrollment_validated_flag_`latestenryear3' = enrollment_validated_flag_`max_enr'
		cap gen enrollment_interpolated_flag`latestenryear3' = enrollment_interpolated_flag`max_enr'
	} 
	else {
		* Otherwise, don't worry about it
		noi di "Most recent year of assessment database matches most recent year of UIS enrollment data. Continuing."
	}
	
 
  * Compress and save
  compress
  noi di "{phang}Saving file: ${clone}/01_data/013_outputs/rawfull.dta{p_end}"
  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
    local description "Dataset of proficiency merged with enrollment and population. Not a timeseries, rather a collection of observations, from which subsets of time series may be extracted. Long in proficiency, wide on population and enrollment."
    local sources "All population, enrollment and proficiency sources combined."
    edukit_save, filename(rawfull) path("${clone}/01_data/013_outputs/")   ///
                 idvars(countrycode year_assessment idgrade test nla_code subject) ///
                 varc("value *nonprof* fgt* enrollment_val* enrollment_inte* year_enrollment*  population_*; trait *source* *definition* *threshold* surveyid countryname region* adminregion* incomelevel* lendingtype* cmu") ///
                 metadata("description `description'; sources `sources'; filename Rawfull")
  }
  else save "${clone}/01_data/013_outputs/rawfull.dta", replace

}
