*==============================================================================*
*! LEARNING POVERTY (LP) - PUBLIC VERSION
*! Project information at: https://github.com/worldbank/LearningPoverty
*! EduAnalytics Team, World Bank Group [eduanalytics@worldbank.org]

*! PROFILE: Required step before running any do-files in this project
*==============================================================================*

quietly {

  /*
  Steps in this do-file:
  1) General program setup
  2) Define user-dependant path for local clone repo
  3) Check if can access WB network path and WB datalibweb
  4) Download and install required user written ado's
  5) Flag that profile was successfully loaded
  */

  *-----------------------------------------------------------------------------
  * 1) General program setup
  *-----------------------------------------------------------------------------
  clear               all
  capture log         close _all
  set more            off
  set varabbrev       off, permanently
  set emptycells      drop
  set maxvar          2048
  set linesize        135
  version             15
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * 2) Define user-dependant path for local clone repo
  *-----------------------------------------------------------------------------
  * Change here only if this repo is renamed
  local this_repo     "LearningPoverty"
  * Change here only if this master run do-file is renamed
  local this_run_do   "run_LearningPoverty.do"

  * The remaining of this section is standard in EduAnalytics repos

  * One of two options can be used to "know" the clone path for a given user
  * A. the user had previously saved their GitHub location with -whereis-,
  *    so the clone is a subfolder with this Project Name in that location
  * B. through a window dialog box where the user manually selects a file

  * Method A - Github location stored in -whereis-
  *---------------------------------------------
  capture whereis github
  if _rc == 0 global clone "`r(github)'/`this_repo'"

  * Method B - clone selected manually
  *---------------------------------------------
  else {
    * Display an explanation plus warning to force the user to look at the dialog box
    noi disp as txt `"{phang}Your GitHub clone local could not be automatically identified by the command {it: whereis}, so you will be prompted to do it manually. To save time, you could install -whereis- with {it: ssc install whereis}, then store your GitHub location, for example {it: whereis github "C:/Users/AdaLovelace/GitHub"}.{p_end}"'
    noi disp as error _n `"{phang}Please use the dialog box to manually select the file `this_run_do' in your machine.{p_end}"'

    * Dialog box to select file manually
    capture window fopen path_and_run_do "Select the master do-file for this project (`this_run_do'), expected to be inside any path/`this_repo'/" "Do Files (*.do)|*.do|All Files (*.*)|*.*" do

    * If user clicked cancel without selecting a file or chose a file that is not a do, will run into error later
    if _rc == 0 {

      * Pretend user chose what was expected in terms of string lenght to parse
      local user_chosen_do   = substr("$path_and_run_do",   - strlen("`this_run_do'"),     strlen("`this_run_do'") )
      local user_chosen_path = substr("$path_and_run_do", 1 , strlen("$path_and_run_do") - strlen("`this_run_do'") - 1 )

      * Replace backward slash with forward slash to avoid possible troubles
      local user_chosen_path = subinstr("`user_chosen_path'", "\", "/", .)

      * Check if master do-file chosen by the user is master_run_do as expected
      * If yes, attributes the path chosen by user to the clone, if not, exit
      if "`user_chosen_do'" == "`this_run_do'"  global clone "`user_chosen_path'"
      else {
        noi disp as error _newline "{phang}You selected $path_and_run_do as the master do file. This does not match what was expected (any path/`this_repo'/`this_run_do'). Code aborted.{p_end}"
        error 2222
      }
    }
  }

  * Regardless of the method above, check clone
  *---------------------------------------------
  * Confirm that clone is indeed accessible by testing that master run is there
  cap confirm file "${clone}/`this_run_do'"
  if _rc != 0 {
    noi disp as error _n `"{phang}Having issues accessing your local clone of the `this_repo' repo. Please double check the clone location specified in the run do-file and try again.{p_end}"'
    error 2222
  }
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * 3) Check if can access WB network path and WB datalibweb
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
  if _rc == 0     global datalibweb_is_available 1
  else            global datalibweb_is_available 0

  * Both the network path and datalibweb are only used to update the repo (task 04),
  * it is not a problem for users external to WBG attempting to replicate main results
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * 4) Download and install required user written ado's
  *-----------------------------------------------------------------------------
  * Fill this list will all user-written commands this project requires
  * that can be installed automatically from ssc
  local user_commands wbopendata carryforward touch _gwtmean mdensity estout grqreg missings adecomp repest

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
  if $use_edukit_save == 0 noi disp as res "{phang}This will not prevent the replication of the main results, but will skip the creation of markdown documentation.{p_end}"


  * Load other auxiliary programs, that are found in this Repo

  * Preferred list selects 1 observation per country from rawfull (unique proficiency)
  * and trims the dataset on the wide sense (keep 1 enrollment, 1 population only)
  do "${clone}/01_data/012_programs/01261_preferred_list.do"

  * Population weights creates frequency weights for aggregations of global numbers
  do "${clone}/01_data/012_programs/01262_population_weights.do"

  * Make sure the ado for running the simulations is loaded
  do "${clone}/02_simulation/022_programs/simulate_learning_poverty.ado"

  * Tables for paper defines programs that export tables to csv
  do "${clone}/03_export_tables/032_programs/03211_outline_tables.do"
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * 5) Flag that profile was successfully loaded
  *-----------------------------------------------------------------------------
  noi disp as result _n `"{phang}`this_repo' clone sucessfully set up (${clone}).{p_end}"'
  global LP_profile_is_loaded = 1
  *-----------------------------------------------------------------------------

}
