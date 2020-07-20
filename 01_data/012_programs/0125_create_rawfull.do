*==============================================================================*
* 0125 SUBTASK: MERGE PROFICIENCY, ENROLLMENT AND POPULATION INTO RAWFULL
*==============================================================================*
qui {

  noi di _newline "{phang}Creating rawfull with $anchor_year as anchor year...{p_end}"

  /* The anchor year is set as a global in the 012_run.do, for it affects
     several files. When Learning Poverty numbers were first released
     in Sep 2019, the chosen anchor year was 2015. */

  *-----------------------------*
  * Dataset WITHOUT proficiency *
  *-----------------------------*

  * Open population for anchor year only
  * Note that population.dta is LONG on year, WIDE on population definitions and gender
  use "${clone}/01_data/013_outputs/population.dta" if year_population == $anchor_year, clear

  * To be able to merge with enrollment
  clonevar year = year_population

  * Brings in Enrollment
  * Note that enrollment.dta is LONG on year, WIDE on enrollment definiions and gender
  merge m:1 countrycode year using "${clone}/01_data/013_outputs/enrollment.dta", keep(master match) nogen

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
  * Open population for anchor year only
  * Note that population.dta is LONG on year, WIDE on population definitions and gender
  use "${clone}/01_data/013_outputs/population.dta" if year_population==$anchor_year, clear


  *** Brings in Proficiency (LONG)
  merge 1:m countrycode using "${clone}/01_data/013_outputs/proficiency.dta", keep(match) nogen
  //* TODO Investigate two cases (CHI and BIH)

  * Brings in Enrollment (WIDE)
  merge m:1 countrycode year using "${clone}/01_data/013_outputs/enrollment.dta", keep(master match) nogen



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


  *-------------------------------*
  * Unit of Observation Explainer *
  *-------------------------------*
  * Observations are uniquely identified by:
  isid  countrycode test nla_code subject idgrade year_assessment

  * Organizing the dataset
  local assessment_vars "test nla_code subject idgrade year_assessment *nonprof* min_proficiency_threshold source_assessment"
  unab enrollment_vars : *enrollment*
  unab population_vars : *population*
  order countrycode `assessment_vars' `enrollment_vars' `population_vars'

  * Compress and save
  compress
  noi di "{phang}Saving file: ${clone}/01_data/013_outputs/rawfull.dta{p_end}"
  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
    local description "Dataset of proficiency merged with enrollment and population. Not a timeseries, rather a collection of observations, from which subsets of time series may be extracted. Long in proficiency, wide on population and enrollment."
    local sources "All population, enrollment and proficiency sources combined."
    edukit_save, filename(rawfull) path("${clone}/01_data/013_outputs/")   ///
                 idvars(countrycode year_assessment idgrade test nla_code subject) ///
                 varc("value *nonprof* fgt* enrollment_val* enrollment_inte* population_*; trait year_enrollment year_population *source* *definition* *threshold* surveyid countryname region* adminregion* incomelevel* lendingtype* cmu") ///
                 metadata("description `description'; sources `sources'; filename Rawfull")
  }
  else save "${clone}/01_data/013_outputs/rawfull.dta", replace

}
