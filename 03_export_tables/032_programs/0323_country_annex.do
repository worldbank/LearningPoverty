*==============================================================================*
* 0323 SUBTASK: COUNTRY ANNEX NUMBERS
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference


  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", replace
  population_weights, timewindow(year_assessment>=2011) countryfilter()

  keep if year_assessment>=2011

  *FIRST DO WITH ALL 98 Countries
  *Export output for preference 1000 to excel for country spreadsheet

  gen pct_reading_low_target=100-nonprof_all


  *Build sub-totals and totals
  *regional sub-totals
  preserve
    collapse adj_nonprof_all  population_2017_all  [fw=region_weight], by(region)
    gen countryname="ZZZ"
    tempfile rgn_98
    save `rgn_98'
  restore

  preserve
    collapse adj_nonprof_all    [fw=region_weight]
    gen region="Z_Global"
    gen countryname="ZZZ"
    tempfile glob_98
    save `glob_98'
  restore


  *Now DO WITH no LNX countries

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", replace
  population_weights, timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")
  gen pct_reading_low_target=100-nonprof_all

  keep if year_assessment>=2011

  *regional sub-totals using just the !LNX countries
  preserve
    drop if incomelevel=="LNX"
    collapse adj_nonprof_all    [fw=region_weight], by(region)
    gen countryname="ZZZ_!LNX"
    tempfile rgn
    save `rgn'
  restore

  preserve
    collapse adj_nonprof_all    [fw=region_weight]
    gen region="Z_Global"
    gen countryname="ZZZ_!LNX"
    tempfile glob
    save `glob'
  restore


  append using `rgn_98'
  append using `glob_98'
  append using `rgn'
  append using `glob'
  sort region countryname
  replace region="Global" if region=="Z_Global"
  replace countryname="Group Total" if countryname=="ZZZ"
  replace countryname="Group Total w/out LNX" if countryname=="ZZZ_!LNX"

  drop if test=="None"

  keep  region adminregion countrycode countryname adj_nonprof_all enrollment_all pct_reading_low_target population_2017_all incomelevel lendingtype test year_assessment
  order region adminregion countrycode countryname adj_nonprof_all enrollment_all pct_reading_low_target population_2017_all incomelevel lendingtype test year_assessment

  *----------------------------------------------------------------------------*
  * Manual corrections that need to be done to rawlatest wrt "exceptions"
  * that were disguised as NLAs (Mali Madagascar) and with recent year (Congo)
  replace year_assessment = 2010 if countrycode == "COD"
  replace test = "PASEC"         if inlist(countrycode,"MLI","MDG","COD")
  *----------------------------------------------------------------------------*

  export excel  using "${clone}/03_export_tables/033_outputs/rawlatest_cntry_file.xlsx", replace firstrow(varl)

  noi disp as res _newline "Finished exporting excel for country annex."

}
