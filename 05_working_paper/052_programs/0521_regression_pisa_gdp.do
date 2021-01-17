*==============================================================================*
* 0521 SUBTASK: Relationship between Reading and Math Proficiency (PISA)
*==============================================================================*
qui {

  *-----------------------------------------------------------------------------
  local outputs   "${clone}/05_working_paper/053_outputs"
  local rawdata   "${clone}/05_working_paper/051_rawdata"
  local overwrite_csv = 0 // Change here to download new data even if csv already in clone
  *-----------------------------------------------------------------------------


  /*-----------------------------------------------------------------------------
  * Download the cross country GDP data
  wbopendata , indicators(NY.GDP.PCAP.PP.KD) long clear
  keep if ny_gdp_pcap_pp_kd != .
  sort countrycode year
  tempfile gdp
  save    `gdp', replace

  * Load PISA results from the GROUPDATA
  import delimited  "`rawdata'/pisa-groupdata.csv", numericcols(15) clear

  keep if type == 1
  gen flag = .
  replace flag = 1 if indicator <= 3 & model == 1
  replace flag = 1 if indicator == 4 & model == 2

  keep if flag == 1
  drop flag

  drop countrycode year test subject idgrade seqpov seqmean model type
  reshape wide value , i(name povline mean sd) j(indicator)


  gen countrycode = word(subinstr(name,"_", " ",.),1)
  gen year        = real(word(subinstr(name,"_", " ",.),2))
  gen test        = upper(word(subinstr(name,"_", " ",.),4))
  gen subject     = word(subinstr(name,"_", " ",.),5)
  gen idgrade     = real(word(subinstr(name,"_", " ",.),6))

  drop name

  reshape wide value1 value2 value3 value4 mean sd, i(countrycode year test idgrade povline ) j(subject)  string

  *-----------------------------------------------------------------------------
  * Merge GDP data
  merge m:1 countrycode year using `gdp', keep(master) nogen

  *-----------------------------------------------------------------------------
  * Run models using PISA-Groupdata indicators

  regress meanread meanmath     , cluster(countrycode)
  regress value1read value1math , cluster(countrycode)
  regress value2read value2math , cluster(countrycode)
  regress value3read value3math , cluster(countrycode)
  regress value4read value4math , cluster(countrycode)

  regress value1read meanmath  , cluster(countrycode)
  regress value2read meanmath  , cluster(countrycode)
  regress value3read meanmath  , cluster(countrycode)
  regress value4read meanmath  , cluster(countrycode)

  regress meanread meanscience     , cluster(countrycode)
  regress value1read value1science , cluster(countrycode)
  regress value2read value2science , cluster(countrycode)
  regress value3read value3science , cluster(countrycode)
  regress value4read value4science , cluster(countrycode)

  regress value1read meanscience  , cluster(countrycode)
  regress value2read meanscience  , cluster(countrycode)
  regress value3read meanscience  , cluster(countrycode)
  regress value4read meanscience  , cluster(countrycode)

  noi disp as res _n "Finished runing PISA models with groupdata indicators"

  */

  * In the end, those regressions above are not being used and were just an experiment
  * The outputs are not even saved. Rather, we use the edstats indicator restults


  *-----------------------------------------------------------------------------
  * Download EdStats data from WBOPENDATA
  *-----------------------------------------------------------------------------

  * Check for a pre-existing frozen version in the clone
  cap confirm file "`rawdata'/pisa-wdi.csv"

  * If the frozen version is not found or forced to overwrite with a fresh wbopendata query
  if (_rc | `overwrite_csv') {


     global math   " LO.PISA.MAT  ;  LO.PISA.MAT.0 ;  LO.PISA.MAT.1  ; LO.PISA.MAT.2 ;  LO.PISA.MAT.3  ; LO.PISA.MAT.4  ; LO.PISA.MAT.5   ; LO.PISA.MAT.6   "

     global read   " LO.PISA.REA  ;  LO.PISA.REA.0.B1C   ; LO.PISA.REA.1C  ; LO.PISA.REA.1B ; LO.PISA.REA.1A ; LO.PISA.REA.2 ; LO.PISA.REA.3 ; LO.PISA.REA.4 ; LO.PISA.REA.5 ;  LO.PISA.REA.6  "

     global sci    " LO.PISA.SCI  ; LO.PISA.SCI.0  ;  LO.PISA.SCI.1A ;  LO.PISA.SCI.1B  ; LO.PISA.SCI.2 ; LO.PISA.SCI.3  ;  LO.PISA.SCI.4 ; LO.PISA.SCI.5  ;  LO.PISA.SCI.6   "

    * download the cross country data
    wbopendata , indicator(NY.GDP.PCAP.PP.KD ; $math ; $read ; $sci ) long clear

    * generate cummulative scores

    egen math = rowtotal(lo_pisa_mat_*)
    egen read = rowtotal(lo_pisa_rea_*)
    egen sci  = rowtotal(lo_pisa_sci_*)

    recode math 0 = .
    recode read 0 = .
    recode sci  0 = .

    sum math read sci

    egen check = rowmiss( lo_pisa_mat lo_pisa_rea lo_pisa_sci)
    drop if check == 3
    sort countrycode year
    bysort countrycode : gen latest = _n == _N


    * generate weights to control for multiple observations for the same country
    bysort countrycode : gen tot = _N
    gen wtg = 1/tot

    * encode region and incomelevel
    encode regionname, gen(reg)
    encode incomelevelname, gen(inc)

    * export microdata
    export delimited using "`rawdata'/pisa-wdi.csv", nolabel replace
  }

  * If not creating a new csv, simply imports existing csv into a dta
  else {
    import delimited       "`rawdata'/pisa-wdi.csv", numericcols(15) clear
  }

  est drop _all

  * regression without ctry weights
  regress lo_pisa_rea lo_pisa_mat , cluster(countrycode)
  est store m11

  regress lo_pisa_rea lo_pisa_mat i.reg i.inc , cluster(countrycode)
  est store m12

  regress lo_pisa_rea lo_pisa_mat i.year i.reg i.inc , cluster(countrycode)
  est store m13

  regress lo_pisa_rea lo_pisa_mat ny_gdp_pcap_pp_kd i.year i.reg i.inc , cluster(countrycode)
  est store m14

  regress lo_pisa_rea lo_pisa_sci   , cluster(countrycode)
  est store m21

  regress lo_pisa_rea lo_pisa_sci  i.reg i.inc , cluster(countrycode)
  est store m22

  regress lo_pisa_rea lo_pisa_sci i.year i.reg i.inc , cluster(countrycode)
  est store m23

  regress lo_pisa_rea lo_pisa_sci ny_gdp_pcap_pp_kd i.year i.reg i.inc , cluster(countrycode)
  est store m24


  * regression with ctry weights
  regress lo_pisa_rea lo_pisa_mat [aw=wtg] , cluster(countrycode)
  est store w11

  regress lo_pisa_rea lo_pisa_mat i.reg i.inc [aw=wtg] , cluster(countrycode)
  est store w12

  regress lo_pisa_rea lo_pisa_mat i.year i.reg i.inc [aw=wtg] , cluster(countrycode)
  est store w13

  regress lo_pisa_rea lo_pisa_mat ny_gdp_pcap_pp_kd i.year i.reg i.inc [aw=wtg] , cluster(countrycode)
  est store w14

  regress lo_pisa_rea lo_pisa_sci [aw=wtg] , cluster(countrycode)
  est store w21

  regress lo_pisa_rea lo_pisa_sci i.reg i.inc [aw=wtg] , cluster(countrycode)
  est store w22

  regress lo_pisa_rea lo_pisa_sci i.year i.reg i.inc [aw=wtg] , cluster(countrycode)
  est store w23

  regress lo_pisa_rea lo_pisa_sci ny_gdp_pcap_pp_kd i.year i.reg i.inc [aw=wtg] , cluster(countrycode)
  est store w24


  * display output
  estout m* using "`outputs'/pisa_1.txt", ///
            cells(b(star fmt(%9.3f)) se(par))                ///
            stats(r2_a N, fmt(%9.3f %9.0g) labels(R2-Adj))      ///
            legend label collabels(none) varlabels(_cons Constant) ///
            keep(lo_pisa_mat lo_pisa_sci ) replace



  estout w* using "`outputs'/pisa_2.txt", ///
            cells(b(star fmt(%9.3f)) se(par))                ///
            stats(r2_a N, fmt(%9.3f %9.0g) labels(R2-Adj))      ///
            legend label collabels(none) varlabels(_cons Constant) ///
            keep(lo_pisa_mat lo_pisa_sci ) replace

  noi disp as res _n "Finished runing PISA models with EdStats indicators"

}

