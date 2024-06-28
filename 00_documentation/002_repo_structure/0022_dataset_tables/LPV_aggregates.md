

Documentation of Rawlatest
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Preference 1303 dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
~~~~


About the **58 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode preference
valuevars: lpv_all lpv_fe lpv_ma se_ld_all se_ld_ma se_ld_fe min_proficiency_threshold ld_all ldgap_all ldsev_all ld_fe ldgap_fe ldsev_fe ld_ma ldgap_ma ldsev_ma sd_all sd_fe sd_ma ldgap_all ldgap_fe ldgap_ma ldsev_all ldsev_fe ldsev_ma lpgap_all lpgap_fe lpgap_ma lpsev_all lpsev_fe lpsev_ma enrollmentyr population_source population_2019_fe population_2019_ma population_2019_all anchor_population anchor_population_w_assessment anchor_year
traitvars: idgrade test nla_code subject year_assessment enrollment_year anchor_year enrollment_flag enrollment_source enrollment_definition min_proficiency_threshold surveyid countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename cmu preference_description lp_by_gender_is_available toinclude

. population_weights, preference(${chosen_preference}) countryfilter(lendingtype!="LNX")

Learning Poverty Global Number
  preference:   1303
  time window:  
  cty filters:  lendingtype!="LNX"
  # countries:  84

. 
. output_display

--------------------------------------------------------------------------------------
           |                                Indicators                                
 Subgroups |           LPV             LD             SD  Pop. Coverage  Ctry Coverage
-----------+--------------------------------------------------------------------------
       All |          57.1           54.7            9.7           85.7           58.3
region_EAS |          34.1           33.4            1.8           97.9           43.5
region_ECS |          16.6           13.0            4.2           95.3           82.6
region_LCN |          52.2           51.0            3.1           87.7           60.0
region_MEA |          60.5           59.5            4.4           78.1           58.3
region_SAS |          59.7           56.3            9.9           98.2           62.5
region_SSF |          85.9           82.8           22.6           54.5           52.1
--------------------------------------------------------------------------------------

-----------------------------------------------------------------------
           |                         Indicators                        
 Subgroups |  Pop. w/ Data     Total Pop.  Ctrys w/ Data    Total Ctrys
-----------+-----------------------------------------------------------
       All |   531,270,516    619,695,963             84            144
region_EAS |   148,310,186    151,547,107             10             23
region_ECS |    51,228,042     53,763,999             19             23
region_LCN |    46,329,991     52,814,648             18             30
region_MEA |    33,975,233     43,482,175              7             12
region_SAS |   175,379,820    178,522,786              5              8
region_SSF |    76,047,244    139,565,248             25             48
-----------------------------------------------------------------------

. 
. population_weights, preference(${chosen_preference}) 

Learning Poverty Global Number
  preference:   1303
  time window:  
  cty filters:  none (WORLD)
  # countries:  125

. 
. output_display

--------------------------------------------------------------------------------------
           |                                Indicators                                
 Subgroups |           LPV             LD             SD  Pop. Coverage  Ctry Coverage
-----------+--------------------------------------------------------------------------
       All |          52.2           49.8            9.1           86.3           57.6
region_EAS |          32.1           31.3            1.9           97.9           45.9
region_ECS |          12.5            9.2            3.7           95.3           74.1
region_LCN |          52.2           51.0            3.1           87.7           42.9
region_MEA |          56.2           54.9            4.3           78.1           71.4
region_NAC |           9.2            5.4            4.1          100.0           66.7
region_SAS |          59.7           56.3            9.9           98.2           62.5
region_SSF |          85.9           82.8           22.6           54.5           52.1
--------------------------------------------------------------------------------------

-----------------------------------------------------------------------
           |                         Indicators                        
 Subgroups |  Pop. w/ Data     Total Pop.  Ctrys w/ Data    Total Ctrys
-----------+-----------------------------------------------------------
       All |   555,001,689    643,430,491            125            217
region_EAS |   148,310,186    151,547,107             17             37
region_ECS |    51,228,042     53,763,999             43             58
region_LCN |    46,329,991     52,814,648             18             42
region_MEA |    33,975,233     43,482,175             15             21
region_NAC |    23,731,173     23,734,528              2              3
region_SAS |   175,379,820    178,522,786              5              8
region_SSF |    76,047,244    139,565,248             25             48
-----------------------------------------------------------------------


~~~~


