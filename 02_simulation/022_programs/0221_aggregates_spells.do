*==============================================================================*
* 0221 SUBTASK: AGGREGATE SPELLS AND EXPORT TO MARKDOWNS FOR SIMULATION
*==============================================================================*

quietly {


  *-----------------------------------------------------------------------------*
  * Generate alternative markdown inputs for simulations
  *-----------------------------------------------------------------------------*

  foreach marker in glossy_sim used_sim withoutliers_sim rmlastsacmeq_sim {

    local aggregations "region incomelevel initial_poverty_level"
    foreach aggregation of local aggregations {

      * Open the spells file and prepare it for collapse
      *----------------------------------------------------

      use "${clone}/02_simulation/023_outputs/all_spells.dta", clear

      * Will only keep the observations marked as used in simulation file_marker
      * for example if used_sim == 1 means N spells = 71
      keep if `marker' == 1

      * To avoid changing names later, when those mds are called
      * Will only add the marker to the name of the md files that are new
      if "`marker'" == "used_sim" local mdprefix "simulation_spells"
      else local mdprefix "simulation_spells_`marker'"


      * Weighted version will consider each country only once, that is, if the same
      * country has multiple spells, they are averaged
      bysort countrycode : gen n_spells_country = _N
      gen spells_wgt = 1 / n_spells_country

      * Placeholder variables for weighted and un-weighted spells
      * note that the name "reg" was for region but is used for all aggregations
      forvalues p = 10(10)90 {
        gen delta_reg_u_`p'   = .
        gen delta_reg_w_`p' = .
      }

      * Substitute summary stats for each aggregation (weighted and unweighted)
      *----------------------------------------------------

      levelsof `aggregation', local(this_aggregation_values)
      foreach agg_value of local this_aggregation_values {

        count if `aggregation' == "`agg_value'"
        local count = `r(N)'

        * By Region, no weights
        _pctile delta_lp if `aggregation' == "`agg_value'", percentiles(10(10)90)
        forvalues p = 10(10)90 {
          local   d = `p'/10
          replace delta_reg_u_`p' = r(r`d') if `aggregation' == "`agg_value'"
        }

        * By Region, with weights
        _pctile delta_lp [aw = spells_wgt] if `aggregation' == "`agg_value'", percentiles(10(10)90)
        forvalues p = 10(10)90 {
          local   d = `p'/10
          replace delta_reg_w_`p' = r(r`d') if `aggregation' == "`agg_value'"
        }
      }

      * Creates a file with Global Overall line
      preserve
        collapse (count) n_spells = delta_lp (mean) delta_adj_pct = delta_lp delta_reg_u_* delta_reg_w_*
        gen `aggregation' = "Overall"
        tempfile global
        save `global'
      restore

      * Collapse into regions (a mean of all equal values, since the calculation actually happened in pctile)
      collapse (count) n_spells = delta_lp (mean) delta_adj_pct = delta_lp delta_reg_u_* delta_reg_w_*, by(`aggregation')

      * Replace value for EAS and SAS with the global, because of lack of spells
      if "`aggregation'" == "region" {
        drop if inlist(region, "EAS", "SAS")
        append using `global'
        replace region = "EAS" if region == "Overall"
        append using `global'
        replace region = "SAS" if region == "Overall"
      }

      sort `aggregation'

      * In any aggregation case, add the global line at the bottom
      append using `global'

      gen aux_sort = _n +1

      * Save final version to markdown file, compatible with Github

      * Do some extra formatting for markdown file
      * Which is adding a blank line with --- at the first observation
      set obs `=_N+1'
      replace aux_sort = 1 if _n == _N
      sort aux_sort
      foreach var of varlist `aggregation' n_spells delta_* {
      	tostring `var', replace force
      	replace `var'="---" if _n==1
      }
      drop aux_sort

      * At this point, both weighted and unweighted variables exist.
      * Keep only one group at a time, in separate files
      * Since we decided to use the WEIGHTED file by REGION, all others are saved in sensitivity_checks

      preserve
        drop delta_reg_w_*
        export delimited using "${clone}/02_simulation/021_rawdata/sensitivity_checks/`mdprefix'_unweighted_`aggregation'.md", delimiter("|") replace
      restore

      * Weighted file
      drop delta_reg_u_*
      if "`marker'" == "used_sim" & "`aggregation'" == "region" export delimited using "${clone}/02_simulation/021_rawdata/`mdprefix'_weighted_`aggregation'.md", delimiter("|") replace
      else export delimited using "${clone}/02_simulation/021_rawdata/sensitivity_checks/`mdprefix'_weighted_`aggregation'.md", delimiter("|") replace

      * Note that out of the 9 combinations ( 3 markers * 3 aggregations )
      * only one md file is saved in the main folder
      * others go to a subfolder for easy identification of our preferred one

      * next aggregation
    }

    * next marker
  }

  noisily disp as result _n "Exported special simulation md files"

}
