use "${clone}/02_simulation/023_outputs/all_spells.dta", clear
tab lendingtype
tab test
tab spell if test == "PASEC"

qui {
	
  * GLOSSY version (below) is equivalent to attempt0
  gen attempt0 = (lendingtype != "LNX" & range_ok == 1 & comparable == 1 & y1 >= 2000 & excess_timss == 0) & region == "SSF"

  * Without the "drop outliers" (masked as range_ok)
  gen attempt1 = (lendingtype != "LNX" & comparable == 1 & y1 >= 2000 & excess_timss == 0) & region == "SSF"
  * This should be equivalent in SSF only to:
  //gen attempt1 = inlist(test, "SACMEQ", "PIRLS") & comparable == 1 & region == "SSF"

  * Version that drops the SACMEQ 2013
  gen attempt2 = inlist(test, "SACMEQ", "PIRLS") & comparable == 1 & y2 != 2013  & region == "SSF"

  * Version with only SACMEQ 2000-2007
  gen attempt3 = inlist(test, "SACMEQ") & y2 != 2013 & region == "SSF"

  * Version that keeps PASEC (any) but not the 2013 SACMEQ
  gen attempt4 = inlist(test, "PASEC", "SACMEQ")  & y2 != 2013 & region == "SSF"

  * Version that keeps PASEC (not too old), but not the 2013 SACMEQ
  gen attempt5 = inlist(test, "PASEC", "SACMEQ")  & y1 >= 2000  & y2 != 2013 & region == "SSF"

  * Version that keeps PASEC (any) and SACMEQ (any)
  gen attempt6 = inlist(test, "PASEC", "SACMEQ") & region == "SSF"

  * Version that keeps PASEC (not too old) and SACMEQ (any)
  gen attempt7 = inlist(test, "PASEC", "SACMEQ")  & y1 >= 2000 & region == "SSF"
  
  * Masks North Africa as Africa
  gen attempt8 = inlist(test, "SACMEQ", "PIRLS") & comparable == 1 & (region == "SSF" | inlist(countrycode , "MAR", "TUN"))

  * Same as glossy, but outlier range -4 to 4 (instead of -2 to 4)
  gen attempt9 = (lendingtype != "LNX" & delta_lp<=4 & delta_lp>=-4 & comparable == 1 & y1 >= 2000 & excess_timss == 0) & region == "SSF"
    

  noi disp as res _n "Attempt | Weight | N spells | p50  | p80"

  forvalues i=0/9 {
    
    preserve
      
      keep if attempt`i'
    
      * Weighted version will consider each country only once, that is, if the same
      * country has multiple spells, they are averaged
      bysort countrycode : gen n_spells_country = _N
      gen spells_wgt = 1 / n_spells_country
      gen spells_wgt2 = spells_wgt * spell_lenght
     
      _pctile delta_lp [aw = spells_wgt] , percentiles(50 80)
      
      noi disp as txt "   `i'    |   reg  |    `=_N'    | `: di %3.2fc r(r1)' | `: di %3.2fc r(r2)'"

      _pctile delta_lp [aw = spells_wgt2] , percentiles(50 80)
      
      // noi disp as txt "   `i'    |   new  |    `=_N'    | `: di %3.2fc r(r1)' | `: di %3.2fc r(r2)'"
      
    restore
  }
}