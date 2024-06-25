
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

. codebook, compact

Variable      Obs Unique       Mean       Min       Max  Label
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   217    217          .         .         .  WB country code (3 letters)
preference    217      1          .         .         .  Preference
lpv_all       125    125    41.6979  2.330513  98.50421  Learning Poverty (all)
lpv_fe         82     82   34.84442  2.031479       100  Learning Poverty (fe)
lpv_ma         82     82   38.82107  2.451698  98.12722  Learning Poverty (ma)
se_ld_all      43     43    1.28778  .1297758  2.651935  SE of pupils below minimum proficiency (all)
se_ld_ma       42     42   1.499661  .2211475  2.757465  SE of pupils below minimum proficiency (ma)
se_ld_fe       42     42   1.534117  .1777982  3.085637  SE of pupils below minimum proficiency (fe)
min_profic~d  126     12          .         .         .  Minimum Proficiency Threshold (assessment-specific)
ld_all        126    126   38.91174  .7973636  98.24239  Learning Deprivation (all)
ldgap_all      95     95   14.61289  4.391868   51.9554  Learning Deprivation Gap (all)
ldsev_all      95     95   4.031541  .3408805  33.31398  Learning Deprivation Severity (all)
ld_fe         100    100   30.25715  .8080508  97.00749  Learning Deprivation (fe)
ldgap_fe       95     95   13.94138  4.262402  48.20448  Learning Deprivation Gap (fe)
ldsev_fe       95     95   3.667004  .3176738  29.36567  Learning Deprivation Severity (fe)
ld_ma         100    100   34.48284  .7871103  97.97008  Learning Deprivation (ma)
ldgap_ma       95     95   15.09789  4.487056  54.45552  Learning Deprivation Gap (ma)
ldsev_ma       95     95   4.302532  .3579716  35.94563  Learning Deprivation Severity (ma)
sd_all        125    123    7.20174         0  63.19589  Schooling Deprivation (all)
sd_fe         104    102   8.681906         0       100  Schooling Deprivation (fe)
sd_ma         104    102    7.32165         0  62.28584  Schooling Deprivation (ma)
lpgap_all      94     94   20.73539  4.391868  86.64364  Learning Poverty Gap (all)
lpgap_fe       77     77   21.84178  4.262402  126.2272  Learning Poverty Gap (fe)
lpgap_ma       77     77   21.65109  4.487056  84.98829  Learning Poverty Gap (ma)
lpsev_all      94     94   5.197842  .3408805  46.72258  Learning Poverty Severity (all)
lpsev_fe       77     77   6.517356  .3176738  108.5327  Learning Poverty Severity (fe)
lpsev_ma       77     77   5.751544  .3579716  45.22939  Learning Poverty Severity (ma)
enrollmentyr  217      1          .         .         .  
populatio~ce  217      1          .         .         .  The source used for population variables
populatio~fe  217    217    1433703       490  6.01e+07  2019 population_fe_1014_
population~a  217    217    1531415       557  6.62e+07  2019 population_ma_1014_
population~l  217    217    2965117      1047  1.26e+08  2019 population_all_1014_
anchor_pop~n  217    217    2965117      1047  1.26e+08  2019 population_all_1014_
anchor_pop~t  217    127    2557611         0  1.26e+08  Anchor population * has data dummy
anchor_year   217      1       2019      2019      2019  
idgrade       217      4  -416.2304      -999         6  Grade ID
test          217      8          .         .         .  Assessment
nla_code      217     13          .         .         .  Reference code for NLA in markdown documentation
subject       217      3          .         .         .  Subject
year_asses~t  126     16   2017.976      2001      2023  Year of assessment
enrollmen~ar  125     19   2015.208      1997      2022  
enrollment~g  126      2   .2063492         0         1  
enrollment~e  217      4          .         .         .  The source used for this enrollment value
enrollment~n  144      5          .         .         .  The definition used for this enrollment value
surveyid      126    126          .         .         .  SurveyID (countrycode_year_assessment)
countryname   217    217          .         .         .  Country Name
region        217      7          .         .         .  Region Code
regionname    217      7          .         .         .  Region Name
adminregion   134      6          .         .         .  Administrative Region Code
adminregio~e  134      6          .         .         .  Administrative Region Name
incomelevel   217      5          .         .         .  Income Level Code
incomeleve~e  217      5          .         .         .  Income Level Name
lendingtype   217      4          .         .         .  Lending Type Code
lendingty~me  217      4          .         .         .  Lending Type Name
cmu           169     48          .         .         .  WB Country Management Unit
preference~n  217      1          .         .         .  Preference description
lp_by_gend~e  217      2   .3778802         0         1  Dummy for availibility of Learning Poverty gender disaggregated
toinclude     217      2  -3.792627        -9         1  
---------------------------------------------------------------------------------------------------------------------------------------


~~~~
