*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* TASK 02_SIMULATION: simulates learning poverty from 2015 to 2030
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
*-------------------------------------------------------------------------------


*-------------------------------------------------------------------------------
* Subroutines for this task
*-------------------------------------------------------------------------------
* Get all possible learning poverty spells (plus dummies of comparability and use)
do "${clone}/02_simulation/022_programs/0220_create_all_spells.do"

* Generate alternative markdown inputs for simulations
do "${clone}/02_simulation/022_programs/0221_aggregates_spells.do"

* Run simulations to produce final datasets
do "${clone}/02_simulation/022_programs/0222_simulations.do"

/* To generate spells that were saved as markdown in the 021_rawdata/old_version
do "${clone}/02_simulation/022_programs/022x_custom_spells.do"
do "${clone}/02_simulation/022_programs/022y_custom_spells_bootstrap.do"
*/
*-------------------------------------------------------------------------------
