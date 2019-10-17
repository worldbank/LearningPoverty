qui {

  cd "${clone}\02_simulation\022_program

  loc preference 1005
  loc enrollment validated
  loc inputfolder clone
  loc repetitions 100


  forval i=1/`repetitions' {

    use "${`inputfolder'}/01_data/013_outputs/rawfull.dta", clear
    gen year=year_assessment
    *nla_code should be distributed over s rather than being available in each .

    *temporarily rename test to assessment and idgrade to grade, change back after merge.
    rename test assessment
    rename idgrade grade

    *------------------------------*
    * Learning poverty calculation
    *------------------------------*
    * Adjusts non-proficiency by out-of school
    foreach subgroup in all fe ma {
      gen adj_nonprof_`subgroup' = 100 * ( 1 - (enrollment_validated_`subgroup'/100) * (1 - nonprof_`subgroup'/100))
      label var adj_nonprof_`subgroup' "Learning Poverty (adjusted non-proficiency, `subgroup')"
    }


    gen adj_pct_reading_low_rawfull= 100-adj_nonprof_all

    merge m:1 countrycode   using "${`inputfolder'}/01_data/013_outputs/preference`preference'.dta", keepusing(test idgrade incomelevel lendingtype nonprof_all)
    gen adj_pct_reading_low= 100-adj_nonprof_all
    *change name in rawlatest of assessment to test_rawlatest, and revert back to test from assessment

    rename adj_pct_reading_low adj_pct_reading_low_rawlatest
    rename adj_pct_reading_low_rawfull adj_pct_reading_low


    gen initial_poverty_level_temp=100-adj_pct_reading_low_rawlatest
    cap gen initial_poverty_level="0-25% Learning Poverty"
    cap replace initial_poverty_level="25-50% Learning Poverty" if initial_poverty_level_temp>=25
    cap replace initial_poverty_level="50-75% Learning Poverty" if initial_poverty_level_temp>=50
    cap replace initial_poverty_level="75-100% Learning Poverty"  if initial_poverty_level_temp>=75


    rename test test_rawlatest
    rename assessment test
    *same for grade
    rename idgrade idgrade_rawlatest
    rename grade idgrade

    drop if _merge==1

    gen enrollment=enrollment_validated_all
    drop if subject!="science" & test=="TIMSS"  & countrycode!="JOR"

    sort countrycode nla_code idgrade  test subject
    count


    *Cleaning the data file
    keep region regionname countrycode countryname incomelevel incomelevelname lendingtype ///
         lendingtypename year_population year_assessment idgrade test source_assessment  	///
         enrollment  	///
         adj_pct_reading_low* nonprof_all se_nonprof_all subject nla_code  initial_poverty_level

    *Generating all possible combinations of forward spells:
    sort countrycode nla_code idgrade  test subject    year_assessment
    bysort countrycode nla_code idgrade  test subject   : gen spell_c1 = string(year_assessment[_n-1]) + "-" + string(year_assessment)
    bysort countrycode nla_code idgrade  test subject   : gen spell_c2 = string(year_assessment[_n-2]) + "-" + string(year_assessment)
    bysort countrycode nla_code idgrade  test subject   : gen spell_c3 = string(year_assessment[_n-3]) + "-" + string(year_assessment)
    bysort countrycode nla_code idgrade  test subject   : gen spell_c4 = string(year_assessment[_n-4]) + "-" + string(year_assessment)

    reshape long spell_c, i(countrycode nla_code idgrade  test subject year_assessment subject) j(lag)
    ren spell_c spell

    *tag if actual spell:
    gen spell_exists=(length(spell) == 9 )

    **********************************************
    * Preparing the data for simulations:
    **********************************************
    *The data should be restructured for unique identifiers:
    sort countrycode nla_code idgrade  test subject    year_assessment spell lag

    * Rules for cleaning the spell data:
    * Bringing in the list of countries and spells for which the data is not comparable:

    merge m:1 countrycode idgrade test year_assessment spell using  "${clone}\02_simulation\021_rawdata\comparability_TIMSS_PIRLS_yr.dta", assert(master match using) keep(master match) keepusing(comparable) nogen
    drop if comparable == 0

    * Generating preferred consecutive spells:
    sort countrycode nla_code idgrade  test subject    year_assessment
    bysort countrycode nla_code idgrade  test subject   : egen lag_min = min(lag)
    * Keeping the comparable consecutive spells
    keep if lag == lag_min

    * All comparable spells for TIMSS/PIRLS
    assert comparable == 1 if !missing(comparable)



    ***************************************
    * Start Bootstrap code
    ***************************************

    * Assign median std error if not available
    su se_nonprof_all, de
    replace se_nonprof_all=`r(p50)' if missing(se_nonprof_all)


    * Form new adjprof based on random draw in boostrap sim

    gen adj_prof_bs= (enrollment/100) * (100- rnormal(nonprof_all, se_nonprof_all))


    * Annual change in enrollment, adjusted proficiency and proficiency
    sort countrycode nla_code idgrade  test subject    year_assessment
    bysort countrycode nla_code idgrade  test subject    : gen delta_adj_pct = (adj_prof_bs-adj_prof_bs[_n-1])/(year_assessment-year_assessment[_n-1])
    bysort countrycode nla_code idgrade  test subject    : gen initial_adj_pct = adj_pct_reading_low[_n-1]
    bysort countrycode nla_code idgrade  test subject    : gen final_adj_pct = adj_pct_reading_low


    * Drop observatoins specified by [if] [in].
    if `"`ifspell'"'!=""  {
      di `"`ifspell'"'
      keep `ifspell'
    }

    /* weights */

    if ("`weight'" == "") {
      cap tempname wtg
      cap gen `wtg' = 1
      local weight2 ""
      loc weight "fw"
      loc exp    "=`wtg'"
    }

    * Generating deltas in terms of reduction of gap to the frontier
    gen gap_to_frontier = 100-adj_pct_reading_low
    bysort countrycode nla_code idgrade  test subject   : gen red_gap_frontier = -1*(gap_to_frontier-gap_to_frontier[_n-1])/(year_assessment-year_assessment[_n-1])
    bysort countrycode nla_code idgrade  test subject   : gen pct_red_gap = (red_gap_frontier/gap_to_frontier[_n-1])
    gen pct_red_gap_100 = pct_red_gap*100


    *Following threshold IIB specification as the baseline file to be used will be threshold IIB.
    *Not using spell data for SACMEQ 2007 - SACMEQ 2013:
    *replace delta_adj_pct = . if test == "SACMEQ" & year == 2013
    *replace pct_red_gap_100 = . if test == "SACMEQ" & year == 2013

    *Generating categories of countries
    gen catinitial = .
    foreach var in 25 50 75 100 {
      replace catinitial= `var' if initial_adj_pct  <= `var' & catinitial== .
    }

    gen initial_learning_poverty = 100-initial_adj_pct


    ****************************************************************
    * Identify only selected spells (n=71)

    keep if test != "no assessment" & test != "EGRA" & delta_adj_pct != . & delta_adj_pct > -2 & delta_adj_pct < 4 & test != "PASEC" & year_assessment>2000 & lendingtype!="LNX" & test!="NLA"
    bysort countrycode : gen tot = _N
    gen wtg = 1/tot
    ****************************************************************
    * Results by Assessment
    * Original
    tabstat delta_adj_pct if test != "no assessment" & test != "EGRA" , by(test) stat(mean median min max N)


    *********************************************'


    *Calculating regional 90th, 8th and 70th percentiles with weights
    gen delta_reg_50 = .
    gen delta_reg_60 = .
    gen delta_reg_70 = .
    gen delta_reg_80 = .
    gen delta_reg_90 = .

    gen delta_reg_w_50 = .
    gen delta_reg_w_60 = .
    gen delta_reg_w_70 = .
    gen delta_reg_w_80 = .
    gen delta_reg_w_85 = .
    gen delta_reg_w_90 = .

    gen delta_reg_50_noSQ = .
    gen delta_reg_60_noSQ = .
    gen delta_reg_70_noSQ = .
    gen delta_reg_80_noSQ = .
    gen delta_reg_90_noSQ = .

    gen delta_reg_w_50_noSQ = .
    gen delta_reg_w_60_noSQ = .
    gen delta_reg_w_70_noSQ = .
    gen delta_reg_w_80_noSQ = .
    gen delta_reg_w_85_noSQ = .
    gen delta_reg_w_90_noSQ = .

    gen threshold="III"
    levelsof threshold, local(tr)

    foreach t of local tr {

      levelsof region, local(reg)
      foreach r of local reg {

        count if !missing(delta_adj_pct ) & threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                 & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        local count=`r(N)'

        *Only make change to regional if we have at least 3 regional spells

        /* no weights */
        _pctile delta_adj_pct  if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & delta_adj_pct > -2 & delta_adj_pct < 4 & year_assessment>2000 & lendingtype!="LNX", ///
                percentiles(50(10)90)

        replace delta_reg_50 = r(r1) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_60 = r(r2) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_70 = r(r3) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_80 = r(r4) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_90 = r(r5) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"

        /* with weights */
        _pctile delta_adj_pct  [aw = wtg] if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & delta_adj_pct > -2 & delta_adj_pct < 4 & lendingtype!="LNX" , ///
                percentiles(50(10)90)

        replace delta_reg_w_50 = r(r1) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_w_60 = r(r2) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_w_70 = r(r3) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_w_80 = r(r4) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"
        replace delta_reg_w_90 = r(r5) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"


        /* no weights + NO SAQMEC */
        _pctile delta_adj_pct if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & delta_adj_pct > -2 & delta_adj_pct < 4 & lendingtype!="LNX"& test != "SACMEQ", ///
                percentiles(50(10)90)

        replace delta_reg_50_noSQ = r(r1) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_60_noSQ = r(r2) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_70_noSQ = r(r3) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_80_noSQ = r(r4) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_90_noSQ = r(r5) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"

        /* with weights + NO SAQMEC*/
        _pctile delta_adj_pct [aw = wtg] if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & delta_adj_pct > -2 & delta_adj_pct < 4 & lendingtype!="LNX"& test != "SACMEQ", ///
                percentiles(50(10)90)

        replace delta_reg_w_50_noSQ = r(r1) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_w_60_noSQ = r(r2) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_w_70_noSQ = r(r3) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_w_80_noSQ = r(r4) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"
        replace delta_reg_w_90_noSQ = r(r5) if threshold == "`t'" & region == "`r'" & test != "EGRA" ///
                & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX"& test != "SACMEQ"

      }

    }


    ** No SAQMEC (no PASEC)
    tempfile temp2
    preserve
      collapse delta_adj_pct delta_reg_w_50 delta_reg_w_60  delta_reg_w_70 delta_reg_w_80 delta_reg_w_90 if test != "EGRA" ///
               & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX",
      gen region="Overall"
      save `temp2'
    restore

    collapse delta_adj_pct delta_reg_w_50 delta_reg_w_60  delta_reg_w_70 delta_reg_w_80 delta_reg_w_90 if test != "EGRA" ///
             & test != "PASEC" & test != "no assessment"  & year_assessment>2000 & lendingtype!="LNX", by( region )

    append using `temp2'

    gen rep=`i'
    tempfile temp`i'
    save "`temp`i''"

  }

  clear
  forval i=1/`repetitions' {
    append using `temp`i''
  }

  collapse (sd) delta_adj_pct delta_reg_w_50 delta_reg_w_60  delta_reg_w_70 delta_reg_w_80 delta_reg_w_90, by(region)
  save "${clone}\02_simulation\023_outputs\md_std_errors.dta, replace

}
