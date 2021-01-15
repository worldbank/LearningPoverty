*==============================================================================*
* 0321 SUBTASK: GENERATES TABLES FOR PAPER
*==============================================================================*
qui {

  * Change here only if wanting to use a different preference
  * than what is being passed in the global in 032_run
  * But don't commit any change here (only commit in global 032_run)
  local chosen_preference = $chosen_preference

  * Baseline (PART2 COUNTRIES)
  // By Region
  _preferred_list_tables_ci, preference(`chosen_preference') population(pop_TOT_1014) anchoryear(2015) ///
    globalweight(region) globalweightwindow(year_assessment>=2011) ///
    globalweightfilter(( lendingtype!="LNX") ) ///
    repetitions(100) runname(New_Baseline)

  // By Lending Type
  _preferred_list_tables_ci, preference(`chosen_preference') population(pop_TOT_1014) anchoryear(2015) ///
    globalweight(lendingtype) globalweightwindow(year_assessment>=2011) ///
    globalweightfilter(( lendingtype!="LNX") ) ///
    repetitions(100) runname(New_Baseline)

  // By Income Level
  _preferred_list_tables_ci, preference(`chosen_preference') population(pop_TOT_1014) anchoryear(2015) ///
    globalweight(incomelevel) globalweightwindow(year_assessment>=2011) ///
    globalweightfilter()		///
    repetitions(100) runname(New_Baseline)


  * Baseline (WORLD -  All countries)
  // By Region
  _preferred_list_tables_ci, preference(`chosen_preference') population(pop_TOT_1014) anchoryear(2015) ///
    globalweight(region) globalweightwindow(year_assessment>=2011) ///
    globalweightfilter() ///
    repetitions(100) runname(Baseline_All)

  // By Lending Type
  _preferred_list_tables_ci, preference(`chosen_preference') population(pop_TOT_1014) anchoryear(2015) ///
    globalweight(lendingtype) globalweightwindow(year_assessment>=2011) ///
    globalweightfilter( ) ///
    repetitions(100) runname(Baseline_All)

  // By Income Level
  _preferred_list_tables_ci, preference(`chosen_preference') population(pop_TOT_1014) anchoryear(2015) ///
    globalweight(incomelevel) globalweightwindow(year_assessment>=2011) ///
    globalweightfilter()		///
    repetitions(100) runname(Baseline_All)

    noi disp as res _newline "Finished exporting tables from put_to_excel."

}
