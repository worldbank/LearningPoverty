*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 05_WORKINGPAPER: export figures and tables for the Working Paper
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
* Subtasks 0521 through 0524 are validations of LP with other constructs

* Relationship between Reading and Math Proficiency (PISA)
do "${clone}/05_working_paper/052_programs/0521_regression_pisa_gdp.do"

* Correlations between assessments and subjects
do "${clone}/05_working_paper/052_programs/0522_correlations.do"

* Relationship between Learning Poveryt BMP and PISA Level 2
do "${clone}/05_working_paper/052_programs/0523_bmp_pisa_validation.do"

* Relationship between Learning Poveryt BMP and Early Grade
do "${clone}/05_working_paper/052_programs/0524_bmp_earlygrade_validation.do"

* Put every table and figure together to create all numbers in the Working Paper

* Clones the Excel template and fills it with data
do "${clone}/05_working_paper/052_programs/0525_export_excel.do"
*-------------------------------------------------------------------------------
