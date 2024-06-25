

Documentation of Rawlatest
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Preference 1005 dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
~~~~


About the **68 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode preference
valuevars: adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe population_source population_2015_fe population_2015_ma population_2015_all anchor_population anchor_population_w_assessment
traitvars: idgrade test nla_code subject year_assessment enrollment_flag enrollment_source enrollment_definition min_proficiency_threshold surveyid countryname region regionname region_n_countries region_total_population region_population_w_data region_coverage region_weight adminregion adminregionname adminregion_n_countries adminregion_total_population adminregion_population_w_data adminregion_coverage adminregion_weight incomelevel incomelevelname incomelevel_n_countries incomelevel_total_population incomelevel_population_w_data incomelevel_coverage incomelevel_weight lendingtype lendingtypename lendingtype_n_countries lendingtype_total_population lendingtype_population_w_data lendingtype_coverage lendingtype_weight cmu preference_description lp_by_gender_is_available

. population_weights, preference(${chosen_preference}) timewindow(year_assessment>=${year_assessment}) countryfilter(lendingtype!="LNX"
> )

Learning Poverty Global Number
  preference:   1005
  time window:  year_assessment>=2011
  cty filters:  lendingtype!="LNX"
  # countries:  67

Summary statistics: Mean
Group variable: region (Region Code)

region |             adj_no~l             region~a             region~n
-------+---------------------------------------------------------------
   EAS |                 27.4        130,113,472.0        130,332,944.0
   ECS |                 13.9         20,261,164.0         22,678,264.0
   LCN |                 50.6         47,058,588.0         47,717,460.0
   MEA |                 63.7         22,375,764.0         25,296,212.0
   SAS |                 59.7        171,290,912.0        171,290,912.0
   SSF |                 86.2         58,512,348.0         59,169,712.0
-------+---------------------------------------------------------------
 Total |                 50.9        116,174,190.6        116,672,852.8
-----------------------------------------------------------------------

. population_weights, preference(${chosen_preference}) timewindow(year_assessment>=${year_assessment})

Learning Poverty Global Number
  preference:   1005
  time window:  year_assessment>=2011
  cty filters:  none (WORLD)
  # countries:  105

Summary statistics: Mean
Group variable: region (Region Code)

region |             adj_no~l             region~a             region~n
-------+---------------------------------------------------------------
   EAS |                 25.6        140,471,472.0        140,690,944.0
   ECS |                 10.3         42,657,504.0         45,667,656.0
   LCN |                 50.6         47,058,588.0         47,717,460.0
   MEA |                 59.0         26,560,332.0         29,480,778.0
   NAC |                  8.7         22,578,080.0         22,578,080.0
   SAS |                 59.7        171,290,912.0        171,290,912.0
   SSF |                 86.2         58,512,348.0         59,169,712.0
-------+---------------------------------------------------------------
 Total |                 46.0        112,374,513.4        113,003,200.7
-----------------------------------------------------------------------


~~~~


