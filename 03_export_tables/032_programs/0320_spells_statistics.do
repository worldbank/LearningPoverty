*==============================================================================*
* 0320 SUBTASK: PRODUCE SPELLS STATISTICS SUMMARY TABLES
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference


  *-----------------------------------------------------------------------------*
  * Statistics on spells used and potentially used (for Table 22)
  *-----------------------------------------------------------------------------*

  foreach filter in potential_sim used_sim {

    use "${clone}/02_simulation/023_outputs/all_spells.dta", clear

    clonevar delta_adj_pct = delta_lp
    clonevar initial_learning_poverty = learningpoverty_y1

    * Will only keep the observations marked for the simulation
    keep if `filter' == 1

    preserve

      collapse (mean) meand = delta_adj_pct  meanlp = initial_learning_poverty ///
                 (p50) p50d = delta_adj_pct   p50lp = initial_learning_poverty ///
                 (min) mind = delta_adj_pct   minlp = initial_learning_poverty ///
                 (max) maxd = delta_adj_pct   maxlp = initial_learning_poverty ///
                 (count) nd = delta_adj_pct     nlp = initial_learning_poverty

      gen test = "Total"

      tempfile all_tests
      save `all_tests', replace

    restore

     collapse (mean) meand = delta_adj_pct  meanlp = initial_learning_poverty ///
                (p50) p50d = delta_adj_pct   p50lp = initial_learning_poverty ///
                (min) mind = delta_adj_pct   minlp = initial_learning_poverty ///
                (max) maxd = delta_adj_pct   maxlp = initial_learning_poverty ///
                (count) nd = delta_adj_pct     nlp = initial_learning_poverty ///
                , by(test)

    append using `all_tests'

    gen filter = "`filter'"

    tempfile `filter'
    save ``filter'', replace

  }

  use `potential_sim'
  append using `used_sim'

  * Save stats file
  save "${clone}/03_export_tables/033_outputs/individual_tables/spells_stats_by_assessment.dta", replace


  *-----------------------------------------------------------------------------*
  * Statistics on spells used and potentially used (for Table 23)
  *-----------------------------------------------------------------------------*

  foreach weigth_mode in not_weighted weighted {

    use "${clone}/02_simulation/023_outputs/all_spells.dta", clear

    clonevar delta_adj_pct = delta_lp
    clonevar initial_learning_poverty = learningpoverty_y1

    * Will only keep the observations marked for the simulation
    keep if used_sim == 1

    * Addendum to the collapse
    if "`weigth_mode'" == "weighted" {
      * Weighted version will consider each country only once, that is, if the same
      * country has multiple spells, they are averaged
      bysort countrycode : gen n_spells_country = _N
      gen spells_wgt = 1 / n_spells_country

      local wgt_opt "[aw = spells_wgt]"
    }
    else {
      local wgt_opt ""
    }

    preserve

      collapse (mean) meand = delta_adj_pct  meanlp = initial_learning_poverty ///
                 (p50) p50d = delta_adj_pct   p50lp = initial_learning_poverty ///
                 (min) mind = delta_adj_pct   minlp = initial_learning_poverty ///
                 (max) maxd = delta_adj_pct   maxlp = initial_learning_poverty ///
                 (count) nd = delta_adj_pct     nlp = initial_learning_poverty ///
                 `wgt_opt'

      gen region = "Total"

      tempfile all_tests
      save `all_tests', replace

    restore

     collapse (mean) meand = delta_adj_pct  meanlp = initial_learning_poverty ///
                (p50) p50d = delta_adj_pct   p50lp = initial_learning_poverty ///
                (min) mind = delta_adj_pct   minlp = initial_learning_poverty ///
                (max) maxd = delta_adj_pct   maxlp = initial_learning_poverty ///
                (count) nd = delta_adj_pct     nlp = initial_learning_poverty ///
                `wgt_opt', by(region)

    append using `all_tests'

    gen weights = "`weigth_mode'"

    tempfile `weigth_mode'
    save ``weigth_mode'', replace

  }

  use `not_weighted'
  append using `weighted'

  * For those two regions with a single spell, won't report values
  foreach var of varlist mean* p50* min* max* {
    replace `var' = . if inlist(region, "EAS", "SAS")
  }

  * Save stats file
  save "${clone}/03_export_tables/033_outputs/individual_tables/spells_stats_by_region.dta", replace


  noi disp as res _newline "Finished exporting spells statistics."

}
