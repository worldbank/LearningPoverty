/*======================================================
Author: Brian Stacy
Modified: Joao Pedro Azevedo

This do file:
Simulations using both Growth Rates Calculated from Spells
=======================================================*
*/
*produce simulation dataset using ado.


cd "${clone}\02_simulation\022_program

/*Execute an ado file to produce the dataset for the simulations.  The configuration for the ado file matches closesly
the configuration for the _preferred_list ado used to produce the raw latest.  This is intentional as
1)Develops database for preferred list
The user must specify a number of options.
(1) preference() - 	which dictates which preference to use for the adjusted proficiency levels.  Current options are 0,1,2,...,926.
(2) specialincludeassess() 	-	which dictate which assessments to specifically include in spell calculations.  This option takes assessment names
(3) specialincludegrade() 	-	which dictate which grades to specifically include in spell calculations.  This option takes grade names
(4) dropgrade() 	-	which dictate which grades to not calculate proficiency levels.  This option takes assessment names
(5) filename()	-	which dictates the name of the file produced to be used in the simulation.
(6) TIMSS_SUBJECT()-dictates either math or science for TIMSS.  either enter string "math" or "science"
(7) enrollment()	-dictates which enrollment to use.  original enrollment, validated, or interpolated for the spells
(8) EGRADROP()	-drop specific EGRAs, 3rd grade, 4th grade, non-nationally representative.
(9) ifspell() - if option to keep these units.  Use regular stata if syntax
(10)ifsim() - if option to keep these units.  Use regular stata if syntax
(11)POPULATION_2015() - enter Yes to fix population at 2015 levels.  e.g. 	_simulation_dataset  ,population_2015(Yes)					///

*/

*Run simulation with tabulations done by region and growth rates calculated using regional growth
_simulation_dataset,    ifspell(if delta_adj_pct > -2 & delta_adj_pct < 4 & year_assessment>2000 & lendingtype!="LNX") ///
            ifwindow(if assess_year>=2011) ///
            ifsim(if lendingtype!="LNX" ) weight(aw=wgt) preference(1001) ///
            specialincludeassess(PIRLS LLECE TIMSS SACMEQ ) specialincludegrade(3 4 5 6) ///
            filename(simfile_preference_1001_regional_growth) ///
            usefile("${clone}/02_simulation/022_program/special_simulation_spells_nopasec_weigthed_pref1000a.md") ///
            timss(science) enrollment(validated) population_2015(No) ///
            groupingsim(region) groupingspells(region) growthdynamics(Yes) ///
            percentile(50(10)90)


*Run simulation with tabulations done by region and growth rates calculated using growth rates by initial poverty level
_simulation_dataset,    ifspell(if delta_adj_pct > -2 & delta_adj_pct < 4 & year_assessment>2000 & lendingtype!="LNX") ///
            ifwindow(if assess_year>=2011) ///
            ifsim(if lendingtype!="LNX" ) weight(aw=wgt) preference(1001) ///
            specialincludeassess( PIRLS LLECE TIMSS SACMEQ ) specialincludegrade(3 4 5 6) ///
            filename(simfile_preference_1001_initial_poverty_level_growth) ///
            usefile("${clone}/02_simulation/022_program/special_simulation_spells_nopasec_weigthed_pref1000a_initial_poverty_level.md") ///
            timss(science) enrollment(validated) population_2015(No) ///
            groupingsim(region) groupingspells(initial_poverty_level) growthdynamics(Yes) ///
            percentile(50(10)90)


*Run simulation with tabulations done by region and growth rates calculated using growth rates by income level
_simulation_dataset,    ifspell(if delta_adj_pct > -2 & delta_adj_pct < 4 & year_assessment>2000 & lendingtype!="LNX") ///
            ifwindow(if assess_year>=2011) ///
            ifsim(if lendingtype!="LNX" ) weight(aw=wgt) preference(1001) ///
            specialincludeassess( PIRLS LLECE TIMSS SACMEQ ) specialincludegrade(3 4 5 6) ///
            filename(simfile_preference_1001_incomelevel_growth) ///
            usefile("${clone}/02_simulation/022_program/special_simulation_spells_nopasec_weigthed_pref1000a_incomelevel.md") ///
            timss(science) enrollment(validated) population_2015(No) ///
            groupingsim(region) groupingspells(incomelevel) growthdynamics(Yes) ///
            percentile(50(10)90)
