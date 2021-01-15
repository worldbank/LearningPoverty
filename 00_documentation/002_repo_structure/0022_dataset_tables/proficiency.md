
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
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   697    146         .         .         .  WB country code (3 letters)
year          697     20  2009.898      1996      2017  Year of assessment
idgrade       697      4  4.308465         3         6  Grade ID
test          697      7         .         .         .  Assessment
nla_code      697     22         .         .         .  Reference code for NLA in markdown documentation
subject       697      3         .         .         .  Subject
nonprof_all   697    697  30.44595  .2252221  99.89659  % pupils below minimum proficiency (all)
se_nonprof~l  559    559   1.05663  .1218972  3.419903  SE of pupils below minimum proficiency (all)
nonprof_ma    561    561  25.08579  .1586974  97.96137  % pupils below minimum proficiency (ma)
se_nonprof~a  559    559  1.297817  .1287481  3.848194  SE of pupils below minimum proficiency (ma)
nonprof_fe    561    561  22.18714  .1284599  97.83222  % pupils below minimum proficiency (fe)
se_nonprof~e  559    559  1.245255  .1141958  4.098772  SE of pupils below minimum proficiency (fe)
fgt1_all      559    559  .1708391  .0308948  .7537994  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe       559    559  .1641004  .0257019  .7643428  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma       559    559  .1757896  .0298228  .7457443  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all      559    559  .0610742   .001687  .6159182  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe       559    559  .0572421  .0011683  .6308874  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma       559    559  .0639653  .0017091  .6044815  Avg gap squared to minimum proficiency (ma, FGT2)
min_profic~d  694     18         .         .         .  Minimum Proficiency Threshold (assessment-specific)
source_ass~t  697      3         .         .         .  Source of assessment data
surveyid      697    503         .         .         .  SurveyID (countrycode_year_assessment)
---------------------------------------------------------------------------------------------------------------------------------------

~~~~
