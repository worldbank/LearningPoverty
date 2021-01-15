*==============================================================================*
* 0326 SUBTASK: DATAGAPS ANNEX
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", replace

  drop if countryname == "CUB"

  gen byte checkme = year_assessment>=2011 & !missing( adj_nonprof_all ) & lendingtype!="LNX"
  tab checkme

  tostring year_assessment, gen(year_str)
  gen flag = adj_nonprof_all !=.
  gen client = lendingtype != "LNX"
  gen year = year_str == ""
  gen str = string(flag)+string(client)+string(year)
  tab str
  tab str, m
  tab checkme
  tab region checkme

  gen checkme2 = .
  replace checkme2 = 1 if checkme2 == . & checkme == 1
  replace checkme2 = 2 if checkme2 == . & checkme == 0 & !missing( adj_nonprof_all ) &  year_assessment>=2011
  replace checkme2 = 3 if checkme2 == . & checkme == 0 & !missing( adj_nonprof_all )
  replace checkme2 = 4 if checkme2 == . & checkme == 0

  label define checkme2 1 "Part2" 2 "Part1" 3 "OldData" 4 "NoData"
  label values checkme2 checkme2

  tab region checkme2

  sum

  *browse countryname adj_nonprof_all enrollment_all nonprof_all test year_assessment if adj_nonprof_all != . &  year_assessment >= 2011

  kdensity year_assessment if year_str != "", title("") ytitle("Distribution of End of Primary Assessments")

  //mdensity year_assessment if year_str != "", title("") ytitle("Distribution of End of Primary Assessments") by(checkme) sort

  tab year_assessment if year_str != ""

  tab year_assessment checkme if year_str != "", col nof
  di 38/54
  di (8+12+2)/62

  tab year_str checkme [aw = population_2015_all ], col nof m

  tab year_assessment if year_str != ""

  tab idgrade if idgrade != -999
  tab idgrade checkme if idgrade != -999
  tab idgrade checkme if idgrade != -999 & year_assessment >= 2011

  tab idgrade checkme if idgrade != -999 & year_assessment >= 2011 [aw = population_2015_all ], col nof


  tab region checkme

  tab region checkme2
  tab region checkme2 [aw = population_2015_all ], cell nof
  tab region checkme2 [aw = population_2015_all ], row nof
  tab region checkme2 [aw = population_2015_all ], col nof

  gen region2 = region if checkme2 != 4
  tab region2 incomelevel , m col nof
  tab region2 incomelevel [aw = population_2015_all ], m col nof

  tab lendingtypename checkme2 [aw = population_2015_all ], m col nof
  tab lendingtypename checkme2 [aw = population_2015_all ], m row nof

  tab lendingtypename checkme2 [aw = population_2015_all ] if lendingtype != "LNX", m row nof

  noi disp as res _newline "Finished exporting datagaps for annex."

}

*******************************************

clear

cd "${clone}\08_2pager\081_data\"


local chosen_preference = $chosen_preference
use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", replace
keep countrycode *pop*
sort countrycode 
sum
save tmpk, replace

import delimited "${clone}\08_2pager\081_data\cleaned_assessment_metadata.csv", clear 
sort countrycode
save tmp1, replace

import delimited "${clone}\08_2pager\081_data\cleaned_learning_poverty_gender_split.csv", clear 
sort countrycode
save tmp2, replace

merge countrycode using tmp1

gen datastatus = .
replace datastatus = 1 if !missing(learning_poverty_rawlatest) & year >= 2011 & missing(datastatus)
replace datastatus = 2 if countrycode == "COD"
replace datastatus = 3 if !missing(learning_poverty_rawlatest) & year <  2011 & missing(datastatus)
replace datastatus = 4 if missing(learning_poverty_rawlatest) & uis_412b_equal_1 == 1 & missing(datastatus)
replace datastatus = 3 if countrycode == "PHL"
replace datastatus = 5 if countrycode == "CUB" 
replace datastatus = 5 if countrycode == "GRL" 
replace datastatus = 6 if missing(datastatus)

label define datastatus 1 "LP>=2011" 2 "Exception" 3 "LP<2011" 4 "NLA below bar" 5 "Out" 6 "NoData"
label values datastatus datastatus

gen datastatus2 = datastatus
recode datastatus2 2=3 
recode datastatus2 5=.

label values datastatus2 datastatus

_countrymetadata, match(countrycode)

drop _merge
sort countrycode 
merge countrycode using tmpk
drop _merge


tab datastatus2
tab datastatus2 [fw=anchor_population]
tab datastatus2 region [fw=anchor_population], col nof
 
export delimited "${clone}/03_export_tables/033_outputs/data_coverage_learning_poverty.csv", replace

*******************************************

tab datastatus

tab region datastatus 

tab datastatus if lendingtype != "LNX"
tab region datastatus  if lendingtype != "LNX"


order region countrycode countryname  incomelevelname lendingtypename lendingtypename idgrade year test datastatus uis_412b_equal_1
browse region countrycode countryname  incomelevelname lendingtypename lendingtypename idgrade year test datastatus uis_412b_equal_1
 