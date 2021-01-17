* v.0.4 JPAzevedo
** option SAVECTRYFILE created
* v.0.3.1 BStacy
** time region collumn prior to merge
* v.0.3 JPAzevedo
** create INPUTFOLDER Option default value CLONE
** add 25 as a CATINITIAL
* v.0.2 JPAzevedo
** add NOSIMULATION OPTION
** remove drop year_population from code (drop year_population is now a condition
** option all year_populations


/*Execute an ado file to produce the dataset for the simulations.  The configuration for the ado file matches closesly
the configuration for the _preferred_list ado used to produce the raw latest.  This is intentional as
1)Develops database for preferred list
The user must specify a number of options.
(1) preference() - 	which dictates which preference to use for the adjusted proficiency levels.  Current options are 0,1,2,...,926.
(3) dropassess() 	-	which dictate which assessments to not calculate proficiency levels.  This option takes assessment names
(4) dropgrade() 	-	which dictate which grades to not calculate proficiency levels.  This option takes assessment names
(5) filename()	-	which dictates the name of the file produced to be used in the simulation.
(6) TIMSS_SUBJECT()-dictates either math or science for TIMSS.  either enter string "math" or "science"
(7) enrollment()	-dictates which enrollment to use.  original enrollment, validated, or interpolated enrollment for the spells
(8) EGRADROP()	-drop specific EGRAs, 3rd grade, 4th grade, non-nationally representative.
As an example:  _simulation_dataset,  preference(926)  dropassess(SACMEQ) dropgrade(3) filename(simulation_926) timss(science) enrollment(validated)
Specifies that Bangladesh, China, India, and Pakistan use National Learning Assessments.  Preference 926 is applied for all assessments.
*/



cap  program drop _simulation_dataset
program define _simulation_dataset, rclass

	version 15
	syntax [varlist]  [,							///
						IFSPELL(string)					///
						IFSIM(string)						///
						IFWINDOW(string)				///
						WEIGHT(string)					///
						PREFERENCE(string)			///
						SPECIALINCLUDEASSESS(string)    ///
						SPECIALINCLUDEGRADE(string)     ///
						DROPGRADE(string)             	///
						FILENAME(string)             	///
						USEFILE(string)             	///
						TIMSS(string)					///
						ENROLLMENT(string)				///
						EGRADROP(string)				///
						QUIET							///
						PERCENTILE(string)				///
						NOSIMULATION					///
						ALLyear_populationS						///
						POPULATION_2015(string)		    ///
						INPUTFOLDER(string)				///
						SAVECTRYFILE(string)			///
						GROUPINGSPELLS(string)			///
						GROUPINGSIM(string)			///
						GROWTHDYNAMICS(string)		///
						]

	if ("`inputfolder'" == "") {
		loc inputfolder clone
	}

	if "`quiet'" == "" {
		loc qui "noi "
	}

	if "`percentile'" == "" {
		loc percentile "50(10)90"
	}

	noi di _n in r "ATTENTION: " in y "_simulation_dataset" in g " is pulling the data from " in y "`inputfolder'"
	noi di _n as text "preference: `preference' ; groupingspells : `groupingspells'"

	quietly {

		************************************************************************
		********** FIRST PART - CREATES THE SIMULATION GROWTH RATES ************
		*************** only needed if no usefile is provided ******************
		* Not clear why needed if using 0220 & 0221 to create and aggreg spells*
		************************************************************************

		clear
		import delimited "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS.csv",
		*Correcting idgrade for ZAF "2006-11"
		replace idgrade = 5 if countrycode == "ZAF" & test == "PIRLS" & spell == "2006-2011"
		gen year_assessment_i = substr(spell,1,4)
		destring year_assessment_i, replace
		gen year_assessment = substr(spell,6,4)
		destring year_assessment, replace

		save "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS_yr.dta", replace


		use "${`inputfolder'}/01_data/013_outputs/rawfull.dta", clear
		gen year=year_assessment
		*nla_code should be distributed over s rather than being available in each .

		*temporarily rename test to assessment and idgrade to grade, change back after merge.
		rename test assessment
		rename idgrade grade

		*------------------------------*
		* Learning poverty calculation
	  *------------------------------*
		* Adjusts non-proficiency by out-of school
		foreach subgroup in all fe ma {
			gen adj_nonprof_`subgroup' = 100 * ( 1 - (enrollment_validated_`subgroup'/100) * (1 - nonprof_`subgroup'/100))
			label var adj_nonprof_`subgroup' "Learning Poverty (adjusted non-proficiency, `subgroup')"
		}


		gen adj_pct_reading_low_rawfull= 100-adj_nonprof_all

		merge m:1 countrycode   using "${`inputfolder'}/01_data/013_outputs/preference`preference'.dta", keepusing(test idgrade incomelevel lendingtype nonprof_all)
	 	gen adj_pct_reading_low= 100-adj_nonprof_all
		*change name in rawlatest of assessment to test_rawlatest, and revert back to test from assessment

		rename adj_pct_reading_low adj_pct_reading_low_rawlatest
		rename adj_pct_reading_low_rawfull adj_pct_reading_low


		gen initial_poverty_level_temp = 100 - adj_pct_reading_low_rawlatest
		cap gen     initial_poverty_level = "0-25% Learning Poverty"
		cap replace initial_poverty_level = "25-50% Learning Poverty"  if initial_poverty_level_temp >= 25
		cap replace initial_poverty_level = "50-75% Learning Poverty"  if initial_poverty_level_temp >= 50
		cap replace initial_poverty_level = "75-100% Learning Poverty" if initial_poverty_level_temp >= 75

		rename test test_rawlatest
		rename assessment test
		*same for grade
		rename idgrade idgrade_rawlatest
		rename grade idgrade

		drop if _merge==1

		gen enrollment=enrollment_validated_all
		drop if subject!="`timss'" & test=="TIMSS"  & countrycode!="JOR"


		*Keep assessments listed in specialincludeassess option
		levelsof test, local(list_alltest)
		foreach tst in `list_alltest' {
			if strmatch("`specialincludeassess'", "*`tst'*")==0 {
				drop if test=="`tst'"
				di "`tst'"
			}
		}

		*Keep grades listed in specialincludegrades option
		levelsof idgrade, local(list_grd)
		foreach grd in `list_grd' {
			if strmatch("`specialincludegrade'", "*`grd'*")==0 {
				drop if idgrade==`grd'  & idgrade!=idgrade_rawlatest
				di "`grd'"
			}
		}

		sort countrycode nla_code idgrade  test subject
		count


		*Cleaning the data file
		keep region regionname countrycode countryname incomelevel incomelevelname lendingtype ///
			lendingtypename year_population year_assessment idgrade test source_assessment  	///
			enrollment adj_pct_reading_low* subject nla_code  initial_poverty_level

		*Generating all possible combinations of forward spells:
		sort countrycode nla_code idgrade  test subject    year_assessment
		bysort countrycode nla_code idgrade  test subject   : gen spell_c1 = string(year_assessment[_n-1]) + "-" + string(year_assessment)
		bysort countrycode nla_code idgrade  test subject   : gen spell_c2 = string(year_assessment[_n-2]) + "-" + string(year_assessment)
		bysort countrycode nla_code idgrade  test subject   : gen spell_c3 = string(year_assessment[_n-3]) + "-" + string(year_assessment)
		bysort countrycode nla_code idgrade  test subject   : gen spell_c4 = string(year_assessment[_n-4]) + "-" + string(year_assessment)

		reshape long spell_c, i(countrycode nla_code idgrade  test subject year_assessment subject) j(lag)
		ren spell_c spell

		*tag if actual spell:
		gen spell_exists=(length(spell) == 9 )

		**********************************************
		*Preparing the data for simulations:
		**********************************************
		*The data should be restructured for unique identifiers:
		sort countrycode nla_code idgrade  test subject    year_assessment spell lag

		*Rules for cleaning the spell data:
		*Bringing in the list of countries and spells for which the data is not comparable:

		merge m:1 countrycode idgrade test year_assessment spell using  "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS_yr.dta", assert(master match using) keep(master match) keepusing(comparable) nogen
		drop if comparable == 0

		*Generating preferred consecutive spells:
		sort countrycode nla_code idgrade  test subject    year_assessment
		bysort countrycode nla_code idgrade  test subject   : egen lag_min = min(lag)
		*Keeping the comparable consecutive spells
		keep if lag == lag_min

		*All comparable spells for TIMSS/PIRLS
		assert comparable == 1 if !missing(comparable)

		*Annual change in enrollment, adjusted proficiency and proficiency
		sort countrycode nla_code idgrade  test subject    year_assessment
		bysort countrycode nla_code idgrade  test subject    : gen delta_adj_pct = (adj_pct_reading_low-adj_pct_reading_low[_n-1])/(year_assessment-year_assessment[_n-1])
		bysort countrycode nla_code idgrade  test subject    : gen initial_adj_pct = adj_pct_reading_low[_n-1]
		bysort countrycode nla_code idgrade  test subject    : gen final_adj_pct = adj_pct_reading_low


		*drop observatoins specified by [if] [in].
		if `"`ifspell'"'!=""  {
			di `"`ifspell'"'
			keep `ifspell'
		}

		/* weights */

		if ("`weight'" == "") {
			cap tempname wtg
			cap gen `wtg' = 1
			local weight2 ""
			loc weight "fw"
			loc exp    "=`wtg'"
		}

		*Generating deltas in terms of reduction of gap to the frontier
		gen gap_to_frontier = 100-adj_pct_reading_low
		bysort countrycode nla_code idgrade  test subject   : gen red_gap_frontier = -1*(gap_to_frontier-gap_to_frontier[_n-1])/(year_assessment-year_assessment[_n-1])
		bysort countrycode nla_code idgrade  test subject   : gen pct_red_gap = (red_gap_frontier/gap_to_frontier[_n-1])
		gen pct_red_gap_100 = pct_red_gap*100

		*Generating categories of countries
		gen catinitial = .
		foreach var in 25 50 75 100 {
			replace catinitial= `var' if initial_adj_pct  <= `var' & catinitial== .
		}

		*Developing country weights to give each country equal weight despite the number of observations:
		*Counting the country observations where delta exists:

		*Set weights to unity if no weights specified
		if "`weight2'"=="" {
			gen wgt=1
		}

		if "`weight'"!="" {
			local weight2 "`weight'"
			bysort  countrycode: gen delta_exists = !missing(delta_adj_pct)
			bysort  countrycode delta_exists: gen w = _N
			cap gen wgt = .
			replace wgt = 1/w
		}

		*Calculating global 90th, 80th and 70th percentiles:

		forvalues i = `percentile' {
			egen delta_global_`i' = pctile(delta_adj_pct) if test != "EGRA", p(`i')
		}
		gsort -delta_adj_pct
		list countryname initial_adj_pct final_adj_pct delta_adj_pct test spell if delta_adj_pct > delta_global_90 & !missing(delta_adj_pct)
		tabstat delta_global_90 , by(region)

		*Calculating global 90th, 80th and 70th percentiles with weights
		forvalues i = `percentile' {
			gen delta_global_w_`i' = .
		}
		gen threshold="III"
		levelsof threshold, local(tr)
		foreach t of local tr {
			_pctile delta_adj_pct [weight = wgt] if threshold == "`t'" & test != "EGRA", percentiles(`percentile')
			local counter=1
			forvalues i = `percentile' {
				replace delta_global_w_`i' = r(r`counter') if threshold == "`t'" & test != "EGRA"
				local counter=`counter' + 1
			}
		}



		`qui' di "Number of spells per `groupingspells'"
		`qui' tab `groupingspells' if spell_exists == 1

		`qui' di "Number of spells per test"
		`qui' tab test if spell_exists == 1

		`qui' di "Spells per `groupingspells'"
		`qui' tab test if spell_exists == 1

		`qui' tab spell if spell_exists == 1

		*Comparing percentiles with and without weight
		`qui' di "Comparing output by  with and without weights (90th percentile)"
		`qui' tabstat delta_adj_pct delta_global_90 delta_global_w_90  [`weight'`exp'] if spell_exists == 1, ///
				  by() stat(mean N)

		encode `groupingspells', gen(reg_n)

		egen group = group( reg_n)

		*Percentiles by wbregion:

		forvalues i = `percentile' {
			bysort  reg_n: egen delta_reg_`i' = pctile(delta_adj_pct) if test != "EGRA", p(`i')
		}
		`qui' di "Results by `groupingspells'"
		`qui' tabstat delta_adj_pct delta_reg*  [`weight'`exp'], by(reg_n)


		cap list countryname initial_adj_pct final_adj_pct delta_adj_pct test idgrade spell if delta_adj_pct > delta_reg_90 & !missing(delta_adj_pct) & region == "SSF"

		*Calculating regional 90th, 8th and 70th percentiles with weights
		forvalues i = `percentile' {
			gen delta_reg_w_`i' = .
		}

		levelsof threshold, local(tr)
		foreach t of local tr {
			levelsof `groupingspells', local(reg)
			foreach r of local reg {
				count if !missing(delta_adj_pct) & threshold == "`t'" & `groupingspells' == "`r'" & test != "EGRA"
				local count=`r(N)'
				*Only make change to regional if we have at least 3 regional spells
				if `count'<3 {
					forvalues i = `percentile' {
						replace delta_reg_`i' = . if threshold == "`t'" & `groupingspells' == "`r'" & test != "EGRA"
					}
				}
				if `count'>=3 {
					_pctile delta_adj_pct [weight = w] if threshold == "`t'" & `groupingspells' == "`r'" & test != "EGRA", percentiles(`percentile')
					local counter=1
					forvalues i = `percentile' {
						replace delta_reg_w_`i' = r(r`counter') if threshold == "`t'" & `groupingspells' == "`r'" & test != "EGRA"
						local counter=`counter' + 1
					}
				}
			}
		}


		*Comparison of regional percentiles with and without weights
		`qui' tabstat initial_adj_pct   [`weight'`exp'] if spell_exists == 1, ///
			by(reg_n) stat(mean p50 min max N)

			*Comparison of regional percentiles with and without weights
		`qui' tabstat delta_adj_pct delta_reg*  [`weight'`exp'] if spell_exists == 1, ///
			by(reg_n) stat(mean N)


		*Percentiles by initial values:
		forvalues i = `percentile' {
			bysort  catinitial: egen delta_ini_`i' = pctile(delta_adj_pct) if test != "EGRA", p(`i')
		}

		`qui' tabstat delta_adj_pct delta_ini*  [`weight'`exp'] if spell_exists == 1, ///
			by(catinitial) stat(mean N)


		*Average and percentile percentage changes in gap to frontier:
		forvalues i =  `percentile' {
			*drop red_gap_`i'_irsat red_gap_`i'_irsat_extend red_gap_`i'_sas red_gap_`i' red_gap_global_`i' red_gap_global_`i'_extend  /* try tp create a variable does alreayd exist in your database */
			bysort  `groupingspells': egen red_gap_`i' = pctile(pct_red_gap) if test != "EGRA" , p(`i')

			/* bysort  region: egen red_gap_`i'_irsat_extend = max(red_gap_`i'_irsat)
			replace red_gap_`i'_irsat = red_gap_`i'_irsat_extend if missing(red_gap_`i'_irsat)
			*South Asia does not have any nationally representative tests
			bysort  region: egen red_gap_`i'_sas = pctile(pct_red_gap) if region == "SAS", p(`i')
			gen red_gap_`i' = red_gap_`i'_irsat
			replace red_gap_`i' = red_gap_`i'_sas if missing(red_gap_`i')
			*/

	    egen red_gap_global_`i' = pctile(pct_red_gap) if test != "EGRA", p(`i')
			*egen red_gap_global_`i'_extend = max(red_gap_global_`i')
			*replace red_gap_global_`i' = red_gap_global_`i'_extend if missing(red_gap_global_`i')
		}


		* save "${clone}/02_simulation/023_outputs/`filename'_spells.dta", replace

		egen count_ctry_spells = count(delta_adj_pct) , by(countrycode)

		*Obtaining data for projection:
		collapse (first) test countryname `groupingspells' (mean) delta_adj_pct (lastnm) delta_adj_pct_r = delta_adj_pct (max) delta_adj_pct_m = delta_adj_pct (mean) count_ctry_spells pct_red_gap red_gap_* delta_reg_* delta_global_*  [`weight'`exp'], by(countrycode )

		foreach var of varlist pct_red_gap red_gap_70 red_gap_80 red_gap_90 {
			replace `var' = 0 if `var' < 0
		}

		egen count_n = count(delta_adj_pct)
		egen count_reg_n = count(delta_adj_pct) , by(`groupingspells')


		local preference="`preference'"

		save "${clone}/02_simulation/023_outputs/`filename'.dta", replace

		* End of FIRST PART



		*********************************************************************
		****************** SECOND PART - ACTUAL SIMULATION ******************
		******       Will not run if no_simulation is specified       *******
		*********************************************************************

		if ("`nosimulation'" == "") {

			*Import growth rates defined in a markdown file if the usefile() option is specified

			if ("`usefile'" != "") {
				import delimited "`usefile'", delimiter("|") varnames(1) clear

				cap drop v1
				cap drop v9
				drop if _n==1
				*dropping delta_adj_pct, because it is dangerous to merge with this.
				drop delta_adj_pct
				replace `groupingspells'=strtrim(`groupingspells')
				replace `groupingspells'=subinstr(`groupingspells', "`=char(9)'", "", .)

				describe delta_reg*, varlist
				foreach var in  `r(varlist)' {
					destring `var', replace
				}
				local usefile2=subinstr("`usefile'", ".md", ".dta",.)
				save "`usefile2'", replace
			}



			use  "${`inputfolder'}/01_data/013_outputs/preference`preference'.dta", replace
			merge 1:1 countrycode  using  "${clone}/02_simulation/023_outputs/`filename'.dta",

				*Create learning level if not created
			cap replace initial_poverty_level = "0-25% Learning Poverty"   if !missing(adj_nonprof)
			cap replace initial_poverty_level = "25-50% Learning Poverty"  if adj_nonprof >= 25 & !missing(adj_nonprof)
			cap replace initial_poverty_level = "50-75% Learning Poverty"  if adj_nonprof >= 50 & !missing(adj_nonprof)
			cap replace initial_poverty_level = "75-100% Learning Poverty" if adj_nonprof >= 75 & !missing(adj_nonprof)

			cap gen adj_pct_reading_low= 100-adj_nonprof_all

			*********************************************************************
			*Replace missing deltas: Historical
			*********************************************************************
			*Replace with values in markdown file if specified
			if ("`usefile'" != "") {
				cap drop _merge
				`qui' merge m:1 `groupingspells' using "`usefile2'", update replace
				noi di "Update growth rates with values from markdown file."

				assert(1 3 4 5)

				drop if _merge==2
			}

			replace pct_red_gap = red_gap_50 if pct_red_gap == .


			if "`weight2'"=="" {
				*replace with median if missing
				levelsof `groupingspells', local(rgn)
				foreach var in `rgn' {
					di "`var'"
					count if !missing(delta_adj_pct) & `groupingspells'=="`var'"
					local count=`r(N)'
					su delta_reg_50 if `groupingspells'=="`var'"
					*Only make change to regional if we have at least 3 regional spells
					if `count'>=3 {
						cap replace delta_adj_pct = `r(mean)' if delta_adj_pct == . & `groupingspells'=="`var'"
					}
				}
				su delta_global_50
				replace delta_adj_pct = `r(mean)' if delta_adj_pct == .
			}


			if "`weight2'"!="" {
				di "`weight2'"
				levelsof `groupingspells', local(rgn)
				foreach var in `rgn' {
					di "`var'"
					count if !missing(delta_adj_pct) & `groupingspells'=="`var'"
					local count=`r(N)'

					su delta_reg_w_50 if `groupingspells'=="`var'"
					*Only make change to regional if we have at least 3 regional spells
					if `count'>=3 {
						cap replace delta_adj_pct = `r(mean)' if delta_adj_pct == . & `groupingspells'=="`var'"
					}
				}
				su delta_global_w_50
				replace delta_adj_pct = `r(mean)' if delta_adj_pct == .
			}

			forval i=`percentile' {
				levelsof `groupingspells', local(rgn)
				foreach var in `rgn' {
					count if !missing(delta_reg_w_`i') & `groupingspells'=="`var'"
					local count=`r(N)'
					su delta_reg_w_`i'	if `groupingspells'=="`var'"
					*Only make change to regional if we have at least 3 regional spells
					if `count'>=3 {
						cap replace delta_reg_w_`i' = `r(mean)' if delta_reg_w_`i' == . & `groupingspells'=="`var'"
					}

					count if !missing(delta_reg_`i') & `groupingspells'=="`var'"
					local count=`r(N)'
					su delta_reg_`i'	if `groupingspells'=="`var'"
					if `count'>=3 {
						cap replace delta_reg_`i' = `r(mean)' if delta_reg_`i' == . & `groupingspells'=="`var'"
					}

				}
			}

			forval i=`percentile' {
				su delta_global_w_`i'
				replace delta_reg_w_`i' = `r(mean)' if delta_reg_w_`i' == .

				su delta_global_`i'
				replace delta_reg_`i' = `r(mean)' if delta_reg_`i' == .

				su delta_global_`i'
				replace delta_global_`i' = `r(mean)' if delta_global_`i' == .

				su delta_global_w_`i'
				replace delta_global_w_`i' = `r(mean)' if delta_global_w_`i' == .
			}

			*Use own country spell only if there are two or more spells, so that slight changes don't throw off simulations
			if "`weight2'"!="" {
				replace delta_adj_pct = delta_reg_w_50 if !missing(count_ctry_spells) & count_ctry_spells<2
			}
			if "`weight2'"=="" {
				replace delta_adj_pct = delta_reg_50 if !missing(count_ctry_spells) & count_ctry_spells<2
			}

			*Don't slow down countries that have max growth rates higher than the regional percentage
			forval i=70(10)90 {
				replace delta_reg_w_`i' = delta_adj_pct_m if delta_reg_w_`i' < delta_adj_pct_m & !missing(delta_adj_pct_m)
				replace delta_reg_`i' = delta_adj_pct_m if delta_reg_`i' < delta_adj_pct_m & !missing(delta_adj_pct_m)
				replace delta_global_w_`i' = delta_adj_pct_m if delta_global_w_`i' < delta_adj_pct_m & !missing(delta_adj_pct_m)
				replace delta_global_`i' = delta_adj_pct_m if delta_global_`i' < delta_adj_pct_m & !missing(delta_adj_pct_m)
			}
			*save dataset
			save "${clone}/02_simulation/023_outputs/`filename'.dta", replace


			save "${clone}/02_simulation/023_outputs/`filename'.dta", replace

			* Drop trait/useless variables because it's too confusing
			rename year_assessment assess_year
			drop count_* _merge    adminregion* ///
				   *source*  cmu  regionname test idgrade ///
				  pop*  enrollment*    ///
				 nla_code pct_*


			* Rename remaining variables in a consistent logic to be able to reshape long
			rename adj_pct_reading_low  baseline
			*rename delta_adj_pct_r reduct_own // WARNING!!! NOT SURE THIS INTERPRETATION IS CORRECT. BRIAN CAN YOU CHECK?
			rename delta_adj_pct    growth_own
			generate growei_own = growth_own
			forvalues i = `percentile' {
				rename red_gap_`i'              reduct_r`i'
				cap rename red_gap_global_`i'   reduct_g`i' //WARNING!!! WHY ONLY EXISTS FOR G90 ON YOUR FILE, BRIAN?
				rename delta_reg_w_`i'          growei_r`i'
				rename delta_reg_`i'            growth_r`i'
				rename delta_global_w_`i'       growei_g`i'
				rename delta_global_`i'         growth_g`i'
			}

			/* From my understanding, as of now, there are:
				7 possible "benchmark"
				- own = own country historical, business as usual
				- r70, r80, r90 = region percentiles 70, 80, 90
				- g70, g80, g90 = global percentiles 70, 80, 90
				3 possible "rateflavor"
				- reduct = rate applied in (100 - baseline), hopefully a negative rate
				- growth = rate applied in baseline, hopefully a positive rate
				- growei = rate applied in baseline (same as above), but constructed from weighted something
			*/

			* Transform the dataset in long to reflect those combinations of benchmarks and rate_flavors

			*save time in simulations by dropping some combinations we don't use
			if "`weight2'"=="" {
				drop growei_*
				drop reduct_*
				reshape long  growth , i(countrycode `groupingspells' baseline) j(benchmark) string
				rename ( growth ) ( rategrowth )
			}
			if "`weight2'"!="" {
				drop growth_*
				drop reduct_*
				reshape long   growei, i(countrycode `groupingspells' baseline) j(benchmark) string
				rename (  growei) (  rategrowei)
			}

			reshape long rate, i(countrycode `groupingspells' baseline benchmark) j(rate_flavor) string

			order countrycode `groupingspells' rate_flavor benchmark rate baseline
			format rate baseline %10.2f

			* Describes input flavor
			gen str50 input_flavor = "preference: " + preference
			replace input_flavor = input_flavor + " | rate_flavor: " + rate_flavor
			replace input_flavor = input_flavor + " | benchmark: " + benchmark


			***************************************************
			*Dynamically calculated growth rates (particularly for growth rates based on initial learning poverty categories)
			***************************************************
			if "`groupingspells'"=="initial_poverty_level" {
				levelsof initial_poverty_level, local(pov_levels)
				levelsof input_flavor , local(flavors)

				local counter=1
				foreach var in `pov_levels' {
					gen rate_`counter'=.
					label var rate_`counter' "`var'"
					foreach flav in `flavors' {
						qui su rate if input_flavor == "`flav'" & initial_poverty_level == "`var'"
						replace rate_`counter'=`r(mean)' if input_flavor == "`flav'"
					}
					replace rate_`counter'=rate if benchmark=="_own"

					local counter=`counter'+1
				}
			}

			drop  rate_flavor benchmark

			save "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace


			// Delete those lines if input vars are already labelled
			label var rate "Rate (growth or delta) used in simulation"
			label var baseline "Adjusted percentage of test takers with minimum reading proficiency at baseline"
			label var input_flavor "Short for: Benchmark Scenario | Rate Method | Latest Prefence"
			*                       Benchmark Scenario: own/r70/r80/r90/g70/g80/g90
			*                       Rate Method: reduce/growth/growei
			*                       Latest Preference: 926
			*label var input_flavor_des "Long description: Benchmark Scenario | Rate Method | Latest Prefence"


			* Step 1. Simulate future adjusted proficiency
			*==================================================
			tempname tmp_adjpro
			// Advances adjusted proficiency (adjpro) for all year_populations to simulate
			// Each adjpro_year_population is created as column, then it is reshaped to long
			quietly forvalues i=2015/2050 {     // CHANGE HERE FOR A LONGER HORIZON
				gen adjpro`i' = .
				gen rate`i'=rate
				replace adjpro`i' = 100 - (100-baseline)*((1-rate)^(`i'-2015))      if ( strpos(input_flavor, "reduct")  & !missing(baseline))
				replace adjpro`i' = baseline + rate*(`i'-2015)                      if (!strpos(input_flavor, "reduct") & !missing(baseline))

				*Add dynamics to simulations based on initial poverty level
				if "`groupingspells'"=="initial_poverty_level" & "`growthdynamics'"=="Yes"{
					if `i'>2015 {
						local j=`i'-1
						replace adjpro`i' = adjpro`j' + rate_4                      if (!strpos(input_flavor, "reduct") & !missing(baseline))
						replace adjpro`i' = adjpro`j' + rate_3                      if adjpro`j'>=25 & (!strpos(input_flavor, "reduct") & !missing(baseline))
						replace adjpro`i' = adjpro`j' + rate_2                      if adjpro`j'>=50 & (!strpos(input_flavor, "reduct") & !missing(baseline))
						replace adjpro`i' = adjpro`j' + rate_1                      if adjpro`j'>=75 &  (!strpos(input_flavor, "reduct") & !missing(baseline))
					}
				}

				replace adjpro`i' = 100 if ( adjpro`i' > 100  &  !missing(adjpro`i') )   // Upper bound is 100
				replace adjpro`i' = 0   if ( adjpro`i' < 0     &  !missing(adjpro`i') )  // Lower bound is 0
			}


			reshape long adjpro, i(countrycode input_flavor baseline rate) j(year_population)

			// Housekeeping and save temp
			label var adjpro "Adjusted percentage of test takers with minimum reading proficiency simulated"
			order countrycode year_population input_flavor rate baseline adjpro
			format adjpro %10.2f
			save "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace


			*********************************************************************
			* Merge Population projections (1960-2050 )
			*********************************************************************

			use  "${`inputfolder'}/01_data/013_outputs/population.dta" , clear
			cap g year_population = year

			*Choose population type
			if "$population" == "" {
				local population = "population_all_1014"
				gen pop 			= `population'
			}
			else {
				cap confirm var $population
				if _rc!=0 {
					di "You messed up the population option, try: (empty=xls) | pop_TOT_10 | pop_TOT_10_14 | pop_TOT_primary | pop_TOT_9_plus"
					di "You specified population as: $population. Is that what you want?"
					error 2222
				}
				else {
					gen pop 			= $population
				}
			}


			*Use population in 2015 for the simulations if specified
			if "$pop_sim"=="Yes" {
				gen tmp1_2015_pop=pop if year_population==2015
				egen tmp2_2015_pop=mean(tmp1_2015_pop), by(countrycode)
				replace pop=tmp2_2015_pop
			}


			g source_population = "World Bank"
			keep  countrycode year_population* pop



			//TWN does not have population data
			drop if countrycode == "TWN"

			merge m:1 countrycode using "${`inputfolder'}/01_data/011_rawdata/country_metadata.dta", keep(master match) nogen
			tempfile popdata
			save `popdata', replace

			/*
			tempname tmp
			import excel using "${clone}\01_data\011_rawdata\population\Pop by 5 year_population age groups for JP v2.xlsx", ///
					sheet("Data") firstrow clear
			gen id = _n
			reshape long YR , i(id CountryName CountryCode SeriesName SeriesCode) j(year_population) string
			tolower CountryName CountryCode SeriesName SeriesCode YR
			replace seriescode = subinstr(seriescode,".","_",.)
			drop id seriesname
			drop if seriescode == ""
			destring yr, replace force
			destring year_population , replace
			reshape wide yr, i(countryname countrycode year_population) j(seriescode) string
			renpfix yr
			tolower SP*
			foreach var in 0004 0509 1014 1519 {
				gen double sp_pop_`var' = sp_pop_`var'_fe + sp_pop_`var'_ma
			}
			sort countrycode year_population
			save `tmp', replace
			*/

			/*** Merge population ***/

			use "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace

			sort countrycode year_population
			cap drop _merge
			merge m:1 countrycode year_population using `popdata', update

			drop if _merge == 2

			rename _merge merge_population

			label define merge_population 1 "Yrs with no population" 3 "Yrs with population"

			label values merge_population merge_population

			order countrycode year_population input_flavor rate baseline adjpro pop*



			* Step 3. Compare simulated versus target
			*==================================================
			// Targets specification
			label define ltarget ///
				0 "100 percent adjusted proficiency" ///
				1 "98 percent adjusted proficiency" ///
				2 "95 percent adjusted proficiency" ///
				3 "Reducing the gap to frontier by 1/2" ///
				4 "Reducing the gap to frontier by 2/3" ///
				5 "Reducing the gap to frontier by 1/3"

			// Each target specification is a column at first but reshaped to long after dummies
			// Generate target dummies
			gen byte dtarget0 = adjpro>=100  if !missing(adjpro)
			gen byte dtarget1 = adjpro>=98   if !missing(adjpro)
			gen byte dtarget2 = adjpro>=95   if !missing(adjpro)
			// Aux variable to contruct targets based on gap reduction
			gen gap_to_frontier_ratio = (100-adjpro)/(100-baseline)
			gen byte dtarget3 = 1 if (gap_to_frontier_ratio<=1/2  & !missing(gap_to_frontier_ratio))
			gen byte dtarget4 = 1 if (gap_to_frontier_ratio<=2/3  & !missing(gap_to_frontier_ratio))
			gen byte dtarget5 = 1 if (gap_to_frontier_ratio<=1/3  & !missing(gap_to_frontier_ratio))
			drop gap_to_frontier_ratio


			// Reshape to long
			reshape long dtarget, i(countrycode year_population input_flavor baseline rate adjpro) j(target)
			label var target "Description of target"
			order countrycode year_population input_flavor target baseline rate adjpro dtarget pop*

			// Housekeeping
			label var dtarget "Dummy for whether a country met the target"
			label values target ltarget

			// Save long dataset with all countries
			// Change to _save_metadata

				// Simulation ID and Simulation Descriptor
			gen str5 sim_id 		 = "`filename'"
			gen str250 sim_describe="filename(`filename') + ifspell(`ifspell') + ifsim(`ifsim') + ifwindow(`ifwindow') weight(`weight') preference(`preference') specialincludeassess(`specialincludeassess') specialincludegrade(`specialincludegrade') timss(`timss') + enrollment(`enrollment') + population_sim_2015(`population_2015')"

			cap gen dropped_spell_sample_id="`incomegroupdrop'"
			cap gen dropped_simulation_sample_id="`simincomegroupdrop'"
			cap replace dropped_spell_sample_id="Full Sample Used" if dropped_spell_sample_id==""
			cap replace dropped_simulation_sample_id="Full Sample Used" if dropped_simulation_sample_id==""

			save "${clone}/02_simulation/023_outputs/`filename'_long.dta", replace

			*Generate population for countries used in simulation
			gen pop_sim=pop

			if `"`ifsim'"'!=""  {
				di `"`ifsim'"'
				tempvar simkeep
				gen `simkeep'=0
				replace `simkeep'=1 `ifsim'
				replace rate=. if `simkeep'==0
				replace adjpro=. if `simkeep'==0
				replace dtarget=. if `simkeep'==0
				replace pop_sim=. if `simkeep'==0
			}

			*drop countries without recent assessments at baseline
			if `"`ifwindow'"'!="" {
				tempvar simwindow
				gen `simwindow'=0
				replace `simwindow'=1 `ifwindow'

				replace rate=. if `simwindow'==0
				replace adjpro=. if `simwindow'==0
				replace dtarget=. if `simwindow'==0
			}

			* Step 4. Display regions overall achievement
			*==================================================
			// Percentage of proficient kids by region-year_population-specs
			local which_pop_wgt = "pop"
			gen wgt_included = `which_pop_wgt' if !missing(adjpro)
			replace rate=. if missing(adjpro)
			gen aux_adjpro  = `which_pop_wgt'*adjpro
			gen aux_rate  = `which_pop_wgt'*rate
			gen country_count=!missing(adjpro)


			preserve

				***********
				*Produce formatted table at country level that is reshaped
				***********
				keep if target==1 & year_population>=2015 & year_population<=2030 //doesnt matter target, just reduce to 1 copy in 2030

				*generate variable indicating whether own growth rate or regional 90
				gen growth_type=substr(input_flavor, -3,.)

				*generate preference variable

				keep if year_population>=2015 & year_population<=2030
				keep countrycode region year_population growth_type preference pop wgt_included adjpro country_count

				gen learning_poverty=100-adjpro


				egen rgn_mn=mean(learning_poverty), by(region year_population growth_type)
				cap replace learning_poverty = rgn_mn if learning_poverty == .
				drop rgn_mn

				drop region

				drop adjpro

				merge m:1 countrycode using "${`inputfolder'}/01_data/011_rawdata/country_metadata.dta", keep(master match) nogen

				tempvar simkeep
				gen `simkeep'=0
				replace `simkeep'=1 `ifsim'
				replace learning_poverty=. if `simkeep'==0

				*reshape dataset by year_population
				reshape wide pop wgt_included learning_poverty country_count , i(countrycode growth_type) j(year_population)

				*reshape dataset by growth_type
				reshape wide  pop* wgt_included* learning_poverty* country_count* , i(countrycode) j(growth_type) string

				foreach var in pop wgt_included country_count {
					forval i=2015/2030 {
						rename `var'`i'own `var'_`i'
						drop `var'`i'?*
					}
				}



				save "${clone}/02_simulation/023_outputs/`filename'_country_sim_table.dta", replace

			restore



			if ("`savectryfile'" != "") {

				preserve


					collapse (first) sim_id sim_describe  dropped_simulation_sample_id dropped_spell_sample_id (sum) country_count num_countries_meeting_target=dtarget ///
									aux_adjpro aux_rate  pop_total=pop  pop_with_data=wgt_included pop_sim , ///
									by(`groupingsim' year_population input_flavor target)
					gen wgt_adjpro = aux_adjpro/pop_with_data
					gen wgt_growth_rate = aux_rate/pop_with_data

					label var wgt_adjpro "Weighted adjusted proficiency for each `groupingsim'"
					label var wgt_growth_rate "Weighted mean growth rate for each `groupingsim'"
					label var pop_with_data "Population with data in `groupingsim'"
					label var pop_total "Total regional population"
					label var pop_total "Total regional population Among Countries in Simulation"
					label var num_countries_meeting_target "Number of countries in `groupingsim' meeting specified proficiency target"

					save "${`inputfolder'}/02_simulation/023_outputs/dta_ctry_`savectryfile'.dta", replace

				restore

			}

			collapse (first) sim_id sim_describe  dropped_simulation_sample_id dropped_spell_sample_id (sum) country_count num_countries_meeting_target=dtarget   ///
							aux_adjpro aux_rate pop_total=pop  pop_with_data=wgt_included pop_sim , ///
							by(`groupingsim' year_population input_flavor target)
			gen wgt_adjpro = aux_adjpro/pop_with_data
			gen wgt_growth_rate = aux_rate/pop_with_data

			drop aux_adjpro  aux_rate

			label var wgt_adjpro "Weighted adjusted proficiency for each `groupingsim'"
			label var wgt_growth_rate "Weighted mean growth rate for each `groupingsim'"
			label var pop_with_data "Population with data in `groupingsim'"
			label var pop_total "Total regional population"
			label var pop_total "Total regional population Among Countries in Simulation"

			label var num_countries_meeting_target "Number of countries in `groupingsim' meeting specified proficiency target"

			if ("`savectryfile'" != "") {

				preserve

					save "${`inputfolder'}/02_simulation/023_outputs/dta_`groupingsim'_`savectryfile'.dta", replace

				restore

			}

			if ("`allyear_populations'" == "") {

				// ON THE FLY FOR EMAIL REQUEST
				keep if target==1 & year_population>=2015 & year_population<=2030 //doesnt matter target, just reduce to 1 copy in 2030

				// Q1
				preserve
				if "`weight2'"=="" {
					keep if input_flavor =="preference: `preference' | rate_flavor: growth | benchmark: _own"
				}
				if "`weight2'"!="" {
					keep if input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _own"
				}

				save "${clone}/02_simulation/023_outputs/`filename'_sim_numbers.dta", replace


				// Q2
				restore
				if "`weight2'"=="" {
					keep if input_flavor =="preference: `preference' | rate_flavor: growth | benchmark: _r90"
				}
				if "`weight2'"!="" {
					keep if input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r50" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r10" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r20" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r30" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r40" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r60" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r70" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r80" ///
					| input_flavor =="preference: `preference' | rate_flavor: growei | benchmark: _r90"
				}

				append using "${clone}/02_simulation/023_outputs//`filename'_sim_numbers.dta",
				gen specification="`filename'"

				*generate variable indicating whether own growth rate or regional 90
				gen growth_type=substr(input_flavor, -3,.)

				*generate preference variable
				gen preference=substr(input_flavor, 13,4)

				*Add in global number
				preserve
					tempfile globalfile
					collapse wgt_adjpro*  [aw=pop_sim], by(growth_type year_population)
					gen `groupingsim'="Global"
					save `globalfile'
				restore

				append using `globalfile'

				rename year_population year
				save "${clone}/02_simulation/023_outputs/`filename'_sim_numbers.dta", replace


				***********
				*Produce formatted table that is reshaped
				***********
				replace `groupingsim'="Z_Global" if `groupingsim'=="Global"

				keep if year>=2015 & year<=2030
				keep year `groupingsim' growth_type preference pop_total pop_with_data pop_sim wgt_adjpro country_count

				gen learning_poverty=100-wgt_adjpro
				drop wgt_adjpro

				*reshape dataset by year
				reshape wide  pop_total pop_with_data pop_sim learning_poverty country_count , i(`groupingsim' growth_type) j(year)

				*reshape dataset by growth_type
				reshape wide  pop_total* pop_with_data* pop_sim* learning_poverty* country_count* , i(`groupingsim') j(growth_type) string

				foreach var in pop_total pop_with_data pop_sim country_count {
					forval i=2015/2030 {
						rename `var'`i'own `var'_`i'
						drop `var'`i'?*
					}
				}
				replace `groupingsim'="Global" if `groupingsim'=="Z_Global"

				save "${clone}/02_simulation/023_outputs/`filename'_sim_table.dta", replace
				export delimited using "${clone}/02_simulation/023_outputs/`filename'_sim_table.csv", replace

	    	* end if allyear_populations
			}

			noi di _n as res "This simulation concluded."

			* Close the if nosimulation
		}

		* Close the quietly
	}

end
