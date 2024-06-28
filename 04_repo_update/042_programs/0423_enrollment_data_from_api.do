*==============================================================================*
* 0423 SUBTASK: PREPARE ENROLLMENT CSVS TO UPDATE THE 011_RAWDATA IN REPO FOLDER
*==============================================================================*

qui {

	/***********************************
	 Enrollment (TENR) from WB opendata
	***********************************/
	noi di _newline "{phang}Enrollment (TENR) from WB opendata{p_end}"

	* Prepare local to create file
	local clonefile "${clone}/04_repo_update/043_outputs/enrollment_tenr_wbopendata.csv"

	* Import the rawdata from WB Opendata
	* indicator SE.PRM.TENR = Adjusted net enrollment rate, primary (% of primary school age children)
	wbopendata, indicator(SE.PRM.TENR; SE.PRM.TENR.FE; SE.PRM.TENR.MA) clear nometadata long

	* Drop all aggregates (non-countries)
	drop if region == "NA"

	* Keep only relevant variables and time window
	keep countrycode year se_prm_tenr*

	* make the most recent year 2016, so we can see if more recent years 
	* can be covered (ie., 2019) - wbopendata has not updated yet
	keep if year >=1990 
	
	preserve
	
	* Read the latest enrollment ifle
	import delimited "${network}/HLO_Database/UIS/${uis}/EDU_DATA_NATIONAL.csv", clear	
			
	keep if indicator_id == "NERA.1.cp"  | indicator_id == "NERA.1.F.cp"  | indicator_id == "NERA.1.M.cp" 
	
	* Drop aggregates 
	drop if strpos(country_id,"4")>0
	
	keep indicator_id country_id year value
	
	replace indicator_id = subinstr(indicator_id,".","_",.)
	
	reshape wide value, i(country_id year) j(indicator_id, string)
	
	rename (valueNERA_1_cp valueNERA_1_F_cp valueNERA_1_M_cp) (tot fe ma)

	rename country_id countrycode 
	

	tempfile wbopendata 
	save `wbopendata', replace
	
	restore 
	
	merge 1:1 countrycode year using `wbopendata', nogen keep(match master)
	
	replace se_prm_tenr = tot 
	replace se_prm_tenr_fe = fe 
	replace se_prm_tenr_ma = ma
	
	drop tot fe ma
	
	* Export csv
	export delimited using "`clonefile'", replace
	noi di "{phang}Saved `clonefile'{p_end}"
	

	/***********************************
	    Enrollment from UIS EDULIT
	***********************************/
	** Note: This part of the routine was never created, it was meant for the 
	* enrollment_edulist_uis.csv under 01 raw.
	
	** Info retrieved from apiportal.uis.unesco.org on 6/12/23:
	** "Please note that as of June 23rd, 2020 the current UIS SDMX API has reached its End-of-Life (EOL) and is no longer up-to-date with the latest UIS datasets. It will continue to accept API traffic and return results until it is decommissioned and replaced with a new UIS API in 2021."
	
	* For now, it takes from a manual uis download in data.uis.unesco.org from 6/12/23 (not the bulk download because the file size is too big)
	* Note: in this iteration, it seems ANER and NER are no longer in the dataset.	
	* TENR
	import delimited "${network}/HLO_Database/UIS/${uis}/NATMON_DATA_NATIONAL.csv", clear
		
	* Keep TENR primary, total, fe, ma
	keep if indicator_id == "NERT.1.cp"  | indicator_id == "NERT.1.F.cp"  | indicator_id == "NERT.1.M.cp" 
	
	replace indicator_id = subinstr(indicator_id,".","_",.)
	
	* Drop aggregates 
	drop if strpos(country_id,"4")>0
		
	* Get a dummy NER that is identical to NERT 
	* Note: The implication here is that NER and ANER are no longer in the hierarchy
	* though it seems UIS no longer has these indicators in the database
	expand 2
	bysort indicator_id country_id year: gen n = _n
	replace indicator_id = "NER_1_CP" if n == 1 & indicator_id == "NERT_1_cp"
	replace indicator_id = "NER_1_F_CP" if n == 1 & indicator_id == "NERT_1_F_cp"
	replace indicator_id = "NER_1_M_CP" if n == 1 & indicator_id == "NERT_1_M_cp"
		
	tempfile tenr
	save `tenr', replace 
	
	* GER
	import delimited "${network}/HLO_Database/UIS/${uis}/NATMON_DATA_NATIONAL.csv", clear
	
	* keep GER primary, total, fe, ma
	keep if indicator_id == "GER.1" | indicator_id == "GER.1.F" | indicator_id == "GER.1.M"
	
	* Drop aggregates 
	drop if strpos(country_id,"4")>0	
	replace indicator_id = subinstr(indicator_id,".","_",.)

	
	* Append TENR
	append using `tenr'
	
	* Conform to original .csv format
	rename indicator_id edulit_ind
	
	tempfile enr 
	save `enr', replace


	export delimited "${clone}/04_repo_update/043_outputs/enrollment_edulit_uis.csv", replace
	
}