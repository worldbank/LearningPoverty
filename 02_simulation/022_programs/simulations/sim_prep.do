*****************************************************
* Define Seed used to produce results
gl master_seed 17893
*****************************************************

*-------------------------------------------------------------------------------
* Define user-dependant global paths
*-------------------------------------------------------------------------------
// User-dependant paths for local repo clone
*Brian
if inlist("`c(username)'","wb469649","WB469649") {
/*Local repo clone  */ global clone   "C:/Users/`c(username)'/Documents/GitHub/LearningPoverty-Production"
}
*Diana
if inlist("`c(username)'","wb552057","WB552057","diana") {
/*Local repo clone  */ global clone   "C:/Users/`c(username)'/Documents/Github/LearningPoverty"
}
*Joao Pedro
if inlist("`c(username)'","wb255520","WB255520") {
/*Local repo clone  */ global clone   "C:/Users/`c(username)'/Documents/mytasks/LearningPoverty"
}
*Kristoffer
if inlist("`c(username)'","wb462869","WB462869") {
/*Local repo clone  */ global clone   "C:/Users/`c(username)'/Documents/GitHub/LearningPoverty"
}

/* WELCOME!!! ARE YOU NEW TO THIS CODE?
   Add yourself by copying the lines above, making sure to adapt your clone */
*--------------------

*****************************************************
* Explicitly set varabbreviation off to avoid errors
*****************************************************
  set varabbrev    off, permanently

*****************************************************
* Install packages
*****************************************************

/* WELCOME!!! ARE YOU NEW TO THIS CODE?
   Add yourself by copying the lines above, making sure to adapt your clone */
*-------------------------------------------------------------------------------

* Make sure stata simulation_dataset.ado file is loaded
cd "${clone}/02_simulation/022_programs/"

do "${clone}/02_simulation/022_programs/_simulation_dataset.ado"
