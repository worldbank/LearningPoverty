{smcl}
{* *! version 1.0  May 2019}{...}
{cmd:help _simulation_dataset}{...}
{right:also see:  }
{hline}

{title:Title}

{pstd}
{hi:_simulation_dataset} {hline 2} Pull together datafiles and produce final dataset for simulations

{title:Syntax}

{pstd} Produce final dataset for simulations

{p 8 15 2}
{cmd:_simulation_dataset}, {opt preference(string)} {opt filename(string)}  {opt ifspell(string)} {opt ifsim(string)} {opt ifwindow(string)} {opt weight(string)} [{it:options}]
{p_end}

{synoptset 30 tabbed}{...}
{synopthdr :options}
{synoptline}
{syntab :Main}
{synopt :{cmdab:filename(}{it:string}{cmd:)}}name for the final .dta simulation file to create{p_end}
{synopt :{cmdab:preference(}{it:string}{cmd:)}}name of the preference from the rawlatest to base the simulation on{p_end}
{synopt :{cmdab:weight(}{it:string}{cmd:)}} specify weights to be used using standard stata weight syntax{p_end}

{syntab :if options}
{synopt :{cmdab:ifspell(}{it:string}{cmd:)}} if statement in stata syntax to keep only these observations for inclusion to calculate proficiency growth rates from spell data ({it:required}){p_end}
{synopt :{cmdab:ifsim(}{it:string}{cmd:)}} if statement in stata syntax to keep only these observations for inclusion in the simulations ({it:required}){p_end}
{synopt :{cmdab:ifwhere(}{it:string}{cmd:)}} if statement in stata syntax to keep only observations with specified recent assessment data in simulations ({it:required}){p_end}


{syntab :Other options}
{synopt :{cmdab:enrollment(}{it:string}{cmd:)}}which enrollment variable to use: validated or interpolated {it: valuevars}{p_end}
{synopt :{cmdab:specialincludegrade(}{it:string}{cmd:)}} Inlcude any extra assessments in the spells database that use these grades{it: valuevars}{p_end}
{synopt :{cmdab:specialincludeassess(}{it:string}{cmd:)}} Include any extra assessments  in the spells database of this type for a country {it: valuevars}{p_end}
{synopt :{cmdab:population_2015(}{it:string}{cmd:)}} Keep population fixed to 2015 in the simulation {it: valuevars}{p_end}
{synopt :{cmdab:timss(}{it:string}{cmd:)}}which TIMSS suject to use: science or math {it: valuevars}{p_end}
{synopt :{cmdab:usefile(}{it:string}{cmd:)}} Location of a markdown file to custom replace the growth rates based on the spells data {it: valuevars}{p_end}

{synoptline}


{marker description}{...}
{title:Description}

{pstd}
{cmd:save_metadata} Pull together datafiles and produce final dataset for simulations

{pstd} The _simulation_dataset ado file takes spell data from our assessment database, calculates rates of growth in proficiency using these spells, combines these proficiency growth rates with country baseline data, and projects improvements in proficiency into the future as part of our simulation.

{title:Options}

{dlgtab:Main}

{phang} {cmdab:filename(}{it:string}{cmd:)} name for the final .dta simulation file to create

{phang} {cmdab:preference(}{it:string}{cmd:)} name of the preference from the rawlatest to base the simulation on.  If in doubt, use 960.  It is our default.

{phang} {cmdab:weight(}{it:string}{cmd:)} specify weights to be used using standard stata weight.  Weights come in when countries have more than one spell to use in the proficiency growth calculations.  When global and regional percentiles, etc are calculated, countries are weighted inversely by the number of spells available if this option is specified.  Otherwise more weight is implicitly given to countries with more assessment spells.

{dlgtab:ifs}

{phang} {cmdab:ifspell(}{it:string}{cmd:)} if statement in stata syntax to keep only these observations for inclusion to calculate proficiency growth rates from spell data

{phang} {cmdab:ifsim(}{it:string}{cmd:)} if statement in stata syntax to keep only these observations for inclusion in the simulations

{phang} {cmdab:ifwhere(}{it:string}{cmd:)} if statement in stata syntax to keep only observations with specified recent assessment data in simulations


{dlgtab:Others}

{phang} {cmdab:enrollment(}{it:string}{cmd:)} which enrollment variable to use: validated or interpolated.  Validated enrollment is the name given to the enrollment variable used to produce the baseline numbers.  It deals with missing values using a carry forward, carry backward method.  The interpolated enrollment variable uses linear interpolation to deal with missing values, and it is based on the same source data as the validated enrollment variable.  The only difference is how missing values are treated. 

{phang} {cmdab:specialincludegrade(}{it:string}{cmd:)} Inlcude any extra assessments in the spells database that use these grades.  For example, a country may have assessment data for grade 3 and grade 4.  Because grade 4 is preferred, in the baseline grade 4 is used.  However, to calculate proficiency growth based on spell, we may be interested in comparing spells from 3rd grade as well to increase sample size.  This options allows this possibility.

