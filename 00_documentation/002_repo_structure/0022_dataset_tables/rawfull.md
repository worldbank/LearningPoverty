
Documentation of Rawfull
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of proficiency merged with enrollment and population. Not a timeseries, rather a collection of observations, from which subsets of time series may be extracted. Long in proficiency, wide on population and enrollment.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
~~~~


About the **59 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year_assessment idgrade test nla_code subject
valuevars: nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_validated_all enrollment_validated_fe enrollment_validated_ma enrollment_validated_flag enrollment_interpolated_all enrollment_interpolated_fe enrollment_interpolated_ma enrollment_interpolated_flag population_fe_10 population_fe_0516 population_fe_primary population_fe_9plus population_ma_10 population_ma_0516 population_ma_primary population_ma_9plus population_all_10 population_all_0516 population_all_primary population_all_9plus population_fe_1014 population_ma_1014 population_all_1014 population_source
traitvars: year_enrollment year_population source_assessment enrollment_source population_source enrollment_definition min_proficiency_threshold surveyid countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename cmu

. codebook, compact

Variable       Obs Unique       Mean       Min       Max  Label
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   1042    217          .         .         .  WB country code (3 letters)
year_asses~t  1042     21   2012.495      1996      2019  Year of assessment
idgrade       1042      5  -204.6315      -999         6  Grade ID
test          1042      9          .         .         .  Assessment
nla_code      1042     22          .         .         .  Reference code for NLA in markdown documentation
subject       1042      4          .         .         .  Subject
nonprof_all    825    825   29.79082  .2252197  99.89659  % pupils below minimum proficiency (all)
se_nonprof~l   687    687   1.103412  .1218972  4.659985  SE of pupils below minimum proficiency (all)
nonprof_ma     690    690   25.54863  .1586986  97.97008  % pupils below minimum proficiency (ma)
se_nonprof~a   687    687   1.347357  .1287481  5.034541  SE of pupils below minimum proficiency (ma)
nonprof_fe     690    690   22.79707  .1284603  97.83222  % pupils below minimum proficiency (fe)
se_nonprof~e   687    687   1.306891  .1141958  6.059458  SE of pupils below minimum proficiency (fe)
fgt1_all       687    687   .1358525  .0308948  .5614824  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe        687    687   .1297836  .0257019  .5376112  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma        687    687   .1403113  .0298228  .5797679  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all       687    687   .0366347   .001687   .390271  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe        687    687   .0335486  .0011683  .3641997  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma        687    687   .0389487  .0017091  .4102417  Avg gap squared to minimum proficiency (ma, FGT2)
en~dated_all  1022    584   92.44464  23.54786       100  Validated % of children enrolled in school (using closest year, both genders)
enr~dated_fe   862    486    91.9935  16.75778       100  Validated % of children enrolled in school (using closest year, female only)
enr~dated_ma   864    488   92.50133  30.29106       100  Validated % of children enrolled in school (using closest year, male only)
e~dated_flag  1042      2   .2303263         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  1022    622    92.4566  23.54786       100  Validated % of children enrolled in school (using interpolation, both gend...
enr~lated_fe   792    463    92.7003  16.75778       100  Validated % of children enrolled in school (using interpolation, female only)
enr~lated_ma   794    464   93.03792  30.29106       100  Validated % of children enrolled in school (using interpolation, male only)
e~lated_flag  1042      2   .2447217         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
populat~e_10  1016    193   293790.7       672  1.21e+07  Female population aged 10 (WB API)
popul~e_0516  1016    193    3507837      8061  1.43e+08  Female population aged 05-16 (WB API)
po~e_primary   970    179    2013042      4379  7.18e+07  Female population primary age, country specific (WB API)
popu~e_9plus   990    186    1085839      1356  3.63e+07  Female population aged 9 to end of primary, country specific (WB API)
populat~a_10  1016    193   310473.2       687  1.34e+07  Male population aged 10 (WB API)
popul~a_0516  1016    193    3706547      8324  1.59e+08  Male population aged 05-16 (WB API)
po~a_primary   970    179    2125880      4534  7.94e+07  Male population primary age, country specific (WB API)
popu~a_9plus   990    186    1143901      1400  4.03e+07  Male population aged 9 to end of primary, country specific (WB API)
populat~l_10  1016    193   604263.9      1359  2.55e+07  Total population aged 10 (WB API)
popul~l_0516  1016    193    7214384     16385  3.02e+08  Total population aged 05-16 (WB API)
po~l_primary   970    179    4138922      8913  1.51e+08  Total population primary age, country specific (WB API)
popu~l_9plus   990    186    2229740      2756  7.65e+07  Total population aged 9 to end of primary, country specific (WB API)
popul~e_1014  1016    193    1432652      3328  6.01e+07  Female population between ages 10 to 14 (WB API)
popul~a_1014  1016    193    1514505      3467  6.72e+07  Male population between ages 10 to 14 (WB API)
popul~l_1014  1016    193    2947158      6795  1.27e+08  Total population between ages 10 to 14 (WB API)
population~e  1042      1          .         .         .  The source used for population variables
year_enrol~t  1022     26   2011.796      1991      2019  The year that the enrollment value is from
year_popul~n  1042      1       2017      2017      2017  Year of population
source_ass~t   825      3          .         .         .  Source of assessment data
enrollmen~ce  1042      4          .         .         .  The source used for this enrollment value
enrollment~n  1042      6          .         .         .  The definition used for this enrollment value
min_profic~d   816     18          .         .         .  Minimum Proficiency Threshold (assessment-specific)
surveyid       825    577          .         .         .  SurveyID (countrycode_year_assessment)
countryname   1042    217          .         .         .  Country Name
region        1042      7          .         .         .  Region Code
regionname    1042      7          .         .         .  Region Name
adminregion    519      6          .         .         .  Administrative Region Code
adminregio~e   519      6          .         .         .  Administrative Region Name
incomelevel   1042      4          .         .         .  Income Level Code
incomeleve~e  1042      4          .         .         .  Income Level Name
lendingtype   1042      4          .         .         .  Lending Type Code
lendingty~me  1042      4          .         .         .  Lending Type Name
cmu            774     48          .         .         .  WB Country Management Unit
---------------------------------------------------------------------------------------------------------------------------------------

~~~~
