*==============================================================================*
* 0220 SUBTASK: CREATE ALL LEARNING POVERTY SPELLS (PLUS DUMMIES OF USE)
*==============================================================================*

local chosen_preference = 1005
local enrollment_def "validated"

quietly {

  * Ensure comparability file is up to date
  import delimited "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS.csv", clear
	gen year_assessment_i = substr(spell,1,4)
  gen year_assessment   = substr(spell,6,4)
	destring year_assessment_i year_assessment, replace
	save "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS_yr.dta", replace

  *-----------------------------------------------------------------------------*
  * All possible spells = all combinations of points in time equivalent measures
  *-----------------------------------------------------------------------------*

  * Starts with rawfull
  use "${clone}/01_data/013_outputs/rawfull.dta", clear

  * More intuitive/shorter names for key variables
  rename (enrollment_`enrollment_def'_all nonprof_all) (enrollment bmp)

  * Calculates learning poverty
  gen learningpoverty = 100 * ( 1 - (enrollment/100) * (1 - bmp/100))
  label var learningpoverty "Learning Poverty (adjusted non-proficiency, all)"

  * Keep only essential variables
  local idvars  "countrycode idgrade test nla_code subject"
  local values  "year_assessment enrollment bmp learningpoverty"
  local traits  "region incomelevel lendingtype countryname"
  keep `idvars' `values' `traits'

  * Will save two almost identical copies of the file, with year sufix in variables
  tempfile rawfull_y1 rawfull_y2

  * Rename value vars as year 1
  rename (year_assessment enrollment bmp learningpoverty) (y1 enrollment_y1 bmp_y1 learningpoverty_y1)
  save `rawfull_y1', replace

  * Rename value vars as year 2*
  rename (y1 enrollment_y1 bmp_y1 learningpoverty_y1) (y2 enrollment_y2 bmp_y2 learningpoverty_y2)
  save `rawfull_y2', replace

  * Join both datasets, that is, all possible combinations that match in idvars
  use `rawfull_y1', clear
  joinby `idvars' using `rawfull_y2'

  * No sense in keeping if y2>y1 because it already appears with flipped years
  drop if y2 <= y1

  * Spell is identified by those two years plus other idvars
  gen str9 spell = string(y1) + "-" + string(y2)
  label var spell "Spell"

  * Concatenate a full spell id
  gen spell_id = countrycode + "_" + test + "_" + subject + "_" + spell + "_grade" + string(idgrade)
  label var spell_id "Full spell identification"

  * Lenght in years could be used for weighting
  gen int spell_lenght = y2 - y1
  label var spell_lenght "Spell lenght (years)"

  *-----------------------------------------------------------------------------*
  * Several dummies to map on spells characteristics and usage
  *-----------------------------------------------------------------------------*

  * Will use the same label for all dummies
  label define ny 0 "no" 1 "yes"

  * For TIMSS, only keeps science, except for Jordan, should be equivalent to
  * if a country has TIMMS spells for a given year interval, keep the science only
  gen byte  excess_timss: ny = (subject!= "science" & test == "TIMSS"  & countrycode != "JOR")
  label var excess_timss "Redundant TIMSS spell (least preferred subject)"

  * SACMEQ round IV (2013) has some quality issues, mark those as doubtful
  gen byte  quality_control: ny = 1 - (test == "SACMEQ" & (y1 == 2013 | y2 == 2013) )
  label var quality_control "Flags out SACMEQ low quality spell (with 2013)"

  * Mark only the spells that correspond to the preferred specification of LP
  merge m:1 `idvars' using "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", keep(master match) keepusing(`traits') gen(preferred)
  recode preferred (1 = 0) (3 = 1)
  label var preferred "Same assessment, subject and grade as preferred in rawlatest"
  label values preferred ny

  * Mark whether it is a comparable spell
  merge m:1 countrycode idgrade test spell using "${clone}\02_simulation\021_rawdata\comparability_TIMSS_PIRLS_yr.dta", keep(master match) keepusing(comparable) nogen
  replace comparable = 0 if inlist(test, "EGRA", "PASEC")
  replace comparable = 1 if missing(comparable)
  label var comparable "Spell is comparable"
  label values comparable ny


  * Up to this point , if a country participated in 4 PIRLS,
  * it would have 3 stepwise spells, 2 skipping spells, 1 overarching spell.
  * Will only keep the stepwise spells, that is, of consecutive years.

  * As of now, a single loop run is called, but for robustness uses a while
  local  move_on  = 0
  while `move_on' != 1 {

    * Identifies the minimum and maximum lag (when both are 1, it's unique)
    sort `idvars' y1 y2
    by   `idvars' y1 : gen min_lag = (_n == 1)
    by   `idvars' y1 : gen max_lag = (_n == _N)

    * The min_lag must be comparable, unless a single non-comparable exists
    count if min_lag == 1 & comparable == 0 & max_lag !=1
    if `r(N)' == 0 local move_on = 1

    drop  if min_lag == 1 & comparable == 0 & max_lag !=1
    drop min_lag max_lag
  }

  * Now we can actually keep only the minimum lag
  sort `idvars' y1 y2
  by   `idvars' y1 : keep if _n == 1


  * What actually matters: the value of the spell
  gen delta_lp = (learningpoverty_y2 - learningpoverty_y1) / (y1 - y2)
  label var delta_lp "Annualized change in Learning Poverty in this spell (pp)"

  * Adds filter of spells neither too big nor small
  gen byte  range_old: ny = (delta_lp > -2 & delta_lp < 4)
  label var range_old "Spell is between -2 and 4 annual change in Learning Poverty"
  gen byte  range_new: ny = (delta_lp > -4 & delta_lp < 4)
  label var range_new "Spell is between -4 and 4 annual change in Learning Poverty"

  * What was used for the simulation in the glossy (Part2 only)
  gen byte  glossy_sim: ny = (lendingtype != "LNX" & comparable == 1 & y1 >= 2000 & excess_timss == 0 & test != "NLA" & range_old == 1)
  label var glossy_sim "Spell was used in the simulation for the Glossy (N=70)"

  * What we are actually using in the tehnical paper (Part2 only)
  * - change the range from [-2, 4] to [-4,4]
  * - removes the South Africa spell which does not seem comparable
  gen byte  used_sim: ny = (lendingtype != "LNX" & comparable == 1 & y1 >= 2000 & excess_timss == 0 & range_new == 1 & spell_id != "ZAF_PIRLS_read_2011-2016_grade5")
  label var used_sim "Spell was used in the simulation (N=72)"
  * Almost equal to the above, but without the outliers exclusion, because it's needed for a table later
  gen byte  almostused_sim: ny = (lendingtype != "LNX" & comparable == 1 & y1 >= 2000 & excess_timss == 0 & spell_id != "ZAF_PIRLS_read_2011-2016_grade5")
  label var almostused_sim "Spell was ALMOST used in the simulation (without range condition)"

  * In some tables we report an analogous of "used_sim", but including Part1 countries
  gen byte  potential_sim: ny = (comparable == 1 & y1 >= 2000 & excess_timss == 0 & range_new == 1 & spell_id != "ZAF_PIRLS_read_2011-2016_grade5")
  label var potential_sim "Spell would be used in the simulation if Part 1 was included (N=207)"
  * Almost equal to the above, but without the outliers exclusion, because it's needed for a table later
  gen byte  almostpotential_sim: ny = (comparable == 1 & y1 >= 2000 & excess_timss == 0 & spell_id != "ZAF_PIRLS_read_2011-2016_grade5")
  label var almostpotential_sim "Spell was ALMOST potential simulation (without range condition)"

  * Alternatively, we could use spells without the range rule
  gen byte  withoutliers_sim: ny = (lendingtype != "LNX" & comparable == 1 & y1 >= 2000 & excess_timss == 0 & spell_id != "ZAF_PIRLS_read_2011-2016_grade5")
  label var withoutliers_sim "Spell could be used in the simulation (N=82)"

  * Alternatively, we could use spells without the range rule but drop SACMEQ 2013
  gen byte  rmlastsacmeq_sim: ny = (lendingtype != "LNX" & comparable == 1 & y1 >= 2000 & excess_timss == 0 & spell_id != "ZAF_PIRLS_read_2011-2016_grade5" & quality_control == 1)
  label var rmlastsacmeq_sim "Spell could be used in the simulation (N=70)"

  * Creates initial learning poverty level
  gen initial_poverty_level = ""
  replace initial_poverty_level = "0-25% Learning Poverty"   if !missing(learningpoverty_y1)
  replace initial_poverty_level = "25-50% Learning Poverty"  if learningpoverty_y1 >= 25 & !missing(learningpoverty_y1)
  replace initial_poverty_level = "50-75% Learning Poverty"  if learningpoverty_y1 >= 50 & !missing(learningpoverty_y1)
  replace initial_poverty_level = "75-100% Learning Poverty" if learningpoverty_y1 >= 75 & !missing(learningpoverty_y1)
  label var initial_poverty_level "Categorical string variable on initial Learning Poverty (y1 of spell)"

  * Beautify
  sort countrycode
  order `idvars' spell* delta_lp *y1 *y2 preferred comparable range_* *sim `traits'
  format %4.1f enrollment* bmp* learningpoverty* delta_lp
  format %3.0g preferred comparable *sim

  compress
  save "${clone}/02_simulation/023_outputs/all_spells.dta", replace

  noi disp as result _n "Saved all spells." _n
}

* Display summary stats of spells to double check results (copied below)

tab test if glossy_sim

tab test if used_sim

tab test if potential_sim

tab test if withoutliers_sim

tab test if rmlastsacmeq_sim

exit
*------------------------------------------------------------------------------*
/*

* Results as of June 26, 2020
.
. tab test if glossy_sim

 Assessment |      Freq.     Percent        Cum.
------------+-----------------------------------
      LLECE |         14       20.00       20.00
      PIRLS |         23       32.86       52.86
     SACMEQ |         17       24.29       77.14
      TIMSS |         16       22.86      100.00
------------+-----------------------------------
      Total |         70      100.00

.
. tab test if used_sim

 Assessment |      Freq.     Percent        Cum.
------------+-----------------------------------
      LLECE |         14       19.44       19.44
        NLA |          1        1.39       20.83
      PIRLS |         23       31.94       52.78
     SACMEQ |         17       23.61       76.39
      TIMSS |         17       23.61      100.00
------------+-----------------------------------
      Total |         72      100.00

.
. tab test if potential_sim

 Assessment |      Freq.     Percent        Cum.
------------+-----------------------------------
      LLECE |         14        6.76        6.76
        NLA |          1        0.48        7.25
      PIRLS |         95       45.89       53.14
     SACMEQ |         17        8.21       61.35
      TIMSS |         80       38.65      100.00
------------+-----------------------------------
      Total |        207      100.00

.
. tab test if withoutliers_sim

 Assessment |      Freq.     Percent        Cum.
------------+-----------------------------------
      LLECE |         14       17.07       17.07
        NLA |          1        1.22       18.29
      PIRLS |         23       28.05       46.34
     SACMEQ |         25       30.49       76.83
      TIMSS |         19       23.17      100.00
------------+-----------------------------------
      Total |         82      100.00

.
. tab test if rmlastsacmeq_sim

 Assessment |      Freq.     Percent        Cum.
------------+-----------------------------------
      LLECE |         14       20.00       20.00
        NLA |          1        1.43       21.43
      PIRLS |         23       32.86       54.29
     SACMEQ |         13       18.57       72.86
      TIMSS |         19       27.14      100.00
------------+-----------------------------------
      Total |         70      100.00

*/
