
Documentation of Population
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of late primary aged population. Long in countrycode and year, wide in population definitions (ie: 10-14y, primary-aged, etc) and subgroups (all, male, female). In units, not thousands nor millions.

**Metadata** stored in this dataset:

~~~~
sources:     World Bank staff estimates using the World Bank's total population and age distributions of the United Nations Population Division's World Population Prospects.
~~~~


About the **18 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year_population
valuevars: population_fe_10 population_fe_0516 population_fe_primary population_fe_9plus population_ma_10 population_ma_0516 population_ma_primary population_ma_9plus population_all_10 population_all_0516 population_all_primary population_all_9plus population_fe_1014 population_ma_1014 population_all_1014 population_source
traitvars: population_source

. codebook, compact

Variable        Obs Unique      Mean     Min       Max  Label
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   13237    217         .       .         .  WB country code (3 letters)
year_popul~n  13237     61      2020    1990      2050  Year of population
populat~e_10  13237  12217  285210.6      21  1.24e+07  Female population aged 10 (WB API)
popul~e_0516  13237  13084   3411101   909.5  1.46e+08  Female population aged 05-16 (WB API)
po~e_primary  12078  11906   1994438   349.5  7.40e+07  Female population primary age, country specific (WB API)
popu~e_9plus  12855  12468   1058900      52  4.84e+07  Female population aged 9 to end of primary, country specific (WB API)
populat~a_10  13237  12219  301266.4      86  1.37e+07  Male population aged 10 (WB API)
popul~a_0516  13237  13104   3602373  1106.5  1.61e+08  Male population aged 05-16 (WB API)
po~a_primary  12078  11927   2106306   638.5  8.17e+07  Male population primary age, country specific (WB API)
popu~a_9plus  12855  12467   1116159   217.5  5.32e+07  Male population aged 9 to end of primary, country specific (WB API)
populat~l_10  13237  12626  586477.1     168  2.62e+07  Total population aged 10 (WB API)
popul~l_0516  13237  13158   7013474  2166.5  3.07e+08  Total population aged 05-16 (WB API)
po~l_primary  12078  11980   4100744  1244.5  1.56e+08  Total population primary age, country specific (WB API)
popu~l_9plus  12855  12617   2175059   336.5  1.02e+08  Total population aged 9 to end of primary, country specific (WB API)
popul~e_1014  13125  12653   1422726     365  6.16e+07  Female population between ages 10 to 14 (WB API)
popul~a_1014  13125  12628   1502714     366  6.80e+07  Male population between ages 10 to 14 (WB API)
popul~l_1014  13125  12829   2925440     731  1.30e+08  Total population between ages 10 to 14 (WB API)
population~e  13237      1         .       .         .  The source used for population variables
---------------------------------------------------------------------------------------------------------------------------------------


~~~~
