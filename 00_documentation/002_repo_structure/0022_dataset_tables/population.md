
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

Variable        Obs Unique      Mean    Min       Max  Label
-----------------------------------------------------------------------------------------------------------------------------------------
countrycode   13237    217         .      .         .  WB country code (3 letters)
year_popul~n  13237     61      2020   1990      2050  Year of population
populat~e_10  11795   7002  320676.4    479  1.33e+07  Female population aged 10 (WB API)
popul~e_0516  11795   9561   3837089   5500  1.43e+08  Female population aged 05-16 (WB API)
po~e_primary  10941   8376   2211156   3477  7.53e+07  Female population primary age, country specific (WB API)
popu~e_9plus  11413   8142   1198701    967  5.14e+07  Female population aged 9 to end of primary, country specific (WB API)
populat~a_10  11795   7006  339959.2    492  1.42e+07  Male population aged 10 (WB API)
popul~a_0516  11795   9629   4067006   5800  1.60e+08  Male population aged 05-16 (WB API)
po~a_primary  10941   8393   2344046   3858  8.08e+07  Male population primary age, country specific (WB API)
popu~a_9plus  11413   8138   1266440   1007  5.52e+07  Male population aged 9 to end of primary, country specific (WB API)
populat~l_10  11795   7632  660635.6    971  2.75e+07  Total population aged 10 (WB API)
popul~l_0516  11795  10355   7904095  11300  3.04e+08  Total population aged 05-16 (WB API)
po~l_primary  10941   9128   4555202   7335  1.56e+08  Total population primary age, country specific (WB API)
popu~l_9plus  11413   8828   2465141   1974  1.07e+08  Total population aged 9 to end of primary, country specific (WB API)
popul~e_1014  11792   8297   1582232   2300  6.21e+07  Female population between ages 10 to 14 (WB API)
popul~a_1014  11792   8329   1676844   2300  6.72e+07  Male population between ages 10 to 14 (WB API)
popul~l_1014  11792   9012   3259076   4600  1.29e+08  Total population between ages 10 to 14 (WB API)
population~e  13237      1         .      .         .  The source used for population variables
-----------------------------------------------------------------------------------------------------------------------------------------


~~~~
