*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 03_EXPORT_TABLES: exports tables for learning poverty technical paper
*==============================================================================*


*-----------------------------------------------------------------------------
* Setup for this task
*-----------------------------------------------------------------------------
* Check that project profile was loaded, otherwise stops code
cap assert ${LP_profile_is_loaded} == 1
if _rc != 0 {
  noi disp as error "Please execute the profile_LearningPoverty initialization do in the root of this project and try again."
  exit
}

* Execution parameters
global chosen_preference 1005  // Chosen preference created in 01 rawlatest
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutines for this task
*-----------------------------------------------------------------------------
* Run script to produce SPELLS summary statistics tables for paper
do "${clone}/03_export_tables/032_programs/0320_spells_statistics.do"

* Run script to produce CURRENT SITUATION tables for paper
do "${clone}/03_export_tables/032_programs/0321_create_outlines.do"

* Produce decomposition of Learning Poverty levels and change
do "${clone}/03_export_tables/032_programs/0322_decomposition.do"

* Produce numbers for learning poverty for the country annex table
do "${clone}/03_export_tables/032_programs/0323_country_annex.do"

* Export indicators to WDI
do "${clone}/03_export_tables/032_programs/0324_export_WDI.do"
*-----------------------------------------------------------------------------
