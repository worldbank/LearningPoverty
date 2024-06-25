
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
countrycode   948    158         .         .         .  WB country code (3 letters)
year          948     24  2012.364      1996      2023  Year of assessment
idgrade       948      4  4.394515         3         6  Grade ID
test          948     10         .         .         .  Assessment
nla_code      948     26         .         .         .  Reference code for NLA in markdown documentation
subject       948      3         .         .         .  Subject
nonprof_all   948    947  31.36511  .2252197  99.90289  % pupils below minimum proficiency (all)
se_nonprof~l  703    703  1.087973  .0367675  4.659985  SE of pupils below minimum proficiency (all)
nonprof_ma    767    767  25.65895  .1586986  99.86842  % pupils below minimum proficiency (ma)
se_nonprof~a  702    702   1.33252  .0378272  5.034541  SE of pupils below minimum proficiency (ma)
nonprof_fe    767    767  22.82388  .1284603  99.93002  % pupils below minimum proficiency (fe)
se_nonprof~e  702    702  1.290908  .0490543  6.059458  SE of pupils below minimum proficiency (fe)
fgt1_all      752    752  .1348473  .0308948  .5614824  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe       752    752  .1286881  .0257019  .5376112  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma       752    752  .1393555  .0298228  .5797679  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all      752    752  .0361188   .001687   .390271  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe       752    752  .0329784  .0011683  .3641997  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma       752    752  .0384681  .0017091  .4102417  Avg gap squared to minimum proficiency (ma, FGT2)
min_profic~d  946     20         .         .         .  Minimum Proficiency Threshold (assessment-specific)
source_ass~t  948      6         .         .         .  Source of assessment data
surveyid      948    699         .         .         .  SurveyID (countrycode_year_assessment)
---------------------------------------------------------------------------------------------------------------------------------------


~~~~
