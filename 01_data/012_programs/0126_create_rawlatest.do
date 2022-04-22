*==============================================================================*
* 0126 SUBTASK: SELECT RAWLATEST FROM RAWFULL AND SUMMARIZE NUMBERS
*==============================================================================*
qui {

  *-----------------------------------------------------------------------------
  * Creates a "picture" of Learning Poverty in all 217 countries
  * with different options on how that "picture" is captured (preferences)
  *-----------------------------------------------------------------------------
 
  * Preference = 1104 = Adds SEA-PLM 2019 & TIMSS 2019 & semi-update window
  local pref1104 "Preference 1104 = Adds TIMSS 2019 & SEA-PLM 2019 (replacing NLAs from KHM, MYS, PAK, VNM) & centered in 2017 (keep start 2011)"
  noi preferred_list, runname("1104") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1105 = Adds SEA-PLM 2019 & TIMSS 2019 & full-update window
  local pref1105 "Preference 1105 = Adds TIMSS 2019 & SEA-PLM 2019 (replacing NLAs from KHM, MYS, PAK, VNM) & centered in 2017 (start 2013)"
  noi preferred_list, runname("1105") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")

  * Preference = 1106 = Remove the fake LLECE
  local pref1106 "Preference 1106 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019 (replacing NLAs from KHM, MYS, PAK, VNM) & centered in 2017 (start 2013)"
  noi preferred_list, runname("1106") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")
      
   * Preference = 1107 = Adds Mali's "fake" NLA back in since no PASEC 2019 data for Mali
  local pref1107 "Preference 1107 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019 (replacing NLAs from KHM, MYS, PAK, VNM) & centered in 2017 (start 2013)"
  noi preferred_list, runname("1107") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")
      
   * Preference = 1108 = Using NLA 2014 for Pakistan instead of TIMSS 2019
  local pref1108 "Preference 1108 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2017 (start 2013)"
  noi preferred_list, runname("1108") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")


  *-----------------------------------------------------------------------------
  * Create RAWLATEST
  *-----------------------------------------------------------------------------
  * Chosen preference will be copied as rawlatest (must be generated above)
  global chosen_preference 1108
  copy "${clone}/01_data/013_outputs/preference${chosen_preference}.dta" ///
       "${clone}/01_data/013_outputs/rawlatest.dta", replace


  *-----------------------------------------------------------------------------
  * Sensitivity Analysis: for the chosen preference ("picture"),
  * varies options to gauge how that influences the global numbers
  *-----------------------------------------------------------------------------

  noi disp as err _newline "Sensitivity analysis: Exclude all NLAs"

  * Preference = 1108b
  noi preferred_list, runname("1108b") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(COD MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX") worldalso


  noi disp as err _newline "Sensitivity analysis: change population definitions (1014, 10, 0516, primary, 9plus)"

  * Preference = 1108_1014
  noi preferred_list, runname("1108_1014") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")

  * Preference = 1108_10
  noi preferred_list, runname("1108_10") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(10) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")

  * Preference = 1108_0516
  noi preferred_list, runname("1108_0516") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(0516) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")

  * Preference = 1108_primary
    noi preferred_list, runname("1108_primary") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(primary) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")
  
  * Preference = 1108_9plus
  noi preferred_list, runname("1108_9plus") timss_subject(science) drop_assessment(SACMEQ EGRA) drop_round(LLECE_2018) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(9plus) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=2013) countryfilter(lendingtype!="LNX")

  *-----------------------------------------------------------------------------

  noi disp as err _newline "Sensitivity analysis: change reporting window (Latest available, 8, 6 and 4 years)"

  foreach year in 2001 2011 2013 2015 {

    * Displays output for chosen preferences for PART2 countries (`year')
    noi population_weights, preference(1108) timewindow(year_assessment>=`year') countryfilter(lendingtype!="LNX")
    noi sum year_assessment if year_assessment >= `year' & adj_nonprof_all != . & lendingtype!="LNX"

    * Displays output for chosen preferences for WORLD (`year')
    noi population_weights, preference(1108) timewindow(year_assessment>=`year')
    noi sum year_assessment if year_assessment >= `year' & adj_nonprof_all != .
  }
}


exit


 /*------------------------------------------------------------------------------------------
  * This part is totally unnecessary, but is nice to have for error checking
  *------------------------------------------------------------------------------------------
  * Shortcuts of checks for gender disaggregation
  bys region: tab countrycode if lp_by_gender_is_available
  noi disp _newline "Part 2 countries in EAS with gender split, before forced drops"
  noi tab countrycode if lp_by_gender_is_available & region == "EAS" & lendingtype!="LNX"

  * Reassurance that we have the number of countries we expect
  use "${clone}/01_data/013_outputs/preference1005.dta", replace
  gen byte checkme = year_assessment>=2011 & !missing(adj_nonprof_all) & lendingtype!="LNX"
  noi disp _newline as err "Quick check that should say we have 62 countries"
  noi tab checkme

	* Compare two preferences
	local path "${clone}/01_data/013_outputs/"
	edukit_comparefiles, localfile("`path'/preference1005.dta") sharedfile("`path'/preference1005_LATERYEAR.dta") compareboth idvars(countrycode)
	// wigglevars(enrollment_fe enrollment_ma) wiggleroom(.01)
  *------------------------------------------------------------------------------------------*/
