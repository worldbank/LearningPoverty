*==============================================================================*
* PROGRAM: SELECTS DATABASE FROM RAWFULL ACCORDING TO PREFERENCE
*==============================================================================*

cap program drop population_weights
program define   population_weights, rclass

  syntax, [                  	///
       PREFERENCE(string)		///
       TIMEwindow(string)     	///
       COUNTRYfilter(string)  	///
       combine_ida_blend      	///
	   yrmax(string)           	///
	   yrmin(string)           	///
	   full					  	///
	   toinclude				///
	   coverage					///
       varlist(string)			///
	   ]

  qui {

  *-----------------
  * Check options
  *-----------------
  if ("`varlist'" == "") {
	local var lpv_all
  }
  else {
	local var = word("`varlist'",1) 
	local varfilter "!missing(`var')"
  }
  
  * If no preference is specified, uses the file in memory
  if ("`preference'" == "") {
    * Check that the file contains a unique preference, or the code should break
    tab preference
    assert `r(r)'==1
    noi disp as txt "Applying weights to the already loaded file"
  }
  * If preference is specified, open that file from outputs
  else {
    use "${clone}/01_data/013_outputs/preference`preference'.dta", clear
  }

  if ("`combine_ida_blend'" == "combine_ida_blend") {
    replace lendingtype = "IDXB" if inlist(lendingtype, "IDX", "IDB")
  }

  *-----------------
  * select countries with data
  *-----------------
  * Generate dummy on whether assessment data in LP is inside TIMEWINDOW()
  * note that missing data on LP is considered outside the TIMEWINDOW()
  cap drop include_assessment
  if ("`timewindow'" == "") & ("`toinclude'" == "") {
    * If not specified, this becomes a simple test for whether LP data is available
    gen byte include_assessment = !missing(`var')
  }
  if ("`timewindow'" != "") & ("`toinclude'" == "") {
    * If specified, apply the condition to create the dummy
    cap gen byte include_assessment = (`timewindow') & !missing(`var')
    if _rc != 0 {
      noi di as err `"The option TIMEWINDOW() is incorrectly specified. Good example: timewindow(year_assessment>=2011)"'
      break
    }
  }
  * Adjust yrmin and yrmax
  if (("`yrmin'" != "") | ("`yrmax'" != "")) & ("`toinclude'" == "") {
    cap gen byte include_assessment = !missing(`var' & (year_assessment>=`yrmin') & (year_assessment<=`yrmax')
	if _rc != 0 {
      noi di as err `"The option YRMAX() and YRMIN{} are incorrectly specified. Both values need to be specified. Good example: yrmin(2011) yrmax(2018)"'
      break
    }
  }
  if ("`toinclude'" != "") {
    * If not specified, this becomes a simple test for whether LP data is available
    gen byte include_assessment = !missing(`var') & (toinclude==1)
  }

  *-----------------  
  * create timewindow label
  *-----------------
  if ("`timewindow'" == "") & (("`yrmin'" == "") | ("`yrmax'" == "")) {
    sum year_assessment if include_assessment == 1
	local yrmax = r(max)
	local yrmin = r(min)
	local timewindowlabel "`yrmin'-`yrmax'"
  }
  if (("`yrmin'" != "") & ("`yrmax'" != "")) {
 	local timewindowlabel "`yrmin'-`yrmax'"
  }
  if ("`timewindow'" == "") {
	local timewindowlabel "`timewindow'"
  }
  if ("`toinclude'" != "") {
    sum year_assessment if toinclude  == 1
	local yrmax = r(max)
	local yrmin = r(min)
	local timewindowlabel "`yrmin'-`yrmax'"
  } 
  * Generate dummy on whether country is inside COUNTRYFILTER()
  cap drop include_country
  if "`countryfilter'" == "" {
    * If not specified, all observations are included
    gen byte include_country = 1
  }
  else {
    * If specified, apply the condition to create a dummy
    cap gen byte include_country = (`countryfilter')
    if _rc != 0 {
      noi di as err `"The option COUNTRYFILTER() is incorrectly specified. Good example: countryfilter(incomelevel!="HIC" & lendingtype!="LNX")"'
      break
    }
  }

  * A country learning poverty number is included only if it satisfies both the TIMEWINDOWN() and COUNTRYFILTER()
  cap drop  included_in_weights
  gen byte  included_in_weights = include_country * include_assessment
  label var included_in_weights "Observation is considered for aggregation weights"

  * Before we can create weights for each aggregation, we need this aux var
  * so that global is as much as a group as 'region' or 'incomelevel'
  * and we can do a single loop
  gen str global = "TOTAL"


  *--------------------
  * Aggregation weights
  *--------------------
  * For each possible aggregation level, the same calculation is performed
  local possible_aggregations "global region adminregion incomelevel lendingtype"
  foreach aggregation of local possible_aggregations {

    * Preemptly drop variable that will be created if they existed
    foreach ending in n_countries total_population population_w_data coverage weight {
      cap drop `aggregation'_`ending'
    }

    * The number of countries that will be used in the aggregation
    egen int  `aggregation'_n_countries = total(included_in_weights), by(`aggregation')
    label var `aggregation'_n_countries "Number of countries included in aggregation by `aggregation'"

    * Total population in the aggregation (ie: not excluded in the country filter)
    egen `aggregation'_total_population  = total(anchor_population * include_country), by(`aggregation')
    label var `aggregation'_total_population "Total population represented in aggregation by `aggregation'"

    * Population in the aggregation for which we have and will use learning poverty data (ie: also in the time windown)
    egen `aggregation'_population_w_data = total(anchor_population * included_in_weights), by(`aggregation')
    label var `aggregation'_population_w_data "Population with learning poverty data in aggregation by `aggregation'"

    * The coverage is the ratio of population with data over total population
    gen `aggregation'_coverage = `aggregation'_population_w_data / `aggregation'_total_population
    label var `aggregation'_coverage "Population coverage in aggregation by `aggregation'"

    * The weight we want is the population included, scaled by coverage
    * It is rounded to an integer number so it can be used as frequency weights
    * and interpreted as number of late primary age children
    gen long  `aggregation'_weight = round(included_in_weights * anchor_population / `aggregation'_coverage)
    label var `aggregation'_weight "Population scaled as weights for aggregation by `aggregation'"

  }

  * For global_weight, it was decided that we should use region_weights,
  * ie: a country with missing data in SSA is proxied by SSA average,
  * to avoid regional bias according to region _coverage
  replace global_weight = region_weight

  * Drop excessive amount of auxiliary variables created
  drop include_assessment global

  if ("`full'" == "") {
   local varnames "lpv_all"
  }
  if ("`full'" == "full") {
   local varnames "lpv_all ld_all sd_all"
  }

  *--------------------------------
  * Display number by region
  *--------------------------------
  local aggregation "region"
  if `"`countryfilter'"' == ""   local countryfilter "none (WORLD)"
  qui sum included_in_weights
  local n_included_countries = r(sum)

  noi di ""
  noi di as res  "Learning Poverty Global Number"
  noi di as res  "  preference:   `preference'"
  noi di as res `"  time window:  `timewindowlabel'"'
  noi di as res `"  cty filters:  `countryfilter'"'
  noi di as res  "  # countries:  `n_included_countries'"
  
  qui tablemat lpv_all ld_all sd_all `varlist' [fw = `aggregation'_weight], by(`aggregation')  format(%20.1fc) stat(mean) name(tmp1)
  return mat lpv = tmp1
  
  * create dummy for the aggregate categories which has valid values for `varlist'
  if ("`varlist'" != "") {
	  levelsof `aggregation' if `varfilter'
	  tempname dummy
	  gen `dummy' = .
	  foreach var in  `r(levels)' { 
		replace `dummy' = 1 if `aggregation' == "`var'"
	  }
	  *noi tab `aggregation'
	  *noi tab `aggregation' if `dummy' == 1
	  local filter " & `dummy' == 1 "
  }

  qui tablemat  anchor_population_w_assessment anchor_population  included_in_weights  include_country if `aggregation'_total_population  != 0 `filter', by(`aggregation') stat(sum) name(tmp2)
  return mat cov = tmp2


}

