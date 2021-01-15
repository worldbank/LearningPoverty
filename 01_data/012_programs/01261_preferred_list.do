*==============================================================================*
* PROGRAM: SELECTS DATABASE FROM RAWFULL ACCORDING TO PREFERENCE
*==============================================================================*

/* In rawfull, isidvars = countrycode idgrade year_assessment test nla_code subject
   that is, proficiency is in the long format. Meanwhile, enrollment and population
   are in the wide format.

   To get to a "photo" of learning poverty in the world, we need to pick a single
   proficiency from each country (drop non-chosen proficiency observations), and
   pair it with a single enrollment method (drop other enrollment variables) and
   a single population metric (drop other population variables).

   This is what this program does - select a 'runname' out of rawfull, based on
   specified preferences.
*/

cap program drop preferred_list
program define   preferred_list, rclass
    syntax ,                       ///
           RUNNAME(string)         ///
           TIMSS_subject(string)   ///
           [                       ///
           NLA_keep(string)        ///
           DROP_assessment(string) ///
           DROP_round(string)      ///
           ENROLLment(string)      ///
           POPulation(string)      ///
           EXCEPTION(string)       ///
           TIMEwindow(string)      ///
           COUNTRYfilter(string)   ///
           WORLDalso               ///
           ]

/*  The user must specify a number of options
(1) RUNNAME()	        - dictates the name of the run, and the resulting rawlatest file (i.e. preference1000)
(2) TIMSS_subject()   - dictates either math or science for TIMSS. Either enter string "math" or "science"
(3) NLA_keep()        - dictates that the countries in the list are to use the National Learning Assessment. This option takes nla_codes or countrycodes
(4) DROP_assessment() - dictates which assessments to disregard when calculating proficiency levels. This option takes assessment names (ie: SACMEQ)
(4) DROP_round()      - dictates which rounds to disregard when calculating proficiency levels. This option takes assessment_year (ie: TIMSS_2011)
(5) ENROLLment()      - dictates which enrollment to use (options: "validated" or "interpolated"
(6) POPulation()      - dictates which population to use (options: "10" "1014" "primary" "9plus")
(7) EXCEPTION()       - takes assessments (ie: HND_2013_LLECE) that will trump preferred order to ease adding exceptions to the rule
(8) TIMEwindow()      - option to be passed to population_weight program, to display a global number
(9) COUNTRYfilter()   - option to be passed to population_weight program, to display a global number
(10) WORLDalso        - option that displays table for WORLD also, when countryfilter is used
*/

