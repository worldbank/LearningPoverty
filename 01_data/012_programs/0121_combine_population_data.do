*==============================================================================*
* 0121 SUBTASK: COMBINE POPULATION DATA AND SAVE IN RAWDATA FOLDER
*==============================================================================*
qui {

  /*********************************
   Brings in all population sources
  *********************************/
  noi di _newline "{phang}Combining population data...{p_end}"

  * Start from UIS school age info
  use "${clone}/01_data/011_rawdata/primary_school_age.dta", clear
  keep countrycode year primary_end_age primary_start_age

  * Merge with population_age_by_single_year.dta. Keeping only using (1990-2050) and match
  merge 1:m countrycode year using "${clone}/01_data/011_rawdata/population_by_age.dta" , nogen keep(using match)

  * Merge with data set of countries to use. Keep only those countries
  merge m:1 countrycode using "${clone}/01_data/011_rawdata/country_metadata.dta", keepusing(countrycode) keep(match) nogen


  /*******************************************
   Combines the age-disaggregated projections
       according to primary schooling age
  *******************************************/

  * Fills up primary schooling age data

  * Carry backward primary schooling age data if missing for all years with popdata if
  gsort  countrycode age -year
  foreach var in primary_end_age primary_start_age {
    by countrycode age : replace `var' = `var'[_n-1] if `var' == . & `var'[_n-1] != .
  }

  * Carry forward primary schooling age data if missing for all years with popdata if
  sort  countrycode age year
  foreach var in primary_end_age primary_start_age {
    by countrycode age : replace `var' = `var'[_n-1] if `var' == . & `var'[_n-1] != .
  }

  * Loop over all pop vars and create the categories
  * by copying the values into the new variable if it
  * a given age belongs to that category
  foreach popvar in population_fe population_ma population_all {
    * Age: 10 only
    gen `popvar'_10    = `popvar' if age == 10
    **** NOTE: THIS OPTION IS COMMENTED OUT FOR IT IS LESS ADEQUATE THAN THE SP.POP.1014 SERIES
    //* Age: 10-14 only
    //gen `popvar'_api1014 = `popvar' if age >= 10 & age <= 14
    * Age: the last 5 years of primary. If primary duration is <5 years, than all of primary is used, i.e. less than 5 years.
    gen `popvar'_primary = `popvar' if age >= primary_start_age & age <= primary_end_age
    * Age: 9 to the end of primary only
    gen `popvar'_9plus  = `popvar' if age >= 9 & age <= primary_end_age
  }

  * Aggregate the categories, that is, get one values per variable per country and year
  collapse (sum) population_fe_* population_ma_* population_all_* , by(countrycode year)

  * Restore missing values
  recode population_fe_* population_ma_* population_all_*  ( 0 = .)


  /*******************************************
      Beautify and organize this dataset
  *******************************************/

  foreach aggregation in fe ma all {

    local agg_label ""
    if "`aggregation'" == "fe"  local agg_label "Female population"
    if "`aggregation'" == "ma"  local agg_label "Male population"
    if "`aggregation'" == "all" local agg_label "Total population"

    label var population_`aggregation'_10      "`agg_label' aged 10 (WB API)"
    label var population_`aggregation'_primary "`agg_label' primary age, country specific (WB API)"
    label var population_`aggregation'_9plus   "`agg_label' aged 9 to end of primary, country specific (WB API)"
  }


  /*******************************************
      Merge with population 10-14 series
  *******************************************/
  merge 1:1 countrycode year using "${clone}/01_data/011_rawdata/population_1014.dta", keep(match)	nogen

  * Rename to be able to merge with rawlatest
  rename year year_population
  label var year_population "Year of population"
  label var countrycode "WB country code (3 letters)"

  * Source metadata
  gen   str population_source="WBopendata"
  label var population_source "The source used for population variables"

  * Compress and save
  compress
  noi disp "{phang}Saving file: ${clone}/01_data/013_outputs/population.dta{p_end}"
  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
    local description "Dataset of late primary aged population. Long in countrycode and year, wide in population definitions (ie: 10-14y, primary-aged, etc) and subgroups (all, male, female). In units, not thousands nor millions."
    local sources "World Bank staff estimates using the World Bank's total population and age distributions of the United Nations Population Division's World Population Prospects."
    edukit_save, filename(population) path("${clone}/01_data/013_outputs/")   ///
                 idvars(countrycode year_population) ///
                 varc("value population_*; trait population_source") ///
                 metadata("description `description'; sources `sources'; filename Population")
  }
  else save "${clone}/01_data/013_outputs/population.dta", replace

}
