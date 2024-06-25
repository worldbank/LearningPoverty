*==============================================================================*
* 0325 SUBTASK: EXPORT INDICATOR SERIES BASED ON DCS FORMAT (WB API)
* Created by Sheena Fazili and Yi Ning Wong on 02/27/23
* Last modified by SF on 1/3/23
*==============================================================================*

 
  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference 	= ${chosen_preference}
 
  *----------------------------------------------------------
  * Dataset 1: Full Data 
  *----------------------------------------------------------

  *-----------------
  * Use dataset created in task 0324
  *-----------------
  
  use "${clone}/03_export_tables/033_outputs/WDI_indicators_`chosen_preference'.dta", clear
  
  *--------------------
  * Update variables 
  *--------------------

  * Rename vars
  rename (countrycode indicator value) (COUNTRY SERIES Data)

  * National only (0=National, 1=States, 2=Districts)
  gen SCALE = 0
  
  * Generate new TIME var to display yr in "YR20##" format
  gen TIME = "YR" + string(year, "%03.0f")
  
  * Keeping only vars of interest
  keep COUNTRY SERIES TIME Data SCALE
  order COUNTRY SERIES TIME Data SCALE
  
  * DCS doesn't support aggregates for part 2 countries 
  drop if COUNTRY == "WBC"
  *--------------------
  * Export Dataset
  *--------------------
  save "${clone}/03_export_tables/033_outputs/api_`chosen_preference'.dta", replace
  
  * .csv to track changes on github
  export delimited "${clone}/03_export_tables/033_outputs/api_`chosen_preference'.csv", replace
  
  * .xlsx for DCS compatible format
  export excel using"${clone}/03_export_tables/033_outputs/api_`chosen_preference'.xlsx", replace firstrow(variables) sheet("Series_Table")
  
  *----------------------------------------------------------
  * Dataset 2: Metadata
  *----------------------------------------------------------

    * Preset: DCS structure has 25 total variables 
  * This should not be changed
  local dcs_vars = 30
  
  * File that will be updated, using the variable names DCS requires 
  global template_file "${clone}/03_export_tables/031_rawdata/metadata_api.xlsx"
  
  global excel_file    "${clone}/03_export_tables/033_outputs/metadata_api.xlsx"
  copy "${template_file}" "${excel_file}", replace
  noi disp as txt _n "Copied the variable names for DCS purposes"
  
  * Read the lpv_metadata
	import excel using "${clone}/03_export_tables/033_outputs/lpv_edstats_`chosen_preference'.xls",  sheet("lpv_metadata") firstrow clear

	* Create new variables 
	local exist_vars = c(k)
	local create_vars = `dcs_vars' - `exist_vars'

	forval i = 1/`create_vars' {
		gen v`i' = ""
	}
	
	* Create static variables
	replace v8 = "CC BY-4.0"
	replace v25 = "% of Total"
	
	* .csv to track changes on github
	export delimited using "${clone}/03_export_tables/033_outputs/metadata_api.csv", replace 
	* .xlsx for DCS compatible format
	export excel using "${excel_file}", cell(A2) nolabel keepcellfmt  sheet("Series_table",modify)
	
  *--------------------------------------------------------------------------------------
  * Dataset 3: Exporting new variables based on Gaurav's suggestion
  *--------------------------------------------------------------------------------------
  
    * File that will be updated, using the variable names DCS requires 
  global template_file "${clone}/03_export_tables/031_rawdata/New vars for DCS.csv"
  
  global excel_file    "${clone}/03_export_tables/033_outputs/New vars for DCS.csv"
  copy "${template_file}" "${excel_file}", replace
  noi disp as txt _n "Copied the variable names for DCS purposes"

  use "${clone}/03_export_tables/033_outputs/WDI_indicators_`chosen_preference'.dta", clear

  keep indicator value_metadata
  //drop if indicator == "SE.LPV.PRIM" | indicator =="SE.LPV.PRIM.FE" | indicator =="SE.LPV.PRIM.LD"

  duplicates drop indicator, force
  * .xlsx for DCS compatible format
  
  * .csv to track changes on github
  export delimited using "${excel_file}", replace 

  export excel using  "${clone}/03_export_tables/033_outputs/New vars for DCS.xlsx", cell(A2) nolabel keepcellfmt sheet("Series",modify)
