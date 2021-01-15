*==============================================================================*
* 0120 SUBTASK: IMPORT ALL RAWDATA CSV/MD FILES HOSTED IN REPO
*==============================================================================*
qui {

  /* This do file manipulates all the CSV and MD files hosted in the repo,
     importing each one into an equivalent dta:
     - country_metadata.csv
     - proficiency_from_GLAD.csv
     - proficiency_no_microdata.csv
     - population_1014.csv
     - population_by_age.csv
     - primary_school_age.csv
     - enrollment_tenr_wbopendata.csv
     - enrollment_edulit_uis.csv
     - enrollment_validated.md
     - primary_expenditure_wbopendata.csv (spending in education)
     - hci_indicators_wbopendata.csv (HCI, LAYS, EYRS, HLO)
     - poverty_gdp_indicators (Poverty @ ILP; LMCL; UMCL; GDP per capita PPP$)
  */

  * Directory where to find the CSVs or MDs (from the repo)
  local input_dir  "${clone}/01_data/011_rawdata/hosted_in_repo"
  * Directory where to save the newly created DTAs
  local output_dir "${clone}/01_data/011_rawdata"

  noi di ""
  noi di "{phang}Importing rawdata from CSV and MD files hosted in the repo...{p_end}"



  /**************************
       Country Metadata
  **************************/
  * Prepare local to create file
  local clonefile "country_metadata"

  * Open the raw csv with both data and labels (in the last observation)
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(preserve) clear

  * Loop through all variables, labelling them per last observation
  foreach thisvar of varlist _all {
    label var `thisvar' "`= `thisvar'[_N]'"
  }

  * Drop last observation, which only had the var labels
  drop if _n == _N

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace



  /**************************
   Proficiency from GLAD_CLO
  **************************/
  * Prepare local to create file
  local clonefile "proficiency_from_GLAD"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(lower) clear

  * Beautify: format, order and label
  format %4.1fc nonprof* se_nonprof*
  foreach subgroup in all fe ma {
    label var nonprof_`subgroup'    "% pupils below minimum proficiency (`subgroup')"
    label var se_nonprof_`subgroup' "SE of pupils below minimum proficiency (`subgroup')"
    label var fgt1_`subgroup'       "Avg gap to minimum proficiency (`subgroup', FGT1)"
    label var fgt2_`subgroup'       "Avg gap squared to minimum proficiency (`subgroup', FGT2)"
  }
  label var countrycode  "WB country code (3 letters)"
  label var idgrade      "Grade ID"
  label var test         "Assessment"
  label var subject      "Subject"
  label var year         "Year of assessment"

  *Only relevant variables kept
  order countrycode idgrade test year subject *nonprof* fgt1* fgt2*
  keep  countrycode idgrade test year subject *nonprof* fgt1* fgt2*

  * Add source for CLO file
  gen source_assessment = "CLO (Country Level Outcomes from GLAD)"
  label var source_assessment "Source of assessment data"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace



  /**************************
   Proficiency from NLA_md
  **************************/
  * Prepare local to create file
  local clonefile "proficiency_from_NLA_md"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(lower) clear

  * Small needed adjustments (fix variables in this dataset)
  gen test = "NLA"
  gen subject = "read"
  gen source_assessment = "National Learning Assessment (from UIS)"
  label var nla_code "Reference code for NLA in markdown documentation"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /**************************
   Proficiency no microdata
  **************************/
  * Prepare local to create file
  local clonefile "proficiency_no_microdata"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(lower) clear

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*************************************
    Population from WB Opendata 10-14
  *************************************/
  * Prepare local to create file
  local clonefile "population_1014"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(lower) clear

  * Calculate aggregate variable
  gen pop1014_all = pop1014_fe + pop1014_ma

  * Rename and label variables
  rename pop1014_fe   population_fe_1014
  label var population_fe_1014  "Female population between ages 10 to 14 (WB API)"
  rename pop1014_ma   population_ma_1014
  label var population_ma_1014  "Male population between ages 10 to 14 (WB API)"
  rename pop1014_all  population_all_1014
  label var population_all_1014 "Total population between ages 10 to 14 (WB API)"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*************************************
    Population from WB Opendata by age
  *************************************/
  * Prepare local to create file
  local clonefile "population_by_age"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(preserve) clear

  * Calculate aggregate variable (rowtotal handles missing values better)
  egen pop_ALL = rowtotal(pop_FE pop_MA), missing

  * Rename and label variables
  label var age     "Age cohort (exact year) for population data"
  label var pop_FE  "Female population in this age"
  label var pop_MA  "Male population in this age"
  label var pop_ALL "Total population in this age"
  rename pop_* population_*
  rename population_*, lower

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*****************************************
  Primary entrance age and duration data
  *****************************************/

  * Prepare local to create file
  local clonefile "primary_school_age"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(lower) clear

  * Create the end age and start age for our definition of 5 last years of primary.
  gen primary_start_age  = uis_ceage_1
  gen primary_end_age   = uis_ceage_1 + se_prm_durs

  * Rename and label variables
  label var uis_ceage_1 "Official entrance age to each ISCED level of education"
  label var se_prm_durs "Primary education, duration (years)"
  label var primary_start_age "Age primary school start (Compulsory starting age)"
  label var primary_end_age   "Age primary school end (Compulsory starting age + duration of primary)"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace



  /***********************************
   Enrollment (TENR) from WB opendata
  ***********************************/

  * Prepare local to create file
  local clonefile "enrollment_tenr_wbopendata"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(preserve) clear

  * Rename and label variables
  rename se_prm_tenr enrollment_ANER_ALL
  label var enrollment_ANER_ALL "Adjusted Net Enrollment Rate (ANER), Primary, Both Sexes"
  rename se_prm_tenr_fe enrollment_ANER_FE
  label var enrollment_ANER_FE  "Adjusted Net Enrollment Rate (ANER), Primary, Female"
  rename se_prm_tenr_ma enrollment_ANER_MA
  label var enrollment_ANER_MA  "Adjusted Net Enrollment Rate (ANER), Primary, Male"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace



  /*******************************
      Enrollment from UIS csv
  *******************************/
  * Prepare local to create file
  local clonefile "enrollment_edulit_uis"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'.csv", varnames(1) case(lower) clear

  * Standardize varnames to those used in wbopendata
  rename (ïedulit_ind location time) (series countrycode year)
  keep series countrycode year value

  * Bring from long to wide
  reshape wide value, i(countrycode year) j(series) string

  * Only keep year after 1990
  keep if year >= 1990

  * Rename and label variables we will use from UIS.
  * Adjusted Net Enrollment is intentially omitted as it will come from wbopendata

  * Gross Enrollment
  rename valueGER_1 enrollment_GER_ALL
  label var enrollment_GER_ALL "Gross Enrollment Rate (GER), Primary, Both Sexes"
  rename valueGER_1_F enrollment_GER_FE
  label var enrollment_GER_FE "Gross Enrollment Rate (GER), Primary, Female"
  rename valueGER_1_M enrollment_GER_MA
  label var enrollment_GER_MA "Gross Enrollment Rate (GER), Primary, Male"

  * Total Net Enrollment
  rename valueNERT_1_CP enrollment_TNER_ALL
  label var enrollment_TNER_ALL "Total Net Enrollment Rate (TNER), Primary, Both Sexes"
  rename valueNERT_1_F_CP enrollment_TNER_FE
  label var enrollment_TNER_FE "Total Net Enrollment Rate (TNER), Primary, Female"
  rename valueNERT_1_M_CP enrollment_TNER_MA
  label var enrollment_TNER_MA "Total Net Enrollment Rate (TNER), Primary, Male"

  * Net Enrollment
  rename valueNER_1_CP enrollment_NER_ALL
  label var enrollment_NER_ALL "Net Enrollment Rate (NER), Primary, Both Sexes"
  rename valueNER_1_F_CP enrollment_NER_FE
  label var enrollment_NER_FE "Net Enrollment Rate (NER), Primary, Female"
  rename valueNER_1_M_CP enrollment_NER_MA
  label var enrollment_NER_MA "Net Enrollment Rate (NER), Primary, Male"

  * Keep only relevant variables
  keep countrycode year enrollment_*

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*******************************
      Enrollment validated md
  *******************************/
  * Prepare local to create file
  local clonefile "enrollment_validated"

  * Import the md rawdata in the repo
  import delimited using "`input_dir'/`clonefile'.md", delimiter("|") varnames(1) clear

  * Corrections/problems that come with the md importing
  keep countrycode year suggested_enrollment decision
  drop if countrycode=="---"
  destring year, replace

  * Destring suggested enrollment after fixing string missing values
  replace suggested_enrollment = "" if suggested_enrollment == "NA"
  destring suggested_enrollment, replace

  * This line of code make sure that within a country there is only one type of decision
  by countrycode (decision), sort : gen same = (decision[1] == decision[_N])
  assert same == 1
  drop same

  * Keep countries that has a to-use value and then drop variable
  keep if decision == "use"
  drop decision

  * Standardize variable name
  rename    suggested_enrollment enrollment_VALID_ALL
  label var enrollment_VALID_ALL "Enrollment value validated by country team"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*************************************
    Primary Expenditure from WB Opendata
  *************************************/

  * Prepare local to create file
  local clonefile "primary_expenditure"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'_wbopendata.csv", varnames(1) case(preserve) clear

  * Rename and label variables used in the enrollment-method
  rename uis_xunit_pppconst_1 exp_pri_perstu_raw
  rename se_prm_enrr       gross_enrol_pri_raw
  label var gross_enrol_pri_raw   "School enrollment, primary (% gross)"
  label var exp_pri_perstu_raw   "Initial government funding per primary student, constant PPP$"

  * Rename and label variables used in the total-method
  rename uis_x_pppconst_1_fsg exp_pri_total_raw
  rename sp_prm_totl_in    children_pri_age
  label var exp_pri_total_raw   "Government expenditure on primary education, constant PPP$ (millions)"
  label var children_pri_age     "School age population, primary education, both sexes (number)"


  * Calculating Spending per child using the enrollment-method
  *   using per student primary expenditure multiplied with gross enrollment (setting Spending
  *   per child equal to per student expenditure if gross enrollement is higher than 100%)
  gen     exp_pri_perchild_enrol = exp_pri_perstu_raw * gross_enrol_pri_raw / 100
  replace exp_pri_perchild_enrol = exp_pri_perstu_raw if exp_pri_perchild_enrol > exp_pri_perstu_raw
  lab var exp_pri_perchild_enrol   "Spending per child, enrollment-method (per student spending * gross enrollment)"

  * Spending per child - using total expenditure and primary school age population
  * Calculating Spending per child using the total-method
  *   using total primary expediture divided by number of children in primary age (multiplied
  *   by 1,000,000 to go from millions of dollars to dollars)
  gen     exp_pri_perchild_total = 1000000 * exp_pri_total_raw / children_pri_age
  lab var exp_pri_perchild_total   "Spending per child, total-method (total spending / children primary age)"

  * Restore the sort order
  sort countrycode year

  * TODO DOUBLE CHECK IF THIS IS NEEDED HERE OR THIS ADJUSTMENT COULD SIT AT TWO PAGER TASK ONLY
  * Replace regional codes for prefered codes from a communication purpose
  replace region = "EAP" if region == "EAS"
  replace region = "ECA" if region == "ECS"
  replace region = "LAC" if region == "LCN"
  replace region = "MNA" if region == "MEA"
  replace region = "SAR" if region == "SAS"
  replace region = "SSA" if region == "SSF"

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*************************************
    HCI Indicators from WB Opendata
  *************************************/

  * Prepare local to create file
  local clonefile "hci_indicators"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'_wbopendata.csv", varnames(1) case(preserve) clear

  * Rename file names to convention used when creating the 2pagers
  rename hd_hci_lays_ma   LAYS_m
  rename hd_hci_lays_fe   LAYS_f
  rename hd_hci_lays      LAYS_mf
  rename hd_hci_eyrs_ma   ExpYS_m
  rename hd_hci_eyrs_fe   ExpYS_f
  rename hd_hci_eyrs      ExpYS_mf
  rename hd_hci_hlos_ma   HarmTS_m
  rename hd_hci_hlos_fe   HarmTS_f
  rename hd_hci_hlos      HarmTS_mf
  rename hd_hci_ovrl      HCI_mf
  rename hd_hci_ovrl_fe   HCI_f
  rename hd_hci_ovrl_ma   HCI_m


  * Make sure that there are only one obs per country
  isid countrycode

  * WB API is not up to date with most recent country names
  replace countryname = "North Macedonia" if countrycode == "MKD"

  * Restore the sort order
  sort countrycode year

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace


  /*************************************
    Poverty and GDP from WB Opendata
  *************************************/

  * Prepare local to create file
  local clonefile "poverty_gdp_indicators"

  * Open the raw csv with data
  import delimited using "`input_dir'/`clonefile'_wbopendata.csv", varnames(1) case(preserve) clear

  *Restore the sort order
  sort countrycode year

  * Compress and save in rawdata
  compress
  noi save "`output_dir'/`clonefile'.dta", replace



  * Display message to end this do file
  noi di as res "{phang}Concluded importing rawdata.{p_end}"

}
