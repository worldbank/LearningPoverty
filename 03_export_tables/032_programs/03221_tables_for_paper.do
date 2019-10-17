*==============================================================================*
* PROGRAMS: CREATES TWO TABLES FOR TECHNICAL PAPER
*==============================================================================*

cap program drop table56
program define   table56, rclass

  syntax , filename(string)

  qui {

    * Check if specified filename is ".csv"
    if substr("`filename'",-4,4)!=".csv" {
      noi disp as err "Filename should end in .csv"
      break
    }

    * Creates empty tempfile where all will be appended
    tempfile this_table
    touch `this_table'

    * Aggregations we want to create tables for
    local possible_aggregations "incomelevel lendingtype adminregion region global"
    gen str global = "TOTAL"

    * Loop through each aggregation
    foreach aggregation of local possible_aggregations {

      preserve

        * Collapse the measures in tables being generated
        collapse (mean) mean_lp = adj_nonprof_all (min) min_lp = adj_nonprof_all (max) max_lp = adj_nonprof_all ///
                 (mean) n_countries = `aggregation'_n_countries (mean) coverage = `aggregation'_coverage ///
                 (mean) population_w_data = `aggregation'_population_w_data  ///
                 (mean) total_population = `aggregation'_total_population    ///
                 [fw = `aggregation'_weight], by(`aggregation')

        * Makes all the files compatible for appending later
        rename `aggregation'  group
        gen aggregated_by = "`aggregation'"

        * Appends to table file being created
        append using `this_table'
        save `this_table', replace

      restore

    }

  * Open the table with all appended aggregations
  use `this_table', clear

  * Marks which filename it is to make it easier when importing to excel
  local end_of_path  = strrpos("`filename'","/")
  local total_lenght = strlen("`filename'")
  gen file = substr("`filename'", `end_of_path' + 1, `total_lenght' - `end_of_path' - 4)

  * Export final csv
  noi export delimited "`filename'", replace

  * Save as dta as well
  local filename = subinstr("`filename'", ".csv", ".dta", 1)
  save "`filename'", replace

  }


end




cap program drop table7
program define   table7, rclass

  syntax , filename(string)

  qui {

    * Check if specified filename is ".csv"
    if substr("`filename'",-4,4)!=".csv" {
      noi disp as err "Filename should end in .csv"
      break
    }

    * Creates empty tempfile where all will be appended
    tempfile this_table
    touch `this_table'

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
        collapse (mean) mean_lp = adj_nonprof_all_compatible (mean) mean_lp_ma = adj_nonprof_ma (mean) mean_lp_fe = adj_nonprof_fe (rawsum) n = lp_by_gender_is_available [fw = `aggregation'_weight], by(`aggregation')

        * Makes all the files compatible for appending later
        rename `aggregation'  group
        gen aggregated_by = "`aggregation'"

        * Appends to table file being created
        append using `this_table'
        save `this_table', replace

      restore

    }

  * Open the table with all appended aggregations
  use `this_table', clear

  * Marks which filename it is to make it easier when importing to excel
  local end_of_path  = strrpos("`filename'","/")
  local total_lenght = strlen("`filename'")
  gen file = substr("`filename'", `end_of_path' + 1, `total_lenght' - `end_of_path' - 4)

  * Export final csv
  noi export delimited "`filename'", replace

  * Save as dta as well
  local filename = subinstr("`filename'", ".csv", ".dta", 1)
  save "`filename'", replace

  }

end
