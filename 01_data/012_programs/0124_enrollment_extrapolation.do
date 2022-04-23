*==============================================================================*
* 0124 SUBTASK: SELECT PREFERRED ENROLLMENT SOURCE AND EXTRAPOLATE MISSING YEARS
*==============================================================================*
qui {

  noi di _newline "{phang}Extrapolating enrollment data...{p_end}"

  *Use data where UIS and WBOPENDATA is combined
  use "${clone}/01_data/011_rawdata/enrollment_uis_wb.dta", clear

  ***********************************
  * Generate the main variables this do-file creates

  *Generate the variables used to consolidate from different definitions.
  gen enrollment_validated       = .
  gen enrollment_interpolated    = .
  gen year_enrollment            = .
  gen enrollment_source          = ""
  gen enrollment_definition      = ""

  *Label extrapolation vars
  label var enrollment_interpolated    "Validated % of children enrolled in school (using interpolation, both genders)"
  label var enrollment_validated       "Validated % of children enrolled in school (using closest year, both genders)"
  label var year_enrollment            "The year that the enrollment value is from"
  label var enrollment_source          "The source used for this enrollment value"
  label var enrollment_definition      "The definition used for this enrollment value"

  *List of 4 definitions to loop over in each loop
  local enrollment_definitions VALID ANER TNER NER GER

  ************ PLACEHOLDER *********
  **** QUICK FIX - GENDER SPLIT ****
  foreach def of local enrollment_definitions {
    rename enrollment_`def'_ALL enrollment_`def'
  }

  ***********************************
  * For each definition find the closest year with data for observations
  * with no data in that definition that year according to this rules:
  * - If that year has data, use that value.
  * - Otherwise check one year before and one year after.
  * - If only one of those years has a data, use that year.
  *	- If both those years have values, use one year before.
  *	- If neither has data, look two years before and two year after. Then
  *	  repeat the same procedure until a year with data is found.

  *Find year with data for all definitions and years
  foreach def of local enrollment_definitions {

    *Year observations with data will use those years.
    gen fillyear_back_`def' = year if !missing(enrollment_`def')
    gen fillyear_forw_`def' = year if !missing(enrollment_`def')

    *Label extrapolation vars
    lab var fillyear_back_`def' "The closest year in the past with data in the `def' definition"
    lab var fillyear_forw_`def' "The closest year in the future with data in the `def' definition"

    *Sort year ascending
    sort countrycode year

    *For all observations with missing values [missing(fillyear_back_`def')] replace with
    *year on row above (year ascending hence succeding year) if country code is same [countrycode == countrycode[_n-1]].
    *Stata does this operation row by row, so years will be carried forward multiple
    *rows when the year to use is more than one year away
    replace fillyear_back_`def'	  = fillyear_back_`def'[_n-1] if missing(fillyear_back_`def') & countrycode == countrycode[_n-1]

    *Sort year descending
    gsort countrycode -year

    *For all observations with missing values [missing(fillyear_forw_`def')] replace with
    *year on row above (year descending hence succeding year) if country code is same [countrycode == countrycode[_n-1]].
    *Stata does this operation row by row, so years will be carried forward multiple
    *rows when the year to use is more than one year away
    replace fillyear_forw_`def' = fillyear_forw_`def'[_n-1] if missing(fillyear_forw_`def') & countrycode == countrycode[_n-1]

    *Return to ascending years
    sort countrycode year

    *When comparing year to see which is closes, backward year cannot be missing, as missing is infinite
    replace fillyear_back_`def' = 0 if missing(fillyear_back_`def')

    gen year_enrollment_`def' = .

    *Set the year enrollemnt to the same year as this observation if we have data in preferred definition in that actual year
    replace year_enrollment_`def' = year if !missing(enrollment_`def')

    *Set the year enrollemnt to the closest year backwards if that is closer than or same difference as closest year forward
    replace year_enrollment_`def' = fillyear_back_`def' if  (year - fillyear_back_`def' <= fillyear_forw_`def' - year) & missing(enrollment_`def')

    *Set the year enrollemnt to the closest year forward if that is closer than closest year backward
    replace year_enrollment_`def' = fillyear_forw_`def' if !(year - fillyear_back_`def' <= fillyear_forw_`def' - year) & missing(enrollment_`def')

    *Creates a dummy that is 1 if there is at least one observation by
    *country for which enrollment for that definitions is not missing
    egen    has_`def' = max(!missing(enrollment_`def')), by(countrycode)
    lab var has_`def' "Dummy for whether there is any data for this definition for this year."

    * Cap enrollment to 100%
    * Gross enrollment can be more than
    * 100% but that does not make sense
    * when comparing to other definitions
    gen enrollment_`def'_tmp=enrollment_`def'
    replace enrollment_`def'_tmp 	= 100											 	if enrollment_`def' > 100 & !missing(enrollment_`def')
    replace enrollment_`def'_tmp 	= 0											 		if enrollment_`def' < 0   & !missing(enrollment_`def')

    *Interpolate enrollment: interpolations only
    ipolate enrollment_`def'_tmp year, gen(enrollment_`def'_int) by(countrycode)
    drop enrollment_`def'_tmp

    *Order fill variables next to original enrollment variable
    order has_`def' year_enrollment_`def' fillyear_back_`def' fillyear_forw_`def' , after(enrollment_`def')
  }

  *Drop values used for calculation that is just confusing in final data set
  drop fillyear_back_* fillyear_forw_*

  ***********************************
  * Copy values from the most preferred definitons
  * Validated values rank first (but they only exist for
  * values where we have set decsion to use in
  * {clone}}/01_data/011_rawdata/national_enrollment.md
  * and then comes ANER from WB, TNER from UIS, NER from UIS
  * and GER from UIS)

  *Generate enrollment_interpolated which is enrollment interpolated as enrollment to begin.

  *Loop over all definitions to copy the first with values in preferred order
  foreach def of local enrollment_definitions {

    *Copy to actualy value for years with data in the preferred definition.
    replace enrollment_validated = enrollment_`def' if has_`def' == 1 & missing(enrollment_source)
    replace enrollment_interpolated = enrollment_`def'_int if has_`def' == 1 & missing(enrollment_source)

    drop enrollment_`def'_int

    *Copy the closest year backward in the preferred defintion
    replace year_enrollment = year_enrollment_`def' if has_`def' == 1 & missing(enrollment_source)

    *Write which source we are using, i.e. the first one in preferred order
    replace enrollment_definition = "`def'" if has_`def' == 1 & missing(enrollment_source)

    *Write which source we are using, i.e. the first one in preferred order
    replace enrollment_source = enrollment_`def'_source if has_`def' == 1 & missing(enrollment_source)

  }

  ***********************************
  * Copy values from the closest year within country

  *Loop over all possible year to copy the value from the year that is the closest year
  forvalues yeardiff = 1/30 {
    replace enrollment_validated = enrollment_validated[_n+`yeardiff'] if year[_n+`yeardiff'] == year_enrollment & countrycode == countrycode[_n+`yeardiff']
    replace enrollment_validated = enrollment_validated[_n-`yeardiff'] if year[_n-`yeardiff'] == year_enrollment & countrycode == countrycode[_n-`yeardiff']
  }


  *******************************
  * Cap enrollment to 100%
  * Gross enrollment can be more than
  * 100% but that does not make sense
  * when comparing to other definitions
  replace enrollment_definition = enrollment_definition + " (capped at 100%)" if enrollment_validated > 100 & !missing(enrollment_validated)
  replace enrollment_validated 	= 100										if enrollment_validated > 100 & !missing(enrollment_validated)

  * Correct metadata for Afghanistan 
  replace enrollment_definition = "National household survey" if countrycode == "AFG" & enrollment_definition == "Country Team Validation"
  ***********************************

  *In some cases, we could not interpolate enrollment, because there was only one value for the country.  In this case, use the carry forward value
  replace enrollment_interpolated=enrollment_validated if missing(enrollment_interpolated) & !missing(enrollment_validated)


  order countrycode year enrollment_interpolated enrollment_validated enrollment_source enrollment_definition year_enrollment
  keep  countrycode-year_enrollment

  label var countrycode "WB country code (3 letters)"
  label var year "Year"

  ********* PLACEHOLDER *************
  **** QUICK FIX - GENDER SPLIT *****

  merge m:1 countrycode year_enrollment enrollment_definition using "${clone}/01_data/011_rawdata/enrollment_uis_wb_reshapedlong.dta", keep(master match) nogen

  *Validation has multiple defintion see table in url above.
  replace enrollment_definition = "Country Team Validation" if enrollment_definition == "VALID"

  *Replace source and defintions for countries with no data
  replace enrollment_definition = "No data" if missing(enrollment_definition)
  replace enrollment_source     = "No data" if missing(enrollment_source)

  * Generate empty variables
  gen enrollment_validated_fe    = .
  gen enrollment_validated_ma    = .
  gen enrollment_interpolated_fe = .
  gen enrollment_interpolated_ma = .
  label var enrollment_interpolated_fe "Validated % of children enrolled in school (using interpolation, female only)"
  label var enrollment_interpolated_ma "Validated % of children enrolled in school (using interpolation, male only)"
  label var enrollment_validated_fe    "Validated % of children enrolled in school (using closest year, female only)"
  label var enrollment_validated_ma    "Validated % of children enrolled in school (using closest year, male only)"

  * Check for each method and attempt to fill enrollement variables
  foreach method in interpolated validated {

    gen byte enrollment_`method'_flag = 0

    * If the both genders is the same (with 0.1% wiggleroom), apply the gender split
    replace enrollment_`method'_fe  = enrollment_FE	  if (enrollment_`method' >= 0.999*enrollment_ALL & enrollment_`method' <= 1.001*enrollment_ALL)
    replace enrollment_`method'_ma  = enrollment_MA	  if (enrollment_`method' >= 0.999*enrollment_ALL & enrollment_`method' <= 1.001*enrollment_ALL)

    * If the total enrollment is high, attributes same value for female and male when missing
    replace enrollment_`method'_flag = 1 if enrollment_`method' >= 98.5 & missing(enrollment_`method'_fe)
    replace enrollment_`method'_fe = enrollment_`method' if enrollment_`method' >= 98.5 & missing(enrollment_`method'_fe)
    replace enrollment_`method'_ma = enrollment_`method' if enrollment_`method' >= 98.5 & missing(enrollment_`method'_ma)

    * Renames the aggregate to _all to avoid confusions
    rename  enrollment_`method'       enrollment_`method'_all
  }

  * Drop the enrollment variables from before extrapolation
  drop enrollment_ALL enrollment_FE enrollment_MA

  * Beautify
  format enrollment_interpolated* enrollment_validated* %4.2fc
  order countrycode year enrollment_interpolated* enrollment_validated*
  label var enrollment_interpolated_flag "Flag for enrollment by gender filled up from aggregate (>=98.5%)"
  label var enrollment_validated_flag "Flag for enrollment by gender filled up from aggregate (>=98.5%)"


  * Compress and save
  compress
  noi disp "{phang}Saving file: ${clone}/01_data/013_outputs/enrollment.dta{p_end}"
  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
  local description "Dataset of enrollment. Long in countrycode and year, wide in enrollment definitions (ie: interpolated, validated) and subgroups (all, male, female)."
  local sources "Multiple enrollment definitions were combined according to a ranking. Original data from World Bank (country team validation, ANER) and UIS (TNER, NET, GER)"
  edukit_save, filename(enrollment) path("${clone}/01_data/013_outputs/") ///
               idvars(countrycode year)                                   ///
               varc("value enrollment_validated* enrollment_interpolated*; trait enrollment_source enrollment_definition year_enrollment")  ///
               metadata("description `description'; sources `sources'; filename Enrollment")
  }
  else save "${clone}/01_data/013_outputs/enrollment.dta", replace

}
