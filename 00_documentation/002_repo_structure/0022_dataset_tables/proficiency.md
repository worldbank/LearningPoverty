
Documentation of Proficiency
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of proficiency. One country may have multiple or no observations at all. Long on specific measures in time (that is, assessment year grade subject country) and wide in subgroups (all, male, female).

**Metadata** stored in this dataset:

~~~~
sources:     Compilation of proficiency measures from 3 sources: CLO (Country Level Outcomes from GLAD), National Learning Assessment (from UIS), HAD (Harmonized Assessment Database)
lastsave:    16 Oct 2019 20:42:18 by wb255520
~~~~


About the **15 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year idgrade test nla_code subject
valuevars: nonprof_all se_nonprof_all nonprof_ma se_nonprof_ma nonprof_fe se_nonprof_fe
traitvars: min_proficiency_threshold source_assessment surveyid

. codebook, compact

Variable      Obs Unique      Mean       Min       Max  Label
----------------------------------------------------------------------------------------------------------------------------------------
countrycode   697    146         .         .         .  WB country code (3 letters)
year          697     20  2009.898      1996      2017  Year of assessment
idgrade       697      4  4.308465         3         6  Grade ID
test          697      7         .         .         .  Assessment
nla_code      697     22         .         .         .  Reference code for NLA in markdown documentation
subject       697      3         .         .         .  Subject
nonprof_all   697    697  30.44718  .2252221  99.89659  % pupils below minimum proficiency (all)
se_nonprof~l  559    559  .9498702  .1218972  3.419903  SE of pupils below minimum proficiency (all)
nonprof_ma    559    559  24.92177  .1586974  97.96137  % pupils below minimum proficiency (ma)
se_nonprof~a  559    559  1.199997  .1287481  3.848194  SE of pupils below minimum proficiency (ma)
nonprof_fe    559    559  22.02045  .1284599  97.83222  % pupils below minimum proficiency (fe)
se_nonprof~e  559    559  1.142743  .1141958  3.566816  SE of pupils below minimum proficiency (fe)
min_profic~d  694     18         .         .         .  Minimum Proficiency Threshold (assessment-specific)
source_ass~t  697      3         .         .         .  Source of assessment data
surveyid      697    503         .         .         .  SurveyID (countrycode_year_assessment)
----------------------------------------------------------------------------------------------------------------------------------------

~~~~
