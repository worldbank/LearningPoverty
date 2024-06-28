/*==============================================================================*
* Version control: Saves the final version of each update as "frozen", as 
* updating 04 overwrites the dataset.
* This is useful when we are running an update and want to compare the old results 
*==============================================================================*/
qui {

	* -----------*
	*  SET UP    *
	* -----------*

	* Part 1. Globals
	* Set overwrite to 1 if you have finalized the release's chosen preference and would like to "Freeze" the data
	global overwrite 0

	* Part 2. Create the generic routine for all releases
	cap program drop freeze_pref
	program define freeze_pref 
	qui {
		* Uses the chosen preference from 01 run to save as csv
		local chosen_preference $chosen_preference 
		* Read the preference dataset
		use "${clone}/01_data/013_outputs/preference`chosen_preference'.dta", clear
			
		* Export the dataset 
		cap export delimited "${clone}/01_data/013_outputs/final_preferences/preference`chosen_preference'.csv"	
		
		* Prevents the frozen version from being overwritten if it alraeady exists
		if _rc != 0 {
		noi di "Pref `chosen_preference' already exists, no overwrite needed"

		}
		else {
		noi di "Pref `chosen_preference' saved"
		}
		}
	end

	* Don't overrite anything if 0
	if $overwrite == 0 {
		noi di "Skip freezing final preference. Task 1 complete."
		e
	} 
	
	
	noi freeze_pref
	

** Keep track of all the frozen preferences
* -------------------------------------------*
* 2019 October Release: Pref 1005 (Global)
* 
* 2021 July Release: Pref 1108 (CNT)
* 
* 2022 October Release: Pref 1205
* 
* 2023 August Release: Pref XXXX
*
* XXXX Release: Pref XXXX
* add final chosen preference for the release
*
* -------------------------------------------*
}