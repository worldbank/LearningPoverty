

Documentation of Rawlatest
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Preference 1205 dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions.

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
  preference:   1205
  time window:  
  cty filters:  lendingtype!="LNX"
  # countries:  69

. 
. output_display

--------------------------------------------------------------------------------------
           |                                Indicators                                
 Subgroups |           LPV             LD             SD  Pop. Coverage  Ctry Coverage
-----------+--------------------------------------------------------------------------
       All |          57.0           54.6            9.7           81.9           47.9
region_EAS |          34.5           33.9            1.8           94.9           34.8
region_ECS |          10.4            7.2            3.5           82.1           60.9
region_LCN |          52.3           51.0            3.1           87.9           56.7
region_MEA |          63.4           62.3            4.8           71.1           50.0
region_SAS |          59.8           56.0           10.3           98.2           62.5
region_SSF |          86.3           83.3           21.9           47.3           39.6
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

. 
. population_weights, preference(${chosen_preference}) 

Learning Poverty Global Number
  preference:   1205
  time window:  
  cty filters:  none (WORLD)
  # countries:  107

. 
. output_display

--------------------------------------------------------------------------------------
           |                                Indicators                                
 Subgroups |           LPV             LD             SD  Pop. Coverage  Ctry Coverage
-----------+--------------------------------------------------------------------------
       All |          51.9           49.6            8.9           82.5           49.3
region_EAS |          32.4           31.6            1.9           94.9           40.5
region_ECS |           8.6            5.5            3.3           82.1           60.3
region_LCN |          52.3           51.0            3.1           87.9           40.5
region_MEA |          58.7           57.5            4.4           71.1           66.7
region_NAC |           4.3            3.9            0.3          100.0           66.7
region_SAS |          59.8           56.0           10.3           98.2           62.5
region_SSF |          86.3           83.3           21.9           47.3           39.6
--------------------------------------------------------------------------------------

-----------------------------------------------------------------------
           |                         Indicators                        
 Subgroups |  Pop. w/ Data     Total Pop.  Ctrys w/ Data    Total Ctrys
-----------+-----------------------------------------------------------
       All |   522,048,431    632,686,899            107            217
region_EAS |   143,007,941    150,635,306             15             37
region_ECS |    44,246,228     53,892,228             35             58
region_LCN |    46,134,881     52,481,358             17             42
region_MEA |    28,536,920     40,160,014             14             21
region_NAC |    23,077,832     23,077,832              2              3
region_SAS |   172,236,920    175,311,745              5              8
region_SSF |    64,807,709    137,128,416             19             48
-----------------------------------------------------------------------


~~~~


