*==============================================================================*
* 0223 SUBTASK: CHECK HOW OOS CHANGES WITH GEMS UPDATE
* Exercise for discussion on potentially replacing enrollment indicators using 
* the GEMS OOS rather than existing ENR (TENR/ANER/GER)
* GEM Database: https://education-estimates.org/out-of-school/data/
*
* Created by Yi Ning Wong on Jue 7th, 2023
* Last modified by Yi Ning Wong on June 7th, 2023
*==============================================================================*

	local chosen_preference = $chosen_preference

	*************************************************************************
	*** 1. GEM and PREF OOS WITH SAME ENROLLMENT YEAR                     ***
	*************************************************************************
	
	*************************
	** 	Read GEM OOS Data  **
	*************************
	import delimited "${clone}/02_simulation/021_rawdata/hosted_in_repo/OOS_Rate_Countries.csv", clear
	
	* Keep only primary
	keep if level == "prim"
	drop level
	drop name
	
	foreach v in value lower upper {
		replace `v' = `v'*100
	}
	
	* Reshape sex to wide so it conforms to LP data structure
	reshape wide value lower upper, i(country year) j(sex, string)
	
	* Rename vars to easier understand
	* subgroup
	rename *female *_fe
	rename *male *_ma
	rename *total *_all
	
	* value
	rename value* sd_gem*
	rename upper* sd_gem_ub*
	rename lower* sd_gem_lb*
	
	* Rename vars to merge 
	rename (country year) (countrycode enrollment_year)
	
	preserve
	
	*************************
	** 	Merge Preference   **
	*************************
	merge 1:1 countrycode enrollment_year using "${clone}/01_data/013_outputs/preference${chosen_preference}", keep(matched using)
	
	tempfile comparisons
	save `comparisons', replace
	
	restore
		
	** Get OOS values based on enr year == ass year
	rename enrollment_year year_assessment 
	keep countrycode year_assessment sd_* 
	
	rename sd_* sd_*1
	merge 1:1 countrycode year_assessment using `comparisons', keep(matched using) nogen

	* get region so it can be sorted 
	wbopendata, match(countrycode)
	
	drop countryname regionname adminregion adminregionname incomelevel incomelevelname lendingtypename
	
	sort region countrycode
	
	* Make ENR consistent 
	foreach g in all fe ma {
		gen sd_pref_`g' = sd_`g'
	}
	
	* Create LP using GEM values 
	foreach g in all fe ma {
		gen lp_gem_`g' = (((ld_`g'/100)*(1-sd_gem_`g'/100))+(sd_gem_`g'/100))*100
		gen lp_gem_`g'1 = (((ld_`g'/100)*(1-sd_gem_`g'1/100))+(sd_gem_`g'1/100))*100
		* Create LP (upper bound and lower bound)
		foreach b in ub lb {
			gen lp_gem_`b'_`g' = (((ld_`g'/100)*(1-sd_gem_`b'_`g'/100))+(sd_gem_`b'_`g'/100))*100
		gen lp_gem_`b'_`g'1 = (((ld_`g'/100)*(1-sd_gem_`b'_`g'1/100))+(sd_gem_`b'_`g'1/100))*100
		}

	}
	
	rename lpv_* lp_pref_*

	keep countrycode region lendingtype enrollment_year year_assessment sd_gem* sd_pref_* lp_* population* toinclude lendingtype
	order countrycode region lendingtype enrollment_year year_assessment sd_*all sd_*fe sd_*ma lp_*all lp*fe lp*ma population* 
	
	* Make the variables look nicer 
	format sd* %3.2f
	format lp* %3.2f
	
	lab var countrycode "Country"
	lab var enrollment_year "Enrollment Year"
	lab var year_assessment "Assessment Year"
	
	* OOS GEM (by pref year)
	lab var sd_gem_all "OOS (GEM)"
	lab var sd_gem_lb_all "OOS (GEM, LB)"
	lab var sd_gem_ub_all "OOS (GEM, UB)"
	
	* LP GEM (by pref year)
	lab var lp_gem_all "LP (GEM)"
	lab var lp_gem_lb_all "LP (GEM, LB)"
	lab var lp_gem_ub_all "LP (GEM, UB)"
	
	* OOS GEM (by assessment year)
	lab var sd_gem_all1 "OOS (GEM)"
	lab var sd_gem_lb_all1 "OOS (GEM, LB)"
	lab var sd_gem_ub_all1 "OOS (GEM, UB)"
	
	* LP GEM (by assessment year)
	lab var lp_gem_all1 "LP (GEM)"
	lab var lp_gem_lb_all1 "LP (GEM, LB)"
	lab var lp_gem_ub_all1 "LP (GEM, UB)"
	
	* Preference vars
	lab var sd_pref_all "OOS (Pref)"
	lab var lp_pref_all "LP (Pref)"
	
	* LP and OOS GEM for MA and FE
	foreach s in fe ma {
		lab var lp_gem_`s' "LP `s' (GEM)"
		lab var lp_gem_`s'1 "LP `s' (GEM)"
		lab var sd_gem_`s' "OOS `s' (GEM)"
		lab var sd_gem_`s'1 "OOS `s' (GEM)"
		* Pref
		lab var sd_pref_`s' "OOS `s' (Pref)"
		lab var lp_pref_`s' "LP `s' (Pref)"
		
		* GEM (Upper and Lower Bound)
		foreach b in ub lb {
			lab var lp_gem_`b'_`s' "LP `s' (GEM, `b')"
			lab var lp_gem_`b'_`s'1 "LP `s' (GEM, `b')"
			lab var sd_gem_`b'_`s' "OOS `s' (GEM, `b')"
			lab var sd_gem_`b'_`s'1 "OOS `s' (GEM, `b')"
		}
		
	}
	
	order countrycode	region	lendingtype	year_assessment	enrollment_year	sd_gem_all	sd_gem_lb_all	sd_gem_ub_all	sd_pref_all	lp_gem_all	lp_gem_lb_all	lp_gem_ub_all	lp_pref_all	population_2019_all	sd_gem_fe	sd_gem_lb_fe	sd_gem_ub_fe	sd_pref_fe	lp_gem_fe	lp_gem_lb_fe	lp_gem_ub_fe	lp_pref_fe	population_2019_fe	sd_gem_ma	sd_gem_lb_ma	sd_gem_ub_ma	sd_pref_ma	lp_gem_ma	lp_gem_lb_ma	lp_gem_ub_ma	lp_pref_ma	population_2019_ma	toinclude

	e
	save "${clone}/02_simulation/023_outputs/oos_gem_pref${chosen_preference}.dta", replace

*-------------------------------------------------------------------------
* SUBTASK: AUTO GENERATE DOCUMENTATION FROM EDUKIT_SAVE WITH METADATA
*-------------------------------------------------------------------------
	use "${clone}/02_simulation/023_outputs/oos_gem_pref${chosen_preference}.dta", clear
	
	* Create a population weight variable so that we can tabstat 
	gen pop_2019_wgt1 =. 
	
	levelsof region, local(regions)

	foreach region in `regions' {
			* Get population sum of the region 
			sum population_2019_all if region == "`region'"
			return list
			local sum_pop `r(sum)'
			
			* Get population sum of the region with LP
			sum population_2019_all if region == "`region'" & toinclude==1
			return list
			local sum_pop_lp `r(sum)'
			
			replace pop_2019_wgt1 = `sum_pop' / `sum_pop_lp' if region == "`region'"
			
	}
	gen pop_2019_wgt = pop_2019_wgt1 * population_2019_all 

	drop *wgt1
	


qui {

  *-----------------------------------------------------------------------------
  * Autogenerated documentation (markdown files) from edukit_save
  *-----------------------------------------------------------------------------

  * Whether we generate documentation for each .dta or no depends on Stata version
  * for dyntext was only implemented in version 15.
  * It also requires that edukit_save was being used to save files
  local generate_documentation = ( c(version)>=15  &  $use_edukit_save )

  * List of files for which edukit_save_metadata is implemented
  local files_saved_with_metadata "oos_gem_pref${chosen_preference}"

  * Location of those files in the clone
  local file_path "${clone}/02_simulation/023_outputs/"

  * Location to save the autogenerated tables and to find the dyntext script
  local doc_path "${clone}/00_documentation/002_repo_structure/0022_dataset_tables"


  * If it was verified that documentation can be generated
  if `generate_documentation'==1 {

    * Must be in the folder where dyntext scrip is found
    cd "`doc_path'"

    * Loop through the files with metadata
    foreach filename of local files_saved_with_metadata {

      * Open the file and document it
	noi dyntext "dyntext_LP_OOS_Compare.txt", saving("`doc_path'/OOS_GEM_compare.md") replace


    noi disp as res "{phang}Create documentation for datasets: `files_saved_with_metadata'.{p_end}"
  }

  else noi disp as err "{phang}Was not able to create documentation for datasets: `files_saved_with_metadata'.{p_end}"

}
}
