*==============================================================================*
* 0122 SUBTASK: BRING PROFICIENCY DATA AND SAVE IN RAWDATA FOLDER
*==============================================================================*
qui {

  noi di _newline "{phang}Combining proficiency data...{p_end}"

  /*******************************
   Combining proficiency data into
          proficiency.dta
  *******************************/

  * Start with the proficiency from CLO/GLAD
  use "${clone}/01_data/011_rawdata/proficiency_from_GLAD.dta", clear

  * Append proficiency from NLAs/UIS
  append using "${clone}/01_data/011_rawdata/proficiency_from_NLA_md.dta"

  * Append proficiency from L4A rawlatest
  append using "${clone}/01_data/011_rawdata/proficiency_no_microdata.dta"

  order countrycode year idgrade test nla_code subject nonprof_all

  replace nla_code = "N.A." if missing(nla_code)

  * Variable to make it easier to add exceptions in rawlatest
  tostring year, gen(year_str)
  gen str surveyid = countrycode + "_" + year_str + "_" + test
  label var surveyid "SurveyID (countrycode_year_assessment)"

  * Add metadata on used MPL (minimum proficiency threshold)
  * COULD BE IN GLAD REPO SO CSV COMES WITH NAMES AND METADATA already (TODO!)
  replace min_proficiency_threshold = "III (SERCE scale)" if test=="LLECE"
  replace min_proficiency_threshold = "4"                 if test=="PASEC"
  replace min_proficiency_threshold = "Low (400 points)"  if test=="PIRLS"
  replace min_proficiency_threshold = "Low (400 points)"  if test=="TIMSS"
  replace min_proficiency_threshold = "Not in use"        if test=="SACMEQ"
  replace min_proficiency_threshold = "10"                if test=="NLA" & nla_code=="AFG_2"
  replace min_proficiency_threshold = "Moderate"          if test=="NLA" & nla_code=="CHN"
  replace min_proficiency_threshold = "Proficient"        if test=="NLA" & nla_code=="BGD_3"
  replace min_proficiency_threshold = "Intermediate"      if test=="NLA" & nla_code=="IND_4"
  replace min_proficiency_threshold = "Score"             if test=="NLA" & nla_code=="UGA_1"
  replace min_proficiency_threshold = "Advanced"          if test=="NLA" & nla_code=="UGA_2"
  replace min_proficiency_threshold = "Proficient"        if test=="NLA" & nla_code=="PAK_3"
  replace min_proficiency_threshold = "Score above 40 mark"  if test=="NLA" & nla_code=="LKA_3"
  replace min_proficiency_threshold = "Acceptable"        if test=="NLA" & nla_code=="VNM_1"
  replace min_proficiency_threshold = "Basic"             if test=="NLA" & nla_code=="ETH_1"
  replace min_proficiency_threshold = "Score"             if test=="NLA" & nla_code=="ETH_2"
  replace min_proficiency_threshold = "Proficient"        if test=="NLA" & nla_code=="ETH_3"
  replace min_proficiency_threshold = "4"                 if test=="NLA" & nla_code=="COD"
  replace min_proficiency_threshold = "Proficient (level 3)" if test=="NLA" & nla_code=="KHM_1"
  replace min_proficiency_threshold = "D"                 if test=="NLA" & nla_code=="MYS_1"
  replace min_proficiency_threshold = "1 (6-11 points)"   if test=="NLA" & nla_code=="ALB_1"
  replace min_proficiency_threshold = "Basic"             if test=="NLA" & nla_code=="KGZ_1"
  replace min_proficiency_threshold = "Minimum Competency"   if test=="NLA" & nla_code=="GHA_1"
  label var min_proficiency_threshold "Minimum Proficiency Threshold (assessment-specific)"

  * Compress and save
  compress
  noi disp "{phang}Saving file: ${clone}/01_data/013_outputs/proficiency.dta{p_end}"
  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
    local description "Dataset of proficiency. One country may have multiple or no observations at all. Long on specific measures in time (that is, assessment year grade subject country) and wide in subgroups (all, male, female)."
    local sources "Compilation of proficiency measures from 3 sources: CLO (Country Level Outcomes from GLAD), National Learning Assessment (from UIS), HAD (Harmonized Assessment Database)"
    edukit_save, filename(proficiency) path("${clone}/01_data/013_outputs/") ///
                 idvars(countrycode year idgrade test nla_code subject)      ///
                 varc("value *nonprof* fgt*; trait *threshold source_assessment surveyid") ///
                 metadata("description `description'; sources `sources'; filename Proficiency")
  }
  else save "${clone}/01_data/013_outputs/proficiency.dta", replace

}
