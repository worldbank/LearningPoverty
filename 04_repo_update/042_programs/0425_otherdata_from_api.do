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

  * Import the rawdata from WB Opendata
  * Initial government funding per primary student, constant PPP$
  wbopendata, language(en - English) country() topics() indicator(UIS.XUNIT.PPPCONST.1.FSGOV; UIS.X.PPPCONST.1.FSGOV; SE.PRM.ENRR; SP.PRM.TOTL.IN) long clear

  * Remove region aggregates and future values
  drop if region == "NA"
  drop if year >= 2020

  * Keep only relevant variables
  keep countrycode year uis_x_pppconst_1_fsg sp_prm_totl_in se_prm_enrr uis_xunit_pppconst_1 region incomelevel

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

}
