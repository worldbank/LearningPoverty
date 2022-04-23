
Documentation of Rawlatest
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Preference 1108 dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
~~~~


About the **49 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode preference
valuevars: adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe population_2017_fe population_2017_ma population_2017_all population_source anchor_population anchor_population_w_assessment
traitvars: idgrade test nla_code subject year_assessment year_enrollment enrollment_flag enrollment_source enrollment_definition min_proficiency_threshold surveyid countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename cmu preference_description lp_by_gender_is_available

. codebook, compact

Variable      Obs Unique      Mean       Min       Max  Label
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   217    217         .         .         .  WB country code (3 letters)
preference    217      1         .         .         .  Preference
adj_nonpro~l  121    121  40.24131  2.186121  97.71729  Learning Poverty (adjusted non-proficiency, all)
adj_nonpro~e   92     92  35.45263  1.132339  97.28742  Learning Poverty (adjusted non-proficiency, fe)
adj_nonpro~a   93     93  40.37611  2.540959  98.12722  Learning Poverty (adjusted non-proficiency, ma)
nonprof_all   123    123  37.43444  .7973636  97.50433  % pupils below minimum proficiency (all)
se_nonprof~l  110    110  1.135298  .1526176  3.357331  SE of pupils below minimum proficiency (all)
nonprof_ma    113    113  37.36868  .7871103  97.97008  % pupils below minimum proficiency (ma)
se_nonprof~a  110    110  1.386618  .2211475  3.741401  SE of pupils below minimum proficiency (ma)
nonprof_fe    113    113  33.09115  .5895654  97.00749  % pupils below minimum proficiency (fe)
se_nonprof~e  110    110  1.330309  .1777982  4.098772  SE of pupils below minimum proficiency (fe)
fgt1_all      110    110  .1454252  .0439187   .519554  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe       110    110  .1384482   .042624  .4820448  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma       110    110  .1503822  .0448706  .5445552  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all      110    110  .0393368  .0034088  .3331398  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe       110    110  .0356563  .0031767  .2936567  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma       110    110  .0419848  .0035797  .3594563  Avg gap squared to minimum proficiency (ma, FGT2)
enrollment~l  201    197   90.5746  23.54786       100  Validated % of children enrolled in school (using closest year, both genders)
enrollment~a  161    157  90.01606  30.29106       100  Validated % of children enrolled in school (using closest year, male only)
enrollmen~fe  160    156    89.272  16.75778       100  Validated % of children enrolled in school (using closest year, female only)
populatio~fe  193    193   1553426      3328  6.01e+07  Female population between ages 10 to 14 (WB API)
population~a  193    193   1664672      3467  6.72e+07  Male population between ages 10 to 14 (WB API)
population~l  193    193   3218098      6795  1.27e+08  Total population between ages 10 to 14 (WB API)
populatio~ce  217      1         .         .         .  The source used for population variables
anchor_pop~n  193    193   3218098      6795  1.27e+08  Total population between ages 10 to 14 (WB API)
anchor_pop~t  193    123   2738218         0  1.27e+08  Anchor population * has data dummy
idgrade       217      4  -430.106      -999         6  Grade ID
test          217      7         .         .         .  Assessment
nla_code      217     11         .         .         .  Reference code for NLA in markdown documentation
subject       217      4         .         .         .  Subject
year_asses~t  217     13  2015.857      2001      2019  Year of assessment
year_enrol~t  201     18   2013.99      1993      2018  The year that the enrollment value is from
enrollment~g  217      2   .235023         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
enrollmen~ce  217      4         .         .         .  The source used for this enrollment value
enrollment~n  217      6         .         .         .  The definition used for this enrollment value
min_profic~d  116     10         .         .         .  Minimum Proficiency Threshold (assessment-specific)
surveyid      123    123         .         .         .  SurveyID (countrycode_year_assessment)
countryname   217    217         .         .         .  Country Name
region        217      7         .         .         .  Region Code
regionname    217      7         .         .         .  Region Name
adminregion   135      6         .         .         .  Administrative Region Code
adminregio~e  135      6         .         .         .  Administrative Region Name
incomelevel   217      4         .         .         .  Income Level Code
incomeleve~e  217      4         .         .         .  Income Level Name
lendingtype   217      4         .         .         .  Lending Type Code
lendingty~me  217      4         .         .         .  Lending Type Name
cmu           169     48         .         .         .  WB Country Management Unit
preference~n  217      1         .         .         .  Preference description
lp_by_gend~e  217      2  .4239631         0         1  Dummy for availibility of Learning Poverty gender disaggregated
---------------------------------------------------------------------------------------------------------------------------------------

~~~~
