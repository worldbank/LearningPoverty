
Documentation of Rawlatest
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Preference 1005 dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
~~~~


About the **53 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode preference
valuevars: adj_nonprof_all adj_nonprof_fe adj_nonprof_ma nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_all enrollment_ma enrollment_fe population_2015_fe population_2015_ma population_2015_all population_source anchor_population anchor_population_w_assessment
traitvars: idgrade test nla_code subject year_assessment year_enrollment enrollment_flag enrollment_source enrollment_definition min_proficiency_threshold surveyid countryname region region_iso2 regionname adminregion adminregion_iso2 adminregionname incomelevel incomelevel_iso2 incomelevelname lendingtype lendingtype_iso2 lendingtypename cmu preference_description lp_by_gender_is_available

. codebook, compact

Variable      Obs Unique       Mean       Min       Max  Label
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   217    217          .         .         .  WB country code (3 letters)
preference    217      1          .         .         .  Preference
adj_nonpro~l  116    116   38.49149  1.640046  98.72119  Learning Poverty (adjusted non-proficiency, all)
adj_nonpro~e   94     94   32.27536  1.199595   98.7845  Learning Poverty (adjusted non-proficiency, fe)
adj_nonpro~a   94     94   36.28663  2.114902   98.6577  Learning Poverty (adjusted non-proficiency, ma)
nonprof_all   116    116   36.09931  .3021896  97.90538  % pupils below minimum proficiency (all)
se_nonprof~l   97     97   1.141696     .1344  3.357331  SE of pupils below minimum proficiency (all)
nonprof_ma     99     99   34.90619  .2807498  97.96137  % pupils below minimum proficiency (ma)
se_nonprof~a   97     97   1.420192  .1502485  3.741401  SE of pupils below minimum proficiency (ma)
nonprof_fe     99     99   30.70454  .3251851  97.83222  % pupils below minimum proficiency (fe)
se_nonprof~e   97     97    1.33035  .1886169  4.098772  SE of pupils below minimum proficiency (fe)
fgt1_all       97     97   .2326854  .0527193  .7537994  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe        97     97   .2243604  .0453513  .7643428  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma        97     97   .2387256  .0490034  .7457443  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all       97     97   .1026644  .0041254  .6159182  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe        97     97   .0976484  .0032002  .6308874  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma        97     97   .1065394  .0041836  .6044815  Avg gap squared to minimum proficiency (ma, FGT2)
enrollment~l  199    194   90.18949  23.54786       100  Validated % of children enrolled in school (using closest year, both genders)
enrollment~a  190    185   90.59003  30.29106       100  Validated % of children enrolled in school (using closest year, male only)
enrollmen~fe  190    185   89.86092  16.75778       100  Validated % of children enrolled in school (using closest year, female only)
populatio~fe  193    193    1529768      3162  5.98e+07  Female population between ages 10 to 14 (WB API)
population~a  193    193    1640311      3286  6.71e+07  Male population between ages 10 to 14 (WB API)
population~l  193    193    3170079      6448  1.27e+08  Total population between ages 10 to 14 (WB API)
populatio~ce  217      1          .         .         .  The source used for population variables
anchor_pop~n  193    193    3170079      6448  1.27e+08  Total population between ages 10 to 14 (WB API)
anchor_pop~t  193    117    2667970         0  1.27e+08  Anchor population * has data dummy
idgrade       217      4  -462.4931      -999         6  Grade ID
test          217      6          .         .         .  Assessment
nla_code      217     16          .         .         .  Reference code for NLA in markdown documentation
subject       217      4          .         .         .  Subject
year_asses~t  217     13   2014.134      2001      2017  Year of assessment
year_enrol~t  199     19   2012.739      1993      2017  The year that the enrollment value is from
enrollment~g  217      2   .1751152         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
enrollmen~ce  217      4          .         .         .  The source used for this enrollment value
enrollment~n  217      6          .         .         .  The definition used for this enrollment value
min_profic~d  114     13          .         .         .  Minimum Proficiency Threshold (assessment-specific)
surveyid      116    116          .         .         .  SurveyID (countrycode_year_assessment)
countryname   217    217          .         .         .  Country Name
region        217      7          .         .         .  Region Code
region_iso2   217      7          .         .         .  Region Code (ISO 2 digits)
regionname    217      7          .         .         .  Region Name
adminregion   138      6          .         .         .  Administrative Region Code
adminregio~2  138      6          .         .         .  Administrative Region Code (ISO 2 digits)
adminregio~e  138      6          .         .         .  Administrative Region Name
incomelevel   217      4          .         .         .  Income Level Code
incomeleve~2  217      4          .         .         .  Income Level Code (ISO 2 digits)
incomeleve~e  217      4          .         .         .  Income Level Name
lendingtype   217      4          .         .         .  Lending Type Code
lendingtyp~2  217      4          .         .         .  Lending Type Code (ISO 2 digits)
lendingty~me  217      4          .         .         .  Lending Type Name
cmu           169     48          .         .         .  WB Country Management Unit
preference~n  217      1          .         .         .  Preference description
lp_by_gend~e  217      2   .4331797         0         1  Dummy for availibility of Learning Poverty gender disaggregated
---------------------------------------------------------------------------------------------------------------------------------------

~~~~
