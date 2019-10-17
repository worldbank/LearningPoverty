*==============================================================================*
* 0322 SUBTASK: GENERATE GENDER TABLES FOR TECHNICAL PAPER
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference


  *-----------------------------------------------------------------------------
  * Creates CSV sheets for Excel with Tables for Glossy
  * (as a cross-check with put_to_excel)
  *-----------------------------------------------------------------------------

  * Tables 5 and 6 - PART2
  population_weights, preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")
  table56, filename("${clone}/03_export_tables/033_outputs/viz_tab56_part2.csv")

  * Tables 5 and 6 - WORLD
  population_weights, preference(`chosen_preference') timewindow(year_assessment>=2011)
  table56, filename("${clone}/03_export_tables/033_outputs/viz_tab56_world.csv")

  * Table 7 (gender) - PART2
  population_weights, preference(`chosen_preference') countryfilter(lendingtype!="LNX")
  table7, filename("${clone}/03_export_tables/033_outputs/viz_tab7_part2.csv")

  * Table 7 (gender) - PART2 DROPPING MNG and PHL
  population_weights, preference(`chosen_preference') countryfilter(lendingtype!="LNX" & inlist(countrycode,"MNG","PHL")==0)
  replace lp_by_gender_is_available = 0 if inlist(countrycode,"MNG","PHL")
  table7, filename("${clone}/03_export_tables/033_outputs/viz_tab7_part2_no_MNG_PHL.csv")

  * Table 7 (gender) - WORLD
  population_weights, preference(`chosen_preference')
  table7, filename("${clone}/03_export_tables/033_outputs/viz_tab7_world.csv")

  * Table 7 (gender) - WORLD DROPPING MNG and PHL
  population_weights, preference(`chosen_preference') countryfilter(inlist(countrycode,"MNG","PHL")==0)
  replace lp_by_gender_is_available = 0 if inlist(countrycode,"MNG","PHL")
  noi tab countrycode if enrollment_flag == 1 & lp_by_gender_is_available == 1
  table7, filename("${clone}/03_export_tables/033_outputs/viz_tab7_world_no_MNG_PHL.csv")

  * Number of countries we should expect for two pagers
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  gen byte should_have_2pgr = !missing(nonprof_all)
  keep countrycode should_have_2pgr lp_by_gender_is_available
  export delimited "${clone}/03_export_tables/033_outputs/viz_countrylist.csv", replace

  noi disp as res _newline "Finished exporting Tables 5/6 and 7 to csv."

  *-----------------------------------------------------------------------------
  * Sensitivity Analysis: for the chosen preference ("picture"),
  * varies options to gauge how that influences the global numbers
  *-----------------------------------------------------------------------------

  noi disp as res _newline "Sensitivity analysis: changing reporting window (8, 6 and 4 years)"

  foreach year in 2011 2013 2015 {

    * Displays output for chosen preferences for PART2 countries (`year')
    noi population_weights, preference(`chosen_preference') timewindow(year_assessment>=`year') countryfilter(lendingtype!="LNX")
    table56, filename("${clone}/03_export_tables/033_outputs/viz_SA_1005_`year'_part2.csv")

    * Displays output for chosen preferences for WORLD (`year')
    noi population_weights, preference(`chosen_preference') timewindow(year_assessment>=`year')
    table56, filename("${clone}/03_export_tables/033_outputs/viz_SA_1005_`year'_world.csv")

  }

  * NOTE: the list of preferences generated as sensitivity analysis is hard numbered
  local preferences_in_SA "1005 1005b 1005_1014 1005_10 1005_primary 1005_9plus"
  foreach preference of local preferences_in_SA {

    * Tables 5 and 6 - PART2
    population_weights, preference(`preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")
    table56, filename("${clone}/03_export_tables/033_outputs/viz_SA_`preference'_part2.csv")

    * Tables 5 and 6 - WORLD
    population_weights, preference(`preference') timewindow(year_assessment>=2011)
    table56, filename("${clone}/03_export_tables/033_outputs/viz_SA_`preference'_world.csv")

  }

  * Retrieves list of sensitivity dtas in the 033_outputs
  local SA_files : dir "${clone}/03_export_tables/033_outputs/" files "viz_SA_*.dta", respectcase
  * Append all those sensitivity tables in one single dta
  touch "${clone}/03_export_tables/033_outputs/viz_SA_all.dta", replace
  foreach SA_file of local SA_files {
    append using "${clone}/03_export_tables/033_outputs/`SA_file'"
    save "${clone}/03_export_tables/033_outputs/viz_SA_all.dta", replace
  }

  * Add concatenation
  gen str concatenated = group + "-" + aggregated_by + "-" + file

  * Export table as csv
  export delimited "${clone}/03_export_tables/033_outputs/viz_SA_all.csv", replace

  noi disp as res _newline "Finished exporting Sensitivity Tables."


}
