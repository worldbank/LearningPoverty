*==============================================================================*
* 0422 SUBTASK: PREPARE POPULATION CSVS TO UPDATE THE 011_RAWDATA IN REPO FOLDER
*==============================================================================*
qui {

  /* NOTE: This section was purposefully commented out because WB opendata
  does not bring projections, only historic ranges, and we needed those
  series from 1990:2050. The next section is precisely the same series,
  but directly from the API that wbopendata calls. The advantage is being
  able to query both the historic and projected series.

  /*****************************************
      HISTORIC population from WB Opendata
  *****************************************/
  noi di ""
  noi di "{phang}Historic population 10-14 from wbopendata{p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/population_1014.csv"

  * Import the rawdata from WB Opendata
  wbopendata, indicator(SP.POP.1014.FE; SP.POP.1014.MA) clear long nometadata

  * Drop all aggregates (non-countries)
  drop if region == "NA"

  * Keep only relevant variables and time window
  keep countrycode year *pop*
  keep if year >= 1990

  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"

  */


  /*****************************************
      PROJECTED population from WB API
             SP.POP.1014 series
  *****************************************/
  noi di _newline "{phang}Historic and projected population 10-14 from WB API{p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/population_1014.csv"

  * Avoid API issue
  set checksum off

  * Set up parts of API call that are identical per country
  local api_url 		 "https://api.worldbank.org/v2/country"
  local api_cnt 		 "ALL" // Change to any country abbreviation to get a specific one
  local api_parameters "?source=40&filetype=data&downloadformat=csv&date=1990:2050"
  local indicators   "indicator/SP.POP.1014.FE;SP.POP.1014.MA"

  *Concatenate the api request
  local get_request	"`api_url'/`api_cnt'/`indicators'/`api_parameters'"

  * Copy the file from API to csv folder
  copy "`get_request'" "`clonefile'"

  * Import the csv file
  import delimited "`clonefile'", varnames(5) rowrange(6) clear

  * Stata cannot have numbers as varnames, so fix varnames that
  * was imported on the format v5, v6 etc.
  forvalues year = 1990/2050 {
    local varNameNum = `year' - 1985
    rename v`varNameNum' pop1014_`year'
  }

  * Reshape file to long
  reshape long pop1014_, i(countrycode indicatorname)  j(year)

  * Create a gender variable
  gen gender = ""
  replace gender = "fe" if (indicatorcode == "SP.POP.1014.FE")
  replace gender = "ma" if (indicatorcode == "SP.POP.1014.MA")

  * Keep only relevant variables
  keep countrycode gender year pop*

  * Put gender wide so unit of obs is country-year-age
  reshape wide pop1014_, i(countrycode year) j(gender) string

  * Export csv (replacing the downloaded one)
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"




  /*****************************************
      PROJECTED population from WB API
          by single year of age
  *****************************************/
  noi di _newline "{phang}Historic and projected population by single year of age from WB API{p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/population_by_age.csv"

  * Avoid API issue
  set checksum off

  * Set up parts of API call that are identical per country
  local api_url 		 "https://api.worldbank.org/v2/country"
  local api_cnt 		 "ALL" // Change to any country abbreviation to get a specific one
  local api_parameters "?source=40&filetype=data&downloadformat=csv&date=1990:2050"

  * Use the same file and import before overwritten, to decrease number of files in folder
  local temp_csvfile "${clone}/04_repo_update/043_outputs/popdata_single_age_temp.csv"

  * Starts with an empty data set to append to
  clear
  tempfile appendfile
  save 	  `appendfile' , emptyok

  * Loop over all ages (Stata might crash when trying to do all at once)
  local ages 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18
  foreach age of local ages {

    * Prepare the part of the API request with the indicator for this age
    local indicators "indicator/SP.POP.AG`age'.FE.IN;SP.POP.AG`age'.MA.IN"

    * Concatenate the api request
    local get_request	"`api_url'/`api_cnt'/`indicators'/`api_parameters'"

    * Copy the file from API to csv folder
    copy "`get_request'" "`temp_csvfile'"

    * Import the csv file
    import delimited "`temp_csvfile'", varnames(5) rowrange(6) clear

    * Stata cannot have numbers as varnames, so fix varnames that
    * was imported on the format v5, v6 etc.
    forvalues year = 1990/2050 {
      local varNameNum = `year' - 1985
      rename v`varNameNum' pop`year'
    }

    * Reshape file to long
    reshape long pop, i(countrycode indicatorname)  j(year)

    * Create a gender variable
    gen gender = ""
    replace gender = "FE" if (indicatorcode == "SP.POP.AG`age'.FE.IN")
    replace gender = "MA" if (indicatorcode == "SP.POP.AG`age'.MA.IN")

    * Create an age variable
    gen age = real("`age'")

    * Keep only relevant variables
    keep countrycode gender age year pop

    * Append to other ages
    append using `appendfile'
    save `appendfile', replace

  }

  * Use the result with all ages
  use `appendfile', clear

  * Put gender wide so unit of obs is country-year-age
  rename pop pop_
  reshape wide pop_, i(countrycode year age) j(gender) string

  * Order and sort and make sure unit of obs is correct
  isid  countrycode year age, sort
  order countrycode year age

  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"

  *Erase temporary csvfile
  erase "`temp_csvfile'"



  /*****************************************
    Primary entrance age and duration data
  *****************************************/
  noi di _newline "{phang}Primary entrance and duration data from wbopendata{p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/primary_school_age.csv"

  * List of indicators on primary school entrance and duration
  local schoolage_indicators "UIS.CEAge.1;SE.PRM.DURS"

  * Import the rawdata from WB Opendata
  wbopendata, indicator(`schoolage_indicators') clear long nometadata

  * Drop all aggregates (non-countries)
  drop if region == "NA"

  * Keep only relevant variables and time window
  keep countrycode year uis_ceage_1 se_prm_durs
  keep if year >= 1990

  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"


}
