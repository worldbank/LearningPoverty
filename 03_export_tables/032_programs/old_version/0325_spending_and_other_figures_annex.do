*==============================================================================*
* 0325 SUBTASK: SPENDING AND OTHER FIGURES FOR ANNEX
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference

  ****************************************************
  **** Table on Expenditure and Learning Poverty
  ****************************************************

  import delimited "${clone}/08_2pager/081_data/cleaned_expenditure_data.csv", varnames(1) clear

  sort countrycode year
  bysort countrycode : keep if _N==_n

  sort countrycode

  merge countrycode using "${clone}/01_data/013_outputs/preference`chosen_preference'.dta"

  tab _merge if adj_nonprof_all != .



  ****************************************************
  **** Table on Expenditure and Learning Poverty
  ****************************************************

  tempfile tmp1 tmp2 tmp3 tmp4

  *** spending

  use "${clone}/01_data/011_rawdata/primary_expenditure.dta", clear

  drop if exp_pri_perchild_total == .
  sort countrycode year
  bysort countrycode : keep if _N==_n

  rename year year_spending

  sort countrycode

  save `tmp1', replace


  *** gdp

  use "${clone}/01_data/011_rawdata/poverty_gdp_indicators.dta", clear

  drop if ny_gdp_pcap_cd == .
  sort countrycode year
  bysort countrycode : keep if _N==_n

  rename year year_gdp

  keep ny_gdp_pcap_cd countrycode year_gdp

  sort countrycode

  save `tmp2', replace

  ** poverty

  use "${clone}/01_data/011_rawdata/poverty_gdp_indicators.dta", clear

  drop if si_pov_dday  == .
  sort countrycode year
  bysort countrycode : keep if _N==_n

  rename year year_poverty

  keep si_pov_dday si_pov_lmic si_pov_umic countrycode year_poverty

  sort countrycode

  save `tmp3', replace

  ** HCI

  use "${clone}/01_data/011_rawdata/hci_indicators.dta", clear

  sort countrycode

  save `tmp4', replace


  ** Preference

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  sort countrycode

  merge countrycode using  `tmp1'
  rename _merge merge_spending
  tab merge_spending if adj_nonprof_all != .
  sort countrycode

  merge countrycode using  `tmp2'
  rename _merge merge_gdp
  tab merge_gdp if adj_nonprof_all != .
  sort countrycode

  merge countrycode using  `tmp3'
  rename _merge merge_poverty
  tab merge_poverty if adj_nonprof_all != .
  sort countrycode

  merge countrycode using  `tmp4'
  rename _merge merge_hci
  tab merge_hci if adj_nonprof_all != .

  ****************************************************************

  gen lp = adj_nonprof_all
  gen exp = ny_gdp_pcap_cd
  gen gdp = exp_pri_perchild_total
  gen dday = si_pov_dday
  gen lays = LAYS_mf
  gen hci  = HCI_mf

  gen ln_lp = ln( adj_nonprof_all)
  gen ln_gdp = ln(ny_gdp_pcap_cd)
  gen ln_exp = ln( exp_pri_perchild_total)
  gen ln_dday = ln(si_pov_dday)
  gen ln_lays = ln(LAYS_mf)
  gen ln_hci = ln(HCI_mf)

  tab region, gen(region)

  label var ln_lp 	"Log(Learning Poverty)"
  label var ln_exp 	"log(Primary Spending per Child)"
  label var ln_gdp 	"log(GDP per capita PPP 2011)"
  label var ln_dday 	"log(Poverty [DDay])"
  label var ln_lays 	"log(LAYS)"
  label var ln_hci	"log(HCI)"

  label var lp 	"Learning Poverty"
  label var exp 	"Primary Spending per Child"
  label var gdp 	"GDP per capita PPP 2011"
  label var dday 	"Poverty [DDay]"
  label var lays 	"LAYS"
  label var hci	"HCI"

  ****************************************************************

  foreach var in ln_gdp ln_exp ln_dday ln_lays ln_hci {
    regress  `var' ln_lp
    est store `var'
  }

    estout ln*, cells(b(star fmt(%9.3f)) se(par))                ///
         stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
         legend label collabels(none) varlabels(_cons Constant)


  foreach var in gdp exp dday lays hci {
    regress  `var' ln_lp
    est store o_`var'
  }

    estout o_*, cells(b(star fmt(%9.3f)) se(par))                ///
         stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))      ///
         legend label collabels(none) varlabels(_cons Constant)

  ****************************************************************


  export delimited using "${clone}/03_export_tables/033_outputs/viz_latest.csv", replace


  *********************  NEED TO MOVE THIS TO ANALYSIS FOR THE PAPER  **********************************

  use "${clone}/01_data/013_outputs/rawfull.dta" , clear

  gen year = year_assessment

  sort countrycode year

  merge countrycode year using "${clone}/01_data/011_rawdata/primary_expenditure.dta"

  local enrollment "validated"

  * Check ENROLLMENT() option
  * Must be one of enrollment methods supported
  * Assume "validated" as default if not specified
    if "`enrollment'" == "validated" | "`enrollment'" == "" {
      drop enrollment_interpolated*
      rename enrollment_validated_* enrollment_*
    }
    else if "`enrollment'" == "interpolated" {
      drop enrollment_validated*
      rename enrollment_interpolated_* enrollment_*
    }
    else {
    noi dis as error `"ENROLLMENT must be either "interpolated" or "validated". Try again."'
      break
    }

  * Adjusts non-proficiency by out-of school
    foreach subgroup in all fe ma {
      gen adj_nonprof_`subgroup' = 100 * ( 1 - (enrollment_`subgroup'/100) * (1 - nonprof_`subgroup'/100))
      label var adj_nonprof_`subgroup' "Learning Poverty (adjusted non-proficiency, `subgroup')"
    }

  tab _merge if adj_nonprof_all != .

  ****************************************************************
  gen lp 		= adj_nonprof_all
  gen c1_lp    = 100-lp
  gen ln_1_lp = ln(c1_lp)
  gen ln_lp = ln( adj_nonprof_all)
  gen ln_exp = ln( exp_pri_perchild_total)
  tab region, gen(region)
  tab incomelevel, gen(income)
  tab lendingtype, gen(lendingtype)

  label var ln_1_lp "Log(100-Learning Poverty)"
  label var ln_lp "Log(Learning Poverty)"
  label var ln_exp "log(Primary Spending per Child)"

  ****************************************************************

  regress ln_lp ln_exp

  keep if e(sample)

  bysort countrycode: gen wtg = (1/_N)*10

  qreg ln_lp ln_exp [fw=int(wtg)], vce(robust)
  grqreg [fw=int(wtg)], ci ols olsci    qmin(.05) qmax(.95) qstep(.05)

  qreg ln_1_lp ln_exp [fw=int(wtg)], vce(robust)
  grqreg [fw=int(wtg)], ci ols olsci    qmin(.05) qmax(.95) qstep(.05)

  // to JP: I commented out those lines that were breaking (pw not allowed in grqreg)
  //qreg ln_1_lp  ln_exp [pw=wtg], vce(robust)
  //grqreg [pw=wtg], ci ols olsci    qmin(.05) qmax(.95) qstep(.05)

  qreg ln_1_lp ln_exp, vce(robust)
  grqreg , ci ols olsci    qmin(.05) qmax(.95) qstep(.05)

  qreg ln_1_lp ln_exp, vce(robust)
  grqreg, ci ols olsci    qmin(.2) qmax(.8) qstep(.05)

  regress ln_lp ln_exp region2 region4 region6 region7 region9

  qreg ln_lp ln_exp, vce(robust)
  grqreg, ci ols olsci    qmin(.2) qmax(.8) qstep(.05)

  qreg ln_lp ln_exp region2 region4 region6 region7 region9 , vce(robust)
  grqreg ln_exp  , ci ols olsci    qmin(.05) qmax(.95) qstep(.05)

  qreg ln_lp ln_exp income1 income2 income3, vce(robust)
  grqreg ln_exp  , ci ols olsci    qmin(.05) qmax(.95) qstep(.05)

  qreg ln_lp ln_exp lendingtype1 lendingtype2 lendingtype3, vce(robust)
  grqreg ln_exp  , ci ols olsci    qmin(.05) qmax(.95) qstep(.05)


  qreg ln_lp ln_exp region2 region4 region6 region7 region9  [fw=int(wtg)], vce(robust)
  grqreg ln_exp  [fw=int(wtg)], ci ols olsci    qmin(.05) qmax(.95) qstep(.05)


  qreg adj_nonprof_all exp_pri_perchild_total, vce(robust)
  grqreg, ci ols olsci    qmin(.2) qmax(.8) qstep(.1) mfx(eyex )

  // to JP: I commented out those lines that were breaking (pw not allowed in grqreg)
  //qreg ln_lp ln_exp [pw=wtg], vce(robust)
  //grqreg [pweight=wtg], ci ols olsci qmin(.05) qmax(.95) qstep(.05)

  qreg ln_lp ln_exp, vce(robust)
  grqreg, ci ols olsci  qmin(.2) qmax(.8) qstep(.05)

  noi disp as res _newline "Finished exporting Spending and other figures for annex."

}