qui {

  * Load rawfull.dta
  use "${clone}/01_data/013_outputs/rawfull.dta", clear

  * Check TIMSS_SUBJECT() option
  * Display error and exit if option not allowed
  if inlist("`timss_subject'","math","science")==0 {
    noi dis as error "TIMSS_SUBJECT must be either math or science. Try again."
    break
  }
  else if "`timss_subject'" == "math" {
    * Math is kept and science is dropped for TIMSS
    drop if subject=="science" & test=="TIMSS"
  }
  else if "`timss_subject'" == "science" {
    * Jordan is one exeption: always keep math, even if science is specified
    * because it has no science data
    drop if subject=="math" & test=="TIMSS" & countrycode!="JOR"
  }

  * Keep only NLAs passed in NLA_KEEP option, dropping all others
  levelsof nla_code if test == "NLA", local(all_nlas)
  foreach  this_nla_code of local all_nlas {
    * If cannot find this nla_code in the list to keep
    if strmatch("`nla_keep'", "*`this_nla_code'*")==0 {
        drop if nla_code == "`this_nla_code'"
    }
  }

  * Drop assessments listed in DROP_ASSESSMENT option
  * First, check if the option was used
  if "`drop_assessment'" != "" {
    * For each test found in rawfull
    levelsof test, local(all_assessments)
    foreach this_test of local all_assessments {
      * Drop observations with this_test if it belongs to drop list
      if strmatch("`drop_assessment'", "*`this_test'*") == 1 {
        drop if test == "`this_test'"
      }
    }
  }

  * Drop surveys listed in DROP_ROUND option
  * First, check if the option was used
  if "`drop_round'" != "" {
    * For each round found in rawfull
    gen round = test + "_" + strofreal(year_assessment)
    levelsof round, local(all_rounds)
    foreach this_round of local all_rounds {
      * Drop observations with this_round if it belongs to drop list
      if strmatch("`drop_round'", "*`this_round'*") == 1 {
        drop if round == "`this_round'"
      }
    }
  }

  * Check ENROLLMENT() option
  * Must be one of enrollment methods supported
  * Assume "validated" as default if not specified
  if "`enrollment'" == "validated" | "`enrollment'" == "" {
    drop enrollment_interpolated*
    rename enrollment_validated_* enrollment_*
  }
  else if "`enrollment'" == "interpolated" {
    drop enrollment_validated*
    rename enrollment_interpolated_* enrollment_*
  }
  else {
    noi dis as error `"ENROLLMENT must be either "interpolated" or "validated". Try again."'
    break
  }

  * Check POPULATION() option
  * Assume "1014" as default if not specified
  if "`population'"=="" local population == "1014"
  * Give error if option specified does not exist
  if inlist("`population'","10","1014","primary","9plus") == 0 {
    noi dis as error `"POPULATION method not supported. Try again (use: "10", "1014", "primary" or "9plus")."'
    break
  }
  else {
    foreach method in 10 1014 primary 9plus {
      * Drop population variables that were not specified
      if "`population'" != "`method'" drop population_*_`method'
    }
  }
  * Rename the population variable
  rename population_*_`population' population_${anchor_year}_*
  * Given that this is simply always = $anchor_year and now appears in var name
  drop year_population

  * Check EXCEPTION() option
  * For as long as it's not empty, will read each surveyid in it and only
  * keep that observation for that country
  while "`exception'" != "" {
    * Parsing out multiple surveyid passed as exceptions
    gettoken this_surveyid exception : exception, parse(" ")
    * Splitting countrycode from surveyid (first 3 letters)
    local this_countrycode = substr("`this_surveyid'",1,3)
    * Drop observations from this country that are not the given exception
    drop if countrycode == "`this_countrycode'" & surveyid != "`this_surveyid'"
    * Remove trailing characters after the parsing
    local exception   = trim("`exception'")
  }

  *-----------------
  * Grade Window
  *-----------------
  * Only assessments of grade 3-6 are considered, so drop all other grades that made it so far
  keep if (idgrade>=3 & idgrade<=6) | missing(idgrade) | idgrade==-999
  * But after considering the assessment hierarchy, we will re-consider grade hierarchy

  *-----------------
  * Time Window
  *-----------------
  * For multiple instances of the same test, the one closest to the anchor_year
  * is preferred, any other is dropped.
  * When tied, chose the most recent (ie: anchor_year=2015, 2015 > 2016 > 2014)
  * which is why we add the .01 in the aux variable below
  gen years_from_anchor = abs($anchor_year - year_assessment + .01)
  bysort countrycode test: egen min_years_from_anchor = min(years_from_anchor)
  * Will only keep the preferred year for each test (including test = "None")
  keep if (years_from_anchor == min_years_from_anchor)
  * Drop aux variables
  drop *years_from_anchor

  *----------------------
  * Assessment Hierarchy
  *----------------------
  * General rule: ILAs > RLAs > EGRA
  * Exception: NLAs are treated as special case, since they trump all other selections

  * Dummies for each assessment (just to make the code more readable)
  foreach assessment in NLA PIRLS TIMSS EGRA {
    gen byte is_`assessment' = (test == "`assessment'")
  }
  * Regional Learning Assessments are bundled together
  gen byte is_RLA   = inlist(test,"LLECE","LLECE-T","PASEC","SACMEQ","SEA-PLM")

  * Originally anchor year of 2015, the exceptions were defined in relation to 2010
  * To make it flexible for future updates
  local year_limit = $anchor_year - 5

  * Preferred ranking of assessments:
  gen int assessment_ranking = .
  * 0. Countries without assessment data should be kept, as well as NLA observations
  replace assessment_ranking = 0 if  is_NLA
  * 1. PIRLS from 2010 or more recent
  replace assessment_ranking = 1 if (is_PIRLS & year_assessment >= `year_limit')
  * 2. TIMSS from 2010 or more recent
  replace assessment_ranking = 2 if (is_TIMSS & year_assessment >= `year_limit')
  * 3. Regional Learning Assessment from 2010 or more recent
  replace assessment_ranking = 3 if (is_RLA   & year_assessment >= `year_limit')
  * 4. PIRLS older than 2010
  replace assessment_ranking = 4 if (is_PIRLS & year_assessment <  `year_limit')
  * 5. TIMSS older than 2010
  replace assessment_ranking = 5 if (is_TIMSS & year_assessment <  `year_limit')
  * 6. Regional Learning Assessment older than 2010
  replace assessment_ranking = 6 if (is_RLA   & year_assessment <  `year_limit')
  * 7. EGRAs
  replace assessment_ranking = 7 if (is_EGRA)
  * 8. No assessment data
  replace assessment_ranking = 8 if test == "None"

  * Keep only the preferred assessment
  bysort countrycode: egen min_assessment_ranking = min(assessment_ranking)
  keep if (assessment_ranking == min_assessment_ranking)
  * Drop aux variables
  drop is_* *assessment_ranking

  * NOTE: there may be more than one grade assessed, which is taken care of in next step

  *-----------------
  * Grade Hierarchy
  *-----------------
  * Grade 4 > Grade 5 > Grade 6 > Grade 3
  gen idgrade_ranking = .
  replace idgrade_ranking = 1 if idgrade == 4
  replace idgrade_ranking = 2 if idgrade == 5
  replace idgrade_ranking = 3 if idgrade == 6
  replace idgrade_ranking = 4 if idgrade == 3

  * Keep only the preferred grade
  bysort countrycode: egen min_idgrade_ranking = min(idgrade_ranking)
  keep if (idgrade_ranking == min_idgrade_ranking)
  * Drop aux variables
  drop *idgrade_ranking

  *------------------------------*
  * Learning poverty calculation
  *------------------------------*
  * Adjusts non-proficiency by out-of school
  foreach subgroup in all fe ma {
    gen adj_nonprof_`subgroup' = 100 * ( 1 - (enrollment_`subgroup'/100) * (1 - nonprof_`subgroup'/100))
    label var adj_nonprof_`subgroup' "Learning Poverty (adjusted non-proficiency, `subgroup')"
  }
  gen byte  lp_by_gender_is_available = !missing(adj_nonprof_fe) & !missing(adj_nonprof_ma)
  label var lp_by_gender_is_available   "Dummy for availibility of Learning Poverty gender disaggregated"

  *-----------------
  * Final touches
  *-----------------
  * Double check that each country appears only once by now
  duplicates tag countrycode, gen(duplicates_countrycode)
  * Will break here if not one observation per countrycode
  assert duplicates_countrycode == 0
  * Now can drop this auxiliary variable
  drop duplicates_countrycode

  * Order
  order countrycode-year_assessment adj_nonprof*

  * Label the preference and creates a description
  gen str preference = "`runname'"
  gen preference_description = "`runname': TIMSS(`timss_subject')+NLA(`nla_keep')+Drop(`drop_assessment')+Population(`population')+Enrollment(`enrollment')"
  label var preference "Preference"
  label var preference_description "Preference description"

  * Auxiliary variables for generating weights
  clonevar anchor_population = population_${anchor_year}_all
  gen anchor_population_w_assessment = anchor_population * !missing(nonprof_all)
  label var anchor_population_w_assessment "Anchor population * has data dummy"

  * Save
  compress

  * If global is one, saves with metadata through edukitsave. Otherwise use regular save
  if $use_edukit_save {
    local description "Preference `runname' dataset. Contains one observation for each of the 217 countries, with corresponding proficiency, enrollment and population. Should be interpreted as a picture of learning poverty in the world, for a chosen angle - that is, rules for selecting the preferred assessment, enrollment and population definitions."
    local sources "All population, enrollment and proficiency sources combined."
    edukit_save, filename("preference`runname'") path("${clone}/01_data/013_outputs/")   ///
                 idvars(countrycode preference) ///
                 varc("value *nonprof* fgt* enrollment_all enrollment_ma enrollment_fe population_* anchor_*; trait idgrade test nla_code subject *year* enrollment_flag enrollment_*source* *definition* *threshold* surveyid countryname region* adminregion* incomelevel* lendingtype* cmu preference_description lp_by_gender_is_available") ///
                 metadata("description `description'; sources `sources'; filename Rawlatest")
  }
  else save "${clone}/01_data/013_outputs/preference`runname'.dta", replace


  *--------------------------------
  * Display number by region
  *--------------------------------
  * NOTE: this section is only for display (makes QA easier), but will not be saved in the preference dataset

  * Displays global number based on population weights for given options
  noi population_weights, preference(`runname') timewindow(`timewindow') countryfilter(`countryfilter')

  * Because most often we want to see both PART2 countries and WORLD, does worldalso when option is specified
  if "`worldalso'" == "worldalso" noi population_weights, preference(`runname') timewindow(`timewindow')

}

end
