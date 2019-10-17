*==============================================================================*
* 0421 SUBTASK: PREPARE METADATA CSV TO UPDATE THE 011_RAWDATA IN REPO FOLDER
*==============================================================================*
qui {

  * Locals to point to User-Specific locations
  * - where the CMU excel is found
  local cmu_csv "${clone}/04_repo_update/041_rawdata/cmu_ctry.csv"
  * - where to save the resulting CSV with/without labels
  local csv_with_labels "${clone}/04_repo_update/043_outputs/country_metadata.csv"


  /*****************************************
       CMU and Regional Focal Point info
         from Excel file in ONE DRIVE
  *****************************************/
  noi di _newline "{phang}Getting CMU information from csv{p_end}"

  * Import the Excel file with the CMU information
  import delimited "`cmu_csv'", varnames(1) clear

  * Keep only the metadata that is not available in wbopendata
  keep countrycode cmu

  * Beautify: variable names and variable labels
  label var cmu       "WB Country Management Unit"

  * Store it as a tempfile
  tempfile  cmu_dta
  save 	   `cmu_dta'


  /*****************************************
     Region, IncomeLevel, other metadata
                from WB Opendata
  *****************************************/
  noi di "{phang}Getting other metadata from wbopendata{p_end}"

  * Get metadata from wbopendata - doesn't matter the indicator or year
  wbopendata, indicator(SP.POP.TOTL) year(2000) clear long nometadata full

  * Drop all aggregates (non-countries)
  drop if region == "NA"

  * Keep only the metadata (drop indicator and year)
  keep country* *region* incomelevel* lendingtype*



  /********* Combine both sources ***********/

  * With the wbopendata one in memory, bring the cmu data
  merge 1:1 countrycode using `cmu_dta', keep(match) nogen

  sort countrycode

  * Double check we have exactly the 217 countries
  assert `c(N)' == 217

  * Could already export as csv the country metadata (but the variable labels would be loss)


  /********* PRESERVING THE VARIBLE LABELS  ***********/

  * Variable labels are saved in the last observation before exporting to csv
  * Note that this is a good solution because all vars are strings anyway

  * Create extra observation in the end, to store the labels
  local label_obs = _N +1
  set obs `label_obs'

  * Loop through all vars, storing their label in the last observation
  foreach thisvar of varlist _all {
    replace `thisvar' ="`: variable label `thisvar''" if _n == `label_obs'
  }

  * Export csv that contains the labels
  export delimited using "`csv_with_labels'", replace

  noi di "{phang}Saved `csv_with_labels'{p_end}"

}

exit


/* EXAMPLE OF HOW TO REVERT BACK THE VARIABLE LABELS WHEN IMPORTING THE CSV

* Open the csv with both data and labels (in the last observation)
import delimited using "`csv_with_labels'", varnames(1) case(preserve) clear

* Loop through all variables, labelling them per last observation
foreach thisvar of varlist _all {
  label var `thisvar' "`= `thisvar'[_N]'"
}

* Drop last observation, which only had the var labels
drop if _n == _N

* Compress (remember that the string vars got larger because of labels)
compress
