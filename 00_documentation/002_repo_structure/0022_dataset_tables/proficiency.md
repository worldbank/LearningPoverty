
Documentation of Proficiency
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of proficiency. One country may have multiple or no observations at all. Long on specific measures in time (that is, assessment year grade subject country) and wide in subgroups (all, male, female).

**Metadata** stored in this dataset:

~~~~
sources:     Compilation of proficiency measures from 3 sources: CLO (Country Level Outcomes from GLAD), National Learning Assessment (from UIS), HAD (Harmonized Assessment Database)
~~~~


About the **21 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year idgrade test nla_code subject
valuevars: nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma
traitvars: min_proficiency_threshold source_assessment surveyid

. codebook, compact

Variable      Obs Unique      Mean       Min       Max  Label
-----------------------------------------------------------------------------------------------------------------------
countrycode   831    153         .         .         .  WB country code (3 letters)
year          831     21  2011.366      1996      2019  Year of assessment
idgrade       831      4  4.309266         3         6  Grade ID
test          831      8         .         .         .  Assessment
nla_code      831     22         .         .         .  Reference code for NLA in markdown documentation
subject       831      3         .         .         .  Subject
nonprof_all   831    831  29.61033  .2252197  99.89659  % pupils below minimum proficiency (all)
se_nonprof~l  693    693  1.100099  .1218972  4.659985  SE of pupils below minimum proficiency (all)
nonprof_ma    696    696  25.37036  .1586986  97.97008  % pupils below minimum proficiency (ma)
se_nonprof~a  693    693  1.344615  .1287481  5.034541  SE of pupils below minimum proficiency (ma)
nonprof_fe    696    696  22.64117  .1284603  97.83222  % pupils below minimum proficiency (fe)
se_nonprof~e  693    693  1.303262  .1141958  6.059458  SE of pupils below minimum proficiency (fe)
fgt1_all      693    693   .135403  .0308948  .5614824  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe       693    693  .1293705  .0257019  .5376112  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma       693    693  .1398457  .0298228  .5797679  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all      693    693  .0364274   .001687   .390271  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe       693    693  .0333626  .0011683  .3641997  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma       693    693  .0387286  .0017091  .4102417  Avg gap squared to minimum proficiency (ma, FGT2)
min_profic~d  822     18         .         .         .  Minimum Proficiency Threshold (assessment-specific)
source_ass~t  831      3         .         .         .  Source of assessment data
surveyid      831    580         .         .         .  SurveyID (countrycode_year_assessment)
-----------------------------------------------------------------------------------------------------------------------

~~~~
