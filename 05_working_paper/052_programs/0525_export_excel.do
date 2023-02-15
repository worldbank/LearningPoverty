*==============================================================================*
* 0525 SUBTASK: EXPORT TO EXCEL WORKING PAPER TABLES AND FIGURES
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference
  
  * Change here only if wanting to use a different anchor year
  * than what is being passed in the global in 012_run
  * But don't commit any change here (only commit in global 012_run)
  local anchor_year = $anchor_year

  * File that will be updated, one worksheet at a time from the template
  global template_file "${clone}/05_working_paper/051_rawdata/LPV_Tables_Figures_Template.xlsx"
  global excel_file "${clone}/05_working_paper/053_outputs/LPV_Tables_Figures.xlsx"
  copy "${template_file}" "${excel_file}", replace

  /* List of input files manipulated to export to Excel
  - "${clone}/01_data/013_outputs/preference1005.dta" (T2,T19,T20,T21,F3)
  - "${clone}/01_data/013_outputs/rawfull.dta" (T2,F2)
  - "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS_yr.dta" (T17)
  - "${clone}/02_simulation/021_rawdata/simulation_spells_weighted_region.dta" (T12)
  - "${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_weigthed_incomelevel.dta" (T12)
  - "${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_weigthed_initial_poverty_level.dta" (T12)
  - "${clone}/02_simulation/023_outputs/simfile_preference_1005_regional_growth_summarytable.dta" (T14)
  - "${clone}/02_simulation/023_outputs/simfile_preference_1005_income_level_summarytable.dta" (T14)
  - "${clone}/02_simulation/023_outputs/simfile_preference_1005_initial_poverty_level_summarytable.dta" (T14)
  - "${clone}/02_simulation/023_outputs/simfile_preference_1005_regional_growth_oldused_summarytable.dta" (T14)
  - "${clone}/02_simulation/023_outputs/all_spells.dta" (T4,T5,T13,F6)
  - "${clone}/02_simulation/023_outputs/simfile_preference_1005_regional_growth_fulltable.dta" (F7)
  - "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_lpv_*.dta" (T9)
  - "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_spells.dta" (T11)
  - "${clone}/03_export_tables/033_outputs/individual_tables/spells_stats_by_assessment.dta" (T22)
  - "${clone}/03_export_tables/033_outputs/individual_tables/spells_stats_by_region.dta" (T23)
  - "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_current_lp.dta" (T3,T6,T18)
  - "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_gender_lp.dta" (T10)
  - "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_SA_lp.dta" (T7,T8)
  */

  *-----------------------------------------------------------------------------
  * Auxiliary programs that may be called in any table
  *-----------------------------------------------------------------------------

  * Since some people at WB are used with region abbreviations that are not
  * the ones used in the system, we change them to the "usual" ones in tables
  cap program drop rename_regions
  program define   rename_regions, nclass
    syntax, [regionvar(string) namevar(string)]
    if "`regionvar'" == ""  local regionvar "region"
    replace `regionvar' = "EAP" if `regionvar' == "EAS"
    replace `regionvar' = "ECA" if `regionvar' == "ECS"
    replace `regionvar' = "LAC" if `regionvar' == "LCN"
    replace `regionvar' = "MNA" if `regionvar' == "MEA"
    replace `regionvar' = "SAR" if `regionvar' == "SAS"
    replace `regionvar' = "SSA" if `regionvar' == "SSF"
    if "`namevar'" != "" {
      replace `namevar' = "East Asia and Pacific"        if `regionvar' == "EAP"
      replace `namevar' = "Europe and Central Asia"      if `regionvar' == "ECA"
      replace `namevar' = "Latin American and Caribbean" if `regionvar' == "LAC"
      replace `namevar' = "Middle East and North Africa" if `regionvar' == "MNA"
      replace `namevar' = "North America"                if `regionvar' == "NAC"
      replace `namevar' = "South Asia"                   if `regionvar' == "SAR"
      replace `namevar' = "Sub-Saharan Africa"           if `regionvar' == "SSA"
    }
  end

  * Usual order of groups that is different from alphabetical order
  cap program drop order_incomelevel
  program define   order_incomelevel, nclass
    syntax, [incomelevelvar(string) namevar(string)]
    if "`incomelevelvar'" == ""  local incomelevelvar "incomelevel"
    generate order_incomelevel = .
    replace  order_incomelevel = 1 if `incomelevelvar' == "HIC"
    replace  order_incomelevel = 2 if `incomelevelvar' == "UMC"
    replace  order_incomelevel = 3 if `incomelevelvar' == "LMC"
    replace  order_incomelevel = 4 if `incomelevelvar' == "LIC"
    if "`namevar'" != "" {
      replace `namevar' = "High income"         if `incomelevelvar' == "HIC"
      replace `namevar' = "Upper middle income" if `incomelevelvar' == "UMC"
      replace `namevar' = "Lower middle income" if `incomelevelvar' == "LMC"
      replace `namevar' = "Low income"          if `incomelevelvar' == "LIC"
    }
  end

  * Usual order of groups that is different from alphabetical order
  cap program drop order_lendingtype
  program define   order_lendingtype, nclass
    syntax, [lendingtypevar(string) namevar(string)]
    if "`lendingtypevar'" == ""  local lendingtypevar "lendingtype"
    generate order_lendingtype = .
    replace  order_lendingtype = 1 if `lendingtypevar' == "LNX"
    replace  order_lendingtype = 2 if `lendingtypevar' == "IBD"
    replace  order_lendingtype = 3 if `lendingtypevar' == "IDXB"
    replace  order_lendingtype = 4 if `lendingtypevar' == "IDB"
    replace  order_lendingtype = 5 if `lendingtypevar' == "IDX"
    if "`namevar'" != "" {
      replace `namevar' = "Part 1"      if `lendingtypevar' == "LNX"
      replace `namevar' = "IBRD"        if `lendingtypevar' == "IBD"
      replace `namevar' = "IDA / Blend" if `lendingtypevar' == "IDXB"
      replace `namevar' = "Blend"       if `lendingtypevar' == "IDB"
      replace `namevar' = "IDA"         if `lendingtypevar' == "IDX"
    }
  end

  * Trick to fill cells in Excel with "N/A"
  cap program drop fill_na
  program define   fill_na, nclass
    syntax, ncol(integer)
    if `ncol'>1 {
      clear
      set obs 1
      forvalues i=1/`ncol' {
        gen str col`i' = "N/A"
      }
    }
  end

  *-----------------------------------------------------------------------------
  * Table 1 Assessment data used in constructing the consolidated global dataset
  *-----------------------------------------------------------------------------
  use "${clone}/05_working_paper/053_outputs/assessment_correlations.dta", clear
  gen blank = .
  order r_country r_county r_school r_student blank assessment subject
  export excel using "${excel_file}", sheet("T1", modify) cell(D7) nolabel keepcellfmt

  noi disp as txt "Table 1 exported"

  *-----------------------------------------------------------------------------
  * Table 2 Assessment data used in constructing the consolidated global dataset
  *-----------------------------------------------------------------------------
  * Only count what is in the Global Number
  tempfile in_global_number
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  * Those 3 PASEC are "desguised" as NLAs because they belong to an earlier round
  replace test = "PASEC" if inlist(countrycode,"MLI","MDG","COD")
  gen byte included = (year_assessment >= 2011 & lendingtype != "LNX")
  keep if !missing(adj_nonprof_all) & included == 1
  collapse (sum) included anchor_population, by(test)
  save `in_global_number', replace

  * Now counts everything, including what was used for spells
  use "${clone}/01_data/013_outputs/rawfull.dta", clear
  * Those 3 PASEC are "desguised" as NLAs because they belong to an earlier round
  replace test = "PASEC" if inlist(countrycode,"MLI","MDG","COD")
  bys countrycode test : keep if _n == 1
  drop if inlist(test, "EGRA", "None")
  gen byte exists = 1
  collapse (sum) exists, by(test)
  merge 1:1 test using `in_global_number', nogen

  * Same order as in Template
  gen byte aux_order = .
  replace  aux_order = 1 if test == "PIRLS"
  replace  aux_order = 2 if test == "TIMSS"
  replace  aux_order = 3 if test == "LLECE"
  replace  aux_order = 4 if test == "PASEC"
  replace  aux_order = 5 if test == "SACMEQ"
  replace  aux_order = 6 if test == "NLA"
  sort aux_order
  replace anchor_population = anchor_population/1E6
  replace included = 0 if missing(included)
  replace anchor_population = 0 if missing(anchor_population)
  drop aux_order test
  export excel using "${excel_file}", sheet("T2", modify) cell(F7) nolabel keepcellfmt

  * Annex with NLA info
  import delimited "${clone}/04_repo_update/041_rawdata/national_assessment_proficiency.md", delimiter("|") varnames(1) clear
  keep wbcode year cutoff source
  destring year, replace force
  tempfile cutoff_nla
  save `cutoff_nla', replace
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  replace test = "PASEC" if inlist(countrycode,"MLI","MDG","COD")
  keep if test == "NLA"
  keep countryname year_assessment nla_code
  rename (year_assessment nla_code) (year wbcode)
  merge 1:1 year wbcode using `cutoff_nla', assert(match using) keep(match) nogen
  drop wbcode
  order countryname year
  export excel using "${excel_file}", sheet("T2", modify) cell(B21) nolabel keepcellfmt

  noi disp as txt "Table 2 exported"


  *-----------------------------------------------------------------------------
  * Table 3 Population and country coverage by country groups
  * Table 15 Population and country coverage by country groups, latest available learning assessment
  *-----------------------------------------------------------------------------
  local cell_old_0 "C8"
  local cell_old_1 "C29"
  foreach i in 0 1 {
    use "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_current_lp.dta", clear
    keep if inlist(aggregated_by, "incomelevel", "global", "lendingtype", "region") & old == `i'
    keep   group coverage n_countries total_countries part2_only aggregated_by population_w_data
    reshape wide coverage n_countries total_countries population_w_data, i(group) j(part2_only)
    rename_regions,    regionvar(group)      namevar(group)
    order_incomelevel, incomelevelvar(group) namevar(group)
    order_lendingtype, lendingtypevar(group) namevar(group)
    generate order_groups = .
    replace order_groups = 1 if aggregated_by == "global"
    replace order_groups = 2 if aggregated_by == "region"
    replace order_groups = 3 if aggregated_by == "incomelevel"
    replace order_groups = 4 if aggregated_by == "lendingtype"
    sort  order_groups order_incomelevel order_lendingtype group
    gen blank = .
    order group n_countries0 total_countries0 population_w_data0 coverage0 blank n_countries1 total_countries1 population_w_data1 coverage1
    keep  group - coverage1
    replace group = "Overall" if group == "TOTAL"
    export excel using "${excel_file}", sheet("T3", modify) cell(`cell_old_`i'') nolabel keepcellfmt
  }

  * N/A trick for NAC and Part1 in "Low and Middle Contries" panel
  fill_na, ncol(4)
  foreach cell in I13 I20 I34 I41 {
    export excel using "${excel_file}", sheet("T3", modify) cell(`cell') nolabel keepcellfmt
  }

  noi disp as txt "Table 3 & 15 exported"


  *-----------------------------------------------------------------------------
  * Table 4 Share of children who are learning-poor by late primary by country groups
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_current_lp.dta", clear
  keep if inlist(aggregated_by, "global", "region", "incomelevel", "lendingtype") & old == 0
  keep   group mean_lp se_lp min_lp max_lp part2_only aggregated_by
  reshape wide mean_lp se_lp min_lp max_lp, i(group) j(part2_only)
  rename_regions,    regionvar(group)      namevar(group)
  order_incomelevel, incomelevelvar(group) namevar(group)
  order_lendingtype, lendingtypevar(group) namevar(group)
  generate order_groups = .
  replace order_groups = 1 if aggregated_by == "global"
  replace order_groups = 2 if aggregated_by == "region"
  replace order_groups = 3 if aggregated_by == "incomelevel"
  replace order_groups = 4 if aggregated_by == "lendingtype"
  sort  order_groups order_incomelevel order_lendingtype group
  gen blank = .
  order group mean_lp0 se_lp0 min_lp0 max_lp0 blank mean_lp1 se_lp1 min_lp1 max_lp1
  keep  group - max_lp1
  replace group = "Overall" if group == "TOTAL"
  export excel using "${excel_file}", sheet("T4", modify) cell(C8) nolabel keepcellfmt

  * N/A trick for NAC and Part1 in "Low and Middle Contries" panel
  fill_na, ncol(4)
  export excel using "${excel_file}", sheet("T4", modify) cell(I13) nolabel keepcellfmt
  export excel using "${excel_file}", sheet("T4", modify) cell(I20) nolabel keepcellfmt

  noi disp as txt "Table 4 exported"


  *-----------------------------------------------------------------------------
  * Table 5 Results sensitivity in respect to choice of reporting window
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_SA_lp.dta", clear
  keep if aggregated_by == "global"
  gen auxfile = substr(file, 15, .)
  keep if inlist(auxfile, "2001_part2", "2001_world", "2011_part2", "2011_world", "2013_part2", "2013_world", "2015_part2", "2015_world")
  split auxfile, p("_")
  rename (auxfile1 auxfile2) (timewindow globaldef)
  keep         mean_lp se_lp coverage n_countries avg_assess_year timewindow globaldef
  reshape wide mean_lp se_lp coverage n_countries avg_assess_year, i(timewindow) j(globaldef) string
  foreach globaldef in part2 world {
    label var mean_lp`globaldef'         "Learning Poverty (%)"
    label var se_lp`globaldef'           "S.E. L.P. (%)"
    label var coverage`globaldef'        "Population Coverage (%)"
    label var n_countries`globaldef'     "N countries"
    label var avg_assess_year`globaldef' "Avg. Year"
  }
  sort timewindow
  replace timewindow = "Latest"  if timewindow == "2001"
  replace timewindow = "8 years" if timewindow == "2011"
  replace timewindow = "6 years" if timewindow == "2013"
  replace timewindow = "4 years" if timewindow == "2015"
  gen blank = .
  label var blank " "
  label var timewindow "Window"
  order timewindow mean_lpworld se_lpworld coverageworld n_countriesworld avg_assess_yearworld ///
        blank      mean_lppart2 se_lppart2 coveragepart2 n_countriespart2 avg_assess_yearpart2
  export excel using "${excel_file}", sheet("T5", modify) cell(B7) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 5 exported"


  *-----------------------------------------------------------------------------
  * Table 6 Results sensitivity in respect to choice of population of reference
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_SA_lp.dta", clear
  keep if aggregated_by == "global"
  gen auxfile = substr(file, 20, .)
  keep if inlist(auxfile, "1014_part2", "1014_world", "0516_part2", "0516_world") | inlist(auxfile, "10_part2", "10_world", "9plus_part2", "9plus_world", "primary_part2", "primary_world")
  split auxfile, p("_")
  rename (auxfile1 auxfile2 total_population) (age globaldef population)
  keep         mean_lp se_lp population coverage learning_poor age globaldef
  reshape wide mean_lp se_lp population coverage learning_poor, i(age) j(globaldef) string
  foreach globaldef in part2 world {
    label var mean_lp`globaldef'       "Learning Poverty (%)"
    label var se_lp`globaldef'         "S.E. L.P. (%)"
    label var population`globaldef'    "Population (millions)"
    label var coverage`globaldef'      "Population Coverage (%)"
    label var learning_poor`globaldef' "Learning Poor (millions)"
  }
  replace age = "10-14" if age == "1014"
  replace age = "5-16" if age == "0516"
  sort age
  label var age "Population Definition"
  gen blank = .
  label var blank " "
  order age    mean_lpworld se_lpworld populationworld coverageworld learning_poorworld ///
        blank  mean_lppart2 se_lppart2 populationpart2 coveragepart2 learning_poorpart2
  export excel using "${excel_file}", sheet("T6", modify) cell(B7) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 6 exported"


  *-----------------------------------------------------------------------------
  * Table 7  Decomposition of learning poverty by learning and schooling
  *-----------------------------------------------------------------------------
  * Pooled genders, All countries and Part 2
  use "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_lpv_all.dta", clear
  gen byte part2_only = (filter != "all ctrys")
  drop filter
  reshape wide total bmp oos shr_bmp shr_oos, i(category panel) j(part2_only)
  rename_regions,    regionvar(category)      namevar(category)
  order_incomelevel, incomelevelvar(category) namevar(category)
  order_lendingtype, lendingtypevar(category) namevar(category)
  replace category = "Overall" if category == "WLD" & panel == "reg"
  drop if category == "WLD"
  generate order_groups = .
  replace order_groups = 1 if category == "Overall"
  replace order_groups = 2 if panel == "reg" & category != "Overall"
  replace order_groups = 3 if panel == "inc"
  replace order_groups = 4 if panel == "len"
  gen blank = .
  label var blank " "
  sort order_groups order_incomelevel order_lendingtype category
  order category total0 bmp0 oos0 shr_bmp0 shr_oos0 blank total1 bmp1 oos1 shr_bmp1 shr_oos1
  keep  category - shr_oos1
  export excel using "${excel_file}", sheet("T7", modify) cell(C9) nolabel keepcellfmt

  * N/A trick for NAC and Part1 in "Low and Middle Contries" panel
  fill_na, ncol(5)
  export excel using "${excel_file}", sheet("T7", modify) cell(J14) nolabel keepcellfmt
  export excel using "${excel_file}", sheet("T7", modify) cell(J21) nolabel keepcellfmt

  noi disp as txt "Table 7 exported"


  *-----------------------------------------------------------------------------
  * Table 8 Learning poverty by boys and girls, and country groups, for a subsample of countries
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/outline_all_gender_lp.dta", clear
  keep if inlist(aggregated_by, "global", "region", "incomelevel", "lendingtype")
  drop concatenated agg_file file *allcomp*
  reshape wide n_countries mean_lp_ma se_lp_ma mean_lp_fe se_lp_fe, i(group aggregated_by) j(part2_only)
  rename_regions,    regionvar(group)      namevar(group)
  order_incomelevel, incomelevelvar(group) namevar(group)
  order_lendingtype, lendingtypevar(group) namevar(group)
  generate order_groups = .
  replace order_groups = 1 if aggregated_by == "global"
  replace order_groups = 2 if aggregated_by == "region"
  replace order_groups = 3 if aggregated_by == "incomelevel"
  replace order_groups = 4 if aggregated_by == "lendingtype"
  sort  order_groups order_incomelevel order_lendingtype group
  gen blank = .
  order group n_countries0 mean_lp_ma0 se_lp_ma0 mean_lp_fe0 se_lp_fe0  ///
        blank n_countries1 mean_lp_ma1 se_lp_ma1 mean_lp_fe1 se_lp_fe1
  keep  group - se_lp_fe1
  replace group = "Overall" if group == "TOTAL"
  export excel using "${excel_file}", sheet("T8", modify) cell(C9) nolabel keepcellfmt

  * N/A trick for NAC and Part1 in "Low and Middle Contries" panel
  fill_na, ncol(5)
  export excel using "${excel_file}", sheet("T8", modify) cell(J14) nolabel keepcellfmt
  export excel using "${excel_file}", sheet("T8", modify) cell(J21) nolabel keepcellfmt

  * Corresponding notes below the table:

  * - list of Enrollment gender flag countries
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  keep if enrollment_flag & lp_by_gender_is_available
  keep countrycode countryname
  export excel using "${excel_file}", sheet("T8", modify) cell(B29) nolabel keepcellfmt

  * - share of population with gender disaggregated data
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  collapse (sum) population_`anchor_year'_all, by(lp_by_gender_is_available)
  sum population_`anchor_year'_all
  gen share = population_`anchor_year'_all / `r(sum)'
  gen group = "all countries"
  export excel using "${excel_file}", sheet("T8", modify) cell(J29) firstrow(variables) nolabel keepcellfmt

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  keep if lendingtype != "LNX"
  collapse (sum) population_`anchor_year'_all, by(lp_by_gender_is_available)
  sum population_`anchor_year'_all
  gen share = population_`anchor_year'_all / `r(sum)'
  gen group = "low and middle income countries"
  export excel using "${excel_file}", sheet("T8", modify) cell(J34) firstrow(variables) nolabel keepcellfmt

  noi disp as txt "Table 8 exported"


  *-----------------------------------------------------------------------------
  * Table 9  Decomposition of learning poverty by learning and schooling, for boys and girls
  *-----------------------------------------------------------------------------
  * Gender disaggregated, All countries only
  use "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_lpv_ma.dta", clear
  gen gender = 0
  append using "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_lpv_fe.dta"
  replace gender = 1 if missing(gender)
  keep if filter == "all ctrys"
  reshape wide total bmp oos shr_bmp shr_oos, i(category panel filter) j(gender)
  rename_regions,    regionvar(category)      namevar(category)
  order_incomelevel, incomelevelvar(category) namevar(category)
  order_lendingtype, lendingtypevar(category) namevar(category)
  replace category = "Overall" if category == "WLD" & panel == "reg"
  drop if category == "WLD"
  generate order_groups = .
  replace order_groups = 1 if category == "Overall"
  replace order_groups = 2 if panel == "reg" & category != "Overall"
  replace order_groups = 3 if panel == "inc"
  replace order_groups = 4 if panel == "len"
  gen blank = .
  label var blank " "
  sort order_groups order_incomelevel order_lendingtype category
  order category total0 bmp0 oos0 shr_bmp0 shr_oos0 blank total1 bmp1 oos1 shr_bmp1 shr_oos1
  keep  category - shr_oos1
  export excel using "${excel_file}", sheet("T9", modify) cell(C9) nolabel keepcellfmt

  noi disp as txt "Table 9 exported"


  *-----------------------------------------------------------------------------
  * Table 10 Decomposition of the change in learning poverty by learning and schooling
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/decomposition_spells.dta", clear
  drop if category == "SAS"
  rename_regions, regionvar(category) namevar(category)
  replace category = "Overall" if category == "WLD"
  export excel using "${excel_file}", sheet("T10", modify) cell(B6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 10 exported"


  *-----------------------------------------------------------------------------
  * Table 11 Annualized change in learning poverty (in percentage points) by
  * country group, 2000-2017
  *-----------------------------------------------------------------------------
  **** By Region ****
  use "${clone}/02_simulation/021_rawdata/simulation_spells_weighted_region.dta", clear
  label var region "Region"
  rename_regions, namevar(region)
  label var delta_reg_50 "BaU (p50)"
  forvalues p=60(10)90 {
    label var delta_reg_`p' "r`p'"
  }
  keep region *50 *60 *70 *80 *90
  * Trick to move overall line to firstrow
  gen sortaux = _n
  replace sortaux = 0 if region == "Overall"
  sort sortaux
  drop sortaux
  export excel using "${excel_file}", sheet("T11", modify) cell(C7) nolabel keepcellfmt

  **** By Income Level ****
  use "${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_weighted_incomelevel.dta", clear
  label var incomelevel "Income Level"
  label var delta_reg_50 "BaU (p50)"
  forvalues p=60(10)90 {
    label var delta_reg_`p' "r`p'"
  }
  keep incomelevel *50 *60 *70 *80 *90
  order_incomelevel, namevar(incomelevel)
  sort order_incomelevel
  drop order_incomelevel
  drop if incomelevel == "Overall"
  export excel using "${excel_file}", sheet("T11", modify) cell(C14) nolabel keepcellfmt

  **** By Initial Learning Poverty ****
  use "${clone}/02_simulation/021_rawdata/sensitivity_checks/simulation_spells_weighted_initial_poverty_level.dta", clear
  label var initial_poverty_level "Initial Poverty Level"
  label var delta_reg_50 "BaU (p50)"
  forvalues p=60(10)90 {
    label var delta_reg_`p' "r`p'"
  }
  keep initial* *50 *60 *70 *80 *90
  drop if initial_poverty_level == "Overall"
  export excel using "${excel_file}", sheet("T11", modify) cell(C18) nolabel keepcellfmt

  noi disp as txt "Table 11 exported"


  *-----------------------------------------------------------------------------
  * Table 12 Learning poverty rates in 2030 under two scenarios (simulation using spells by region)
  *-----------------------------------------------------------------------------

  local table_12_A_file "simfile_preference_`chosen_preference'_regional_growth_summarytable.dta"
  local table_12_B_file "simfile_preference_`chosen_preference'_income_level_summarytable.dta"
  local table_12_C_file "simfile_preference_`chosen_preference'_initial_poverty_level_summarytable.dta"
  local table_12_D_file "simfile_preference_`chosen_preference'_regional_growth_glossy_summarytable.dta"
  local table_12_E_file "simfile_preference_`chosen_preference'_regional_growth_min2_summarytable.dta"

  local table_12_A_place "B9"
  local table_12_B_place "B25"
  local table_12_C_place "B37"
  local table_12_D_place "B51"
  local table_12_E_place "B63"

  * Run for each panel in Table 12
  foreach table in table_12_A table_12_B table_12_C table_12_D table_12_E {
    use "${clone}/02_simulation/023_outputs/``table'_file'", clear
    forvalues i=1/4 {
      gen blank`i' = .
      label var blank`i' " "
    }
    order region pop_2015 pop_2030 blank1 lpv_own_2015 blank2 lpv_own_2030 ///
          lpv_r80_2030 blank3 lps_own_2015 blank4 lps_own_2030 lps_r80_2030
    rename_regions, namevar(region)
    replace region = "Overall" if region == "_Overall"
    export excel using "${excel_file}", sheet("T12", modify) cell(``table'_place') nolabel keepcellfmt
  }

  noi disp as txt "Table 12, 23 & 24 exported"


  *-----------------------------------------------------------------------------
  * Table 13 Relationship between reading and math proficiency (PISA)
  *-----------------------------------------------------------------------------
  insheet using "${clone}/05_working_paper/053_outputs/pisa_2.txt", clear
  tempfile tmp
  save    `tmp', replace

  insheet using "${clone}/05_working_paper/053_outputs/pisa_1.txt", clear
  append using `tmp'
  drop v1
  drop in 9
  drop in 1

  gen blank1 = .
  gen blank2 = .
  label var blank1 " "
  label var blank2 " "

  order v2 v3 v4 v5 blank1 v6 v7 v8 v9
  drop if _n == _N
  export excel using "${excel_file}", sheet("T13", modify) cell(C8) nolabel keepcellfmt

  noi disp as txt "Table 13 exported"


  *-----------------------------------------------------------------------------
  * Table 14 Non-comparable spells in PIRLS and TIMMS
  *-----------------------------------------------------------------------------
  use "${clone}/02_simulation/021_rawdata/comparability_TIMSS_PIRLS_yr.dta", clear
  replace comparable = 0 if countrycode == "ZAF" & test == "PIRLS"
  keep if comparable == 0
  keep countrycode country spell test idgrade
  sort test countrycode
  export excel using "${excel_file}", sheet("T14", modify) cell(G6) firstrow(variables) nolabel keepcellfmt

  noi disp as txt "Table 14 exported"


  *-----------------------------------------------------------------------------
  * [Table 15 is with Table 3]
  *-----------------------------------------------------------------------------


  *-----------------------------------------------------------------------------
  * Table 16  Source of enrollment data
  *-----------------------------------------------------------------------------
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  keep if !missing(adj_nonprof_all)
  preserve
    collapse (count) freq=adj_nonprof_all, by(enrollment_definition)
    qui sum freq
    gen percent = freq/`r(sum)'
    label var freq "Freq."
    label var percent "Percent"
    label var enrollment_definition "Type of enrollment indicator"
    gsort -freq enrollment_definition
    export excel using "${excel_file}", sheet("T16", modify) cell(B6) firstrow(varlabels) nolabel keepcellfmt
  restore

  keep countrycode countryname enrollment_definition
  order countrycode countryname enrollment_definition
  keep if enrollment_definition != "ANER"
  export excel using "${excel_file}", sheet("T16", modify) cell(F6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 16 exported"


  *-----------------------------------------------------------------------------
  * Table 17 Population ages 10-14 years old by region and income classifications (Year = 2015)
  *-----------------------------------------------------------------------------
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  keep regionname incomelevel population_`anchor_year'_all
  separate population_`anchor_year'_all , by(incomelevel)
  collapse (sum) population_`anchor_year'_all?, by(regionname)
  label var population_`anchor_year'_all1 "High income Countries"
  label var population_`anchor_year'_all2 "Low income Countries"
  label var population_`anchor_year'_all3 "Low-middle income"
  label var population_`anchor_year'_all4 "Upper-middle income"
  order regionname population_`anchor_year'_all1 population_`anchor_year'_all4 population_`anchor_year'_all3 population_`anchor_year'_all2
  preserve
    collapse (sum) population*
    gen regionname = "Global"
    tempfile globalpop
    save `globalpop', replace
  restore
  append using `globalpop'

  egen population_`anchor_year'_alltotal = rowtotal(population_`anchor_year'_all?)
  label var population_`anchor_year'_alltotal "Total"

  export excel using "${excel_file}", sheet("T17", modify) cell(B6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 17 exported"


  *-----------------------------------------------------------------------------
  * Table 18  Weighted average and correlation of PISA and Learning Poverty country
  * averages according to country groupings and moving windows of PISA data (weighted)
  *-----------------------------------------------------------------------------
  use "${clone}/05_working_paper/053_outputs/rho-BMP-PISA-LP.dta", clear
  * add a collumn with N
  gen N = LP[_n+1] if rho_PISA_LP != .
  drop if N == .
  * Add a blank column and a blank line
  gen blank1 = .
  gen blank2 = .
  gen blank3 = .
  label var blank1 " "
  label var blank2 " "
  label var blank3 " "
  gen obs_n = _n
  order PISA_BMP LP_BMP LP blank1 rho_PISA_LP_BMP rho_PISA_LP blank2
  set obs `=_N +1'
  replace obs_n = 5.5 if missing(obs_n)
  sort obs_n
  export excel using "${excel_file}", sheet("T18", modify) cell(E8) nolabel keepcellfmt

  noi disp as txt "Table 18 exported"


  *-----------------------------------------------------------------------------
  * Table 19 Correlation of early grade and end of primary scores
  *-----------------------------------------------------------------------------
  use "${clone}/05_working_paper/053_outputs/rho-BMP-early-end.dta", clear
  * add a collumn with N
  gen N = End_Primary[_n+1] if rho != .
  drop if N == .
  * drop FGT2
  drop in 12
  drop in 8
  drop in 4
  * Add a blank column and a blank line
  gen blank1 = .
  gen blank2 = .
  gen blank3 = .
  label var blank1 " "
  label var blank2 " "
  gen obs_n = _n
  set obs `=_N +1'
  replace obs_n = 3.5 if missing(obs_n)
  set obs `=_N +1'
  replace obs_n = 6.5 if missing(obs_n)
  sort obs_n
  order Early_Grade End_Primary blank1 rho blank2 N
  keep  Early_Grade-N
  export excel using "${excel_file}", sheet("T19", modify) cell(D7) nolabel keepcellfmt

  noi disp as txt "Table 19 exported"


  *-----------------------------------------------------------------------------
  * Table 20 Country Numbers
  *-----------------------------------------------------------------------------
  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  keep if year_assessment >= 2011 & !missing(adj_nonprof_all)
  gen oos_all = 100 - enrollment_all
  sort region countryname
  rename_regions
  * Those 3 PASEC are "desguised" as NLAs because they belong to an earlier round
  * and COD also had the actual year of 2010 disguised as 2011
  replace year_assessment = 2010 if countrycode == "COD"
  replace test = "PASEC"         if inlist(countrycode,"MLI","MDG","COD")
  local  vars2keep "region countryname oos_all nonprof_all adj_nonprof_all test year_assessment"
  order `vars2keep'
  keep  `vars2keep'
  label var oos_all          "Out of School (OOS, %)"
  label var nonprof_all      "Below Minimum Proficiency (BMP, %)"
  label var adj_nonprof_all  "Learning Poverty (%)"
  label var test             "Assessment"
  label var year_assessment  "Assessment Year"
  export excel using "${excel_file}", sheet("T20", modify) cell(B6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 20 exported"


  *-----------------------------------------------------------------------------
  * Table 21 Summary statistics of the annualized changes in learning poverty
  * and initial condition by assessment
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/spells_stats_by_assessment.dta", clear
  * Add a blank column and a blank line
  gen blank1 = .
  gen blank2 = .
  label var blank1 " "
  label var blank2 " "
  gen obs_n = _n
  order test *d blank1 *lp blank2 filter obs_n
  set obs `=_N +1'
  replace obs_n = 6.5 if missing(obs_n)
  sort obs_n
  export excel using "${excel_file}", sheet("T21", modify) cell(C8) nolabel keepcellfmt

  noi disp as txt "Table 21 exported"


  *-----------------------------------------------------------------------------
  * Table 22  Summary statistics of the annualized changes in learning poverty and
  * initial condition by region, low- and middle-income countries (weighted and unweighted)
  *-----------------------------------------------------------------------------
  use "${clone}/03_export_tables/033_outputs/individual_tables/spells_stats_by_region.dta", clear
  * Add a blank column and a blank line
  gen blank1 = .
  gen blank2 = .
  label var blank1 " "
  label var blank2 " "
  gen obs_n = _n
  order region *d blank1 *lp blank2 weights obs_n
  set obs `=_N +1'
  replace obs_n = 7.5 if missing(obs_n)
  sort obs_n
  rename_regions, namevar(region)
  export excel using "${excel_file}", sheet("T22", modify) cell(C8) nolabel keepcellfmt

  noi disp as txt "Table 22 exported"


  *-----------------------------------------------------------------------------
  * [Tables 23 and 24 are with Table 12]
  *-----------------------------------------------------------------------------

  *-----------------------------------------------------------------------------
  * Table 25 Assessment comparability in terms of grades by region and income level
  *-----------------------------------------------------------------------------
  use "${clone}/02_simulation/023_outputs/all_spells.dta", clear
  gen rich_countries   = (almostpotential_sim & lendingtype == "LNX")
  gen client_countries = (almostused_sim & lendingtype != "LNX")
  collapse (max) *_countries, by(countrycode idgrade)
  keep if rich_countries == 1 | client_countries == 1
  collapse (sum) *_countries, by(idgrade)
  preserve
    collapse (sum) *_countries
    tempfile rowtotal
    save `rowtotal', replace
  restore
  append using `rowtotal'
  egen all_countries = rowtotal(rich_countries client_countries)
  sort idgrade
  assert inlist(idgrade,4,5,6,.)
  tostring idgrade, replace
  replace idgrade = "Total" if idgrade == "."
  label var idgrade "Grade"
  label var rich_countries   "High-Income Countries"
  label var client_countries "Low- and Middle-Income Countries"
  label var all_countries "Total"
  export excel using "${excel_file}", sheet("T25", modify) cell(B7) firstrow(varlabels) nolabel keepcellfmt

  use "${clone}/02_simulation/023_outputs/all_spells.dta", clear
  gen rich_countries = (comparable == 1 & excess_timss == 0 & lendingtype == "LNX")
  gen client_countries = (comparable == 1 & excess_timss == 0 & lendingtype != "LNX")
  collapse (max) *_countries, by(countrycode idgrade)
  keep if rich_countries == 1 | client_countries == 1
  merge m:1 countrycode using "${clone}/01_data/013_outputs/rawlatest.dta", keepusing(population_2017_all) assert(match using) keep(match) nogen

  gen population_rich   = population_`anchor_year'_all * rich_countries
  gen population_client = population_`anchor_year'_all * client_countries

  collapse (sum) population_rich population_client, by(idgrade)
  egen population_all = rowtotal(population_rich population_client)
  assert _N == 3
  set obs 4
  foreach segment in rich client all {
    sum population_`segment'
    replace population_`segment' = 100* population_`segment' / `r(sum)'
    replace population_`segment' = 100 if _n == 4
  }
  sort idgrade
  assert inlist(idgrade,4,5,6,.)
  drop idgrade
  label var population_rich   "High-Income Countries"
  label var population_client "Low- and Middle-Income Countries"
  label var population_all "Total"
  export excel using "${excel_file}", sheet("T25", modify) cell(G7) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Table 25 exported"


  *-----------------------------------------------------------------------------
  * Table 26 Temporal comparability within assessments
  *-----------------------------------------------------------------------------
  use "${clone}/02_simulation/023_outputs/all_spells.dta", clear
  drop if test == "EGRA"
  rename (potential_sim used_sim)             (world_rangeok  part2_rangeok)
  rename (almostpotential_sim almostused_sim) (world_anyrange part2_anyrange)
  collapse (sum) *_anyrange *_rangeok, by(test)
  preserve
    collapse (sum) *_anyrange *_rangeok
    tempfile rowtotal
    save `rowtotal', replace
  restore
  append using `rowtotal'
  replace test = "Total" if _n == _N
  label var world_anyrange "All Countries"
  label var world_rangeok  "All Countries, no outliers"
  label var part2_anyrange "Low- and Middle-Income Countries"
  label var part2_rangeok  "Low- and Middle-Income Countries, no outliers"
  gen blank = .
  order test world_anyrange world_rangeok blank part2_anyrange part2_rangeok
  export excel using "${excel_file}", sheet("T26", modify) cell(B8) nolabel keepcellfmt

  * List of outliers from Part2
  use "${clone}/02_simulation/023_outputs/all_spells.dta", clear
  rename (potential_sim used_sim)             (world_rangeok  part2_rangeok)
  rename (almostpotential_sim almostused_sim) (world_anyrange part2_anyrange)
  keep if part2_rangeok == 0 & part2_anyrange == 1
  keep countrycode-delta_lp
  sort test delta_lp
  export excel using "${excel_file}", sheet("T26", modify) cell(B19) firstrow(variables) nolabel keepcellfmt

  noi disp as txt "Table 26 exported"


  *-----------------------------------------------------------------------------
  * Figure 1 Rates of non-proficiency in reading:  end-primary vs.lower-secondary
  * (15-year-olds, PISA)
  *-----------------------------------------------------------------------------
  use "${clone}/05_working_paper/053_outputs/pisa-lp-by-country.dta", clear
  keep if latest_pisa == 1
  foreach var in nonprof_all adj_nonprof_all value {
      replace `var' = `var'/100
  }
  drop indicator diff maxyear latest_pisa
  order countrycode region incomelevel lendingtype test nonprof_all year_lp adj_nonprof_all value year_pisa
  export excel using "${excel_file}", sheet("F1", modify) cell(O6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Figure 1 exported"


  *-----------------------------------------------------------------------------
  * Figure 2 Proficiency in reading: Early Grade vs End of Primary
  *-----------------------------------------------------------------------------
  use "${clone}/05_working_paper/053_outputs/earlygrade-lp-by-country.dta", clear
  export excel using "${excel_file}", sheet("F2", modify) cell(W6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Figure 2 exported"


  *-----------------------------------------------------------------------------
  * Figure 3 Learning poverty and the average learning gap by country
  *-----------------------------------------------------------------------------
  use "${clone}/01_data/013_outputs/rawfull.dta", clear
  keep if !missing(nonprof_all) & !missing(fgt1_all) & !missing(fgt2_all)
  drop if test == "TIMSS" & subject == "math"
  order countrycode test idgrade subject year_assessment nonprof_all fgt1_all fgt2_all region incomelevel lendingtype
  keep  countrycode - lendingtype
  sort test
  replace nonprof_all = nonprof_all/100
  export excel using "${excel_file}", sheet("F3", modify) cell(O5) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Figure 3 exported"


  *-----------------------------------------------------------------------------
  * Figure 4 Learning poverty gender gap, by country
  * Figure 5 Learning poverty gender gap by the level of Learning Poverty
  *-----------------------------------------------------------------------------

  use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
  replace lp_by_gender_is_available = 0 if inlist(countrycode,"MNG","PHL")
  keep if lp_by_gender_is_available
  keep countrycode adj_*
  gen gap = adj_nonprof_ma - adj_nonprof_fe
  gen abs_gap = abs(gap)
  order countrycode adj_nonprof_all adj_nonprof_fe adj_nonprof_ma gap abs_gap
  sort gap
  export excel using "${excel_file}", sheet("F4", modify) cell(J6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Figures 4 & 5 exported"


  *-----------------------------------------------------------------------------
  * Figure 6 Learning Poverty by Brazilian Municipality (national definition)
  *-----------------------------------------------------------------------------
  noi disp as txt "Figure 6 skipped (created in LearningPoverty-Brazil repo only)"


  *-----------------------------------------------------------------------------
  * Figure 7 Distribution of annualized changes in learning poverty for low- and
  * middle-income countries, 2000-2017
  *-----------------------------------------------------------------------------
  use "${clone}/02_simulation/023_outputs/all_spells.dta", clear
  keep if used_sim == 1
  gen str concatenated_spell = countrycode + " " + test + " grade " + strofreal(idgrade) + " " + spell
  keep  spell_id used_sim delta_lp
  order spell_id used_sim delta_lp
  sort delta_lp
  replace delta_lp = delta_lp * -1
  export excel using "${excel_file}", sheet("F7", modify) cell(J6) firstrow(varlabels) nolabel keepcellfmt

  noi disp as txt "Figure 7 exported"


  *-----------------------------------------------------------------------------
  * Figure 8  Learning poverty under two scenarios, 2015-30 (simulation)
  *-----------------------------------------------------------------------------
  use "${clone}/02_simulation/023_outputs/simfile_preference_`chosen_preference'_regional_growth_fulltable.dta", clear
  keep if year>=2015 & year<=2030
  keep if region == "_Overall"
  keep if inlist(benchmark,"_own_","_r80_")
  keep year lpv benchmark
  reshape wide lpv, i(benchmark) j(year)
  export excel using "${excel_file}", sheet("F8", modify) cell(C28) nolabel keepcellfmt

  noi disp as txt "Figure 8 exported"


  noi disp as res _newline "Finished exporting to excel."

}
