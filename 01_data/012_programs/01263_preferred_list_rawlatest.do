/*==============================================================================*
* PROGRAM: SELECTS DATABASE FROM RAWFULL ACCORDING TO PREFERENCE
*==============================================================================*/

/* In rawfull, isidvars = countrycode idgrade year_assessment test nla_code subject
   that is, proficiency is in the long format. Meanwhile, enrollment and population
   are in the wide format.

   To get to a "photo" of learning poverty in the world, we need to pick a single
   proficiency from each country (drop non-chosen proficiency observations), and
   pair it with a single enrollment method (drop other enrollment variables) and
   a single population metric (drop other population variables).

   This is what this program does - select a 'runname' out of rawfull, based on
   specified preferences.
*/

cap program drop preferred_list_rawlatest
program define   preferred_list_rawlatest, rclass
    syntax ,                       ///
           RUNNAME(string)         ///
           TIMSS_subject(string)   ///
           [                       ///
           NLA_keep(string)        ///
           DROP_assessment(string) ///
           DROP_round(string)      ///
           ENROLLment(string)      ///
           POPulation(string)      ///
           EXCEPTION(string)       ///
           TIMEwindow(string)      ///
           COUNTRYfilter(string)   ///
           WORLDalso               ///
		   DROPCTRYYR(string)	   ///
		   ANCHORYEAR(string)	   ///
   		   WINDOW(string)	   	   ///
		   YRMAX(string)           ///
		   YRMIN(string)           ///
		   FULL					   ///
		   ENROLLMENTYR(string)	   ///
		   POPULATIONYR(string)	   ///
		   toinclude 			   ///
		   coverage				   ///
		   * 					   ///
           ]

/*  The user must specify a number of options
(1) RUNNAME()	        - dictates the name of the run, and the resulting rawlatest file (i.e. preference1000)
(2) TIMSS_subject()   - dictates either math or science for TIMSS. Either enter string "math" or "science"
(3) NLA_keep()        - dictates that the countries in the list are to use the National Learning Assessment. This option takes nla_codes or countrycodes
(4) DROP_assessment() - dictates which assessments to disregard when calculating proficiency levels. This option takes assessment names (ie: SACMEQ)
(4) DROP_round()      - dictates which rounds to disregard when calculating proficiency levels. This option takes assessment_year (ie: TIMSS_2011)
(5) ENROLLment()      - dictates which enrollment to use (options: "validated" or "interpolated")
(6) POPulation()      - dictates which population to use (options: "10" "1014" "primary" "9plus")
(7) EXCEPTION()       - takes assessments (ie: HND_2013_LLECE) that will trump preferred order to ease adding exceptions to the rule
(8) TIMEwindow()      - option to be passed to population_weight program, to display a global number
(9) COUNTRYfilter()   - option to be passed to population_weight program, to display a global number
(10) WORLDalso        - option that displays table for WORLD also, when countryfilter is used
(11) DROPCTRYYR()     - option to drop specific country year
(12) ANCHORYEAR()     - Select Anchor Year
(13) WINDOW()     	  - Select Reporting Window (default value 4)
(14) FULL             - Reports pop weighted results for LD and SD
(15) ENROLLMENTYR()   - Select which enrolllment year should be used (default value, adjust) 
(16) POPULATIONYR()   - Select which population year should be used (default value, is anchoryear) 

  noi disp as err _newline "Chosen preference (representation of Learning Poverty in 2015)"
  noi preferred_list, runname("1005") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET AMPLB SEA-PLM) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECES CHL_2013_LLECES COL_2013_LLECES") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") dropctryyr("CUB_2019_LLECET") yrmax(2018) worldalso

log using c:/temp/mylog, text replace

  local runname 			"1005" 
  local timss_subject 	  "science" 
  local drop_assessment 	"SACMEQ EGRA AMPLB SEA-PLM LLECET"
  local nla_keep 			"AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1)"
  local enrollment 		"validated" 
  local population 		"1014"  
  local exception 		"HND_2013_LLECES CHL_2013_LLECES COL_2013_LLECES"
  local timewindow 		"year_assessment>=2011" 
  local countryfilter 	`"lendingtype!="LNX""'
  local dropctryyr 		"CUB_2006_LLECES"
  local anchoryear   =   2015
  local yrmax        =   2017
  local full             "full"
*  local enrollmentyr     "2015"
  local populationyr ""

*/

