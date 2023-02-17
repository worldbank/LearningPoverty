
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

. codebook, compact

Variable      Obs Unique       Mean       Min       Max  Label
-----------------------------------------------------------------------------------------------------------------------------------------
countrycode   217    217          .         .         .  WB country code (3 letters)
preference    217      1          .         .         .  Preference
lpv_all       123    123   41.57634  2.186121  98.50421  Learning Poverty (all)
lpv_fe         79     79   31.99112  1.132339  97.28742  Learning Poverty (fe)
lpv_ma         80     80   36.96178  2.540959  98.12722  Learning Poverty (ma)
se_ld_all      94     94   1.018822  .1297758  2.651935  SE of pupils below minimum proficiency (all)
se_ld_ma       93     93   1.257077  .2211475  2.933891  SE of pupils below minimum proficiency (ma)
se_ld_fe       93     93   1.186322  .1777982  3.085637  SE of pupils below minimum proficiency (fe)
min_profic~d  127     12          .         .         .  Minimum Proficiency Threshold (assessment-specific)
ld_all        123    123   38.90772  .7973636  98.24239  Learning Deprivation (all)
ldgap_all      93     93   14.64934  4.391868   51.9554  Learning Deprivation Gap (all)
ldsev_all      93     93   4.095623  .3408805  33.31398  Learning Deprivation Severity (all)
ld_fe          96     96   29.74008  .5895654  97.00749  Learning Deprivation (fe)
ldgap_fe       93     93   13.89557  4.262402  48.20448  Learning Deprivation Gap (fe)
ldsev_fe       93     93   3.685532  .3176738  29.36567  Learning Deprivation Severity (fe)
ld_ma          96     96   34.07545  .7871103  97.97008  Learning Deprivation (ma)
ldgap_ma       93     93   15.17616  4.487056  54.45552  Learning Deprivation Gap (ma)
ldsev_ma       93     93   4.387988  .3579716  35.94563  Learning Deprivation Severity (ma)
sd_all        123    122   7.159892         0  63.19589  Schooling Deprivation (all)
sd_fe         100     99   7.358409         0  64.11402  Schooling Deprivation (fe)
sd_ma         101    100   7.056089         0  62.28584  Schooling Deprivation (ma)
lpgap_all      93     93   20.65814  4.391868  86.64364  Learning Poverty Gap (all)
lpgap_fe       76     76    20.0229  4.262402  88.31586  Learning Poverty Gap (fe)
lpgap_ma       77     77   21.25095  4.487056  84.98829  Learning Poverty Gap (ma)
lpsev_all      93     93   5.256691  .3408805  46.72258  Learning Poverty Severity (all)
lpsev_fe       76     76   5.056702  .3176738  48.24685  Learning Poverty Severity (fe)
lpsev_ma       77     77   5.649549  .3579716  45.22939  Learning Poverty Severity (ma)
enrollmentyr  203      1          .         .         .  
populatio~ce  217      1          .         .         .  The source used for population variables
populatio~fe  193    193    1583227      3370  6.02e+07  2019 population_fe_1014_
population~a  193    193    1694944      3444  6.68e+07  2019 population_ma_1014_
population~l  193    193    3278170      6814  1.27e+08  2019 population_all_1014_
anchor_pop~n  193    193    3278170      6814  1.27e+08  2019 population_all_1014_
anchor_pop~t  193    138    3041599         0  1.27e+08  Anchor population * has data dummy
anchor_year   217      1       2019      2019      2019  
idgrade       217      4  -430.0876      -999         6  Grade ID
test          203      8          .         .         .  Assessment
nla_code      217     12          .         .         .  Reference code for NLA in markdown documentation
subject       203      4          .         .         .  Subject
year_asses~t  217     14   1822.461      -999      2019  Year of assessment
enrollmen~ar  137     17    1706.46      -999      2018  
enrollment~g  137      3   -101.927      -999         1  
enrollment~e  203      4          .         .         .  The source used for this enrollment value
enrollment~n  217      6          .         .         .  The definition used for this enrollment value
surveyid      123    123          .         .         .  SurveyID (countrycode_year_assessment)
countryname   217    217          .         .         .  Country Name
region        217      7          .         .         .  Region Code
regionname    217      7          .         .         .  Region Name
adminregion   137      6          .         .         .  Administrative Region Code
adminregio~e  137      6          .         .         .  Administrative Region Name
incomelevel   217      5          .         .         .  Income Level Code
incomeleve~e  217      5          .         .         .  Income Level Name
lendingtype   217      4          .         .         .  Lending Type Code
lendingty~me  217      4          .         .         .  Lending Type Name
cmu           169     48          .         .         .  WB Country Management Unit
preference~n  217      1          .         .         .  Preference description
lp_by_gend~e  217      2   .3963134         0         1  Dummy for availibility of Learning Poverty gender disaggregated
toinclude     217      3  -3.764977        -9         1  
-----------------------------------------------------------------------------------------------------------------------------------------


~~~~
