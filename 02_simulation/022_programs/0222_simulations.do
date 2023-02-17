*==============================================================================*
* 0222 SUBTASK: RUN SIMULATIONS USING GROWTH RATES FROM SPELLS
*==============================================================================*

local chosen_preference = $chosen_preference

/*
Mandatory parameters:
 - filename : prefix for which resulting dtas will be named (saved in 023_outputs)
 - groupingspells : group on which benchmarking spells are assigned (region | incomelevel | initial_poverty_level)
 - usefile : an md with spells provided per groups as defined in groupingspells (full path should be used)
 - preference : starting point for the simulation

Optional parameters (no default):
 - countryfilter : filter on the aggregation provided, applied to the starting point as in population_weights (ie: lendingtype!="LNX")
 - timewindow : filter on the assessments at starting point considered, as in population_weights (ie: year_assessment>=2011)
 - ifspell : filter on all_spells.dta (ie: if used_sim == 1)

Optional parameters (with default):
 - minspell : default to 1 if ommitted. The minimum number of country own spells to avoid overwritting with group value
 - percentile : default to 50(10)90 if omitted. All values must be available in the usefile
 - groupingsim : default is region. Does not need to match the groupingspells, and it only matters for displaying results
 - quiet : default is to display main results, use this option to quiet it fully
*/


* PREFERRED SIMULATION

* Run simulation with tabulations done by region and growth rates calculated using regional growth
simulate_learning_poverty, ifspell(if used_sim == 1) ///
  preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") ///
  filename(simfile_preference_`chosen_preference'_regional_growth) groupingspells(region)  ///
  usefile("${clone}/02_simulation/021_rawdata/simulation_spells_weighted_region.md") ///


* SENSITIVITY CHECKS ON SPELLS SELECTION

* Same as main one, but with minspell = 2 instead of 1
simulate_learning_poverty, ifspell(if used_sim == 1) minspell(2) ///
  preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") ///
  filename(simfile_preference_`chosen_preference'_regional_growth_min2) groupingspells(region)  ///
  usefile("${clone}/02_simulation/021_rawdata/simulation_spells_weighted_region.md")

* Same as above, but using the spells that were in the Glossy
simulate_learning_poverty, ifspell(if glossy_sim == 1) minspell(2) ///
  preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") ///
  filename(simfile_preference_`chosen_preference'_regional_growth_glossy) groupingspells(region)  ///
  usefile("${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_glossy_sim_weighted_region.md")


* SENSITIVITY CHECKS ON MECHANICS OF GROWTH RATE

* Run simulation with growth rates calculated using income level growth
simulate_learning_poverty, ifspell(if used_sim == 1) ///
  preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") ///
  filename(simfile_preference_`chosen_preference'_income_level) groupingspells(incomelevel)  ///
  usefile("${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_weighted_incomelevel.md")

* Run simulation with growth rates calculated using initial learning poverty
simulate_learning_poverty, ifspell(if used_sim == 1) ///
  preference(`chosen_preference') timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") ///
  filename(simfile_preference_`chosen_preference'_initial_poverty_level) groupingspells(initial_poverty_level)  ///
  usefile("${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_weighted_initial_poverty_level.md")


exit
