
Documentation of Rawfull
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of proficiency merged with enrollment and population. Not a timeseries, rather a collection of observations, from which subsets of time series may be extracted. Long in proficiency, wide on population and enrollment.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
lastsave:    16 Oct 2019 20:42:20 by wb255520
~~~~


About the **54 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year_assessment idgrade test nla_code subject
valuevars: nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe enrollment_validated_all enrollment_validated_fe enrollment_validated_ma enrollment_validated_flag enrollment_interpolated_all enrollment_interpolated_fe enrollment_interpolated_ma enrollment_interpolated_flag population_fe_10 population_fe_primary population_fe_9plus population_ma_10 population_ma_primary population_ma_9plus population_all_10 population_all_primary population_all_9plus population_fe_1014 population_ma_1014 population_all_1014 population_source
traitvars: year_enrollment year_population source_assessment enrollment_source population_source enrollment_definition min_proficiency_threshold surveyid countryname region region_iso2 regionname adminregion adminregion_iso2 adminregionname incomelevel incomelevel_iso2 incomelevelname lendingtype lendingtype_iso2 lendingtypename cmu

. codebook, compact

Variable      Obs Unique      Mean       Min       Max  Label
----------------------------------------------------------------------------------------------------------------------------------------
countrycode   914    217         .         .         .  WB country code (3 letters)
year_asses~t  914     20  2011.109      1996      2017  Year of assessment
idgrade       914      5  -233.895      -999         6  Grade ID
test          914      8         .         .         .  Assessment
nla_code      914     22         .         .         .  Reference code for NLA in markdown documentation
subject       914      4         .         .         .  Subject
nonprof_all   697    697  30.44718  .2252221  99.89659  % pupils below minimum proficiency (all)
se_nonprof~l  559    559  .9498702  .1218972  3.419903  SE of pupils below minimum proficiency (all)
nonprof_ma    559    559  24.92177  .1586974  97.96137  % pupils below minimum proficiency (ma)
se_nonprof~a  559    559  1.199997  .1287481  3.848194  SE of pupils below minimum proficiency (ma)
nonprof_fe    559    559  22.02045  .1284599  97.83222  % pupils below minimum proficiency (fe)
se_nonprof~e  559    559  1.142743  .1141958  3.566816  SE of pupils below minimum proficiency (fe)
en~dated_all  896    503  92.41767  23.54786       100  Validated % of children enrolled in school (using closest year, both genders)
enr~dated_fe  855    481  92.32435  16.75778       100  Validated % of children enrolled in school (using closest year, female only)
enr~dated_ma  855    481  92.87754  30.29106  100.2015  Validated % of children enrolled in school (using closest year, male only)
e~dated_flag  914      2  .1345733         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  896    531    92.438  23.54786       100  Validated % of children enrolled in school (using interpolation, both genders)
enr~lated_fe  773    445  93.02931  16.75778       100  Validated % of children enrolled in school (using interpolation, female only)
enr~lated_ma  773    445  93.36419  30.29106  100.2015  Validated % of children enrolled in school (using interpolation, male only)
e~lated_flag  914      2  .1444201         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
populat~e_10  890    193  293630.7       671  1.21e+07  Female population aged 10 (WB API)
po~e_primary  832    172   2052513      4599  7.23e+07  Female population primary age, country specific (WB API)
popu~e_9plus  873    191   1093833      1374  3.62e+07  Female population aged 9 to end of primary, country specific (WB API)
populat~a_10  890    193  310736.6       696  1.35e+07  Male population aged 10 (WB API)
po~a_primary  832    172   2170324      4773  8.04e+07  Male population primary age, country specific (WB API)
popu~a_9plus  873    191   1153568      1425  4.04e+07  Male population aged 9 to end of primary, country specific (WB API)
populat~l_10  890    193  604367.3      1370  2.55e+07  Total population aged 10 (WB API)
po~l_primary  832    172   4222837      9372  1.53e+08  Total population primary age, country specific (WB API)
popu~l_9plus  873    191   2247401      2799  7.65e+07  Total population aged 9 to end of primary, country specific (WB API)
popul~e_1014  890    193   1438254      3162  5.98e+07  Female population between ages 10 to 14 (WB API)
popul~a_1014  890    193   1521794      3286  6.71e+07  Male population between ages 10 to 14 (WB API)
popul~l_1014  890    193   2960048      6448  1.27e+08  Total population between ages 10 to 14 (WB API)
population~e  914      1         .         .         .  The source used for population variables
year_enrol~t  896     24  2010.494      1991      2017  The year that the enrollment value is from
year_popul~n  914      1      2015      2015      2015  Year of population
source_ass~t  697      3         .         .         .  Source of assessment data
enrollmen~ce  914      5         .         .         .  The source used for this enrollment value
enrollment~n  914      5         .         .         .  The definition used for this enrollment value
min_profic~d  694     18         .         .         .  Minimum Proficiency Threshold (assessment-specific)
surveyid      697    503         .         .         .  SurveyID (countrycode_year_assessment)
countryname   914    217         .         .         .  Country Name
region        914      7         .         .         .  Region Code
region_iso2   914      7         .         .         .  Region Code (ISO 2 digits)
regionname    914      7         .         .         .  Region Name
adminregion   475      6         .         .         .  Administrative Region Code
adminregio~2  475      6         .         .         .  Administrative Region Code (ISO 2 digits)
adminregio~e  475      6         .         .         .  Administrative Region Name
incomelevel   914      4         .         .         .  Income Level Code
incomeleve~2  914      4         .         .         .  Income Level Code (ISO 2 digits)
incomeleve~e  914      4         .         .         .  Income Level Name
lendingtype   914      4         .         .         .  Lending Type Code
lendingtyp~2  914      4         .         .         .  Lending Type Code (ISO 2 digits)
lendingty~me  911      4         .         .         .  Lending Type Name
cmu           680     48         .         .         .  WB Country Management Unit
----------------------------------------------------------------------------------------------------------------------------------------

~~~~
