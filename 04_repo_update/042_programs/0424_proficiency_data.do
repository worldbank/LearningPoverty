*==============================================================================*
* 0424 SUBTASK: PREPARE PROFICIENCY CSVS TO UPDATE THE 011_RAWDATA IN REPO
*==============================================================================*
qui {


  /***********************************
      Proficiency from NLA md
  ***********************************/
  noi di _newline "{phang}Proficiency from NLA markdown {p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/proficiency_from_NLA_md.csv"

  * Import the rawdata in the repo
  import delimited "${clone}/04_repo_update/041_rawdata/national_assessment_proficiency.md", delimiter("|") varnames(1) clear

  * Corrections/problmes that come with the md importing
  keep wbcode-status
  drop if _n==1
  destring year, replace
  destring idgrade, replace
  destring pct_reading_low_target_wb_v pct_read_low_fe pct_read_low_ma, replace
  drop if status != "Accepted"

  * Parsing out countrycode from NLA table (ie: BGD_1 or BGD_2 into BGD)
  gen nla_code = wbcode
  split wbcode, p("_")
  gen countrycode = wbcode1
  rename source nla_source
  replace nla_source = nla_source + ";" + cutoff

  * From percentage of proficient students to below proficiency
  gen nonprof_all = 100 - pct_reading_low_target_wb_v
  gen nonprof_fe  = 100 - pct_read_low_fe
  gen nonprof_ma  = 100 - pct_read_low_ma

  * Only relevant variables kept
  keep countrycode year idgrade nonprof_* nla_code

  * Copy the file from network to csv folder
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"



/*
  /***********************************
      Proficiency from L4A RAWFULL
  ***********************************/
  noi di _newline "{phang}Proficiency from L4A rawfull (quick fix){p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/proficiency_no_microdata.csv"

  * This section: on-the-fly attempt to enrich rawfull in LP based on rawfull in L4A
  * by appending any missing proficiency data points
  * TODO: revise, make it unnecessary, less crappy!!! PLACEHOLDER!!!

  * Start with rawfull in MY L4A clone **** THIS IS WHERE THE DANGER LIVES
  cap use "C:\Users\WB552057\Documents\Github\Learning4all\01_data\013_outputs\rawfull.dta", clear

  * If L4A could be opened, extract info from it
  if _rc == 0 {
  
    * Keep only proficiency-related variables
    local vars_to_keep "countrycode idgrade test nlacode subject threshold pct_reading_low pct_reading_low_doubl pct_reading_low_target nonprof assessment_cutoff year_assessment source_assessment"
    keep `vars_to_keep'

    * Keep threshold III (only one supported in LP) and non-missing proficiency obs
    keep if threshold == "III"
    drop threshold
    drop if test == "no assessment"

    * Drop duplicate obs, due to the L4A rawlatest being LONG on enrollment (the LP is WIDE on enrollment)
    duplicates drop

    * The pct variables are very confusing...
    * It seems that the only one in use is pct_reading_low_target, which is 1-nonprof
    drop pct_reading*

    * In LP, we use read for reading
    replace subject = "read" if subject == "reading"



    * Plus other attempts to reconcile LP and L4A
    rename  nlacode nla_code
    replace nla_code = "N.A." if nla_code=="-99"
    rename  nonprof nonprof_all
    rename  assessment_cutoff min_proficiency_threshold
    rename  year_assessment year
    replace source_assessment = "HAD (Harmonized Assessment Database)"
*/

    //* Saving to compare_files in proficiency, not needed in this task
    //save "${clone}/04_repo_update/043_outputs/proficiency_in_L4A_rawfull.dta", replace

    * Only keep what we don't have in GLAD/CLOs:
    * - SACMEQ from 2013 (we have Excel only, no microdata)
    * - PASEC before 2014 (only the 2014 was harmonized in GLAD)
    * - EGRA's didnt make it to GLAD yet
*    keep if (test=="PASEC" & year < 2014) | (test=="SACMEQ" & year == 2013) | (test=="EGRA")

/*
    * Export csv
    export delimited using "`clonefile'", replace
    noi di "{phang}Saved `clonefile'{p_end}"
 
  }

*/


/*
  else {
    noi di as error "{phang}Could not update `clonefile' (L4A rawfull not available){p_end}"
  }
*/



  /***********************************
      Proficiency from GLAD_CLO
  ***********************************/

if $network_is_available {

  noi di _newline "{phang}Proficiency from Country Level Outcomes of GLAD{p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/proficiency_from_GLAD.csv"

  * If getting the files from the network, the path is
  local networkfile "${network}/Projects/WLD_2023_FGT-CLO/clo_fgt_learning.dta"

  * Open the file
  use "`networkfile'", clear

  * List of needed CLO for Learning Poverty (only those for which we have microdata)
  local lp_clos "LAC_2006_LLECE LAC_2013_LLECE SSA_2000_SACMEQ SSA_2007_SACMEQ SSA_2014_PASEC SSA_2019_PASEC WLD_2001_PIRLS WLD_2006_PIRLS WLD_2011_PIRLS WLD_2016_PIRLS WLD_2003_TIMSS WLD_2007_TIMSS WLD_2011_TIMSS WLD_2015_TIMSS WLD_2019_TIMSS EAP_2019_SEA-PLM SSA_2021_AMPLB  WLD_2021_PIRLS"

  * Check that it contains all the CLO of all surveys required for LP
  levelsof survey, local(clos_in_networkfile)
  local missing_clos : list lp_clos - clos_in_networkfile
  if  "`missing_clos'" != "" noi disp as error _n "Could not find some CLO needed for Learning Poverty in the network file (`missing_clos')"

  * Simplifies and prepare-wide to be ready for L4A
  *-----------------------------------------------------------------------------

  * Name that is worse but we had used already
	gen str test = assessment
	drop assessment

  * Only valuevar needed in L4A is harmonized proficiency (hpro)
  local idvars  "countrycode year test idgrade subgroup"
  keep `idvars' *bmp* *_fgt1_* *_fgt2_*

  * Though urban breakdown is calculated in clo, not relevant for L4A
  keep if inlist(subgroup,"all", "male=0","male=1")

  * Use the same subgroup naming convention as wbopendata
  replace subgroup = "_all" if subgroup == "all"
  replace subgroup = "_fe"  if subgroup == "male=0"
  replace subgroup = "_ma"  if subgroup == "male=1"

  * From harmonized_ proficiency to non-proficiency and from share to percentage
  unab subjects : m_bmp_*
  local subjects = subinstr("`subjects'" , "m_bmp_" , "" , .)
  foreach subject of local subjects {
    gen nonprof`subject'    = 100 * (m_bmp_`subject')
    gen se_nonprof`subject' = 100 * (se_bmp_`subject')
    clonevar fgt1`subject' = m_fgt1_`subject'
    clonevar fgt2`subject' = m_fgt2_`subject'
    drop m_*_`subject' se_*_`subject' n_*_`subject'
  }

  * Prepare for bringing into LearningPoverty rawlatest:
  * Reshape long on subject (read, math, science)
  reshape long nonprof se_nonprof fgt1 fgt2, i(countrycode test year idgrade subgroup) j(subject) string
  * Reshape wide on subgroups
  reshape wide nonprof se_nonprof fgt1 fgt2, i(countrycode test year idgrade subject) j(subgroup) string

  * Drop observations with all nonprof values (_all, _fe, _ma) missing
  missings dropobs nonprof_*, force

  * keep only relevant IDGRADES (only End of Primary Grades included, except 3 PIRLS from 3rd Grade)
  keep if idgrade >= 3 & idgrade <= 6

  * drop MATH results from SEA-PLM and PASEC
  drop if subject == "math" & test == "SEA-PLM"
  drop if subject == "math" & test == "PASEC"
  drop if subject == "math" & test == "AMPLB"
  drop if subject == "math" & test == "LLECE"
  
  * Beautify: format, order and label
  order countrycode year test idgrade subject *nonprof_all *nonprof_ma *nonprof_fe fgt1* fgt2*
  sort  countrycode year test idgrade subject

  * Export CSV with proficiency
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"

}

else {
  noi di as error "{phang}Could not update `clonefile' (network not available){p_end}"
}

}