*==============================================================================*
* 0126 SUBTASK: SELECT RAWLATEST FROM RAWFULL AND SUMMARIZE NUMBERS
*==============================================================================*
qui {

  *-----------------------------------------------------------------------------
  * Creates a "picture" of Learning Poverty in all 217 countries
  * with different options on how that "picture" is captured (preferences)
  *-----------------------------------------------------------------------------
  * Preference = 1001
  preferred_list, runname("1001") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1) ///
      enrollment(validated) population(1014) ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1002
  preferred_list, runname("1002") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1) ///
      enrollment(validated) population(1014) ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1003
  preferred_list, runname("1003") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1004
  preferred_list, runname("1004") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1005
  noi disp as err _newline "Chosen preference (representation of Learning Poverty in 2015)"
  noi preferred_list, runname("1005") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") worldalso

  * Chosen preference will be copied as rawlatest (must be generated above)
  global chosen_preference 1005
  copy "${clone}/01_data/013_outputs/preference${chosen_preference}.dta" ///
       "${clone}/01_data/013_outputs/rawlatest.dta", replace

  *-----------------------------------------------------------------------------
  * Sensitivity Analysis: for the chosen preference ("picture"),
  * varies options to gauge how that influences the global numbers
  *-----------------------------------------------------------------------------

  noi disp as err _newline "Sensitivity analysis: Exclude all NLAs"

  * Preference = 1005b
  noi preferred_list, runname("1005b") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(COD MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")  worldalso


  noi disp as err _newline "Sensitivity analysis: change population definitions (1014, 10, primary, 9plus)"

  * Preference = 1005_1014
  noi preferred_list, runname("1005_1014") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1005_10
  noi preferred_list, runname("1005_10") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(10) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1005_primary
  noi preferred_list, runname("1005_primary") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(primary) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")

  * Preference = 1005_9plus
  noi preferred_list, runname("1005_9plus") timss_subject(science) drop_assessment(SACMEQ EGRA) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(9plus) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX")


  noi disp as err _newline "Sensitivity analysis: change reporting window (8, 6 and 4 years)"

  foreach year in 2011 2013 2015 {

    * Displays output for chosen preferences for PART2 countries (`year')
    noi population_weights, preference(1005) timewindow(year_assessment>=`year') countryfilter(lendingtype!="LNX")
    noi sum year_assessment if year_assessment >= `year' & adj_nonprof_all != . & lendingtype!="LNX"

    * Displays output for chosen preferences for WORLD (`year')
    noi population_weights, preference(1005) timewindow(year_assessment>=`year')
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