exit

/*
* https://nces.ed.gov/surveys/pisa/2018technotes-6.asp

In addition to using a range of scale scores as the basic form of measurement, PISA describes student proficiency in terms of levels of proficiency. Higher levels represent the knowledge, skills, and capabilities needed to perform tasks of increasing complexity. PISA results are reported in terms of percentages of the student population at each of the predefined levels.

To determine the performance levels and cut scores on the literacy scales, IRT techniques were used. With IRT techniques, it is possible to simultaneously estimate the ability of all students taking the PISA assessment, as well as the difficulty of all PISA items. Estimates of student ability and item difficulty can then be mapped on a single continuum. The relative ability of students taking a particular test can be estimated by considering the percentage of test items they get correct. The relative difficulty of items in a test can be estimated by considering the percentage of students getting each item correct. In PISA, all students within a level are expected to answer at least half of the items from that level correctly. Students at the bottom of a level are able to provide the correct answers to about 52 percent of all items from that level, have a 62 percent chance of success on the easiest items from that level, and have a 42 percent chance of success on the most difficult items from that level. Students in the middle of a level have a 62 percent chance of correctly answering items of average difficulty for that level (an overall response probability of 62 percent). Students at the top of a level are able to provide the correct answers to about 70 percent of all items from that level, have a 78 percent chance of success on the easiest items from that level, and have a 62 percent chance of success on the most difficult items from that level. Students just below the top of a level would score less than 50 percent on an assessment at the next higher level. Students at a particular level demonstrate not only the knowledge and skills associated with that level but also the proficiencies defined by lower levels. Patterns of responses for students in the proficiency levels labeled below level 1c for reading literacy, below level 1b for science literacy, and below level 1 for mathematics literacy and financial literacy suggest that these students are unable to answer at least half of the items from those levels correctly. For details about the approach to defining and describing the PISA proficiency levels and establishing the cut scores, see the OECD’s PISA 2018 Technical Report . Table A-2 shows the cut scores for each proficiency level for reading, science, and mathematics literacy.

Table A-2. Cut scores for proficiency levels for reading, science, and mathematics literacy: 2018
Proficiency level  Reading  Science  Mathematics  Financial literacy
Level 1 (1c)  189.33 to less than 262.04  —   357.77 to less than 420.07  325.57 to less than 400.33
Level 1 (1b)  262.04 to less than 334.75  260.54 to less than 334.94
Level 1 (1a)  334.75 to less than 407.47  334.94 to less than 409.54
Level 2  407.47 to less than 480.18  409.54 to less than 484.14  420.07 to less than 482.38  400.33 to less than 475.10
Level 3  480.18 to less than 552.89  484.14 to less than 558.73  482.38 to less than 544.68  475.10 to less than 549.86
Level 4  552.89 to less than 625.61  558.73 to less than 633.33  544.68 to less than 606.99  549.86 to less than 624.63
Level 5  625.61 to less than 698.32  633.33 to less than 707.93  606.99 to less than 669.30  624.63 to less than 1000
Level 6  698.32 to less than 1000  707.93 to less than 1000  669.30 to less than 1000  —
— Not applicable.
NOTE: For reading literacy, proficiency level 1 is composed of three levels, 1a, 1b, and 1c. For science literacy, proficiency level 1 is composed of two levels, 1a and 1b. The score range for below level 1 refers to scores below level 1b. For mathematics and financial literacy, there is a single proficiency category at level 1.
SOURCE: Organization for Economic Cooperation and Development (OECD), Program for International Student Assessment (PISA), 2018.
