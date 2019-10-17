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
  destring pct_reading_low_target_wb_v, replace

  * Parsing out countrycode from NLA table (ie: BGD_1 or BGD_2 into BGD)
  gen nla_code = wbcode
  split wbcode, p("_")
  gen countrycode = wbcode1
  rename source nla_source
  replace nla_source = nla_source + ";" + cutoff

  * From percentage of proficient students to below proficiency
  gen nonprof_all = 100 - pct_reading_low_target_wb_v

  * Only relevant variables kept
  keep countrycode year idgrade nonprof_all nla_code

  * Copy the file from network to csv folder
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"


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

    //* Saving to compare_files in proficiency, not needed in this task
    //save "${clone}/04_repo_update/043_outputs/proficiency_in_L4A_rawfull.dta", replace

    * Only keep what we don't have in GLAD/CLOs:
    * - SACMEQ from 2013 (we have Excel only, no microdata)
    * - PASEC before 2014 (only the 2014 was harmonized in GLAD)
    * - EGRA's didnt make it to GLAD yet
    keep if (test=="PASEC" & year < 2014) | (test=="SACMEQ" & year == 2013) | (test=="EGRA")

    * Export csv
    export delimited using "`clonefile'", replace
    noi di "{phang}Saved `clonefile'{p_end}"
  }

  else {
    noi di as error "{phang}Could not update `clonefile' (L4A rawfull not available){p_end}"
  }


  /***********************************
      Proficiency from GLAD_CLO
  ***********************************/

  * TODO / PLACHOLDER: only attempts to run this if which datalibweb not error

  noi di _newline "{phang}Proficiency from Country Level Outcomes of GLAD{p_end}"

  * Prepare local to create file
  local clonefile "${clone}/04_repo_update/043_outputs/proficiency_from_GLAD.csv"

  * List of needed CLO for Learning4All (only those for which we have microdata)
  local l4a_clos "LAC_2006_LLECE LAC_2013_LLECE SSA_2000_SACMEQ SSA_2007_SACMEQ SSA_2014_PASEC WLD_2001_PIRLS WLD_2006_PIRLS WLD_2011_PIRLS WLD_2016_PIRLS WLD_2003_TIMSS WLD_2007_TIMSS WLD_2011_TIMSS WLD_2015_TIMSS"

  * Creates an empty file where all CLOs will be appended
  touch "${clone}/04_repo_update/043_outputs/l4a_country_level_outcomes.dta", replace

  * Loop through each CLO file, read metadata and append and save
  foreach survey of local l4a_clos {

    * Parsing region year and assessment to query this CLO in datalibweb
    gettoken region aux_token : survey,    parse("_")
    gettoken trash  aux_token : aux_token, parse("_")
    gettoken year   aux_token : aux_token, parse("_")
    gettoken trash  test      : aux_token, parse("_")

    local ending   = "v01_M_wrk_A_GLAD_CLO.dta"
    local surveyid = "`survey'_v01_M"
    local clo_file = "`survey'_`ending'"

    * Query datalibweb
    datalibweb, country(`region') year(`year') type(GLAD) surveyid(`surveyid') filename(`clo_file')

    * Append this CLO info in the destination file
    append using "${clone}/04_repo_update/043_outputs/l4a_country_level_outcomes.dta"
    save "${clone}/04_repo_update/043_outputs/l4a_country_level_outcomes.dta", replace

  }


  * Simplifies and prepare-wide to be ready for L4A
  *-----------------------------------------------------------------------------

  * Only valuevar needed in L4A is harmonized proficiency (hpro)
  local idvars  "countrycode year test idgrade subgroup"
  keep `idvars' *hpro*

  * Though urban breakdown is calculated in clo, not relevant for L4A
  keep if inlist(subgroup,"all", "male=0","male=1")

  * Use the same subgroup naming convention as wbopendata
  replace subgroup = "_all" if subgroup == "all"
  replace subgroup = "_fe"  if subgroup == "male=0"
  replace subgroup = "_ma"  if subgroup == "male=1"

  * From harmonized_ proficiency to non-proficiency and from share to percentage
  unab subjects : m_hpro_*
  local subjects = subinstr("`subjects'" , "m_hpro_" , "" , .)
  foreach subject of local subjects {
    gen nonprof`subject'    = 100 * (1 - m_hpro_`subject')
    gen se_nonprof`subject' = 100 * (se_hpro_`subject')
    drop m_hpro_`subject' se_hpro_`subject' n_hpro_`subject'
  }

  * Prepare for bringing into LearningPoverty rawlatest:
  * Reshape long on subject (read, math, science)
  reshape long nonprof se_nonprof, i(countrycode test year idgrade subgroup) j(subject) string
  * Reshape wide on subgroups
  reshape wide nonprof se_nonprof, i(countrycode test year idgrade subject) j(subgroup) string

  * Drop observations with all nonprof values (_all, _fe, _ma) missing
  missings dropobs nonprof_*, force

  * Beautify: format, order and label
  order countrycode year test idgrade subject *nonprof_all *nonprof_ma *nonprof_fe
  sort countrycode year test idgrade

  * Export CSV with proficiency
  export delimited using "`clonefile'", replace
  noi di "{phang}Saved `clonefile'{p_end}"

}