qui {

  version 16

  *-----------------
  * Load rawfull.dta
  *-----------------

  use "${clone}/01_data/013_outputs/rawfull.dta", clear
  
  *-----------------
  * default values
  * Anchor year. Use global if anchor year is not specified
  *-----------------

  if ("`anchoryear'" == "") {
		local anchoryear = ${anchor_year}
		noi dis in y "Anchor Year global value used: `anchoryear'"
  }  
  
  *-----------------
  * Population year. Use global if anchor year is not specified
  *-----------------

  if ("`populationyr'" == "") {
		local populationyr = `anchoryear'
		noi dis in y "Population Year is the same as Anchor Year: `anchoryear'"
  }  
    
  *-----------------
  * Window: default value +/- 4 years
  *-----------------

  if ("`window'" == "") {
		local window = 4
  }
  *-----------------
  * set up lower and upper bondoury of reporting window
  *-----------------

  if ("`yrmin'" == "") {
	local yrmin = `anchoryear'-`window'
  }
  if ("`yrmax'" == "") {
    local yrmax = `anchoryear'+`window'
  }

  if ("`timewindow'" == "") {
	
  }

  *-----------------
  * Indicatoe how enrollment year is to be used
  *-----------------

  if ("`enrollmentyr'" == "") {
	local enrollmentyr "adjust"
	local enrolvltype ="str"
  }
  if ("`enrollmentyr'" != "") {
    if ("`enrollmentyr'" == "adjust") {
		local enrolvltype "str"
    }
	else {
		local type = real("`enrollmentyr'")
		if ("`type'" != ".") {
			local enrolvltype "num"
		}	
		else {
			noi dis as error "ENROLLMENTYR option only accepts adjust or interger years."
			break
		}
	}
  }

  *---------------------------------------------------------------
  * Define which assessments to use
  * generate flag variable for indicate which variables should be used
  *---------------------------------------------------------------

  gen toinclude = .
  replace toinclude = 1 if year_assessment >= `yrmin' & year_assessment <= `yrmax' & year_assessment != -9999
  
  *-----------------
  * Check TIMSS_SUBJECT() option
  * Display error and exit if option not allowed
  *-----------------

  if inlist("`timss_subject'","math","science")==0 {
    noi dis as error "TIMSS_SUBJECT must be either math or science. Try again."
    break
  }
  else if "`timss_subject'" == "math" {
    * Math is kept and science is dropped for TIMSS
	* drop if subject=="science" & test=="TIMSS"
	replace toinclude = 0 if toinclude == 1 & subject=="scie" & test=="TIMSS"
  }
  else if "`timss_subject'" == "science" {
    * Jordan is one exeption: always keep math, even if science is specified
    * because it has no science data
    * drop if subject=="math" & test=="TIMSS" & countrycode!="JOR"
	replace toinclude = 0 if toinclude == 1 & subject=="math" & test=="TIMSS" & countrycode!="JOR"
  }


  *-----------------
  * Keep only NLAs passed in NLA_KEEP option, dropping all others
  *-----------------

  levelsof nla_code if test == "NLA", local(all_nlas)
  foreach  this_nla_code of local all_nlas {
    * If cannot find this nla_code in the list to keep
    if strmatch("`nla_keep'", "*`this_nla_code'*")==0 {
        * drop if nla_code == "`this_nla_code'"
		replace toinclude = 0 if toinclude == 1 & nla_code == "`this_nla_code'"
    }
  }

  *-----------------
  * Drop assessments listed in DROP_ASSESSMENT option
  * First, check if the option was used
  *-----------------

  if "`drop_assessment'" != "" {
    * For each test found in rawfull
    levelsof test, local(all_assessments)
    foreach this_test of local all_assessments {
      * Drop observations with this_test if it belongs to drop list
      if strmatch("`drop_assessment'", "*`this_test'*") == 1 {
        * drop if test == "`this_test'"
		replace toinclude = 0 if toinclude == 1 & test == "`this_test'"
      }
    }
  }

/*   * Drop surveys listed in DROP_ROUND option
  * First, check if the option was used
  if "`drop_round'" != "" {
    * For each round found in rawfull
    gen round = test + "_" + strofreal(year_assessment)
    levelsof round, local(all_rounds)
    foreach this_round of local all_rounds {
      * Drop observations with this_test if it belongs to drop list
      if strmatch("`drop_round'", "*`this_round'*") == 1 {
        drop if round == "`this_round'"
      }
    }
  } */
  
  *-----------------
  * Drop surveys listed in DROP_ROUND option
  * First, check if the option was used
  *-----------------

  if "`drop_round'" != "" {
    * For each round found in rawfull
    levelsof surveyid, local(all_rounds)
    foreach this_round of local all_rounds {
      * Drop observations with this_test if it belongs to drop list
      if strmatch("`this_round'", "*`drop_round'*") == 1 {
        * drop if surveyid == "`this_round'"
 	    replace toinclude = 0 if toinclude == 1 & surveyid == "`this_round'"
     }
    }
  }


  *-----------------
  * Check EXCEPTION() option
  * For as long as it's not empty, will read each surveyid in it and only
  * keep that observation for that country
  *-----------------

  while "`exception'" != "" {
    * Parsing out multiple surveyid passed as exceptions
    gettoken this_surveyid exception : exception, parse(" ")
    * Splitting countrycode from surveyid (first 3 letters)
    local this_countrycode = substr("`this_surveyid'",1,3)
    * Drop observations from this country that are not the given exception
    * drop if countrycode == "`this_countrycode'" & surveyid != "`this_surveyid'"
 	replace toinclude = 1 if toinclude == 1 & countrycode == "`this_countrycode'" & surveyid != "`this_surveyid'"
    * Remove trailing characters after the parsing
    local exception   = trim("`exception'")
  }



  *-----------------
  * Check DROPCTRYYR() option
  * For as long as it's not empty, will read each surveyid in it and only
  * keep that observation for that country
  *-----------------

  while "`dropctryyr'" != "" {
    * Parsing out multiple surveyid passed as exceptions
    gettoken this_surveyid dropctryyr : dropctryyr, parse(" ")
    * Splitting countrycode from surveyid (first 3 letters)
    local this_countrycode = substr("`this_surveyid'",1,3)
	* Drop observations from this country that are not the given exception
    * drop if countrycode == "`this_countrycode'" & surveyid == "`this_surveyid'"
 	replace toinclude = 0 if toinclude == 1 & countrycode == "`this_countrycode'" & surveyid == "`this_surveyid'"
    * Remove trailing characters after the parsing
    local dropctryyr   = trim("`dropctryyr'")
  }


  *-----------------
  * Splitting assessment year from surveyid (second stup, 4 numbers)
  * local this_year = substr("`this_surveyid'",5,4)    
  * Drop observations from this country that are not the given exception
  *-----------------	
  
  replace toinclude = -8 if toinclude == . & (year_assessment > `yrmax' | year_assessment < `yrmin') 
  replace toinclude = -9 if year_assessment == -9999 
  
  sum toinclude if toinclude == -8
  if (`r(N)'!= 0) {
    noi dis ""
    noi dis ""
	noi dis as error "{pstd}The database has Country/Years outside the min and max selected. Adjust timewindow and yrmax options and run the code again.{p_end}"
	break
  }

  * drop observations which should not be included
  drop if toinclude == 0

  *-----------------
  * Check ENROLLMENT() option
  * drop all enrollment years except `anchoryear'
  * select if enrollment data will be matched using a fixed year for all countries, or the closet enrollment to 
  * year_assessment (adjust option)
  *-----------------
  
  if ("`enrollmentyr'" != "adjust") & ("`enrolvltype'" == "num") {
	  * Must be one of enrollment methods supported
	  * Assume "validated" as default if not specified    
	  if "`enrollment'" == "validated" | "`enrollment'" == "" {
		drop enrollment_interpolated*
		rename enrollment_validated_* enrollment_*
	  }
	  else if "`enrollment'" == "interpolated" {
		drop enrollment_validated*
		rename enrollment_interpolated_* enrollment_*
	  }
	  else {
		noi dis as error `"ENROLLMENT must be either "interpolated" or "validated". Try again."'
		break
	  }
      * keep only enrollment variables from selected year
	  foreach var of varlist enrollment_*  {
		if strmatch("`var'","*`enrollmentyr'*") == 0 & strmatch("`var'","*source*") == 0 & strmatch("`var'","*definition*") == 0 {
			drop `var'
		}
		else {
			local newname = subinstr("`var'","_`enrollmentyr'","",.)
			rename `var' `newname'
		}
	  }
      * keep only year_enrollment variables from selected year
	  foreach var of varlist year_enrollment_*  {
		if strmatch("`var'","*`enrollmentyr'*") == 0 {
			drop `var'
		}
		else {
			local newname = subinstr("`var'","_`enrollmentyr'","",.)
			rename `var' `newname'
		}
	  }
  }
  if ("`enrollmentyr'" == "adjust") {
  	  * Must be one of enrollment methods supported
	  * Assume "validated" as default if not specified    
	  if "`enrollment'" == "validated" | "`enrollment'" == "" {
		drop enrollment_interpolated*
		rename enrollment_validated_* enrollment_*
	  }
	  else if "`enrollment'" == "interpolated" {
		drop enrollment_validated*
		rename enrollment_interpolated_* enrollment_*
	  }
	  else {
		noi dis as error `"ENROLLMENT must be either "interpolated" or "validated". Try again."'
		break
	  }
     * keep only enrollment variables from selected year
	 gen enrollment_all		= .
	 gen enrollment_ma		= .
	 gen enrollment_fe		= .
	 gen enrollment_flag	= .
	 gen enrollment_year	= .
	 levelsof year_assessment if year_assessment != -9999
	 foreach yr in `r(levels)'   {
		* loop through all countries
		replace enrollment_all	= enrollment_all_`yr'	if enrollment_all == .	& year_assessment == `yr'
		replace enrollment_ma	= enrollment_ma_`yr'	if enrollment_ma == .	& year_assessment == `yr'
		replace enrollment_fe	= enrollment_fe_`yr'	if enrollment_fe == .	& year_assessment == `yr'
		replace enrollment_flag	= enrollment_flag_`yr'	if enrollment_flag == .	& year_assessment == `yr'
		replace enrollment_year	= year_enrollment_`yr'	if enrollment_year == .	& year_assessment == `yr'
	 	drop enrollment_*_`yr' year_enrollment_`yr'
	  }
  }
  
  * drop remaining year of enrollment variables (for years that do not have learning assessment as defined in line 373)
  drop year_enrollment_*
  
  *-----------------
  * Check POPULATION() option
  * Assume "1014" as default if not specified
  *-----------------

  if "`population'"=="" local population == "1014"
  * Give error if option specified does not exist
  if inlist("`population'","10","1014","0516","primary","9plus") == 0 {
    noi dis as error `"POPULATION method not supported. Try again (use: "10", "1014", "0516", "primary" or "9plus")."'
    break
  }
  else {
    foreach method in 10 0516 1014 primary 9plus {
      * Drop population variables that were not specified
      if "`population'" != "`method'" {
		drop population*_`method'_*
	  }
    }
  }
  
 
  * drop all population years except `anchoryear'
    foreach var of varlist population_* {
	if strmatch("`var'","*`populationyr'*") == 0 & strmatch("`var'","*source*") == 0 & strmatch("`var'","*definition*") == 0 {
		drop `var'
	}
	else {
	    local newname = subinstr("`var'","_`populationyr'","",.)
		rename `var' `newname'
	}
  }

  * Rename the population variable
  rename population_*_`population' population_`anchoryear'_*
  
  *-----------------
  * replace year_assessment -9999 for anchoryear
  *-----------------

  replace year_assessment = `anchoryear'  if year_assessment == -9999

  *-----------------
  * Grade Window
  *-----------------
  * Only assessments of grade 3-6 are considered, so drop all other grades that made it so far
  keep if (idgrade>=3 & idgrade<=6) | missing(idgrade) | idgrade==-999
  * But after considering the assessment hierarchy, we will re-consider grade hierarchy

  *-----------------
  * Time Window
  *-----------------
  * For multiple instances of the same test, the one closest to the anchor_year
  * is preferred, any other is dropped.
  * When tied, chose the least recent (ie: anchor_year=2015, 2015 > 2014 > 2016)
  * which is why we subtract the .01 in the aux variable below
  gen years_from_anchor = abs(`anchoryear' - year_assessment + .01)
  bysort countrycode test: egen min_years_from_anchor = min(years_from_anchor)
  * Will only keep the preferred year for each test (including test = "None")
  keep if (years_from_anchor == min_years_from_anchor)
  * Drop aux variables
  drop *years_from_anchor

  *----------------------
  * Assessment Hierarchy
  *----------------------
  * General rule: ILAs > RLAs > EGRA
  * Exception: NLAs are treated as special case, since they trump all other selections

  * Dummies for each assessment (just to make the code more readable)
  foreach assessment in NLA PIRLS TIMSS EGRA {
    gen byte is_`assessment' = (test == "`assessment'")
  }
  * Regional Learning Assessments are bundled together
  gen byte is_RLA   = inlist(test,"LLECES","LLECET","PASEC","SACMEQ","SEA-PLM","AMPLB")

  * Originally (anchor year of 2015), exceptions defined in relationship to 2010.
  * To make it flexible for future updates
  *local year_limit = `anchoryear' - 5

  * Preferred ranking of assessments:
  gen int assessment_ranking = .
  * 0. Countries without assessment data should be kept, as well as NLA observations
  replace assessment_ranking = 0 if  is_NLA
  * 1. PIRLS within the prefered reporting window
  replace assessment_ranking = 1 if (is_PIRLS & year_assessment >= `yrmin' & year_assessment <= `yrmax') 
  * 2. TIMSS  the prefered reporting window
  replace assessment_ranking = 2 if (is_TIMSS & year_assessment >= `yrmin' & year_assessment <= `yrmax')
  * 3. Regional Learning Assessment  the prefered reporting window
  replace assessment_ranking = 3 if (is_RLA   & year_assessment >= `yrmin' & year_assessment <= `yrmax')
  * 4. PIRLS outside the prefered reporting window
  replace assessment_ranking = 4 if (is_PIRLS & (year_assessment <  `yrmin' | year_assessment > `yrmax'))
  * 5. TIMSS outside the prefered reporting window
  replace assessment_ranking = 5 if (is_TIMSS & (year_assessment <  `yrmin' | year_assessment > `yrmax'))
  * 6. Regional Learning Assessment outside the prefered reporting window
  replace assessment_ranking = 6 if (is_RLA   & (year_assessment <  `yrmin' | year_assessment > `yrmax'))
  * 7. EGRAs
  replace assessment_ranking = 7 if (is_EGRA)
  * 8. No assessment data
  replace assessment_ranking = 8 if test == "None"

  * Keep only the preferred assessment
  bysort countrycode: egen min_assessment_ranking = min(assessment_ranking)
  
  keep if (assessment_ranking == min_assessment_ranking)
  * Drop aux variables
  drop is_* *assessment_ranking

  * NOTE: there may be more than one grade assessed, which is taken care of in next step

  *-----------------
  * Grade Hierarchy
  *-----------------
  * Grade 4 > Grade 5 > Grade 6 > Grade 3
  gen idgrade_ranking = .
  replace idgrade_ranking = 1 if idgrade == 4
  replace idgrade_ranking = 2 if idgrade == 5
  replace idgrade_ranking = 3 if idgrade == 6
  replace idgrade_ranking = 4 if idgrade == 3

  * Keep only the preferred grade
  bysort countrycode: egen min_idgrade_ranking = min(idgrade_ranking)
  keep if (idgrade_ranking == min_idgrade_ranking)
  * Drop aux variables
  drop *idgrade_ranking

  *------------------------------*
  * Enrollment adjustments
  * this is required to replicate October/2019 results (52.7)
  *------------------------------*

  * replace enrollment_all =  97.73  if countrycode == "IND"  

  *------------------------------*
  * Learning poverty calculation
  *------------------------------*
  * Adjusts non-proficiency by out-of school
  foreach subgroup in all fe ma {
    gen double lpv_`subgroup' 	= 100*(1-(enrollment_`subgroup'/100)*(1-nonprof_`subgroup'/100))
	gen double sd_`subgroup' 	= 100-enrollment_`subgroup' 
	gen double ld_`subgroup' 	= nonprof_`subgroup'
	gen double ldgap_`subgroup' = fgt1_`subgroup'*100
    gen double ldsev_`subgroup' = fgt2_`subgroup'*100
    gen double lpgap_`subgroup' = sd_`subgroup'+ldgap_`subgroup' if !missing(sd_`subgroup') & !missing(ldgap_`subgroup')
    gen double lpsev_`subgroup' = (((sd_`subgroup'/100)^2)+fgt2_`subgroup')*100 if !missing(sd_`subgroup') & !missing(fgt2_`subgroup')

    label var lpv_`subgroup' 	"Learning Poverty (`subgroup')"
    label var sd_`subgroup' 	"Schooling Deprivation (`subgroup')"
    label var ld_`subgroup' 	"Learning Deprivation (`subgroup')"
    label var ldgap_`subgroup' 	"Learning Deprivation Gap (`subgroup')"
    label var ldsev_`subgroup' 	"Learning Deprivation Severity (`subgroup')"
    label var lpgap_`subgroup' 	"Learning Poverty Gap (`subgroup')"
    label var lpsev_`subgroup' 	"Learning Poverty Severity (`subgroup')"
  }
  gen byte  lp_by_gender_is_available = !missing(lpv_fe) & !missing(lpv_ma)
  label var lp_by_gender_is_available   "Dummy for availibility of Learning Poverty gender disaggregated"



  *-----------------
  * Final touches
  *-----------------
  * Double check that each country appears only once by now
  duplicates tag countrycode, gen(duplicates_countrycode)
  * Will break here if not one observation per countrycode
  cap: assert duplicates_countrycode == 0
  * drop TIMSS MATH assessments expect JOR
  if (_rc != 0) {
    drop if duplicates_countrycode == 1 & subject=="math" & test=="TIMSS" & countrycode!="JOR"
	drop duplicates_countrycode
    * Double check that each country appears only once by now
    duplicates tag countrycode, gen(duplicates_countrycode)
  }
  * Will break here if not one observation per countrycode
  cap: assert duplicates_countrycode == 0
  if (_rc != 0) {
    noi di ""
    noi di as err "Duplicated countries found. Check options."
	noi list countrycode idgrade test year_assessment subject sd_all toinclude if duplicates_countrycode == 1
	exit 198
  }
  * Now can drop this auxiliary variable
  drop duplicates_countrycode

  * Order
  order countrycode-year_assessment lpv*

  * Label the preference and creates a description
  gen str preference = "`runname'"
  gen preference_description = "`runname': TIMSS(`timss_subject')+NLA(`nla_keep')+Drop(`drop_assessment')+Population(`population')+Enrollment(`enrollment')"
  label var preference "Preference"
  label var preference_description "Preference description"

  * Auxiliary variables for generating weights
  clonevar anchor_population = population_`anchoryear'_all
  gen anchor_population_w_assessment = anchor_population * !missing(ld_all)
  label var anchor_population_w_assessment "Anchor population * has data dummy"

  * Store anchor year
  gen anchor_year = `anchoryear'
  
  * store Enrollment type
  gen enrollmentyr = "`enrollmentyr'"
  
  * rename SE variables
  rename se_nonprof_* se_ld_*
  
  *----------------------------------------------------------------
  * remove EGRAs and SACMQs observations. This will need to be revised with those assessments
  * become eligible to be used by the Learning Poverty database. The reason for not including 
  * can be multiple. Unknown alignment as of June 2022 update with the MPL and GPF, or 
  * non-elgible grade (not 4, 5, 6)
  foreach var in lpv ld se_ld ldgap ldsev lpgap lpsev sd enrollment nonprof fgt1 fgt2 {
 	foreach subgroup in all fe ma {
		replace `var'_`subgroup' = . if `var'_`subgroup' != . & test == "EGRA"
		replace `var'_`subgroup' = . if `var'_`subgroup' != . & test == "SACMEQ"
	}
  }
  foreach var of varlist  subject enrollmentyr enrollment_source  {
	replace `var' = "" if `var' != "" & test == "EGRA"
	replace `var' = "" if `var' != "" & test == "SACMEQ"
  }
  *----------------------------------------------------------------
  * comment out this loop for debug the code    
  foreach var of varlist idgrade enrollment_year  year_assessment  enrollment_flag  {
	replace `var' = -999 if `var' != . & test == "EGRA"
	replace `var' = -999 if `var' != . & test == "SACMEQ"
  } 
  foreach var of varlist  surveyid test  {
	replace `var' = "" if `var' != "" & test == "EGRA"
	replace `var' = "" if `var' != "" & test == "SACMEQ"
  }
  *----------------------------------------------------------------

  * Save
  compress

  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
    local description "Preference `runname' dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions."
    local sources "All population, enrollment and proficiency sources combined."
    edukit_save, filename("preference`runname'_rawlatest") path("${clone}/01_data/013_outputs/")   ///
                 idvars(countrycode preference) ///
                 varc("value lpv* *ld* sd* ldgap* ldsev* lpgap* lpsev* enrollmentyr population_* anchor_*; trait idgrade test nla_code subject *year* enrollment_flag enrollment_*source* *definition* *threshold* surveyid countryname region* adminregion* incomelevel* lendingtype* cmu preference_description lp_by_gender_is_available toinclude") ///
                 metadata("description `description'; sources `sources'; filename Rawlatest")
  }
  else save "${clone}/01_data/013_outputs/preference`runname'_rawlatest.dta", replace
 
  *--------------------------------
  * Display number by region
  *--------------------------------
  * NOTE: this section is only for display (makes QA easier), but will not be saved in the preference dataset

  * Displays global number based on population weights for given options
  noi population_weights, preference(`runname') timewindow(`timewindow') countryfilter(`countryfilter') `full' yrmin(`yrmin') yrmax(`yrmax') `toinclude' `coverage'
  noi output_display


  * Because most often we want to see both PART2 countries and WORLD, does worldalso when option is specified
  if ("`worldalso'" == "worldalso") {
	noi population_weights, preference(`runname') timewindow(`timewindow')  `full'  yrmin(`yrmin') yrmax(`yrmax') `toinclude' `coverage'
    noi output_display
  }
}

* pass return from population weights
return add

end

/*

log close
*/

