*==============================================================================*
* PROGRAMS: CREATES TWO TABLES FOR TECHNICAL PAPER
*==============================================================================*

* This do contains two programs that create tables called in 0321 to outline
* the current learning poverty situation. The first does it aggregated, the
* second program does it with a gender breakdown.


cap program drop outline_current_lp
program define   outline_current_lp, rclass

  syntax , filename(string)  [REPetitions(string)]

  qui {

    * Check if specified filename is ".csv"
    if substr("`filename'",-4,4)!=".csv" {
      noi disp as err "Filename should end in .csv"
      break
    }
    local filename_csv    = "`filename'"
    local filename_dta    = subinstr("`filename'", ".csv", ".dta", 1)
    local filename_bs_dta = subinstr("`filename'", ".csv", "_bs.dta", 1)

    * Marks which filename it is to make it easier when importing to excel
    local end_of_path  = strrpos("`filename'","/")
    local total_lenght = strlen("`filename'")
    local file_marker  = substr("`filename'", `end_of_path' + 1, `total_lenght' - `end_of_path' - 4)

    * Creates empty files where all will be appended
    touch "`filename_dta'" , replace
    if "`repetitions'"!=""  touch "`filename_bs_dta'", replace

    * Aggregations we want to create tables for
    local possible_aggregations "incomelevel lendingtype adminregion region global"
    gen str global = "TOTAL"

    * Aux variable to have average year of included assessments
    gen year2avg = year_assessment if included_in_weights == 1

    * Loop through each aggregation
    foreach aggregation of local possible_aggregations {

      preserve

        bys `aggregation': egen total_countries =  sum(include_country)

        * Collapse the measures in tables being generated
        collapse (mean) mean_lp = adj_nonprof_all (min) min_lp = adj_nonprof_all (max) max_lp = adj_nonprof_all ///
                 (mean) mean_fgt1 = fgt1_all mean_fgt2 = fgt1_all ///
                 (mean) n_countries = `aggregation'_n_countries (mean) coverage = `aggregation'_coverage ///
                 (mean) population_w_data = `aggregation'_population_w_data  ///
                 (mean) total_population = `aggregation'_total_population    ///
                 (mean) avg_assess_year = year2avg (mean) total_countries    ///
                 (min)  min_assess_year = year2avg (max) max_assess_year = year2avg ///
                 [fw = `aggregation'_weight], by(`aggregation')

        * Makes all the files compatible for appending later
        rename `aggregation'  group
        gen aggregated_by = "`aggregation'"

        * Appends to table file being created
        append using "`filename_dta'"
        save "`filename_dta'", replace

      restore


      * Bootstrap approach for std errors
      if "`repetitions'"!="" {

        * Replaces the SE with median value for assessments without this information
        replace se_nonprof_all = 1.2 if missing(se_nonprof_all) & !missing(nonprof_all)

        forvalues i = 1/`repetitions' {
          preserve

            * Bootstrap value for learning poverty
            gen adj_nonprof_bs_all = 100 * ( 1 - (enrollment_all/100) * (1 - rnormal(nonprof_all, se_nonprof_all)/100))

            collapse (mean) adj_nonprof_all adj_nonprof_bs_all  [fw = `aggregation'_weight], by(`aggregation')

            * Makes all the files compatible for appending later
            rename `aggregation'  group
            gen aggregated_by = "`aggregation'"
            gen repetition = `i'

            * Appends to table file being created
            append using "`filename_bs_dta'"
            save "`filename_bs_dta'", replace

          restore
        }
      }

    }


    * Final touches in the created files from multiple appends

    if "`repetitions'"!="" {

      * Open the bootstrap SE with all appended repetitions
      use "`filename_bs_dta'", clear

      collapse (sd) se_lp = adj_nonprof_bs_all, by(group aggregated_by)

      tempfile se
      save    `se'

    }

    * Open the table with all appended aggregations
    use "`filename_dta'", clear

    if "`repetitions'"!="" {
      merge 1:1 group aggregated_by using `se', keep(master match) nogen
      label var se_lp "S.E. Learning Poverty (%)"
    }

    * Beautify and label
    gen file = "`file_marker'"

    * Coverage in percentage points
    replace coverage = coverage * 100

    * Population in millions
    replace total_population  = total_population / 1E6
    replace population_w_data = population_w_data / 1E6

    * Learning poor in millions
    gen learning_poor = mean_lp * total_population / 100

    * Label variables
    label var aggregated_by     "Aggregation group"
    label var group             "Group"
    label var mean_lp           "Learning Poverty (%)"
    label var min_lp            "Minimum Learning Poverty"
    label var max_lp            "Maximum Learning Poverty"
    label var mean_fgt1         "Average Learning Gap (%, FGT1)"
    label var mean_fgt2         "Average Learning Gap Squared (%, FGT2)"
    label var coverage          "Population Coverage (%)"
    label var population_w_data "Population w/ Assessment (in millions)"
    label var total_population  "Regional Population (in millions)"
    label var learning_poor     "Learning Poor (in millions)"
    label var n_countries       "Number of countries w/ Assessment"
    label var total_countries   "Total number of countries"
    label var avg_assess_year   "Avg. Year"
    label var min_assess_year   "Min Year"
    label var max_assess_year   "Max Year"
    label var file              "File marker (table creation)"

    order aggregated_by group *lp* *fgt* learning_poor *population* coverage *countries* *year file
    sort  aggregated_by group

    save "`filename_dta'", replace

    //* Export final csv as well
    //noi export delimited "`filename_csv'", replace


  }


end


****** GENDER TABLE ******

cap program drop outline_gender_lp
program define   outline_gender_lp, rclass

  syntax , filename(string) [REPetitions(string)]

  qui {

    * Check if specified filename is ".csv"
    if substr("`filename'",-4,4)!=".csv" {
      noi disp as err "Filename should end in .csv"
      break
    }
    local filename_csv    = "`filename'"
    local filename_dta    = subinstr("`filename'", ".csv", ".dta", 1)
    local filename_bs_dta = subinstr("`filename'", ".csv", "_bs.dta", 1)

    * Marks which filename it is to make it easier when importing to excel
    local end_of_path  = strrpos("`filename'","/")
    local total_lenght = strlen("`filename'")
    local file_marker  = substr("`filename'", `end_of_path' + 1, `total_lenght' - `end_of_path' - 4)

    * Creates empty files where all will be appended
    touch "`filename_dta'" , replace
    if "`repetitions'"!=""  touch "`filename_bs_dta'", replace

    * Aggregations we want to create tables for
    local possible_aggregations "incomelevel lendingtype adminregion region global"
    gen str global = "TOTAL"

    * Given that we'll print out gender split, only keep LP data if have the gender split
    clonevar adj_nonprof_all_compatible = adj_nonprof_all
    replace  adj_nonprof_all_compatible = . if lp_by_gender_is_available == 0

    * Loop through each aggregation
    foreach aggregation of local possible_aggregations {

      preserve

        * Collapse the measures in tables being generated
        collapse (mean) mean_lp_allcomp = adj_nonprof_all_compatible ///
                 (mean) mean_lp_ma = adj_nonprof_ma (mean) mean_lp_fe = adj_nonprof_fe ///
                 (rawsum) n_countries = lp_by_gender_is_available ///
                 [fw = `aggregation'_weight], by(`aggregation')

        * Makes all the files compatible for appending later
        rename `aggregation'  group
        gen aggregated_by = "`aggregation'"

        * Appends to table file being created
        append using "`filename_dta'"
        save "`filename_dta'", replace

      restore


      * Bootstrap approach for std errors
      if "`repetitions'"!="" {

        * Replaces the SE with median value for assessments without this information
        foreach subgroup in all ma fe {
          replace se_nonprof_`subgroup' = 1.2 if missing(se_nonprof_`subgroup') & !missing(nonprof_`subgroup')
        }

        forvalues i = 1/`repetitions' {
          preserve

            * Bootstrap value for learning poverty
            foreach subgroup in all ma fe {
              gen adj_nonprof_bs_`subgroup' =100 * ( 1 - (enrollment_`subgroup'/100) * (1 - rnormal(nonprof_`subgroup', se_nonprof_`subgroup')/100))
            }

            collapse (mean) adj_nonprof_all_compatible adj_nonprof_ma adj_nonprof_fe adj_nonprof_bs_*  ///
                     [fw = `aggregation'_weight], by(`aggregation')

            * Makes all the files compatible for appending later
            rename `aggregation'  group
            gen aggregated_by = "`aggregation'"
            gen repetition = `i'

            * Appends to table file being created
            append using "`filename_bs_dta'"
            save "`filename_bs_dta'", replace

          restore
        }
      }

    }

    * Final touches in the created files from multiple appends

    if "`repetitions'"!="" {

      * Open the bootstrap SE with all appended repetitions
      use "`filename_bs_dta'", clear

      collapse (sd) adj_nonprof_bs*, by(group aggregated_by)
      rename (adj_nonprof_bs_all adj_nonprof_bs_ma adj_nonprof_bs_fe) ///
             (se_lp_allcomp      se_lp_ma          se_lp_fe)

      tempfile se
      save    `se'

    }

    * Open the table with all appended aggregations
    use "`filename_dta'", clear

    if "`repetitions'"!="" {
      merge 1:1 group aggregated_by using `se', keep(master match) nogen
      label var se_lp_ma        "S.E. male"
      label var se_lp_fe        "S.E. female"
      label var se_lp_allcomp   "S.E. pooled (comparable)"
    }

    * Beautify and label
    gen file = "`file_marker'"

    * Label variables
    label var aggregated_by     "Aggregation group"
    label var group             "Group"
    label var mean_lp_ma        "LP male (%)"
    label var mean_lp_fe        "LP female (%)"
    label var mean_lp_allcomp   "LP pooled (%, comparable)"
    label var n_countries       "Number of countries w/ breakdown"
    label var file              "File marker (table creation)"

    order aggregated_by group *lp* *countries* file
    sort  aggregated_by group

    save "`filename_dta'", replace

    //* Export final csv as well
    //noi export delimited "`filename_csv'", replace

  }

end
