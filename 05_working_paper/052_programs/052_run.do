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
*-----------------------------------------------------------------------------
* Execution parameters
*global chosen_preference 1005  	// Chosen preference created in 01 rawlatest (0126) (if different from master run)
*global timewindow = 2009 		// chose the reference window (if different from master run)
*global anchoryear = 2015		// chose anchor year (if different from master run)

global chosen_preference 1205  	// Chosen preference created in 01 rawlatest (0126) (if different from master run)
global timewindow = 2011 		// chose the reference window (if different from master run)
global anchoryear = 2019		// chose anchor year (if different from master run)

*-----------------------------------------------------------------------------
* CHECK PREFERENCE CHOICE
*-----------------------------------------------------------------------------
qui {

	if (${chosen_preference} == 1005) {
	    noi disp 
		noi disp in r "{pstd}ATTENTION!!!!{p_end}"
		noi disp in y `"{pstd}You have selected the original PRWP No. 9588: March, 2021 vintage {browse "https://openknowledge.worldbank.org/handle/10986/35300"}. The full replication of the workding paper results require using an earlier release of this REPO. Please go to: {browse "https://github.com/worldbank/LearningPoverty/tree/v1.1"}. If you want to continue write 1005, with the undrestanding that results will be different since the vintage of enrollment and population numbers used might have changed, and hit enter. Otherwise write anthing else and hit enter or just hit enter without writing anything. Before continuing please ensure that SUBTASK0126, produced the rawlatest, rawlatest_aggregate, and the rawlatest for different population definitions for preference 1005. These files are inputs in this task.{p_end}"', _request(confirmation_1005)
		noi di ""
		
		if ("${confirmation_1005}" != "1005") {
		  noi di as error "{pstd}Input is not 1005 so code is exited. You will need to change the chosen_preference global to skip this message.{p_end}"
		  exit
		}
		else {
		  noi di as error "{pstd}Input is 1005. Processing request.{p_end}"
		}
		
	}
}
	
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

* Generate tables outlining the current situation following what was reporeted in PRWP No. 9588 
* this is similar to SUBTASK:0321. It has been moved here to give flexibility
do "${clone}/05_working_paper/052_programs/05251_create_outlines.do"

do "${clone}/05_working_paper/052_programs/05252_outline_tables.do"

* Clones the Excel template and fills it with data
do "${clone}/05_working_paper/052_programs/0525_export_excel.do"
*-------------------------------------------------------------------------------
