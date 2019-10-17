*==============================================================================*
* LEARNING POVERTY (LP)
* Project information at: https://github.com/worldbank/LearningPoverty
*
* This initialization do sets paths, globals and install programs for the Repo
*==============================================================================*
qui {


  *-----------------------------------------------------------------------------
  * General program setup
  *-----------------------------------------------------------------------------
  clear               all
  capture log         close _all
  set more            off
  set varabbrev       off, permanently
  set maxvar          10000
  version             15
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * Define user-dependant global paths
  *-----------------------------------------------------------------------------
  * User-dependant paths for local repo clone
  * Brian
  if inlist("`c(username)'","wb469649","WB469649") {
    global clone   "C:/Users/`c(username)'/Documents/GitHub/LearningPoverty"
  }
  * Diana
  else if inlist("`c(username)'","wb552057","WB552057","diana") {
    global clone   "C:/Users/`c(username)'/Documents/Github/LearningPoverty"
  }
  * Joao Pedro I
  else if inlist("`c(username)'","wb255520","WB255520") {
    global clone   "C:/Users/`c(username)'/Documents/mytasks/LearningPoverty-tmp"
  }
  * Joao Pedro II
  else if inlist("`c(username)'","azeve") {
    global clone   "C:/GitHub_mytasks/LearningPoverty-tmp"
  }
  * Kristoffer
  else if inlist("`c(username)'","wb462869","WB462869") {
    global clone   "C:/Users/`c(username)'/Documents/GitHub/LearningPoverty"
  }
  * If none of above cases, give an error
  else {
    noi disp as error _newline "{phang}Your username [`c(username)'] could not be matched with any profile. Please update profile_LearningPoverty do-file accordingly and try again.{p_end}"
    error 2222
  }
  /* WELCOME!!! ARE YOU NEW TO THIS CODE?
     Add yourself by copying the lines above, making sure to adapt your clone */


  * Checks that files in the clone can be accessed by testing any clone file (like this one)
  cap confirm file "${clone}/profile_LearningPoverty.do"
  if _rc != 0 {
    noi disp as error _newline "{phang}Having issues accessing your local clone of the LearningPoverty repo. Please double check the clone location specified in profile_LearningPoverty do-file and try again.{p_end}"
    error 2222
  }
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * Check if can access WB network path and WB datalibweb
  *-----------------------------------------------------------------------------
  * Network drive is always the same for everyone, but may not be available
  * if the user is not connected to the World Bank intranet
  global network 	"//wbgfscifs01/GEDEDU/"
  cap cd "${network}"
  if _rc == 0     global network_is_available 1
  else            global network_is_available 0

  * Datalibweb is only available in Stata for internal World Bank users
  * but external users can access it through SOL (TODO add link here)
  cap which datalibweb
  if _rc == 0     global datalibweb_is_available 0 	// TODO: change here to 1 after testing
  else            global datalibweb_is_available 0
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * Download and install required user written ado's
  *-----------------------------------------------------------------------------
  * Fill this list will all user-written commands this project requires
  local user_commands wbopendata carryforward touch _gwtmean mdensity estout grqreg 

  * Loop over all the commands to test if they are already installed, if not, then install
  foreach command of local user_commands {
    cap which `command'
    if _rc == 111 ssc install `command'
  }

  * Check for EduAnalyticsToolkit package
  /* EDUKIT is the shortname of the the public repo EduAnalyticsToolkit.
     For info on the repo: https://github.com/worldbank/EduAnalyticsToolkit
     Though it is not required for calculating Learning Poverty,
     having the package installed and up-to-date allows to generate automatic
     documentation of all datasets in markdown. */
  cap edukit
  if _rc != 0 {
    noi disp as res _newline "{phang}You don't have the EduAnalytics Toolkit package installed. Please see this link for info on how to install it: https://github.com/worldbank/EduAnalyticsToolkit{p_end}"
    global use_edukit_save = 0
  }
  else if `r(version)' < 1.0 {
    noi disp as res _newline "{phang}You have an outdated version of the EduAnalytics Toolkit package installed. Please see this link for info on how to update it: https://github.com/worldbank/EduAnalyticsToolkit{p_end}"
    global use_edukit_save = 0
  }
  else {
    noi disp as res _newline "{phang}You have an up-to-date version of the EduAnalytics Toolkit package installed. Thus, automatically generated markdown files will be created to document the most relevant datasets.{p_end}"
    global use_edukit_save = 1
  }
  *-----------------------------------------------------------------------------

  *------------------------------------------------------------------------------------------
  * Load the auxiliary programs in this Repo
  *------------------------------------------------------------------------------------------
  * Preferred list selects 1 observation per country from rawfull (unique proficiency)
  * and trims the dataset on the wide sense (keep 1 enrollment, 1 population only)
  do "${clone}/01_data/012_programs/01261_preferred_list.do

  * Population weights creates frequency weights for aggregations of global numbers
  do "${clone}/01_data/012_programs/01262_population_weights.do

  * Tables for paper with confidence intervals to csv
  do "${clone}/03_export_tables/032_programs/03211_preferred_list_tables_ci.do

  * Tables for paper defines programs that export tables to csv
  do "${clone}/03_export_tables/032_programs/03221_tables_for_paper.do
  *-------------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * Flag that profile was successfully loaded
  *-----------------------------------------------------------------------------
  global LP_profile_is_loaded = 1
  noi disp as res "{phang}LearningPoverty profile sucessfully loaded.{p_end}"
  *-----------------------------------------------------------------------------

}
