*==============================================================================*
* 0522 SUBTASK: CORRELATIONS BETWEEN ASSESSMENTS AND SUBJECTS
*==============================================================================*
qui {

  * Opens several microdata from assessments to check correlations

  * Since this microdata depends on being able to access datalibweb and
  * takes a long time to load, it will by default use the "frozen" csv
  * saved in the repository. This code is just a "recipe" of how the csv
  * was obtained, and may be used to update it (if the user can access dlw)

  local overwrite_csv = 0 // Change here to download new data even if csv already in clone

  * If overwrite_csv is not specified will just import this very short results csv
  if `overwrite_csv' != 1 {
    import delimited "${clone}/05_working_paper/053_outputs/assessment_correlations.csv", clear
    save "${clone}/05_working_paper/053_outputs/assessment_correlations.dta", replace
    exit
  }

  * This time-consuming section only runs if overwrite_csv == 1
  * and will save intermediate files to attempt to shortcut further

  *---------------------------------------------------------------------------
  * PIRLS reading and TIMSS math/science. Country level.
  *---------------------------------------------------------------------------
  cap confirm file "${clone}/05_working_paper/053_outputs/assessment_correlations_timss.dta"
  if _rc != 0 {

    * Open CLO of latest PIRLS
    cap dlw, coun(WLD) y(2016) t(GLAD) mod(CLO) verm(01) vera(01) sur(PIRLS)
    keep if subgroup == "all" & idgrade == 4
    gen bmp_pirls = 1 - m_hpro_read
    keep countrycode m_score_* bmp_pirls
    tempfile pirls
    save `pirls', replace

    * Open CLO of latest TIMSS
    cap dlw, coun(WLD) y(2015) t(GLAD) mod(CLO) verm(01) vera(01) sur(TIMSS)
    keep if subgroup == "all" & idgrade == 4
    * From pdf to cdf on the levels
    foreach subject in math science {
      gen bmp_l1_timss_`subject' = m_d1level_timss_`subject'
      gen bmp_l2_timss_`subject' = bmp_l1_timss_`subject' + m_d2level_timss_`subject'
      gen bmp_l3_timss_`subject' = bmp_l2_timss_`subject' + m_d3level_timss_`subject'
      gen bmp_l4_timss_`subject' = bmp_l3_timss_`subject' + m_d4level_timss_`subject'
    }
    keep countrycode m_score_* bmp_*

    * Combine both info
    merge 1:1 countrycode using `pirls', keep(match) nogen
    correl m_score_pirls_read m_score_timss_math
    local r_timss_math_country = `r(rho)'
    correl m_score_pirls_read m_score_timss_science
    local r_timss_science_country = `r(rho)'

    * Info that is not making into the table but we also care about (levels)
    noi correl bmp_pirls bmp_l?_timss_*
    matrix C = r(C)
    clear
    svmat C
    keep C1
    gen description = "correl_bmp_pirls_low_"
    replace description = description + "bmp_pirls_low"        if _n == 1
    replace description = description + "bmp_l1_timss_math"    if _n == 2
    replace description = description + "bmp_l2_timss_math"    if _n == 3
    replace description = description + "bmp_l3_timss_math"    if _n == 4
    replace description = description + "bmp_l4_timss_math"    if _n == 5
    replace description = description + "bmp_l1_timss_science" if _n == 6
    replace description = description + "bmp_l2_timss_science" if _n == 7
    replace description = description + "bmp_l3_timss_science" if _n == 8
    replace description = description + "bmp_l4_timss_science" if _n == 9
    rename C1 value
    save "${clone}/05_working_paper/053_outputs/assessment_correlations_timsslevel.dta", replace

    * Put numbers into the dataset
    clear
    set obs 2
    generate assessment = "TIMSS 4th grade"
    generate subject    = "math"    if _n == 1
    replace  subject    = "science" if _n == 2
    generate r_country  = `r_timss_math_country'     if _n == 1
    replace  r_country  = `r_timss_science_country'  if _n == 2

    save "${clone}/05_working_paper/053_outputs/assessment_correlations_timss.dta", replace
    noi disp as result "Done with TIMSS"
  }

  else noi disp as txt "Skipped the TIMSS correlations (already found in clone)"


  *---------------------------------------------------------------------------
  * LLECE reading and math/science. Country, school and student level.
  *---------------------------------------------------------------------------
  cap confirm file "${clone}/05_working_paper/053_outputs/assessment_correlations_llece.dta"
  if _rc != 0 {

    * Open CLO of latest LLECE
    cap dlw, coun(LAC) y(2013) t(GLAD) mod(CLO) verm(01) vera(01) sur(LLECE)
    keep if subgroup == "all" & idgrade == 6
    correl m_score_llece_read m_score_llece_math
    local  r_llece_math_country = `r(rho)'
    correl m_score_llece_read m_score_llece_science
    local  r_llece_science_country = `r(rho)'

    * Open GLAD of latest LLECE
    cap dlw, coun(LAC) y(2013) t(GLAD) mod(ALL) verm(01) vera(01) sur(LLECE)
    keep if idgrade == 6
    correl score_llece_read score_llece_math [aw = learner_weight_read]
    local r_llece_math_student = `r(rho)'
    correl score_llece_read score_llece_science [aw = learner_weight_read]
    local r_llece_science_student = `r(rho)'

    * School level correlations
    collapse (mean) score_llece_* [aw = learner_weight_quest], by(idschool idgrade)
    correl score_llece_read score_llece_math
    local r_llece_math_school = `r(rho)'
    correl score_llece_read score_llece_science
    local r_llece_science_school = `r(rho)'

    * Put numbers into the dataset
    clear
    set obs 2
    gen     assessment = "LLECE 6th grade"
    gen     subject    = "math"                    if _n == 1
    replace subject    = "science"                 if _n == 2
    gen     r_country  = `r_llece_math_country'    if _n == 1
    replace r_country  = `r_llece_science_country' if _n == 2
    gen     r_school   = `r_llece_math_school'     if _n == 1
    replace r_school   = `r_llece_science_school'  if _n == 2
    gen     r_student  = `r_llece_math_student'    if _n == 1
    replace r_student  = `r_llece_science_student' if _n == 2

    save "${clone}/05_working_paper/053_outputs/assessment_correlations_llece.dta", replace
    noi disp as result "Done with LLECE"
  }

  else noi disp as txt "Skipped the LLECE correlations (already found in clone)"


  *---------------------------------------------------------------------------
  * PISA-D reading and math/science. Country, school and student level.
  *---------------------------------------------------------------------------
  cap confirm file "${clone}/05_working_paper/053_outputs/assessment_correlations_pisad.dta"
  if _rc != 0 {

    * Open EDURAW of PISA-D
    cap dlw, country(WLD) year(2017) type(EDURAW) surveyid(WLD_2017_PISA-D_v01_M) filename(CY1MDAI_STU_QQQ.dta)
    rename *, lower

    * Student level correlations
    repest PISA, estimate(corr pv@read pv@math pv@scie)
    matrix b = e(b)
    local  r_pisad_math_student    = b[1,1]
    local  r_pisad_science_student = b[1,2]

    * Country level aggregations
    cap confirm file "${clone}/05_working_paper/053_outputs/pisad_cnt.dta"
    if _rc != 0 repest PISA, estimate(means pv@math pv@read pv@scie) by(cnt) outfile("${clone}/05_working_paper/053_outputs/pisad_cnt.dta")

    * School level aggregations
    cap confirm file "${clone}/05_working_paper/053_outputs/pisad_cntschid.dta"
    if _rc != 0 repest PISA, estimate(means pv@math pv@read pv@scie) by(cntschid) outfile("${clone}/05_working_paper/053_outputs/pisad_cntschid.dta")

    * School level correlations
    use "${clone}/05_working_paper/053_outputs/pisad_cntschid.dta", clear
    correl pv_math_m_b pv_read_m_b
    local r_pisad_math_school = `r(rho)'
    correl pv_scie_m_b pv_read_m_b
    local r_pisad_science_school = `r(rho)'

    * Country level correlations
    use "${clone}/05_working_paper/053_outputs/pisad_cnt", clear
    correl pv_math_m_b pv_read_m_b
    local r_pisad_math_country = `r(rho)'
    correl pv_scie_m_b pv_read_m_b
    local r_pisad_science_country = `r(rho)'


    * Put numbers into the dataset
    clear
    set obs 2
    gen     assessment = "PISA-D 15 years-old"
    gen     subject    = "math"                     if _n == 1
    replace subject    = "science"                  if _n == 2
    gen     r_country  = `r_pisad_math_country'     if _n == 1
    replace r_country  = `r_pisad_science_country'  if _n == 2
    gen     r_school   = `r_pisad_math_school'      if _n == 1
    replace r_school   = `r_pisad_science_school'   if _n == 2
    gen     r_student  = `r_pisad_math_student'     if _n == 1
    replace r_student  = `r_pisad_science_student'  if _n == 2

    save "${clone}/05_working_paper/053_outputs/assessment_correlations_pisad.dta", replace
    noi disp as result "Done with PISA-D"
  }

  else noi disp as txt "Skipped the PISA-D correlations (already found in clone)"


  *---------------------------------------------------------------------------
  * PISA reading and math/science. Country, school and student level.
  *---------------------------------------------------------------------------
  cap confirm file "${clone}/05_working_paper/053_outputs/assessment_correlations_pisa.dta"
  if _rc != 0 {

    * Open GLAD of latest PISA
    cap dlw, coun(WLD) y(2018) type(GLAD) mod(ALL) verm(01) vera(01) sur(PISA)

    * Rename variables as they are in the RAW data, to be able to use REPEST
    * Alternatively, could load EDURAW, but dlw can't handle its size (>1Gb).
    rename (countrycode idschool learner_weight) (cnt cntschid w_fstuwt)
    forvalues i=1/80 {
      rename weight_replicate`i' w_fsturwt`i'
    }
    foreach subject in read math science {
      local subj = substr("`subject'", 1, 4)
      forvalues i=1/9 {
        rename score_pisa_`subject'_0`i' pv`i'`subj'
      }
      rename score_pisa_`subject'_10 pv10`subj'
    }

    * (Non-restricted) Student level correlations
    repest PISA, estimate(corr pv@read pv@math pv@scie)
    matrix b = e(b)
    local  r_pisa_math_student    = b[1,1]
    local  r_pisa_science_student = b[1,2]

    * See alternative analysis of PISA at the very end of this do-file
    * restricted only to booklets that had the two subjects being correlated

    * Country level aggregations
    cap confirm file "${clone}/05_working_paper/053_outputs/pisa_cnt.dta"
    if _rc != 0 repest PISA, estimate(means pv@math pv@read pv@scie) by(cnt) outfile("${clone}/05_working_paper/053_outputs/pisa_cnt.dta")

    * School level aggregations
    cap confirm file "${clone}/05_working_paper/053_outputs/pisa_cntschid.dta"
    if _rc != 0 repest PISA, estimate(means pv@math pv@read pv@scie) by(cntschid) outfile("${clone}/05_working_paper/053_outputs/pisa_cntschid.dta")

    * School level correlations
    use "${clone}/05_working_paper/053_outputs/pisa_cntschid.dta", clear
    correl pv_math_m_b pv_read_m_b
    local r_pisa_math_school = `r(rho)'
    correl pv_scie_m_b pv_read_m_b
    local r_pisa_science_school = `r(rho)'

    * Country level correlations
    use "${clone}/05_working_paper/053_outputs/pisa_cnt", clear
    correl pv_math_m_b pv_read_m_b
    local r_pisa_math_country = `r(rho)'
    correl pv_scie_m_b pv_read_m_b
    local r_pisa_science_country = `r(rho)'

    * Put numbers into the dataset
    clear
    set obs 2
    gen     assessment = "PISA 15 years-old"
    gen     subject    = "math"                    if _n == 1
    replace subject    = "science"                 if _n == 2
    gen     r_country  = `r_pisa_math_country'     if _n == 1
    replace r_country  = `r_pisa_science_country'  if _n == 2
    gen     r_school   = `r_pisa_math_school'      if _n == 1
    replace r_school   = `r_pisa_science_school'   if _n == 2
    gen     r_student  = `r_pisa_math_student'     if _n == 1
    replace r_student  = `r_pisa_science_student'  if _n == 2

    save "${clone}/05_working_paper/053_outputs/assessment_correlations_pisa.dta", replace
    noi disp as result "Done with PISA"
  }

  else noi disp as txt "Skipped the PISA correlations (already found in clone)"


  *---------------------------------------------------------------------------
  * SAEB reading and math. Municipality, school and student level.
  *---------------------------------------------------------------------------
  cap confirm file "${clone}/05_working_paper/053_outputs/assessment_correlations_brazil.dta"
  if _rc != 0 {

    * This data is not in datalibweb, rather in another repo
    capture whereis github
    if _rc == 0 {

      local SAEB_2017_microdata "`r(github)'/LearningPoverty-Brazil/02_rawdata/INEP_SAEB/Downloads/SAEB_ALUNO_2017.dta"

      * Open micro data from Prova Brasil SAEB 2017
      capture use "`SAEB_2017_microdata'", clear
      if _rc == 0 {

        * Discard the 0.5% of children out of EMIS that don't make it into official numbers
        keep if in_situacao_censo == 1

        * Student level correlations
        correl score_lp score_mt [aw = learner_weight_lp] if idgrade == 5
        local r_saeb5_student = `r(rho)'
        correl score_lp score_mt [aw = learner_weight_lp] if idgrade == 9
        local r_saeb9_student = `r(rho)'

        * School level correlations
        preserve
          collapse (mean) score_lp score_mt [aw = learner_weight_lp], by(idschool idgrade)
          correl score_lp score_mt if idgrade == 5
          local r_saeb5_school = `r(rho)'
          correl score_lp score_mt if idgrade == 9
          local r_saeb9_school = `r(rho)'
        restore

        * County level correlations
        collapse (mean) score_lp score_mt [aw = learner_weight_lp], by(idcounty idgrade)
        correl score_lp score_mt if idgrade == 5
        local r_saeb5_county = `r(rho)'
        correl score_lp score_mt if idgrade == 9
        local r_saeb9_county = `r(rho)'

        * Put numbers into the dataset
        clear
        set obs 2
        gen     subject = "math"
        gen     assessment = "BRAZIL 5th grade" if _n == 1
        replace assessment = "BRAZIL 9th grade" if _n == 2
        gen     r_county   = `r_saeb5_county'   if _n == 1
        replace r_county   = `r_saeb9_county'   if _n == 2
        gen     r_school   = `r_saeb5_school'   if _n == 1
        replace r_school   = `r_saeb9_school'   if _n == 2
        gen     r_student  = `r_saeb5_student'  if _n == 1
        replace r_student  = `r_saeb9_student'  if _n == 2

        save "${clone}/05_working_paper/053_outputs/assessment_correlations_brazil.dta", replace
        noi disp as result "Done with Brazil"
      }
      else noi disp as error `"Skipped the Brazil correlations (trouble opening "`SAEB_2017_microdata'")"'
    }
    else noi disp as error "Skipped the Brazil correlations (requires a clone of LearningPoverty-Brazil and whereis)"
  }
  else noi disp as txt "Skipped the Brazil correlations (already found in clone)"


  *---------------------------------------------------------------------------
  * Combine all files into a single one
  *---------------------------------------------------------------------------
  * Will append everything in this empty target file
  clear
  foreach subfile in timss llece pisad pisa brazil {
    append using "${clone}/05_working_paper/053_outputs/assessment_correlations_`subfile'.dta"
  }

  * Beautify and save
  order assessment subject r_country r_county r_school r_student
  format %4.3fc r*
  save "${clone}/05_working_paper/053_outputs/assessment_correlations.dta", replace

  * Also save as csv, to stay in clone
  export delimited "${clone}/05_working_paper/053_outputs/assessment_correlations.csv", replace

}

