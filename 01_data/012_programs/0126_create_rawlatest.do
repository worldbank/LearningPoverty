*==============================================================================*
* 0126 SUBTASK: SELECT RAWLATEST FROM RAWFULL AND SUMMARIZE NUMBERS
*==============================================================================*

  local timewindow 			= ${timewindow}

qui {

  *-----------------------------------------------------------------------------
  * Creates a "picture" of Learning Poverty in all 217 countries
  * with different options on how that "picture" is captured (preferences)
  *-----------------------------------------------------------------------------

  *-----------------------------------------------------------------------------
  * Preference = 1005
  // this value is 53.1 and not 52.7 becuase of the India country team request to adjust the primary enrollment 
  // rate from 97.73 to 94.88
  *-----------------------------------------------------------------------------
  /*
  Learning Poverty Global Number
  preference:   1005
  time window:  year_assessment>=2011
  cty filters:  lendingtype!="LNX"
  # countries:  62
Summary statistics: Mean
Group variable: region (Region Code)
region |             adj_no~l             region~a             region~n
-------+---------------------------------------------------------------
   EAS |                 21.2        119,064,336.0        137,060,544.0
   ECS |                 13.3         20,018,286.0         27,044,896.0
   LCN |                 50.8         47,141,204.0         53,347,000.0
   MEA |                 63.3         22,375,764.0         32,533,278.0
   SAS |                 58.2        171,290,912.0        174,647,840.0
   SSF |                 86.7         56,789,448.0        123,159,024.0
-------+---------------------------------------------------------------
 Total |                 52.7        104,077,595.5        126,126,842.5
-----------------------------------------------------------------------*/

  *******************************
  * rawlatest_aggregate 
  noi disp as err _newline "Chosen preference (representation of Learning Poverty in 2015)"
  noi preferred_list, runname("1005") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET AMPLB SEA-PLM) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECES CHL_2013_LLECES COL_2013_LLECES") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") dropctryyr("CUB_2019_LLECET" CHL_2011_TIMSS CHL_2015_TIMSS HND_2011_TIMSS COL_2011_PIRLS  CHL_2016_PIRLS HND_2011_PIRLS ) yrmax(2018) ///
	  anchoryear(2015) enrollmentyr(adjust) yrmax(2019) full world coverage rawlatest(yes)
	  


  *******************************
  noi disp as err _newline "Sensitivity analysis: change population definitions (1014, 10, 0516, primary, 9plus)"
 
  foreach pop in "1014" "10" "0516" "primary" "9plus" {
  
	noi disp as err _newline "Chosen preference (representation of Learning Poverty in 2015)"
	noi preferred_list, runname("1005_`pop'") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET AMPLB SEA-PLM) ///
		  nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
		  enrollment(validated) population(`pop') exception("HND_2013_LLECES CHL_2013_LLECES COL_2013_LLECES") ///
		  timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") dropctryyr("CUB_2019_LLECET" CHL_2011_TIMSS CHL_2015_TIMSS HND_2011_TIMSS COL_2011_PIRLS  CHL_2016_PIRLS HND_2011_PIRLS ) yrmax(2018) ///
		  anchoryear(2015) enrollmentyr(adjust) full world coverage
  }
	  
  *******************************
tab surveyid if lendingtype!="LNX" & region == "MEA"	  

tab surveyid if lendingtype!="LNX" & region == "LCN"	  
	  
	  
tab surveyid if lendingtype!="LNX" & region == "SAS"	  
	  
	  
  *******************************
  * use CHL TIMMS Scie 2011
  noi disp as err _newline "Chosen preference (representation of Learning Poverty in 2015)"
  noi preferred_list, runname("1005b") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET AMPLB SEA-PLM) ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 PAK_3 LKA_3 VNM_1 UGA_2 ETH_3 COD KHM_1 MYS_1 KGZ_1 MDG_1 MLI_1) ///
      enrollment(validated) population(1014) exception("HND_2013_LLECES CHL_2013_LLECES COL_2013_LLECES") ///
      timewindow(year_assessment>=2011) countryfilter(lendingtype!="LNX") dropctryyr("CUB_2019_LLECET"  CHL_2015_TIMSS HND_2011_TIMSS COL_2011_PIRLS  CHL_2016_PIRLS HND_2011_PIRLS ) yrmax(2018) ///
	  anchoryear(2015) enrollmentyr(adjust) full world coverage


tab surveyid if lendingtype!="LNX" & region == "LCN"	


  /*-----------------------------------------------------------------------------
  * Preference = 1108 = Using NLA 2014 for Pakistan instead of TIMSS 2019
  *-----------------------------------------------------------------------------

  Learning Poverty Global Number
  preference:   1108
  time window:  year_assessment>=2013
  cty filters:  lendingtype!="LNX"
  # countries:  64
Summary statistics: Mean
Group variable: region (Region Code)
region |             adj_no~l             region~a             region~n
-------+---------------------------------------------------------------
   EAS |                 34.7        131,180,760.0        137,035,056.0
   ECS |                 10.5         20,098,958.0         28,076,356.0
   LCN |                 50.7         46,292,376.0         52,392,848.0
   MEA |                 57.9         18,847,764.0         33,506,664.0
   SAS |                 59.7        172,166,144.0        175,352,128.0
   SSF |                 85.8         59,016,372.0        130,017,848.0
-------+---------------------------------------------------------------
 Total |                 56.2        106,870,067.8        127,767,873.7
-----------------------------------------------------------------------*/

  local pref1108 "Preference 1108 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2017 (start 2013)"
  noi preferred_list, runname("1108") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET AMPLB)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) drop_round(2019_LLECES)   ///
      enrollment(validated) population(1014) exception("HND_2013_LLECE CHL_2013_LLECE COL_2013_LLECE PHL_2019_SEA-PLM PAK_2014_NLA") ///
      countryfilter(lendingtype!="LNX") dropctryyr("CUB_2019_LLECET"  CHL_2019_TIMSS   CHL_2015_TIMSS HND_2011_TIMSS COL_2011_PIRLS  CHL_2016_PIRLS)  ///
	  anchoryear(2018) enrollmentyr(adjust) yrmin(2012) world rawlatest(yes)

tab surveyid if lendingtype!="LNX" & region == "LCN"	


  *-----------------------------------------------------------------------------
  * Preference = 1201 = Using NLA 2014 for Pakistan instead of TIMSS 2019
  *-----------------------------------------------------------------------------
  local pref1201 "Preference 1201 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014)"
  noi preferred_list, runname("1201") timss_subject(science) drop_assessment(SACMEQ EGRA AMPLB LLECET)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=${timewindow}) countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES") worldalso
      
   * Preference = 1201 = Using NLA 2014 for Pakistan instead of TIMSS 2019
  local pref1201 "Preference 1201 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014)"
  noi preferred_list, runname("1201") timss_subject(science) drop_assessment(SACMEQ EGRA AMPLB LLECES)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECET PHL_2019_SEA-PLM PAK_2014_NLA") ///
      timewindow(year_assessment>=${timewindow}) countryfilter(lendingtype!="LNX") dropctryyr("CUB_2019_LLECET") worldalso

  *-----------------------------------------------------------------------------
  *    * Preference = 1202 = Using NLA 2014 for Pakistan instead of TIMSS 2019 + ZMB_2021_AMPLB
  *-----------------------------------------------------------------------------
* CHL_2013_LLECES and no TUN_2011_TIMSS and YEM_2011_TIMSS

  local pref1202 "Preference 1202 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014) & AMPLB for ZWB"
  noi preferred_list, runname("1202") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA ZMB_2021_AMPLB  ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "PHL_2019_TIMSS" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"   CHL_2019_TIMSS  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS ROU_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS  MLI_2012_NLA  ROU_2011_TIMSS  BIH_2019_TIMSS   XKX_2019_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB) anchoryear(2019) enrollmentyr(adjust) yrmin(2012) yrmax(2021) world

* replace CHL_2013_LLECES by CHL_2019_TIMSS and include TUN_2011_TIMSS and YEM_2011_TIMSS
	  
  local pref1203 "Preference 1203 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014) & AMPLB for ZWB"
  noi preferred_list, runname("1203") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA ZMB_2021_AMPLB ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "PHL_2019_TIMSS" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS ROU_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS  MLI_2012_NLA  ROU_2011_TIMSS  BIH_2019_TIMSS   XKX_2019_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB) anchoryear(2019) enrollmentyr(adjust) yrmin(2011) yrmax(2021) full world coverage

* local pref1204 "Preference 1204 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014) & AMPLB for ZWB"
  * noi preferred_list, runname("1204") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      * nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3 LSO NPL ) ///
      * enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA ZMB_2021_AMPLB ") ///
      * countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "PHL_2019_TIMSS" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS ROU_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS  MLI_2012_NLA  ROU_2011_TIMSS  BIH_2019_TIMSS   XKX_2019_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB) ///
	  * anchoryear(2019) enrollmentyr(adjust) yrmin(2011) yrmax(2021) full world coverage


  *-----------------------------------------------------------------------------
  *    * Preference = 1205 = no nepal policy linking
  *-----------------------------------------------------------------------------
/*

	Learning Poverty Global Number
	  preference:   1205
	  time window:  
	  cty filters:  lendingtype!="LNX"
	  # countries:  69

	--------------------------------------------------------------------------------------
			   |                                Indicators                                
	 Subgroups |           LPV             LD             SD  Pop. Coverage  Ctry Coverage
	-----------+--------------------------------------------------------------------------
		   All |          57.0           54.6           90.3           81.9           47.9
	region_EAS |          34.5           33.9           98.2           94.9           34.8
	region_ECS |          10.4            7.2           96.5           82.1           60.9
	region_LCN |          52.3           51.0           96.9           87.9           56.7
	region_MEA |          63.4           62.3           95.2           71.1           50.0
	region_SAS |          59.8           56.0           89.7           98.2           62.5
	region_SSF |          86.3           83.3           78.1           47.3           39.6
	--------------------------------------------------------------------------------------

	-----------------------------------------------------------------------
			   |                         Indicators                        
	 Subgroups |  Pop. w/ Data     Total Pop.  Ctrys w/ Data    Total Ctrys
	-----------+-----------------------------------------------------------
		   All |   498,970,599    609,609,067             69            144
	region_EAS |   143,007,941    150,635,306              8             23
	region_ECS |    44,246,228     53,892,228             14             23
	region_LCN |    46,134,881     52,481,358             17             30
	region_MEA |    28,536,920     40,160,014              6             12
	region_SAS |   172,236,920    175,311,745              5              8
	region_SSF |    64,807,709    137,128,416             19             48
	-----------------------------------------------------------------------

*/
*******************************
* rawlatest_aggregate 
local pref1205 "Preference 1205 = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014) & AMPLB for ZWB"
  noi preferred_list, runname("1205") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3 LSO ) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA ZMB_2021_AMPLB WLD_2021_PIRLS") ///
      countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "PHL_2019_TIMSS" "CHL_2016_PIRLS"  "CHL_2015_TIMSS" "HND_2011_PIRLS" "COL_2011_PIRLS" "HND_2011_TIMSS" "IDN_2011_PIRLS" "THA_2011_TIMSS" "HRV_2011_PIRLS" "ROU_2011_PIRLS" "BWA_2011_PIRLS" "BWA_2011_TIMSS" "MLI_2012_NLA" "ROU_2011_TIMSS" "BIH_2019_TIMSS" "XKX_2019_TIMSS" "BDI_2019_AMPLB" "BFA_2019_AMPLB" "CIV_2019_AMPLB" "SEN_2019_AMPLB") ///
	  oldreport("THA_2011_TIMSS" "ROU_2011_PIRLS" "BWA_2011_PIRLS" "MLI_2012_NLA") ///
	  anchoryear(2019) enrollmentyr(adjust) yrmin(2011) yrmax(2019) full world coverage rawlatest(yes)

 *-----------------------------------------------------------------------------
* Preference = 1301 Update with PIRLS 2021 Data
*-----------------------------------------------------------------------------

*******************************
* Thailand (TIMSS - 2011) and Botsowana (PIRLS -2011) is included in rawlatest:
* ROU_2011_PIRLS - exception - Removed
* MLI_2012_NLA - exception - Removed
* Preference 1301: Identical parameters as 1205, with addition of PIRLS 2021 countries for all participants	  
local pref1301 "Preference 1301 = Adds PIRLS 2021 & centered in 2019 (start 2014) & AMPLB for ZWB, Enrollment year is updated to latest available"
  noi preferred_list, runname("1301") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3 LSO ) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA ZMB_2021_AMPLB ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "PHL_2019_TIMSS" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS ROU_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS  MLI_2012_NLA  ROU_2011_TIMSS  BIH_2019_TIMSS  BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB) ///
	  anchoryear(2019) enrollmentyr(adjust) yrmin(2011) yrmax(2021) full world coverage
	 
*------------------------------------------------------------------------------
* Preference = 1302 Update with PIRLS 2021 Data, Brazil using LLECE 2019
*-----------------------------------------------------------------------------
local pref1302 "Preference 1302 = Adds PIRLS 2021 except Brazil & centered in 2019 (start 2014) & AMPLB for ZMB, Enrollment year is updated to latest available"
  noi preferred_list, runname("1302") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN BGD_3 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_3 LSO ) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PAK_2014_NLA ZMB_2021_AMPLB ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("BRA_2021_PIRLS" "CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS BIH_2019_TIMSS ROU_2011_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB) ///
	  	  oldreport("THA_2011_TIMSS" "ROU_2011_PIRLS" "BWA_2011_PIRLS" "MLI_2012_NLA") ///
	  anchoryear(2019) enrollmentyr(adjust) yrmin(2011) yrmax(2021) full world coverage
	  
	  
*-----------------------------------------------------------------------------
* Preference = 1303 Update with PIRLS 2021 Data, Brazil using LLECE 2019 + China 2019 NLA, PAK 2019 PL. Also includes Bolivia 2017, Include BIH (TIMSS) and XKX (PIRLS) which now has enr data
* Added an option here that saves rawlatest if rawlatest(yes) is specified
*-----------------------------------------------------------------------------
local pref1303 "Preference 1303 = Adds PIRLS 2021 except Brazil & centered in 2019 (start 2014) & AMPLB for ZMB, Enrollment year is updated to latest available"
  noi preferred_list, runname("1303") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN_1 BGD_4 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_4 KEN_1 LSO) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PAK_2014_NLA ZMB_2021_AMPLB ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("BRA_2021_PIRLS" "CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS ROU_2011_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB PHL_2019_TIMSS) ///
	  oldreport("THA_2011_TIMSS" "ROU_2011_PIRLS" "BWA_2011_PIRLS" "MLI_2012_NLA") ///
	  anchoryear(2019) enrollmentyr(adjust) yrmin(2011) full world coverage rawlatest(yes)
	  


  /*-----------------------------------------------------------------------------
  * Create RAWLATEST AGGREGATE
  *-----------------------------------------------------------------------------*/
  * Chosen preference will be copied as rawlatest (must be generated above)
  global chosen_preference 	1303
  global year_assessment	2014
  copy "${clone}/01_data/013_outputs/preference${chosen_preference}.dta" ///
       "${clone}/01_data/013_outputs/rawlatest_aggregate.dta", replace

  /*-----------------------------------------------------------------------------
  * Create RAWLATEST
  *-----------------------------------------------------------------------------*/
  * Chosen preference will be copied as rawlatest (must be generated above)
  global chosen_preference 	1303
  global year_assessment	2014
  copy "${clone}/01_data/013_outputs/preference${chosen_preference}.dta" ///
       "${clone}/01_data/013_outputs/rawlatest.dta", replace


  /*-----------------------------------------------------------------------------
  * Sensitivity Analysis: for the chosen preference ("picture"),
  * varies options to gauge how that influences the global numbers
  *-----------------------------------------------------------------------------*/


  * Preference = 1202b = Using NLA 2014 for Pakistan instead of TIMSS 2019 + ZMB_2021_AMPLB

  noi disp as err _newline "Sensitivity analysis: Exclude all NLAs"
	
	local pref1205b "Preference 1205b = Adds PASEC 2019, TIMSS 2019, SEA-PLM 2019, LLECE 2019 (replacing NLAs from KHM, MYS, VNM) & centered in 2019 (start 2014) & AMPLB for ZWB"
  noi preferred_list, runname("1205b") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PHL_2019_SEA-PLM PAK_2014_NLA ZMB_2021_AMPLB ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "PHL_2019_TIMSS" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS ROU_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS  MLI_2012_NLA  ROU_2011_TIMSS  BIH_2019_TIMSS   XKX_2019_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB) ///
	  anchoryear(2019) enrollmentyr(adjust) yrmin(2011) yrmax(2021) full world coverage
	  
	
	
  * Populations of reference

  noi disp as err _newline "Sensitivity analysis: change population definitions (1014, 10, 0516, primary, 9plus)"
 
  foreach pop in "1014" "10" "0516" "primary" "9plus" {

	  local pref1303 "Preference 1303 = Adds PIRLS 2021 except Brazil & centered in 2019 (start 2014) & AMPLB for ZMB, Enrollment year is updated to latest available"
  noi preferred_list, runname("1303_`pop'") timss_subject(science) drop_assessment(SACMEQ EGRA LLECET)  ///
      nla_keep(AFG_2 CHN_1 BGD_4 IND_4 LKA_3 UGA_2 ETH_3 KGZ_1 MLI_1 PAK_4 KEN_1) ///
      enrollment(validated) population(1014) exception("CHL_2013_LLECES PAK_2014_NLA ZMB_2021_AMPLB ") ///
      countryfilter(lendingtype!="LNX") dropctryyr("BRA_2021_PIRLS" "CUB_2006_LLECES" "BDI_2021_AMPLB" "BFA_2021_AMPLB" "SEN_2021_AMPLB" "CIV_2021_AMPLB" "CHL_2016_PIRLS"  "CHL_2015_TIMSS"  HND_2011_PIRLS  COL_2011_PIRLS  HND_2011_TIMSS  IDN_2011_PIRLS  THA_2011_TIMSS HRV_2011_PIRLS BWA_2011_PIRLS  BWA_2011_TIMSS ROU_2011_TIMSS BDI_2019_AMPLB BFA_2019_AMPLB CIV_2019_AMPLB SEN_2019_AMPLB PHL_2019_TIMSS) ///
	  oldreport("THA_2011_TIMSS" "ROU_2011_PIRLS" "BWA_2011_PIRLS" "MLI_2012_NLA") ///
	  anchoryear(2019) enrollmentyr(adjust) yrmin(2011) full world coverage 
	  

  }
  
  

  *-----------------------------------------------------------------------------

  noi disp as err _newline "Sensitivity analysis: change reporting window (Latest available, 8, 6 and 4 years)"

  foreach year in 2001 2011 2013 2015 2016 2017 {

    * Displays output for chosen preferences for PART2 countries (`year')
    noi population_weights, preference(${chosen_preference}) timewindow(year_assessment>=`year') countryfilter(lendingtype!="LNX")
    noi sum year_assessment if year_assessment >= `year' & lpv_all != . & lendingtype!="LNX"

    * Displays output for chosen preferences for WORLD (`year')
    noi population_weights, preference(${chosen_preference}) timewindow(year_assessment>=`year')
    noi sum year_assessment if year_assessment >= `year' & lpv_all != .
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
