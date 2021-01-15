*==============================================================================*
* 0321 SUBTASK: GENERATE TABLES OUTLINING THE CURRENT SITUATION
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference

  * Where all files created during this do will be saved
  local outputs_folder "${clone}/03_export_tables/033_outputs/individual_tables"

  * Option of bootstrap repetitions for SE calculation
  * (will be applied to all outlines)
  local reps "repetitions(100)"
  noi dis as txt _n "All tables calculated with bootstrap `reps' (may take a long time)"

  *-----------------------------------------------------------------------------
  * Outline of Current Situation
  *-----------------------------------------------------------------------------

  * Part 2 countries only
  population_weights, preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") combine_ida_blend
  outline_current_lp, filename("`outputs_folder'/outline_current_lp_part2.csv") `reps'

  * All countries in the world
  population_weights, preference(`chosen_preference') timewindow(year_assessment>=2011) combine_ida_blend
  outline_current_lp, filename("`outputs_folder'/outline_current_lp_world.csv") `reps'

  * Repeats the above without the restriction on year_assessment (witouth BS repetitions)

  * Part 2 countries only
  population_weights, preference(`chosen_preference') countryfilter(lendingtype!="LNX") combine_ida_blend
  outline_current_lp, filename("`outputs_folder'/outline_current_lp_old_part2.csv")

  * All countries in the world
  population_weights, preference(`chosen_preference') combine_ida_blend
  outline_current_lp, filename("`outputs_folder'/outline_current_lp_old_world.csv")


  noi disp as res _newline "Finished exporting outline of Current Situation."


  *-----------------------------------------------------------------------------
  * Sensitivity Analysis: for the chosen preference ("picture"),
  * varies options to gauge how that influences the global numbers
  *-----------------------------------------------------------------------------

  * Sensitivity analysis: changing reporting window (8, 6 and 4 years)

  foreach year in 2001 2011 2013 2015 {

    * Part 2 countries only
    population_weights, preference(`chosen_preference') timewindow(year_assessment>=`year') countryfilter(lendingtype!="LNX")
    outline_current_lp, filename("`outputs_folder'/outline_SA_lp_`year'_part2.csv") `reps'

    * All countries in the world
    population_weights, preference(`chosen_preference') timewindow(year_assessment>=`year')
    outline_current_lp, filename("`outputs_folder'/outline_SA_lp_`year'_world.csv") `reps'

  }

  noi disp as res _newline "Finished exporting Time Window Sensitivity Tables."

  * Sensitivity analysis: changing the population definitions

  * NOTE: the list of preferences generated as sensitivity analysis is hard numbered
  local preferences_in_SA "1005_1014 1005_10 1005_0516 1005_primary 1005_9plus"
  foreach preference of local preferences_in_SA {

    * Part 2 countries only
    population_weights, preference(`preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")
    outline_current_lp, filename("`outputs_folder'/outline_SA_lp_`preference'_part2.csv") `reps'

    * All countries in the world
    population_weights, preference(`preference') timewindow(year_assessment>=2011)
    outline_current_lp, filename("`outputs_folder'/outline_SA_lp_`preference'_world.csv") `reps'

  }

  noi disp as res _newline "Finished exporting Population Sensitivity Tables."


  *-----------------------------------------------------------------------------
  * Outline of Current Situation with Gender Breakdown
  *-----------------------------------------------------------------------------

  * Part 2 countries only
  * there was a decision to drop MNG and PHL
  population_weights, preference(`chosen_preference') countryfilter(lendingtype!="LNX" & inlist(countrycode,"MNG","PHL")==0) combine_ida_blend
  replace lp_by_gender_is_available = 0 if inlist(countrycode,"MNG","PHL")
  outline_gender_lp, filename("`outputs_folder'/outline_gender_lp_part2.csv") `reps'

  *  All countries in the world
  * there was a decision to drop MNG and PHL
  population_weights, preference(`chosen_preference') countryfilter(inlist(countrycode,"MNG","PHL")==0) combine_ida_blend
  replace lp_by_gender_is_available = 0 if inlist(countrycode,"MNG","PHL")
  outline_gender_lp, filename("`outputs_folder'/outline_gender_lp_world.csv") `reps'

  noi disp as res _newline "Finished exporting outline with Gender Breakdown."


  *-----------------------------------------------------------------------------
  * Quick check on number of countries
  *-----------------------------------------------------------------------------

  * Number of countries we should expect for two pagers
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  gen byte should_have_2pgr = !missing(nonprof_all)
  keep countrycode should_have_2pgr lp_by_gender_is_available


  *-----------------------------------------------------------------------------
  * Combine the stubs to have less files
  *-----------------------------------------------------------------------------
  foreach stub in SA_lp gender_lp current_lp {

    * Retrieves list of stub dtas in the 033_outputs
    local stub_files : dir "`outputs_folder'" files "outline_`stub'_*.dta", respectcase

    * Append all those sensitivity tables in one single dta while erasing them
    clear
    foreach stub_file of local stub_files {

      * Will only keep the bootstrap file, just in case (and not append it)
      if substr("`stub_file'", -7, .) != "_bs.dta" {
        append using "`outputs_folder'/`stub_file'"
      }
      erase "`outputs_folder'/`stub_file'"

    }

    * Add concatenations
    if "`stub'" == "current_lp" gen byte old = strpos(file, "_old_") != 0
    gen byte part2_only = strpos(file, "part2") != 0
    gen str agg_file = aggregated_by + "_" + file
    gen str concatenated = group + "_" + aggregated_by + "_" + file

    * Save combined file
    save "`outputs_folder'/outline_all_`stub'.dta", replace

    * Export table as csv
    // export delimited "`outputs_folder'/outline_all_`stub'.csv", replace

  }


}
