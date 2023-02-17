version 16
*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 01_DATA: calculates learning poverty by combining multiple data sources
*==============================================================================*

version 16

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
* Execution parameters
global master_seed  17893   // Ensures reproducibility
global anchor_year 	= 2019  // Anchor year for learning poverty numbers produced
global timewindow 	= 2014 	/// chose the reference window

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


 *------------------------------------------------------------------------------------------
 * This part is totally unnecessary, but is nice to have for comparing outputs
 *------------------------------------------------------------------------------------------
 /*

net install comparefiles, from("C:\Users\wb255520\GitHub\tasks\EduAnalyticsToolkit\")



local file1 "C:\Users\wb255520\OneDrive - WBG\Desktop\2pgrs\preference1108.dta"
local file2 "C:\Users\wb255520\GitHub\tasks\LearningPoverty-Production\01_data\013_outputs\preference1108.dta"

comparefiles,  localfile(`file1') sharedfile(`file2') compareboth idvars(countrycode) wigglevars(adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe)   wiggleroom( 0.01)   mdreport("C:\Users\wb255520\OneDrive - WBG\Desktop\2pgrs\july2021_update.md") mdevensame




local file1 "C:\Users\wb255520\OneDrive - WBG\Desktop\2pgrs\preference1108.dta"
use "`file1'"

order countrycode preference adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all nonprof_ma nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe test
browse countrycode preference adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all nonprof_ma nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe test


local file2 "C:\Users\wb255520\GitHub\tasks\LearningPoverty-Production\01_data\013_outputs\preference1108.dta"
use "`file2'", clear

order countrycode preference adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all nonprof_ma nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe test
browse countrycode preference adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all nonprof_ma nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe test


local file2 "C:\Users\wb255520\GitHub\tasks\LearningPoverty-Production\01_data\013_outputs\rawlatest.dta"
use "`file2'"

order countrycode preference adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all nonprof_ma nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe test
browse countrycode preference adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all nonprof_ma nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe test

local file2 "C:\Users\wb255520\GitHub\tasks\LearningPoverty-Production\01_data\013_outputs\rawfull.dta"
use "`file2'", clear