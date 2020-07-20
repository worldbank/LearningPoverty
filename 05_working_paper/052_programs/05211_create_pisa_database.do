*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 05_WORKINGPAPER: Relationship between Reading and Math Proficiency (PISA)
*==============================================================================*

cap whereis myados
if _rc == 0 global myados "`r(myados)'"

global rawdata 	"${clone}\05_working_paper\051_rawdata"
global output 	"${clone}\05_working_paper\053_outputs"

*-----------------------------------------------------------------------------
* Load groupdata ADO

do "${myados}\groupdata\src\groupdata.ado"

*-----------------------------------------------------------------------------
* load dataset

use "\\wbgfscifs01\GEDEDU\GDB\Projects\WLD_2020_LPV-BIN\bin_scores.dta" , clear

* save files in RAWDATA
cap: save "${rawdata}\bin_scores.dta" , replace
export delimited using "${rawdata}\bin_scores.csv", replace 

* keep PISA
keep if assessment == "PISA"
  
*-----------------------------------------------------------------------------
* prepare dataset

mat drop _all
sort countrycode year outcome idgrade  bin
gen tmp = countrycode + "#" + string(year) + "#" + outcome + "#" + string(idgrade)
encode tmp, gen( ctry_year_subject_grade_code)
gen ctry_year_subject_grade = countrycode + "#" + string(year) + "#" + outcome + "#" + string(idgrade)
sort ctry_year_subject_grade_code
bysort ctry_year_subject_grade_code : gen 		cumulative = pdf if pdf == pdf[1]
bsort ctry_year_subject_grade_code : replace	cumulative = pdf + cumulative[_n-1] if pdf != pdf[1]
replace cumulative = cumulative - 1
replace cumulative = . if bin == 0
export delimited using "${rawdata}\pisa-reading-distributions.csv", replace 
gen bin2 = bin if bin != 0

*-----------------------------------------------------------------------------
* Validation of Group data estimation
* loop through all distributions

levelsof ctry_year_subject_grade 

qui foreach ctry in `r(levels)' {
    
	noi di "`ctry'"
		
	list ctry_year_subject_grade in 1 
	
	* obtain identifiers
	levelsof countrycode			if ctry_year_subject_grade == "`ctry'" & bin == 0
	local code 		= `r(levels)'
	levelsof assessment				if ctry_year_subject_grade == "`ctry'" & bin == 0
	local test 		= `r(levels)'
	levels survey					if ctry_year_subject_grade == "`ctry'" & bin == 0
	local surveyid 	= `r(levels)'
	levelsof outcome				if ctry_year_subject_grade == "`ctry'" & bin == 0
	local outcome 	= `r(levels)'
	levelsof year		 			if ctry_year_subject_grade == "`ctry'" & bin == 0
	local year 		= `r(levels)'
	levelsof idgrade		 		if ctry_year_subject_grade == "`ctry'" & bin == 0
	local grade 	= `r(levels)'
		
	* country code
	sum ctry_year_subject_grade_code  if ctry_year_subject_grade == "`ctry'" & bin == 0
	local c = r(mean)
		
	* distribution mean
	cap: sum m_score_bin 	if ctry_year_subject_grade == "`ctry'"  & bin == 0
	local m = r(mean)
		
	* select only PIRLS
	if ("`test'" == "PIRLS") {
		local cutoff = 400
	}
	if ("`test'" == "LLECE") {
		local cutoff = 513.66
	}
	if ("`test'" == "PASEC") {
		local cutoff = 595.1
	}
	if ("`test'" == "TIMSS") {
		local cutoff = 400
	}
	if ("`test'" == "PISA") {
		local cutoff = 407.47
	}
	if ("`test'" == "SAQMEC") {
		local cutoff = 509
	}

	local matname = subinstr("`ctry'","#","_",.)
	
	if (`m' != .) {
				
	
		* Group data estimate of learnig poverty
		groupdata m_score_bin if ctry_year_subject_grade == "`ctry'" & bin != 0 , ///
			mean(`m' ) zl(`cutoff') type(5) nofigure binvar(bin2)
						
		mat `matname' = r(results)
	}
	
}

*-----------------------------------------------------------------------------
* append matrixs from memory

levelsof ctry_year_subject_grade 

qui foreach ctry in `r(levels)' {
	
	local matname = subinstr("`ctry'","#","_",.)

	* load matrix from memory 
	clear
	cap : svmat double `matname', names(col)

	* create complementary variables
	gen name = "`matname'"
	order name

	* append loaded matrix to cummulative file
	cap: append using "${output}\pisa-groupdata.dta"
	save "${output}\pisa-groupdata.dta", replace

}

gen countrycode = word(subinstr(name,"_", " ",.),1)
gen year 		= real(word(subinstr(name,"_", " ",.),2))
gen test 		= upper(word(subinstr(name,"_", " ",.),4))
gen subject		= word(subinstr(name,"_", " ",.),5)
gen idgrade		= real(word(subinstr(name,"_", " ",.),6))

order countrycode year test subject idgrade 

sort countrycode year indicator 

	  * labels
		  label define var 1 "FGT(0)" , add modify
		  label define var 2 "FGT(1)" , add modify
		  label define var 3 "FGT(2)" , add modify
		  label define var 4 "Gini"   , add modify

		  label define var 5  "L(0;pi)=0"                       , add modify
		  label define var 6  "L(1;pi)=1"                       , add modify
		  label define var 7  "L'(0+;pi)>=0"                    , add modify
		  label define var 8  "L''(p;pi)>=0 for p within (0,1)" , add modify

		  label define model 0 "Unit Record"                    , add modify
		  label define model 1 "QG Lorenz Curve"                , add modify
		  label define model 2 "Beta Lorenz Curve"              , add modify

		  label define type 1 "Estimated Value"                 , add modify
		  label define type 2 "with respect to the Mean"        , add modify
		  label define type 3 "with respect to the Gini"        , add modify
		  label define type 4 "Checking for consistency of lorenz curve estimation", add modify

		  label define value -99  "NA"  , add modify
		  label define value 1    "OK"  , add modify
		  label define value 0    "FAIL", add modify

		  label values model  model
		  label values type  type
		  label values indicator    var
		  label values value  value

		  label var model Model
		  label var type Type
		  label var indicator   Indicator

sort countrycode year name indicator

save , replace
export delimited using "${output}\pisa-groupdata.csv", replace 
export delimited using "${output}\pisa-groupdata.dta", replace 
 
*-----------------------------------------------------------------------------

 