return add

end



cap program drop output_display
program output_display, rclass

  syntax, [                  	///
       varlist(string)			///
	   ]


   qui {
   
	   mat a = r(lpv)
	   mat b = r(cov)
	   mat a = a'
	   mat b = b'
	   mat c = a , b
	   
	   tempfile output
	   xsvmat double c ,  rownames(aggregate)  saving(`output', replace)
	   

	  preserve
		use `output', clear

		
		local labels1 ""LPV" "LD" "SD"" 
		local labels2 ""Pop. w/ Data" "Total Pop." "Ctrys w/ Data" "Total Ctrys" "Pop. Coverage" "Ctry Coverage""
		local labels3 "`varlist'"
		
		di `"`labels1'"'
		di `"`labels2'"'
		di "`labels3'"
		
		local cnt = 1
		foreach var in  `labels1' `labels3' `labels2' {
			label define indicators `cnt' `"`var'"', add modify
			local cnt = `cnt'+1
		}
			
        local cnt1 = `cnt'-2
		local cnt2 = `cnt'-1
		
		local c4 = `cnt'-6
		local c5 = `cnt'-5
		local c6 = `cnt'-4
		local c7 = `cnt'-3
		
		gen c`cnt1' = (c`c4'/c`c5')*100
		gen c`cnt2' = (c`c6'/c`c7')*100
		reshape long c , i(aggregate) j(indicator)		
		
		*label define indicators 1 "LPV" 2 "LD" 3 "SD" 4 "Pop. w/ Data" 5 "Total Pop." 6 "Ctrys w/ Data"  7 "Total Ctrys" 8 "Pop. Coverage"  9 "Ctry Coverage", add modify
		
		label values indicator indicators
		label variable indicator "Indicators"
		label variable aggregate "Subgroups"	
	
		noi tabdis aggregate indicator if (indicator < `c4') | (indicator > `c7'), cellvar(c)  concise format(%5.1fc) 
		noi tabdis aggregate indicator if (indicator >= `c4') & (indicator <= `c7'), cellvar(c)  concise format(%20.0fc) 
	  restore
	  
  }

  return add
  
end