exit

*-------------------------------------------------------------------------------
* CODE NO LONGER IN USE - Repeats PISA analysis for a restricted sample
*-------------------------------------------------------------------------------

* The PISA code above worked well for the non-restricted student level correlations
* But since we now will need variables that are not available in GLAD-ALL,
* only in GLAD-BASE or in EDURAW, which are files above >1Gb, will have to
* open the file directly from the network.
use "${network}/GDB/HLO_Database/WLD/WLD_2018_PISA/WLD_2018_PISA_v01_M/Data/Stata/CY07_MSU_STU_QQQ.dta", clear
rename *, lower


/* Sample design in PISA 2018
* Fig 2.4 and 2.5 in PISA documentation pdf linked below
* https://www.oecd.org/pisa/data/pisa2018technicalreport/PISA2018-TecReport-Ch-02-Test-Design-Tab-Fig.pdf

Paper-based test, subject clusters and share of students:
- forms 01-12 = Reading + Science (46%)
- forms 13-24 = Reading + Math (46%)
- forms 25-30 = Reading + Math + Science (8%)

Computer-based test, subject clusters and share of students:
- forms 01-12 = Reading + Math (33%)
- forms 13-24 = Reading + Science (33%)
- forms 25-36 = Reading + Math + Science (8%)
- forms 37-48 = Reading + Global competences (22%)
- forms 49-60 = Reading + Science + Global competences (4%)
- forms 61-72 = Reading + Math + Global competences (4%)

Une-Heure form (99) = Reading + Math + Science
*/

