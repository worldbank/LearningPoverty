*==============================================================================*
* 0425 SUBTASK: PREPARE GDP/EXPENDITURE CSVS TO UPDATE THE 011_RAWDATA IN REPO
*==============================================================================*
qui {

  /***********************************
   Primary Spending indicators from WB opendata
  ***********************************/
  noi di _newline "{phang}Primary Expenditure from WB opendata{p_end}"

  * Prepare local to create file - Primary Expenditure
  local clonefile "${clone}/04_repo_update/043_outputs/primary_expenditure_wbopendata.csv"

  import delimited "${network}/HLO_Database/UIS/${uis}/OPRI_DATA_NATIONAL.csv", clear
  
  keep if indicator_id == "X.PPP.1.FSGOV" | indicator_id == "XGDP.1.FSGOV" | indicator_id == "GER.1" | indicator_id == "SAP.1"
  drop if strpos(country_id,"4")>0

  
  tempfile opri 
  save `opri', replace
  
  
  import delimited "${network}/HLO_Database/UIS/${uis}/SDG_DATA_NATIONAL.csv", clear
  
  keep if indicator_id == "XUNIT.PPPCONST.1.FSGOV.FFNTR" 
  drop if strpos(country_id,"4")>0

  append using `opri'
  
  keep indicator_id country_id year value 
  
  rename country_id countrycode
  
  tempfile uis 
  save `uis', replace
  
  wbopendata, language(en - English) country() topics() indicator(NY.GDP.MKTP.PP.KD) long clear
  
  rename ny_gdp_mktp_pp_kd  value
  gen indicator_id = "NY.GDP.MKTP.PP.KD"
  append using `uis'
 
  drop countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename
  replace indicator_id = subinstr(indicator_id,".","_",.)
  
  rename value v
  
  reshape wide v, i(countrycode year) j(indicator_id, string)

  rename v* *
  
  rename *, lower
  
  rename (ger_1 xunit_pppconst_1_fsgov_ffntr x_ppp_1_fsgov sap_1) (se_prm_enrr uis_xunit_pppconst_1 uis_x_pppconst_1_fsg sp_prm_totl_in)

  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"



  /***********************************
   HCI related indicators from WB opendata
  ***********************************/
  noi di _newline "{phang}HCI and its components from WB opendata{p_end}"

  * Prepare local to create file - Primary Expenditure
  local clonefile "${clone}/04_repo_update/043_outputs/hci_indicators_wbopendata.csv"

  * Import the rawdata from WB Opendata
  * Get all the relevant HCI data. GDP per capita is included to also get
  * countries for which there is no HCI data
  * always pull the latest available data
  wbopendata, indicator(HD.HCI.HLOS; HD.HCI.HLOS.FE; HD.HCI.HLOS.MA; ///
              HD.HCI.LAYS; HD.HCI.LAYS.FE; HD.HCI.LAYS.MA; ///
              HD.HCI.EYRS; HD.HCI.EYRS.FE; HD.HCI.EYRS.MA; ///
              HD.HCI.OVRL; HD.HCI.OVRL.FE; HD.HCI.OVRL.MA; ///
              NY.GDP.PCAP.CD) clear long year(2020)
			  			  
  * Remove variables used to get all countries, and remove regional aggregates
  drop ny_gdp_pcap_cd
  drop if region == "NA"

  * Drop admin vars we already have
  drop region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename

  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"

  /***********************************
   GDP and Poverty from WB opendata
  ***********************************/
  noi di _newline "{phang}GDP and Poverty and its components from WB opendata{p_end}"

  * Prepare local to create file - Primary Expenditure
  local clonefile "${clone}/04_repo_update/043_outputs/poverty_gdp_indicators_wbopendata.csv"

  * Import the rawdata from WB Opendata
  * Get all the relevant HCI data. GDP per capita is included to also get
  * countries for which there is no HCI data
  wbopendata, indicator(NY.GDP.PCAP.CD;SI.POV.DDAY;SI.POV.LMIC; SI.POV.UMIC) clear long

  * Remove variables used to get all countries, and remove regional aggregates
  drop if region == "NA"

  * Drop admin vars we already have
  drop region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename

  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"



***************************************************
*  Assessment Participation (UIS Bulk Download)		*
  **************************************************
  
    noi di _newline "{phang}SDG 4.1.6 (Administration of a nationally representative learning assessment) {p_end}"

  * Prepare local to create file - Primary Expenditure
  local clonefile "${clone}/04_repo_update/043_outputs/sdg416.csv"

	local time "March 2023"
	
	* Data label
	import delimited "${network}/HLO_Database/UIS/`time'/SDG_LABEL.csv", clear varnames(1)
	
	merge 1:m indicator_id using "${network}/HLO_Database/UIS/`time'/SDG_DATA_NATIONAL.dta"
	rename *, lower
	keep if strpos(indicator_id, "ADMI.ENDOFPRIM")>0 
	rename _merge m
	local time "March 2023"
	
	tempfile sdg411b
	save `sdg411b', replace

	* Metadata (need this to identify assessments)

	import excel "${network}/HLO_Database/UIS/`time'/SDG_METADATA.xlsx", clear firstrow
	rename *, lower
	keep if strpos(indicator_id, "ADMI.ENDOFPRIM")>0 
	
	keep indicator_id country_id year type metadata

	merge m:1 indicator_id country_id year using `sdg411b'
	
	* keep only national level 
	rename country_id countrycode
	
	wbopendata, match(countrycode)
	
	drop if countryname == ""
	
	sort indicator_id countrycode year
	
	drop m _merge
	
	drop region regionname admin* lending* income*
	
	* Keep only countries in the LP list 
	merge m:1 countrycode using "${network}/HLO_Database/UIS/country_metadata.dta", keep(matched)
	
  * Export csv
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"	
  
}