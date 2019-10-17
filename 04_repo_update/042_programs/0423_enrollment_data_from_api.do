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
	keep if year >= 1990

	* Export csv
	export delimited using "`clonefile'", replace
	noi di "{phang}Saved `clonefile'{p_end}"


	/***********************************
	    Enrollment from UIS EDULIT
	***********************************/
	// TODO: structure the routine to update this file
	// or at the bareminimum list the online source of where it is
	// PLACEHOLDER

}
