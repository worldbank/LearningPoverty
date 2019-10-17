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
* Run script to produce tables for paper (Part 1)
do "${clone}/03_export_tables/032_programs/0321_put_to_excel.do"

* Run script to produce tables for paper (Part 2)
do "${clone}/03_export_tables/032_programs/0322_gender_tables.do"

* Produce numbers for learning poverty for the country annex table
do "${clone}/03_export_tables/032_programs/0323_country_annex.do"

*-----------------------------------------------------------------------------
