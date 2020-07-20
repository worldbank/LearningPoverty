*==============================================================================*
* 0524 SUBTASK: Relationship between Learning Poveryt BMP and Early Grade
*==============================================================================*
qui {

  *-----------------------------------------------------------------------------
  local outputs   "${clone}/05_working_paper/053_outputs"
  local rawdata   "${clone}/05_working_paper/051_rawdata"
  local overwrite_csv = 0 // Change here to download new data even if csv already in clone
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * Check for a pre-existing frozen version in the clone
  cap confirm file "`rawdata'/clo_learning_early_end_grades.csv"

  * If the frozen version is not found or forced to overwrite with a fresh query
  if (_rc | `overwrite_csv') {

    * pulling data from the HISTORICAL Data folder in NETWORK
    use "//wbgfscifs01/GEDEDU/GDB/Projects/WLD_2020_FGT-CLO/clo_fgt_learning.dta", clear

    keep if assessment == "LLECE" | assessment == "PASEC"

    keep survey- se_hpro_read n_total n_male n_urban n_score_pasec_read- se_score_pasec_math

    rename n_total total
    rename n_male  male
    rename n_urban urban

    gen m_fgt0_read  = 1 - m_hpro_read
    gen n_fgt0_read  = n_hpro_read
    gen se_fgt0_read = se_hpro_read

    reshape long n_ m_ se_ , i(survey region year assessment countrycode idgrade subgroup total male urban ) j(type) string

    gen     level = "early" if idgrade <  6
    replace level = "end"   if idgrade == 6

    drop idgrade
    drop if m_ == .
    drop survey region assessment

    reshape wide n_ m_ se_ , i(year countrycode subgroup total male urban type) j(level) string

    gen subject = word(subinstr(type,"_"," ",.),-1)
    gen indicator = word(subinstr(type,"_"," ",.),1)

    sort year countrycode subgroup subject m_early

    bysort year countrycode subgroup subject : replace n_early = n_early[1]   if n_early == . & n_early[1] != .
    bysort year countrycode subgroup subject : replace m_early = m_early[1]   if m_early == . & m_early[1] != .
    bysort year countrycode subgroup subject : replace se_early = se_early[1] if se_early == . & se_early[1] != .

    drop n_* se_* type

    * save CLO dataset
    export delimited "`rawdata'/clo_learning_early_end_grades.csv", replace

  }

  * If not creating a new csv, simply imports existing csv into a dta
  else {
    import delimited "`rawdata'/clo_learning_early_end_grades.csv", clear
  }


  *-------------------------------------------------------------------------------
  * use CLO dataset

  ** Metadata
  merge m:1 countrycode using "${clone}/01_data/011_rawdata/country_metadata.dta", keep(match) nogen

  corr m_end m_early if subject == "read" & indicator == "hpro" & subgroup == "all"

  bysort region: corr m_end m_early if indicator == "hpro" & subgroup == "all"
  bysort region: corr m_end m_early if indicator == "fgt0" & subgroup == "all"
  bysort region: corr m_end m_early if indicator == "fgt1" & subgroup == "all"
  bysort region: corr m_end m_early if indicator == "fgt2" & subgroup == "all"
  bysort region: corr m_end m_early if indicator == "score" & subgroup == "all"

  replace m_end = m_end * 100 if indicator != "score"

  *-------------------------------------------------------------------------------
  * set up output matrix

  preserve

    mat drop _all

    *-------------------------------------------------------------------------------
    * Latin America (LLECE)
    tabstat m_early m_end if indicator != "hpro" & m_end != . & region == "LCN" & subject == "read"  & subgroup == "all", ///
      by(indicator) stat(mean n) nototal save


    foreach l in 4 1 2 3  {
      local name`l' = r(name`l')
      mat lcn = nullmat(lcn)\r(Stat`l')
    }

    foreach l in 4 1 2 3  {
      corr  m_end m_early  if indicator == "`name`l''" & m_end != . & region == "LCN" & subject == "read"  & subgroup == "all"
      mat lcn_rho = nullmat(lcn_rho)\r(rho)\.
    }

    mat lcn = lcn, lcn_rho

    *-------------------------------------------------------------------------------
    * Africa (PASEC)
    tabstat m_early m_end if indicator != "hpro" & m_end != . & region == "SSF" & subject == "read"  & subgroup == "all", ///
      by(indicator) stat(mean n) nototal save


    foreach l in 4 1 2 3  {
      local name`l' = r(name`l')
      mat ssf = nullmat(ssf)\r(Stat`l')
    }

    foreach l in 4 1 2 3  {
      corr  m_end m_early  if indicator == "`name`l''" & m_end != . & region == "SSF" & subject == "read"  & subgroup == "all"
      mat ssf_rho = nullmat(ssf_rho)\r(rho) \.
    }

    mat ssf = ssf, ssf_rho


    *-------------------------------------------------------------------------------
    * Africa (PASEC) NO BURUNDI
    tabstat m_early m_end if indicator != "hpro" & m_end != . & region == "SSF" ///
      & subject == "read"  & subgroup == "all" & countryname != "Burundi", ///
      by(indicator) stat(mean n) nototal save


    foreach l in 4 1 2 3  {
      local name`l' = r(name`l')
      mat ssf2 = nullmat(ssf2)\r(Stat`l')
    }

    foreach l in 4 1 2 3  {
      corr  m_end m_early  if indicator == "`name`l''" & m_end != . & region == "SSF" ///
        & subject == "read"  & subgroup == "all" & countryname != "Burundi"
      mat ssf2_rho = nullmat(ssf2_rho)\r(rho) \.
    }

    mat ssf2 = ssf2, ssf2_rho

    *-------------------------------------------------------------------------------

    mat final = lcn \ ssf \ ssf2


    ***-----------------------------------------------------------------------------
    *** Table XXXX

    drop _all
    svmat final

    rename final1 Early_Grade
    rename final2 End_Primary
    rename final3 rho

    save "`outputs'/rho-BMP-early-end.dta", replace

  restore

  ***-----------------------------------------------------------------------------

  preserve

    keep if region == "SSF"
    keep if subgroup == "all"
    drop if indicator == "hpro"
    drop if m_end == .

    reshape wide m_early  m_end  , i(countryname subject) j(indicator) string
    reshape wide m_early* m_end* , i(countryname) j(subject) string

    sort countryname
    drop m_earlyfgt0math m_endfgt0math m_earlyfgt1math m_endfgt1math m_earlyfgt2math m_endfgt2math

    order countryname m_earlyscoreread m_endscoreread m_earlyscoremath m_endscoremath m_endfgt0read m_endfgt1read m_endfgt2read
    keep  countryname m_earlyscoreread m_endscoreread m_earlyscoremath m_endscoremath m_endfgt0read m_endfgt1read m_endfgt2read

    egen score_read_early = rank(m_earlyscoreread*-1 )
    egen score_read_end = rank(m_endscoreread*-1 )
    egen score_math_early = rank(m_earlyscoremath*-1 )
    egen score_math_end = rank(m_endscoremath*-1 )
    egen fgt0_read_end = rank(m_endfgt0read )
    egen fgt1_read_end = rank(m_endfgt1read )
    egen fgt2_read_end = rank(m_endfgt2read)

    save "`outputs'/pasec-rank-early-end.dta", replace

  restore



  ***-----------------------------------------------------------------------------
  * Figure 2

  keep if indicator != "hpro" & m_end != . & subject == "read"  & subgroup == "all"

  order region countrycode countryname year m_early m_end subject indicator
  keep  region countrycode countryname year m_early m_end subject indicator

  gen flag = 1 if countryname == "Burundi"

  sort subject  indicator region flag countrycode countryname m_early m_end

  save "`outputs'/earlygrade-lp-by-country.dta", replace

  noi disp as res _n "Finished runing early grade validation (LLECE & PASEC)"
}
