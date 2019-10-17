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
* Make sure stata simulation_dataset.ado file is loaded
do "${clone}/02_simulation/022_program/_simulation_dataset.ado"

* Run simulations to produce final datasets
do "${clone}/02_simulation/022_program/022_simulations.do"
*-------------------------------------------------------------------------------