* Dummies for whether the test design included questions on a given subject
gen byte form_w_read_math = 0
replace  form_w_read_math = 1 if adminmode == 1 &  (bookid >= 13 &  bookid <= 30)
replace  form_w_read_math = 1 if adminmode == 2 &  (bookid <= 12 | (bookid >= 25 & bookid <= 36) | (bookid >= 61 & bookid <= 72))
replace  form_w_read_math = 1 if adminmode == 2 &   bookid == 99
gen byte form_w_read_scie = 0
replace  form_w_read_scie = 1 if adminmode == 1 &  (bookid <= 12 | (bookid >= 25  &  bookid <= 30))
replace  form_w_read_scie = 1 if adminmode == 2 & ((bookid >= 13 &  bookid <= 36) | (bookid >= 49 & bookid <= 60))
replace  form_w_read_scie = 1 if adminmode == 2 &   bookid == 99

* Booklet structure
noi tab form_w_read_math form_w_read_scie, cell
/*
form_w_rea |   form_w_read_scie
    d_math |         0          1 |     Total
-----------+----------------------+----------
         0 |    53,983    256,394 |   310,377
           |      8.82      41.89 |     50.71
-----------+----------------------+----------
         1 |   256,628     44,999 |   301,627
           |     41.93       7.35 |     49.29
-----------+----------------------+----------
     Total |   310,611    301,393 |   612,004
           |     50.75      49.25 |    100.00
*/

* (Non-restricted) Student level correlations
repest PISA, estimate(corr pv@read pv@math pv@scie)
matrix b = e(b)
local  r_pisa_math_student    = b[1,1]
local  r_pisa_science_student = b[1,2]
/*
-----------------------------------------------------------------------------------
                  |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
c_pv_read_pv_math |   .8509131   .0016799   506.52   0.000     .8476205    .8542057
c_pv_read_pv_scie |   .8946202   .0012902   693.38   0.000     .8920914     .897149
-----------------------------------------------------------------------------------
*/

* Restricted student level correlations
repest PISA if form_w_read_math == 1, estimate(corr pv@read pv@math)
repest PISA if form_w_read_scie == 1, estimate(corr pv@read pv@scie)
/*
-----------------------------------------------------------------------------------
                  |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
------------------+----------------------------------------------------------------
c_pv_read_pv_math |   .8548513   .0017775   480.93   0.000     .8513675    .8583351
c_pv_read_pv_scie |   .8970047   .0013781   650.92   0.000     .8943037    .8997056
-----------------------------------------------------------------------------------
*/