{phang} {cmdab:specialincludeassess(}{it:string}{cmd:)} Include any extra assessments  in the spells database of this type for a country.  A country may have spell data for PIRLS and TIMSS for instance.  However, PIRLS is preferred to TIMSS, so only PIRLS is used in the baseline.  However, to calculate proficiency growth based on spells, we may want to compare TIMSS spells as well to increase sample size.

{phang} {cmdab:population_2015(}{it:string}{cmd:)} Keep population fixed to 2015 in the simulation.  Enter Yes to fix population at 2015 levels.  Any other command will use population projections for each year of the simulation.

{phang} {cmdab:timss(}{it:string}{cmd:)} which TIMSS suject to use: science or math.  IF in doubt, use TIMSS science.  It is our default.

{phang} {cmdab:usefile(}{it:string}{cmd:)} A command that allows a  user to specify a custom growth rate for learning poverty.  WARNING - Be very careful with this, as the program will merge this file and overwrite the growth rates in the simulation datasets.  It is advisable to hand check that this option has successfully been applied.  Files are stored as .md (markdown) files.  The file must contain a a column named "region", and then the other columns must match the column names in the simulation dataset (usually something like delta_reg_70 or delta_reg_w_70

{title:Examples}

{pstd}
Examples in the context of Learning4All:

   . {cmd:#delimit ;}
   . {cmd:_simulation_dataset, preference(926) specialincludeassess(SACMEQ PASEC LLECE  TIMSS ) }
   . {cmd:		ifwindow(if assess_year>=2011) }
   . {cmd:		specialincludegrade(3 4 5 6) filename(simulation_926_no_egra) timss(science) }
   . {cmd:		enrollment(validated)  }

   
   . {cmd:_simulation_dataset, ifspell(if year>2000 & incomelevel!="HIC" & lendingtype!="LNX") /// }
   . {cmd:   ifwindow(if assess_year>=2011) /// }
   . {cmd:   ifsim(if incomelevel!="HIC" &  lendingtype!="LNX" ) weight(aw=wgt)  preference(960) /// }
   . {cmd:   specialincludeassess( PASEC LLECE  TIMSS SAQMEC ) specialincludegrade(4 5 6) /// }
   . {cmd:   filename(960_pasec_llece_timms_saqmec) /// }
   . {cmd:   timss(science) enrollment(validated) population_2015(Yes) }
    

   . {cmd:_simulation_dataset, ifspell(if year>2000 & incomelevel!="HIC" & lendingtype!="LNX") /// }
   . {cmd:   ifwindow(if assess_year>=2011) /// }
   . {cmd:   ifsim(if incomelevel!="HIC" &  lendingtype!="LNX" ) weight(aw=wgt)  preference(960) /// }
   . {cmd:   specialincludeassess( LLECE  TIMSS ) specialincludegrade(4 5 6) /// }
   . {cmd:   filename(960_llece_timms) /// }
   . {cmd:   timss(science) enrollment(validated) population_2015(Yes) }
    

   . {cmd:_simulation_dataset, ifspell(if year>2000 & incomelevel!="HIC" & lendingtype!="LNX") /// }
   . {cmd:   ifwindow(if assess_year>=2011) /// }
   . {cmd:   ifsim(if incomelevel!="HIC" &  lendingtype!="LNX" ) weight(aw=wgt)  preference(962) /// }
   . {cmd:   specialincludeassess( PASEC LLECE  TIMSS SAQMEC ) specialincludegrade(4 5 6) /// }
   . {cmd:   filename(962_pasec_llece_timms_saqmec) /// }
   . {cmd:   timss(science) enrollment(validated) population_2015(Yes) }
    

   . {cmd:_simulation_dataset, ifspell(if year>2000 & incomelevel!="HIC" & lendingtype!="LNX") /// }
   . {cmd:   ifwindow(if assess_year>=2011) /// }
   . {cmd:   ifsim(if incomelevel!="HIC" &  lendingtype!="LNX" ) weight(aw=wgt)  preference(962) /// }
   . {cmd:   specialincludeassess( LLECE  TIMSS SAQMEC ) specialincludegrade(4 5 6) /// }
   . {cmd:   filename(962_llece_timms_saqmec) /// }
   . {cmd:   timss(science) enrollment(validated) population_2015(Yes) }
   
    . {cmd:_simulation_dataset, ifspell(if delta_adj_pct > -2 & delta_adj_pct < 4 & year>2000 & incomelevel!="HIC" & lendingtype!="LNX") /// }
   . {cmd:    ifwindow(if assess_year>=2011) /// }
   . {cmd:    ifsim(if incomelevel!="HIC" &  lendingtype!="LNX" ) weight(aw=wgt)  preference(960) /// }
   . {cmd:    specialincludeassess( PASEC LLECE  TIMSS SAQMEC ) specialincludegrade(3 4 5 6) /// }
   . {cmd:    filename(special_spells) /// }
   . {cmd:    usefile("${clone}/04_simulation/042_program/special_simulation_spells.md") /// }
   . {cmd:    timss(science) enrollment(validated) population_2015(Yes) savectryfile(special_simulation_spells)	   }
   
{title:Author}

{pstd}Brian Stacy {break}
bstacy@worldbank.org

{title:Acknowledgements}

{pstd}
Joao Pedro Azevedo provided a number of suggestions for improving the routine.

{pstd}
