*==============================================================================*
* 0123 SUBTASK: BRING ENROLLMENT DATA AND SAVE IN RAWDATA FOLDER
*==============================================================================*
qui {

  /*******************************
   Combining enrollment sources
       enrollment_uis_wb.dta
  *******************************/
  noi di _newline "{phang}Combining enrollment data...{p_end}"

  * Start with WB enrollment data
  use "${clone}/01_data/011_rawdata/enrollment_tenr_wbopendata.dta", clear

  * Bring in UIS enrollment data (keep only the 217 countries in wbopendata)
  merge 1:1 countrycode year using "${clone}/01_data/011_rawdata/enrollment_edulit_uis.dta", keep(master match) nogen

  * Bring in enrollment validation by country teams (which is unfortunately not split by gender)
  merge 1:1 countrycode year using "${clone}/01_data/011_rawdata/enrollment_validated.dta", keep(master match) nogen

  * Generate source variables
  gen enrollment_ANER_source  = "WBOPENDATA"
  gen enrollment_TNER_source  = "UIS"
  gen enrollment_NER_source   = "UIS"
  gen enrollment_GER_source   = "UIS"
  gen enrollment_VALID_source = "Country Team Validation"

  * Label source variables
  label var enrollment_ANER_source  "Source used for the ANER indicator"
  label var enrollment_TNER_source  "Source used for the TNER indicator"
  label var enrollment_NER_source   "Source used for the NER indicator"
  label var enrollment_GER_source   "Source used for the GER indicator"
  label var enrollment_VALID_source "Source used for indicator validated by country team"

  * Order the data, according to our preference of enrollment to use
  order countrycode year enrollment_ANER* enrollment_TNER* enrollment_NER* enrollment_GER*

  * Save data to use
  compress
  noi save "${clone}/01_data/011_rawdata/enrollment_uis_wb.dta", replace


  /*********************************
   Reshaping to LONG on definition
  (auxiliary file for interpolation)
  *********************************/
  * Metadata not needed
  drop enrollment_*_source

  * Because enrollment definition is in the middle of gender, will reshape sequentially to get desired format
  reshape long enrollment_ANER enrollment_TNER enrollment_NER enrollment_GER enrollment_VALID, i(countrycode year) j(subgroup) string
  reshape long enrollment, i(countrycode year subgroup) j(enrollment_definition ) string
  drop if missing(enrollment)
  replace enrollment_definition = subinstr(enrollment_definition,"_","",.)
  reshape wide enrollment, i(countrycode year enrollment_definition) j(subgroup) string

  * Organize
  rename year year_enrollment
  sort  countrycode year_enrollment

  * Save data to use
  compress
  noi save "${clone}/01_data/011_rawdata/enrollment_uis_wb_reshapedlong.dta", replace

}
