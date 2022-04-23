*==============================================================================*
* 0523 SUBTASK: Relationship between Learning Poveryt BMP and PISA Level 2
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference

  *-----------------------------------------------------------------------------
  local outputs   "${clone}/05_working_paper/053_outputs"
  local rawdata   "${clone}/05_working_paper/051_rawdata"
  local overwrite_csv = 0 // Change here to download new data even if csv already in clone
  *-----------------------------------------------------------------------------

  tempfile learningpoverty learning_poverty_bmp pisa_bmp

  *-----------------------------------------------------------------------------
  * create and save Learning Poverty dataset

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  keep if !missing(adj_nonprof_all)
  sort region countryname
  local  vars2keep "countrycode countryname enrollment_all nonprof_all adj_nonprof_all test year_assessment"
  order `vars2keep'
  keep  `vars2keep'
  label var enrollment_all   "Enrollment"
  label var nonprof_all      "BMP"
  label var adj_nonprof_all  "Learning Poverty"
  label var test             "Assessment"
  label var year_assessment  "Assessment Year"
  save `learningpoverty', replace


  *-----------------------------------------------------------------------------
  * create and save Learning Poverty BMP database

  import delimited "${clone}/01_data/011_rawdata/hosted_in_repo/proficiency_from_GLAD.csv", encoding(ISO-8859-2) clear
  foreach var of varlist fgt* {
  	replace `var' = `var'*100
  }
  bysort countrycode : egen maxyear = max(year)
  gen latest_lpbmp = year == maxyear
  save `learning_poverty_bmp', replace


  *-----------------------------------------------------------------------------
  * create and save PISA Level 2 database
  //use "`outputs'/pisa-groupdata.dta", clear
  import delimited  "`rawdata'/pisa-groupdata.csv", numericcols(15) clear
  * keep estimated values
  keep if type == 1
  * keep QG Lorenz Curve
  keep if model == 1
  * keep FGTs
  keep if indicator <= 3
  gen year_pisa = year
  bysort countrycode : egen maxyear = max(year)
  gen latest_pisa = year == maxyear
  save `pisa_bmp', replace

  *-----------------------------------------------------------------------------
  * Join LP-BMP and PISA-BMP databases

  use `learning_poverty_bmp', clear
  gen year_lp = year
  merge m:1 countrycode using `learningpoverty', nogen

  joinby countrycode using `pisa_bmp',  _merge(_merge)

  gen before = year_pisa <= year_lp
  gen diff  = year_pisa - year_lp

  gen abs_diff  = abs(diff)

  ***-----------------------------------------------------------------------------
  ** Countrycode

  encode countrycode, gen(ctry)
  bysort countrycode : gen tot = _N
  gen wtg = 1/(tot/9)

  ***-----------------------------------------------------------------------------
  ** PISA subject

  gen subject_pisa = word(subinstr(name,"_"," ",.),-2)


  ***-----------------------------------------------------------------------------
  ** Metadata

  merge m:1 countrycode using "${clone}/01_data/011_rawdata/country_metadata.dta", keep(match) nogen

  ***-----------------------------------------------------------------------------

  preserve

    mat drop _all

    ***-----------------------------------------------------------------------------
    * PISA-BMP and LP-BMP
    * average values
    tabstat value nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"  & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"  & subject_pisa == "read" , save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    * correlation
    corr value nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"     & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    ***-----------------------------------------------------------------------------

    mat final = mean, rho
    mat drop mean
    mat drop rho

    ***-----------------------------------------------------------------------------
    * PISA-BMP and LP
    * average values
    tabstat value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    * correlation
    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"     & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    ***-----------------------------------------------------------------------------

    mat final_lp = mean, rho
    mat drop mean
    mat drop rho

    ***-----------------------------------------------------------------------------

    mat list  final_lp
    mat all = final, final_lp
    mat list all

    ***-----------------------------------------------------------------------------



    ***-----------------------------------------------------------------------------
    * PISA-BMP and LP-BMP
    * average values
    tabstat value nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"    & subject_pisa == "read" & lendingtype == "LNX", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX" , save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX" , save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX" , save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX" , save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    * correlation
    corr value nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    ***-----------------------------------------------------------------------------

    mat final = mean, rho
    mat drop mean
    mat drop rho

    ***-----------------------------------------------------------------------------
    * PISA-BMP and LP
    * average values
    tabstat value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    tabstat   value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX", save stat(mean N)
    mat a = r(StatTotal)
    mat mean= nullmat(mean)\a

    * correlation
    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"   & subject_pisa == "read"  & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff >= 0 & diff <= 4 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -3 & diff >= -5	 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <= -6 & diff >= -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    corr value adj_nonprof_all [aw=wtg] if indicator == 1 & diff <=  -11 & subject == "read"   & subject_pisa == "read" & lendingtype == "LNX"
    mat b = r(rho)
    mat b = b\.
    mat rho = nullmat(rho)\b

    ***-----------------------------------------------------------------------------

    mat final_lp = mean, rho
    mat drop mean
    mat drop rho

    ***-----------------------------------------------------------------------------

    mat list  final_lp
    mat all_part2 = final, final_lp
    mat list all_part2

    ***-----------------------------------------------------------------------------
    * Final

    mat final = all \ all_part2
    mat list final

    ***-----------------------------------------------------------------------------
    *** Table XXXX

    drop _all
    svmat final

    rename final1 PISA_BMP
    rename final2 LP_BMP
    rename final3 rho_PISA_LP_BMP
    drop final4
    rename final5 LP
    rename final6 rho_PISA_LP

    order PISA_BMP LP_BMP LP rho_PISA_LP_BMP rho_PISA_LP

    save "`outputs'/rho-BMP-PISA-LP.dta", replace

    ***-----------------------------------------------------------------------------

  restore

  ***-----------------------------------------------------------------------------
  ** Figures 1


  keep if indicator == 1 & diff >= 3 & diff <= 5 & subject == "read"   & subject_pisa == "read"

  keep countrycode region incomelevel lendingtype test value nonprof_all adj_nonprof_all year_pisa year_lp diff indicator

  bysort countrycode : egen maxyear = max(year_pisa)
  gen latest_pisa = year_pisa == maxyear

  gsort -latest_pisa lendingtype countrycode year_lp

  save "`outputs'/pisa-lp-by-country.dta", replace


  noi disp as res _n "Finished runing PISA BMP validation"

}
