*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 04_REPO_UPDATE: creates csv files that are hosted in repo
*==============================================================================*


*-------------------------------------------------------------------------------
* Setup for this task
*-------------------------------------------------------------------------------
* Check that project profile was loaded, otherwise stops code
cap assert ${LP_profile_is_loaded} == 1
if _rc != 0 {
  noi disp as error "Please execute the profile_LearningPoverty initialization do in the root of this project and try again."
  exit
}
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* Subroutines for this task
*-------------------------------------------------------------------------------
* Update COUNTRY METADATA to store as csv in 011_rawdata
do "${clone}/04_repo_update/042_programs/0421_country_metadata_csv.do"

* Update POPULATION DATA from APIs to store as csv in 011_rawdata
do "${clone}/04_repo_update/042_programs/0422_population_data_from_api.do"

* Update ENROLLMENT DATA from APIs to store as csv in 011_rawdata
do "${clone}/04_repo_update/042_programs/0423_enrollment_data_from_api.do"

* Update PROFICIENCY DATA from multiple sources to store as csv in 011_rawdata
do "${clone}/04_repo_update/042_programs/0424_proficiency_data.do"

* Update Other WB API data to store as csv in 011_rawdata
do "${clone}/04_repo_update/042_programs/0425_otherdata_from_api.do"
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* Copy CSV outputs to 01_data/011_rawdata/hosted_in_repo, with replace
*-------------------------------------------------------------------------------
quietly {

  * Only do this part in case you want to overwrite the CSV files hosted in repo.
  * this means updates in the APIs may lead to different results from published paper
  noi di "{pstd}You are about to replace the CSV files in [${clone}/01_data/011_rawdata/hosted_in_repo]. Are you sure you want to do this? Given that the API data may have changed, updating those files may prevent results to replicate exactly from the working paper. If you want to overwrite the CSV files hosted in repo, write REPLACE and hit enter, otherwise write anything else and hit enter or just hit enter without writing anything.{p_end}", _request(confirmation_repo_update)

  if ("${confirmation_repo_update}" != "REPLACE") {
    noi di as error _newline "{pstd}Input is not REPLACE so code is aborted. No files were copied or overwritten.{p_end}"
    exit
  }

  else {
    noi di as res _newline "{pstd}Input is REPLACE so CSV files hosted in repo will be overwritten.{p_end}"

    * Retrieves list of csv files in the 043_outputs
    local csvfiles : dir "${clone}/04_repo_update/043_outputs/" files "*.csv", respectcase

    * Loop over each csv file and copy with replace it to the 011_rawdata
    foreach csvfile of local csvfiles {
      local 043_csvfile "${clone}/04_repo_update/043_outputs/`csvfile'"
      local 011_csvfile "${clone}/01_data/011_rawdata/hosted_in_repo/`csvfile'"
      copy "`043_csvfile'" "`011_csvfile'", replace
      noi di as text "{pstd}Exported `011_csvfile'.{p_end}"
    }
  }
}
