*==============================================================================*
* 0322 SUBTASK: DECOMPOSITION OF LPV LEVELS AND CHANGE
*==============================================================================*

quietly {

  tempfile tmp1 tmp2

  *-----------------------------------------------------------------------------
  * Decomposition of Learning Poverty Levels
  *-----------------------------------------------------------------------------
  foreach gender in all ma fe {

    foreach type in reg inc len {

        foreach filter in  `"countryfilter(lendingtype!="LNX")"' `""'  {

        if "`filter'" == "" {
        local f b
        }
        else {
        local f a
        }

        ** prepare dataset
        if "`gender'" == "all" ///
               population_weights, preference(1005) timewindow(year_assessment>=2011) combine_ida_blend `filter'
        else {
          if "`filter'" == "" local aux_filter `"countryfilter(inlist(countrycode,"MNG","PHL")==0)"'
          else local aux_filter `"countryfilter(lendingtype!="LNX" & inlist(countrycode,"MNG","PHL")==0)"'
          population_weights, preference(1005) combine_ida_blend `aux_filter'
          drop if inlist(countrycode,"MNG","PHL")
        }

        keep if adj_nonprof_`gender' != .
        keep if global_weight != .

        * More intuitive/shorter names for key variables
        rename (adj_nonprof_`gender' enrollment_`gender' nonprof_`gender') (learningpoverty enrollment bmp)
        gen oos = 100 - enrollment

        tabstat learningpoverty [aw = region_weight], by(region)
        tabstat learningpoverty [aw = global_weight], by(region)

        gen exp  = 2

        sum learningpoverty oos bmp

        * countrycode
        encode countrycode, gen(ctry)
        *regional
        encode region , gen(reg)
        * income levels
        encode incomelevel , gen(inc)
        * lending type (creating IDA/BLED)
        encode lendingtype , gen(len)

        * turn all indicators to indexes
        foreach var in learningpoverty oos bmp {
          replace `var' = `var'/100
        }

        * create complementary variable
        gen  oos_complement = 1-oos

        expand exp , gen(time)

        * create counterfactural / NO LEARNING POVERTY
        foreach var in learningpoverty oos bmp oos_complement  {
          replace `var' = 0 if time == 1
        }

        *-----------------------------------------------------------------------------
        * prepare decomposition by category
        *-----------------------------------------------------------------------------

         preserve

          adecomp learningpoverty bmp oos_complement oos [aw = region_weight], ///
          equation((c1*c2)+(c3)) by(time) id(ctry)  indicator(mean) group(`type')


          mat a = r(b)
          mat a = a'

          svmat double a, names(col)

          keep r1-r4
          drop in 1/2
          gen `type' = _n
          order `type'

          label value `type' `type'

          gen bmp = r1 + r2
          gen oos = r3
          gen total = r4

          drop r1 - r4

          keep if bmp != .

          decode `type' , generate(category)
          drop `type'
          order category

          save `tmp1', replace

        restore

        *-----------------------------------------------------------------------------
        * prepare global decomposition
        *-----------------------------------------------------------------------------

        preserve

          adecomp learningpoverty bmp oos_complement oos [aw = region_weight], ///
          equation((c1*c2)+(c3)) by(time) id(ctry)  indicator(mean)


          mat a = r(b)
          mat a = a'

          svmat double a, names(col)

          keep r1-r4
          drop in 1/2
          gen `type' = 0
          order `type'
          label value `type' `type'

          gen bmp = r1 + r2
          gen oos = r3
          gen total = r4

          drop r1 - r4

          keep if bmp != .

          decode `type' , generate(category)
          drop `type'
          order category

          replace category = "WLD" if category == ""

          save `tmp2', replace

        restore

        *-----------------------------------------------------------------------------
        * append decomposition by categor and global
        *-----------------------------------------------------------------------------

        use `tmp1', clear
        append using `tmp2'

        gen double shr_bmp = bmp/total
        gen double shr_oos = oos/total

        order category total

        * flip sign of absolute value
        foreach var in total bmp oos {
          replace `var' = `var'*(-1)
        }

        * multiply all results by 100 and format output to one decimal
        foreach var in total bmp oos shr_bmp shr_oos {
          replace `var' = `var'*100
          format `var' %16.1f
        }


        gen panel = "`type'"
        if ("`f'" == "a") gen filter = "low- and middle- income"
        else              gen filter = "all ctrys"

        order panel filter category  total

        save "${clone}/03_export_tables/033_outputs/individual_tables/panel_`type'_`f'.dta", replace

        * next filter
      }

     * next type
    }


    *-----------------------------------------------------------------------------
    ** Final Output
    *-----------------------------------------------------------------------------
    clear
    foreach filename in panel_reg_a panel_inc_a panel_len_a panel_reg_b panel_inc_b panel_len_b {
      append using "${clone}/03_export_tables/033_outputs/individual_tables/`filename'.dta"
      erase        "${clone}/03_export_tables/033_outputs/individual_tables/`filename'.dta"
    }

    label var category "Group"
    label var total    "Learning Poverty"
    label var bmp      "Below Minimum Proficiency (BMP)"
    label var oos      "Out of School (OOS)"
    label var shr_bmp  "Percentage of Learning Poverty Explained by BMP"
    label var shr_oos  "Percentage of Learning Poverty Explained by OOS"

    save "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_lpv_`gender'.dta", replace

    * next gender
  }

  noi disp as res _n "Decomposition of Learning Poverty Levels done."



  *-----------------------------------------------------------------------------
  * Decomposition of Learning Poverty Spells
  *-----------------------------------------------------------------------------

  clear
  use  "${clone}/02_simulation/023_outputs/all_spells.dta"
  keep if used_sim  == 1
  keep countrycode y1 bmp_y1 enrollment_y1 learningpoverty_y1 y2 bmp_y2 enrollment_y2 learningpoverty_y2 region incomelevel lendingtype
  rename (y1 y2) (year_y1 year_y2)
  sort countrycode year_y1
  bysort countrycode : gen seq = _n

  reshape long year bmp enrollment learningpoverty , i(countrycode region incomelevel lendingtype seq) j(time) string

  * countrycode
  encode countrycode, gen(ctry)
  *regional
  encode region , gen(reg)
  * income levels
  encode incomelevel , gen(inc)
  * lending type (creating IDA/BLED)
  encode lendingtype , gen(len)
  recode len 3=2

  * time
  encode time, gen(t)
  drop time
  rename t time

  * create complementary variable
  gen oos = 100-enrollment
  gen  oos_complement = 100-oos
  
  bysort countrycode : gen tot = _N
  gen wtg = 1/tot

  * turn all indicators to indexes
  foreach var in learningpoverty bmp enrollment oos_complement oos {
	gen double `var'_i = `var'/100
  }

  gen double bmp_adj = bmp*oos_complement_i

  sort seq countrycode year
  bysort seq countrycode : gen diff =year[2]-year[1]

  foreach var in learningpoverty bmp enrollment oos_complement oos  bmp_adj  learningpoverty_i bmp_i enrollment_i oos_complement_i oos_i {
	bysort seq countrycode : gen double `var'_diff =`var'[2]-`var'[1]
  }

  foreach var in learningpoverty bmp enrollment oos_complement oos  bmp_adj  learningpoverty_i bmp_i enrollment_i oos_complement_i oos_i {
	bysort seq countrycode : gen double `var'_diff2 =(`var'[2]-`var'[1])/(year[2]-year[1])
  }



  foreach var in learningpoverty bmp enrollment oos_complement oos  bmp_adj  learningpoverty_i bmp_i enrollment_i oos_complement_i oos_i {
	gen double `var'2 = `var'/diff
  }

  * summary stats for the two periods
  tabstat learningpoverty oos oos_complement bmp enrollment [aw=wtg]  , by(time) 
  
  tabstat learningpoverty_i oos_i oos_complement_i bmp_i enrollment_i [aw=wtg]  , by(time) 

  tabstat learningpoverty2 oos2 oos_complement2 bmp2 enrollment2 [aw=wtg]  , by(time) 

  tabstat learningpoverty_diff oos_diff oos_complement_diff bmp_diff enrollment_diff [aw=wtg]  , by(time) 

  tabstat learningpoverty_diff oos_diff oos_complement_diff bmp_diff enrollment_diff [aw=wtg]  if time == 1 , by(reg) stat(mean p50)

  
  tabstat learningpoverty_diff oos_diff oos_complement_diff bmp_diff enrollment_diff [aw=wtg]  if time == 1 , by(reg) stat(mean p50)

  * display diff we want to decompose
  tabstat learningpoverty_diff2  [aw=wtg]  if time == 1 , by(reg) stat(mean p50 p25 p10)
  
  * display diff we want to decompose
  tabstat learningpoverty_diff2  [aw=wtg]  if time == 1 , by(reg) stat(mean p50 )
  
  tabstat learningpoverty_diff2  [aw=wtg]  if time == 1 , stat(mean p50 p25 p10)
  
  sum learningpoverty_diff2  [aw=wtg]  if time == 1 , d
  
  * test before
  * global number 
  	adecomp learningpoverty2 bmp_adj2 oos2 [aw=wtg] , ///
	  equation(c1+c2) by(time) id(ctry)  indicator(median) 
	  
	  

  	adecomp learningpoverty2 bmp_adj2 oos2 [aw=wtg] , ///
	  equation(c1+c2) by(time) id(ctry)  indicator(mean median) stats() group(reg)


  
  * test before
  * global number 
  	adecomp learningpoverty2 bmp_adj2 oos2 [aw=wtg] , ///
	  equation(c1+c2) by(time) id(ctry)  indicator(mean) stats() gic(41) method(difference)

  
  * test before
  * global number 
  	adecomp learningpoverty2 bmp_adj2 oos2 [aw=wtg] , ///
	  equation(c1+c2) by(time) id(ctry)  indicator(mean) stats() gic(41) method(growth)

  *-----------------------------------------------------------------------------
  * prepare decomposition by category
  *-----------------------------------------------------------------------------

  local type reg  
  
  preserve

	adecomp learningpoverty2 bmp_adj2 oos2 [aw=wtg] , ///
	  equation(c1+c2) by(time) id(ctry)  indicator(mean) group(`type') 

	mat a = r(b)
	mat a = a'

	svmat double a, names(col)

	keep r1-r3
	drop in 1/2
	gen `type' = _n
	order `type'

	label value `type' `type'

	gen bmp = r1 
	gen oos = r2
	gen total = r3

	drop r1 - r3

	keep if bmp != .

	decode `type' , generate(category)
	drop `type'
	order category

	save `tmp1', replace

  restore


  *-----------------------------------------------------------------------------
  * prepare decomposition by WLD
  *-----------------------------------------------------------------------------

  local type reg

  preserve

  adecomp learningpoverty2 bmp_adj2 oos2 [aw=wtg] , ///
	equation(c1+c2) by(time) id(ctry)  indicator(mean) 

  mat a = r(b)
  mat a = a'

  svmat double a, names(col)

  keep r1-r3
  drop in 1/2
  gen `type' = 0
  order `type'

  label value `type' `type'

  gen bmp = r1
  gen oos = r2
  gen total = r3

  drop r1 - r3

  keep if bmp != .

  decode `type' , generate(category)
  drop `type'
  order category

  replace category = "WLD" if category == ""

  save `tmp2', replace

  restore

  *-----------------------------------------------------------------------------
  * append decomposition by categor and global
  *-----------------------------------------------------------------------------

  use `tmp1', clear
  append using `tmp2'

  gen double shr_bmp = bmp/total
  gen double shr_oos = oos/total

  order category total

  * flip sign of absolute value
  foreach var in total bmp oos {
  	replace `var' = `var'*(-1)
  }

  * multiply all results by 100 and format output to one decimal
  foreach var in total bmp oos shr_bmp shr_oos {
    replace `var' = `var'
    format `var' %16.2f
  }

  * rescale decomposition if share of both components surpasses 100 in module
  forvalues obs = 1/`=_N' {
    while `=shr_bmp[`obs']' > 100 & `=shr_oos[`obs']' < -100 {
      replace shr_bmp = shr_bmp - 100 if _n == `obs'
      replace shr_oos = shr_oos + 100 if _n == `obs'
    }
    while `=shr_bmp[`obs']' < -100 & `=shr_oos[`obs']' > 100 {
      replace shr_bmp = shr_bmp + 100 if _n == `obs'
      replace shr_oos = shr_oos - 100 if _n == `obs'
    }
  }

  order category

  label var category "Region"
  label var total    "Annualized Change in Learning Poverty"
  label var bmp      "Annualized Change in Below Minimum Proficiency (BMP)"
  label var oos      "Annualized Change in Out of School (OOS)"
  label var shr_bmp  "Percentage of Annualized Change in Learning Poverty Explained by BMP"
  label var shr_oos  "Percentage of Annualized Change in Learning Poverty Explained by OOS"

  save "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_spells.dta", replace

  noi disp as res _n "Decomposition of Learning Poverty Spells done."

}
