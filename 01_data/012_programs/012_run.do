*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 01_DATA: calculates learning poverty by combining multiple data sources
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

* Execution parameters
global master_seed  17893   // Ensures reproducibility
global anchor_year = 2015   // Anchor year for learning poverty numbers produced
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* Subroutines for this task
*-------------------------------------------------------------------------------
* Import rawdata from CSVs and MDs hosted in repo into DTAs
do "${clone}/01_data/012_programs/0120_import_rawdata.do"

* Combine POPULATION rawdata from multiple sources
do "${clone}/01_data/012_programs/0121_combine_population_data.do"

* Combine PROFICIENCY rawdata from multiple sources
do "${clone}/01_data/012_programs/0122_combine_proficiency_data.do"

* Combine ENROLLMENT rawdata from multiple sources
do "${clone}/01_data/012_programs/0123_combine_enrollment_data.do"

* Prepare ENROLLMENT extrapolation
do "${clone}/01_data/012_programs/0124_enrollment_extrapolation.do"

* Merge all sources to create RAWFULL
do "${clone}/01_data/012_programs/0125_create_rawfull.do"

* Select info in rawfull to create RAWLATEST
do "${clone}/01_data/012_programs/0126_create_rawlatest.do"

* Auto-generate documentation from metadata in edukit_save
do "${clone}/01_data/012_programs/0127_generate_documentation.do"
*-----------------------------------------------------------------------------
