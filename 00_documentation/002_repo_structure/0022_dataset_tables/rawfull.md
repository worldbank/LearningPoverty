
Documentation of Rawfull
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of proficiency merged with enrollment and population. Not a timeseries, rather a collection of observations, from which subsets of time series may be extracted. Long in proficiency, wide on population and enrollment.

**Metadata** stored in this dataset:

~~~~
sources:     All population, enrollment and proficiency sources combined.
~~~~


About the **655 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year_assessment idgrade test nla_code subject
valuevars: nonprof_all nonprof_ma nonprof_fe se_nonprof_all se_nonprof_ma se_nonprof_fe fgt1_all fgt1_fe fgt1_ma fgt2_all fgt2_fe fgt2_ma enrollment_validated_all_1990 enrollment_validated_fe_1990 enrollment_validated_ma_1990 enrollment_validated_flag_1990 enrollment_validated_all_1991 enrollment_validated_fe_1991 enrollment_validated_ma_1991 enrollment_validated_flag_1991 enrollment_validated_all_1992 enrollment_validated_fe_1992 enrollment_validated_ma_1992 enrollment_validated_flag_1992 enrollment_validated_all_1993 enrollment_validated_fe_1993 enrollment_validated_ma_1993 enrollment_validated_flag_1993 enrollment_validated_all_1994 enrollment_validated_fe_1994 enrollment_validated_ma_1994 enrollment_validated_flag_1994 enrollment_validated_all_1995 enrollment_validated_fe_1995 enrollment_validated_ma_1995 enrollment_validated_flag_1995 enrollment_validated_all_1996 enrollment_validated_fe_1996 enrollment_validated_ma_1996 enrollment_validated_flag_1996 enrollment_validated_all_1997 enrollment_validated_fe_1997 enrollment_validated_ma_1997 enrollment_validated_flag_1997 enrollment_validated_all_1998 enrollment_validated_fe_1998 enrollment_validated_ma_1998 enrollment_validated_flag_1998 enrollment_validated_all_1999 enrollment_validated_fe_1999 enrollment_validated_ma_1999 enrollment_validated_flag_1999 enrollment_validated_all_2000 enrollment_validated_fe_2000 enrollment_validated_ma_2000 enrollment_validated_flag_2000 enrollment_validated_all_2001 enrollment_validated_fe_2001 enrollment_validated_ma_2001 enrollment_validated_flag_2001 enrollment_validated_all_2002 enrollment_validated_fe_2002 enrollment_validated_ma_2002 enrollment_validated_flag_2002 enrollment_validated_all_2003 enrollment_validated_fe_2003 enrollment_validated_ma_2003 enrollment_validated_flag_2003 enrollment_validated_all_2004 enrollment_validated_fe_2004 enrollment_validated_ma_2004 enrollment_validated_flag_2004 enrollment_validated_all_2005 enrollment_validated_fe_2005 enrollment_validated_ma_2005 enrollment_validated_flag_2005 enrollment_validated_all_2006 enrollment_validated_fe_2006 enrollment_validated_ma_2006 enrollment_validated_flag_2006 enrollment_validated_all_2007 enrollment_validated_fe_2007 enrollment_validated_ma_2007 enrollment_validated_flag_2007 enrollment_validated_all_2008 enrollment_validated_fe_2008 enrollment_validated_ma_2008 enrollment_validated_flag_2008 enrollment_validated_all_2009 enrollment_validated_fe_2009 enrollment_validated_ma_2009 enrollment_validated_flag_2009 enrollment_validated_all_2010 enrollment_validated_fe_2010 enrollment_validated_ma_2010 enrollment_validated_flag_2010 enrollment_validated_all_2011 enrollment_validated_fe_2011 enrollment_validated_ma_2011 enrollment_validated_flag_2011 enrollment_validated_all_2012 enrollment_validated_fe_2012 enrollment_validated_ma_2012 enrollment_validated_flag_2012 enrollment_validated_all_2013 enrollment_validated_fe_2013 enrollment_validated_ma_2013 enrollment_validated_flag_2013 enrollment_validated_all_2014 enrollment_validated_fe_2014 enrollment_validated_ma_2014 enrollment_validated_flag_2014 enrollment_validated_all_2015 enrollment_validated_fe_2015 enrollment_validated_ma_2015 enrollment_validated_flag_2015 enrollment_validated_all_2016 enrollment_validated_fe_2016 enrollment_validated_ma_2016 enrollment_validated_flag_2016 enrollment_validated_all_2017 enrollment_validated_fe_2017 enrollment_validated_ma_2017 enrollment_validated_flag_2017 enrollment_validated_all_2018 enrollment_validated_fe_2018 enrollment_validated_ma_2018 enrollment_validated_flag_2018 enrollment_validated_all_2019 enrollment_validated_fe_2019 enrollment_validated_ma_2019 enrollment_validated_flag_2019 enrollment_validated_all_2020 enrollment_validated_fe_2020 enrollment_validated_ma_2020 enrollment_validated_flag_2020 enrollment_validated_all_2021 enrollment_validated_fe_2021 enrollment_validated_ma_2021 enrollment_validated_flag_2021 enrollment_validated_all_2022 enrollment_validated_fe_2022 enrollment_validated_ma_2022 enrollment_validated_flag_2022 enrollment_validated_all_2023 enrollment_validated_fe_2023 enrollment_validated_ma_2023 enrollment_validated_flag_2023 enrollment_interpolated_all_1990 enrollment_interpolated_fe_1990 enrollment_interpolated_ma_1990 enrollment_interpolated_flag1990 enrollment_interpolated_all_1991 enrollment_interpolated_fe_1991 enrollment_interpolated_ma_1991 enrollment_interpolated_flag1991 enrollment_interpolated_all_1992 enrollment_interpolated_fe_1992 enrollment_interpolated_ma_1992 enrollment_interpolated_flag1992 enrollment_interpolated_all_1993 enrollment_interpolated_fe_1993 enrollment_interpolated_ma_1993 enrollment_interpolated_flag1993 enrollment_interpolated_all_1994 enrollment_interpolated_fe_1994 enrollment_interpolated_ma_1994 enrollment_interpolated_flag1994 enrollment_interpolated_all_1995 enrollment_interpolated_fe_1995 enrollment_interpolated_ma_1995 enrollment_interpolated_flag1995 enrollment_interpolated_all_1996 enrollment_interpolated_fe_1996 enrollment_interpolated_ma_1996 enrollment_interpolated_flag1996 enrollment_interpolated_all_1997 enrollment_interpolated_fe_1997 enrollment_interpolated_ma_1997 enrollment_interpolated_flag1997 enrollment_interpolated_all_1998 enrollment_interpolated_fe_1998 enrollment_interpolated_ma_1998 enrollment_interpolated_flag1998 enrollment_interpolated_all_1999 enrollment_interpolated_fe_1999 enrollment_interpolated_ma_1999 enrollment_interpolated_flag1999 enrollment_interpolated_all_2000 enrollment_interpolated_fe_2000 enrollment_interpolated_ma_2000 enrollment_interpolated_flag2000 enrollment_interpolated_all_2001 enrollment_interpolated_fe_2001 enrollment_interpolated_ma_2001 enrollment_interpolated_flag2001 enrollment_interpolated_all_2002 enrollment_interpolated_fe_2002 enrollment_interpolated_ma_2002 enrollment_interpolated_flag2002 enrollment_interpolated_all_2003 enrollment_interpolated_fe_2003 enrollment_interpolated_ma_2003 enrollment_interpolated_flag2003 enrollment_interpolated_all_2004 enrollment_interpolated_fe_2004 enrollment_interpolated_ma_2004 enrollment_interpolated_flag2004 enrollment_interpolated_all_2005 enrollment_interpolated_fe_2005 enrollment_interpolated_ma_2005 enrollment_interpolated_flag2005 enrollment_interpolated_all_2006 enrollment_interpolated_fe_2006 enrollment_interpolated_ma_2006 enrollment_interpolated_flag2006 enrollment_interpolated_all_2007 enrollment_interpolated_fe_2007 enrollment_interpolated_ma_2007 enrollment_interpolated_flag2007 enrollment_interpolated_all_2008 enrollment_interpolated_fe_2008 enrollment_interpolated_ma_2008 enrollment_interpolated_flag2008 enrollment_interpolated_all_2009 enrollment_interpolated_fe_2009 enrollment_interpolated_ma_2009 enrollment_interpolated_flag2009 enrollment_interpolated_all_2010 enrollment_interpolated_fe_2010 enrollment_interpolated_ma_2010 enrollment_interpolated_flag2010 enrollment_interpolated_all_2011 enrollment_interpolated_fe_2011 enrollment_interpolated_ma_2011 enrollment_interpolated_flag2011 enrollment_interpolated_all_2012 enrollment_interpolated_fe_2012 enrollment_interpolated_ma_2012 enrollment_interpolated_flag2012 enrollment_interpolated_all_2013 enrollment_interpolated_fe_2013 enrollment_interpolated_ma_2013 enrollment_interpolated_flag2013 enrollment_interpolated_all_2014 enrollment_interpolated_fe_2014 enrollment_interpolated_ma_2014 enrollment_interpolated_flag2014 enrollment_interpolated_all_2015 enrollment_interpolated_fe_2015 enrollment_interpolated_ma_2015 enrollment_interpolated_flag2015 enrollment_interpolated_all_2016 enrollment_interpolated_fe_2016 enrollment_interpolated_ma_2016 enrollment_interpolated_flag2016 enrollment_interpolated_all_2017 enrollment_interpolated_fe_2017 enrollment_interpolated_ma_2017 enrollment_interpolated_flag2017 enrollment_interpolated_all_2018 enrollment_interpolated_fe_2018 enrollment_interpolated_ma_2018 enrollment_interpolated_flag2018 enrollment_interpolated_all_2019 enrollment_interpolated_fe_2019 enrollment_interpolated_ma_2019 enrollment_interpolated_flag2019 enrollment_interpolated_all_2020 enrollment_interpolated_fe_2020 enrollment_interpolated_ma_2020 enrollment_interpolated_flag2020 enrollment_interpolated_all_2021 enrollment_interpolated_fe_2021 enrollment_interpolated_ma_2021 enrollment_interpolated_flag2021 enrollment_interpolated_all_2022 enrollment_interpolated_fe_2022 enrollment_interpolated_ma_2022 enrollment_interpolated_flag2022 enrollment_interpolated_all_2023 enrollment_interpolated_fe_2023 enrollment_interpolated_ma_2023 enrollment_interpolated_flag2023 year_enrollment_1990 year_enrollment_1991 year_enrollment_1992 year_enrollment_1993 year_enrollment_1994 year_enrollment_1995 year_enrollment_1996 year_enrollment_1997 year_enrollment_1998 year_enrollment_1999 year_enrollment_2000 year_enrollment_2001 year_enrollment_2002 year_enrollment_2003 year_enrollment_2004 year_enrollment_2005 year_enrollment_2006 year_enrollment_2007 year_enrollment_2008 year_enrollment_2009 year_enrollment_2010 year_enrollment_2011 year_enrollment_2012 year_enrollment_2013 year_enrollment_2014 year_enrollment_2015 year_enrollment_2016 year_enrollment_2017 year_enrollment_2018 year_enrollment_2019 year_enrollment_2020 year_enrollment_2021 year_enrollment_2022 year_enrollment_2023 population_source population_fe_10_2010 population_fe_0516_2010 population_fe_primary_2010 population_fe_9plus_2010 population_ma_10_2010 population_ma_0516_2010 population_ma_primary_2010 population_ma_9plus_2010 population_all_10_2010 population_all_0516_2010 population_all_primary_2010 population_all_9plus_2010 population_fe_1014_2010 population_ma_1014_2010 population_all_1014_2010 population_fe_10_2011 population_fe_0516_2011 population_fe_primary_2011 population_fe_9plus_2011 population_ma_10_2011 population_ma_0516_2011 population_ma_primary_2011 population_ma_9plus_2011 population_all_10_2011 population_all_0516_2011 population_all_primary_2011 population_all_9plus_2011 population_fe_1014_2011 population_ma_1014_2011 population_all_1014_2011 population_fe_10_2012 population_fe_0516_2012 population_fe_primary_2012 population_fe_9plus_2012 population_ma_10_2012 population_ma_0516_2012 population_ma_primary_2012 population_ma_9plus_2012 population_all_10_2012 population_all_0516_2012 population_all_primary_2012 population_all_9plus_2012 population_fe_1014_2012 population_ma_1014_2012 population_all_1014_2012 population_fe_10_2013 population_fe_0516_2013 population_fe_primary_2013 population_fe_9plus_2013 population_ma_10_2013 population_ma_0516_2013 population_ma_primary_2013 population_ma_9plus_2013 population_all_10_2013 population_all_0516_2013 population_all_primary_2013 population_all_9plus_2013 population_fe_1014_2013 population_ma_1014_2013 population_all_1014_2013 population_fe_10_2014 population_fe_0516_2014 population_fe_primary_2014 population_fe_9plus_2014 population_ma_10_2014 population_ma_0516_2014 population_ma_primary_2014 population_ma_9plus_2014 population_all_10_2014 population_all_0516_2014 population_all_primary_2014 population_all_9plus_2014 population_fe_1014_2014 population_ma_1014_2014 population_all_1014_2014 population_fe_10_2015 population_fe_0516_2015 population_fe_primary_2015 population_fe_9plus_2015 population_ma_10_2015 population_ma_0516_2015 population_ma_primary_2015 population_ma_9plus_2015 population_all_10_2015 population_all_0516_2015 population_all_primary_2015 population_all_9plus_2015 population_fe_1014_2015 population_ma_1014_2015 population_all_1014_2015 population_fe_10_2016 population_fe_0516_2016 population_fe_primary_2016 population_fe_9plus_2016 population_ma_10_2016 population_ma_0516_2016 population_ma_primary_2016 population_ma_9plus_2016 population_all_10_2016 population_all_0516_2016 population_all_primary_2016 population_all_9plus_2016 population_fe_1014_2016 population_ma_1014_2016 population_all_1014_2016 population_fe_10_2017 population_fe_0516_2017 population_fe_primary_2017 population_fe_9plus_2017 population_ma_10_2017 population_ma_0516_2017 population_ma_primary_2017 population_ma_9plus_2017 population_all_10_2017 population_all_0516_2017 population_all_primary_2017 population_all_9plus_2017 population_fe_1014_2017 population_ma_1014_2017 population_all_1014_2017 population_fe_10_2018 population_fe_0516_2018 population_fe_primary_2018 population_fe_9plus_2018 population_ma_10_2018 population_ma_0516_2018 population_ma_primary_2018 population_ma_9plus_2018 population_all_10_2018 population_all_0516_2018 population_all_primary_2018 population_all_9plus_2018 population_fe_1014_2018 population_ma_1014_2018 population_all_1014_2018 population_fe_10_2019 population_fe_0516_2019 population_fe_primary_2019 population_fe_9plus_2019 population_ma_10_2019 population_ma_0516_2019 population_ma_primary_2019 population_ma_9plus_2019 population_all_10_2019 population_all_0516_2019 population_all_primary_2019 population_all_9plus_2019 population_fe_1014_2019 population_ma_1014_2019 population_all_1014_2019 population_fe_10_2020 population_fe_0516_2020 population_fe_primary_2020 population_fe_9plus_2020 population_ma_10_2020 population_ma_0516_2020 population_ma_primary_2020 population_ma_9plus_2020 population_all_10_2020 population_all_0516_2020 population_all_primary_2020 population_all_9plus_2020 population_fe_1014_2020 population_ma_1014_2020 population_all_1014_2020 population_fe_10_2021 population_fe_0516_2021 population_fe_primary_2021 population_fe_9plus_2021 population_ma_10_2021 population_ma_0516_2021 population_ma_primary_2021 population_ma_9plus_2021 population_all_10_2021 population_all_0516_2021 population_all_primary_2021 population_all_9plus_2021 population_fe_1014_2021 population_ma_1014_2021 population_all_1014_2021 population_fe_10_2022 population_fe_0516_2022 population_fe_primary_2022 population_fe_9plus_2022 population_ma_10_2022 population_ma_0516_2022 population_ma_primary_2022 population_ma_9plus_2022 population_all_10_2022 population_all_0516_2022 population_all_primary_2022 population_all_9plus_2022 population_fe_1014_2022 population_ma_1014_2022 population_all_1014_2022 population_fe_10_2023 population_fe_0516_2023 population_fe_primary_2023 population_fe_9plus_2023 population_ma_10_2023 population_ma_0516_2023 population_ma_primary_2023 population_ma_9plus_2023 population_all_10_2023 population_all_0516_2023 population_all_primary_2023 population_all_9plus_2023 population_fe_1014_2023 population_ma_1014_2023 population_all_1014_2023 population_fe_10_2024 population_fe_0516_2024 population_fe_primary_2024 population_fe_9plus_2024 population_ma_10_2024 population_ma_0516_2024 population_ma_primary_2024 population_ma_9plus_2024 population_all_10_2024 population_all_0516_2024 population_all_primary_2024 population_all_9plus_2024 population_fe_1014_2024 population_ma_1014_2024 population_all_1014_2024 population_fe_10_2025 population_fe_0516_2025 population_fe_primary_2025 population_fe_9plus_2025 population_ma_10_2025 population_ma_0516_2025 population_ma_primary_2025 population_ma_9plus_2025 population_all_10_2025 population_all_0516_2025 population_all_primary_2025 population_all_9plus_2025 population_fe_1014_2025 population_ma_1014_2025 population_all_1014_2025 population_fe_10_2026 population_fe_0516_2026 population_fe_primary_2026 population_fe_9plus_2026 population_ma_10_2026 population_ma_0516_2026 population_ma_primary_2026 population_ma_9plus_2026 population_all_10_2026 population_all_0516_2026 population_all_primary_2026 population_all_9plus_2026 population_fe_1014_2026 population_ma_1014_2026 population_all_1014_2026 population_fe_10_2027 population_fe_0516_2027 population_fe_primary_2027 population_fe_9plus_2027 population_ma_10_2027 population_ma_0516_2027 population_ma_primary_2027 population_ma_9plus_2027 population_all_10_2027 population_all_0516_2027 population_all_primary_2027 population_all_9plus_2027 population_fe_1014_2027 population_ma_1014_2027 population_all_1014_2027 population_fe_10_2028 population_fe_0516_2028 population_fe_primary_2028 population_fe_9plus_2028 population_ma_10_2028 population_ma_0516_2028 population_ma_primary_2028 population_ma_9plus_2028 population_all_10_2028 population_all_0516_2028 population_all_primary_2028 population_all_9plus_2028 population_fe_1014_2028 population_ma_1014_2028 population_all_1014_2028 population_fe_10_2029 population_fe_0516_2029 population_fe_primary_2029 population_fe_9plus_2029 population_ma_10_2029 population_ma_0516_2029 population_ma_primary_2029 population_ma_9plus_2029 population_all_10_2029 population_all_0516_2029 population_all_primary_2029 population_all_9plus_2029 population_fe_1014_2029 population_ma_1014_2029 population_all_1014_2029 population_fe_10_2030 population_fe_0516_2030 population_fe_primary_2030 population_fe_9plus_2030 population_ma_10_2030 population_ma_0516_2030 population_ma_primary_2030 population_ma_9plus_2030 population_all_10_2030 population_all_0516_2030 population_all_primary_2030 population_all_9plus_2030 population_fe_1014_2030 population_ma_1014_2030 population_all_1014_2030
traitvars: source_assessment enrollment_source population_source enrollment_definition min_proficiency_threshold surveyid countryname region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename cmu

. codebook, compact

Variable       Obs Unique       Mean       Min       Max  Label
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   1154    217          .         .         .  WB country code (3 letters)
year_asses~t  1154     25   -246.344     -9999      2023  Year of assessment
idgrade       1154      5  -184.2816      -999         6  Grade ID
test          1154     11          .         .         .  Assessment
nla_code      1154     26          .         .         .  Reference code for NLA in markdown documentation
subject       1154      4          .         .         .  Subject
nonprof_all    937    936   31.67532  .2252197  99.90289  % pupils below minimum proficiency (all)
nonprof_ma     756    756   25.95359  .1586986  99.86842  % pupils below minimum proficiency (ma)
nonprof_fe     756    756   23.09085  .1284603  99.93002  % pupils below minimum proficiency (fe)
se_nonprof~l   697    697   1.091134  .0367675  4.659985  SE of pupils below minimum proficiency (all)
se_nonprof~a   696    696   1.335122  .0378272  5.034541  SE of pupils below minimum proficiency (ma)
se_nonprof~e   696    696   1.294384  .0490543  6.059458  SE of pupils below minimum proficiency (fe)
fgt1_all       741    741   .1355317  .0308948  .5614824  Avg gap to minimum proficiency (all, FGT1)
fgt1_fe        741    741   .1293217  .0257019  .5376112  Avg gap to minimum proficiency (fe, FGT1)
fgt1_ma        741    741    .140074  .0298228  .5797679  Avg gap to minimum proficiency (ma, FGT1)
fgt2_all       741    741   .0364458   .001687   .390271  Avg gap squared to minimum proficiency (all, FGT2)
fgt2_fe        741    741   .0332727  .0011683  .3641997  Avg gap squared to minimum proficiency (fe, FGT2)
fgt2_ma        741    741    .038819  .0017091  .4102417  Avg gap squared to minimum proficiency (ma, FGT2)
enrollment..  1138    198   86.36786  19.18834       100  1990 enrollment_validated_all_
enrollment..  1000    171   85.01366  15.47124       100  1990 enrollment_validated_fe_
enrollment..  1000    172   87.09667   22.7423       100  1990 enrollment_validated_ma_
enrol~g_1990  1154      2   .1256499         0         1  1990 enrollment_validated_flag_
enrollment..  1138    198   86.33181  19.18834       100  1991 enrollment_validated_all_
enrollment..  1002    171   84.92765  15.57176       100  1991 enrollment_validated_fe_
enrollment..  1002    172   87.00236   22.7423       100  1991 enrollment_validated_ma_
enrol~g_1991  1154      2   .1161179         0         1  1991 enrollment_validated_flag_
enrollment..  1138    198   86.25509  19.18834       100  1992 enrollment_validated_all_
enrollment..  1002    173   84.49179  15.57176       100  1992 enrollment_validated_fe_
enrollment..  1002    174   86.75117   22.7423       100  1992 enrollment_validated_ma_
enrol~g_1992  1154      2   .0944541         0         1  1992 enrollment_validated_flag_
enrollment..  1138    198   86.44705  19.18834       100  1993 enrollment_validated_all_
enrollment..  1002    173    84.7848  15.57176       100  1993 enrollment_validated_fe_
enrollment..  1002    174   86.94534   22.7423       100  1993 enrollment_validated_ma_
enrol~g_1993  1154      2   .1039861         0         1  1993 enrollment_validated_flag_
enrollment..  1138    198   86.86014  19.18834       100  1994 enrollment_validated_all_
enrollment..   997    170   85.60735  15.57176       100  1994 enrollment_validated_fe_
enrollment..   997    171   87.85837   22.7423       100  1994 enrollment_validated_ma_
enrol~g_1994  1154      2   .0944541         0         1  1994 enrollment_validated_flag_
enrollment..  1138    197   87.02508  21.94671       100  1995 enrollment_validated_all_
enrollment..   989    167   85.78134  16.62561       100  1995 enrollment_validated_fe_
enrollment..   989    168   87.94078  26.53065       100  1995 enrollment_validated_ma_
enrol~g_1995  1154      2   .1074523         0         1  1995 enrollment_validated_flag_
enrollment..  1138    197   87.61385  23.36354       100  1996 enrollment_validated_all_
enrollment..  1014    169   86.23352  16.62561       100  1996 enrollment_validated_fe_
enrollment..  1014    169   88.60885    29.307       100  1996 enrollment_validated_ma_
enrol~g_1996  1154      2   .1325823         0         1  1996 enrollment_validated_flag_
enrollment..  1138    197   87.74278  23.36354       100  1997 enrollment_validated_all_
enrollment..  1023    174   86.10609  16.62561       100  1997 enrollment_validated_fe_
enrollment..  1023    174   88.59661    29.307       100  1997 enrollment_validated_ma_
enrol~g_1997  1154      2   .1568458         0         1  1997 enrollment_validated_flag_
enrollment..  1138    198   88.66089  23.36354       100  1998 enrollment_validated_all_
enrollment..  1029    176   87.01823  16.62561       100  1998 enrollment_validated_fe_
enrollment..  1029    176   89.12313  29.43147       100  1998 enrollment_validated_ma_
enrol~g_1998  1154      2   .2088388         0         1  1998 enrollment_validated_flag_
enrollment..  1138    197   88.99774  23.36354       100  1999 enrollment_validated_all_
enrollment..  1026    174   87.46022  16.62561       100  1999 enrollment_validated_fe_
enrollment..  1026    174   89.35226  30.05576       100  1999 enrollment_validated_ma_
enrol~g_1999  1154      2   .2417678         0         1  1999 enrollment_validated_flag_
enrollment..  1138    197   89.45871  23.36354       100  2000 enrollment_validated_all_
enrollment..  1002    170   87.93067  16.62561       100  2000 enrollment_validated_fe_
enrollment..  1002    171   89.48044  30.05576       100  2000 enrollment_validated_ma_
enrol~g_2000  1154      2   .2053726         0         1  2000 enrollment_validated_flag_
enrollment..  1138    197   89.81505  23.36354       100  2001 enrollment_validated_all_
enrollment..   972    168   88.90489  16.62561       100  2001 enrollment_validated_fe_
enrollment..   972    169   90.05318  30.05576       100  2001 enrollment_validated_ma_
enrol~g_2001  1154      2   .2313692         0         1  2001 enrollment_validated_flag_
enrollment..  1138    198   90.45147  23.36354       100  2002 enrollment_validated_all_
enrollment..   947    165   89.37894  16.62561       100  2002 enrollment_validated_fe_
enrollment..   947    166   90.28931  30.05576       100  2002 enrollment_validated_ma_
enrol~g_2002  1154      2   .2045061         0         1  2002 enrollment_validated_flag_
enrollment..  1138    198   90.65783  23.36354       100  2003 enrollment_validated_all_
enrollment..   992    166   89.49768  16.62561       100  2003 enrollment_validated_fe_
enrollment..   992    167   90.76956  30.05576       100  2003 enrollment_validated_ma_
enrol~g_2003  1154      2    .202773         0         1  2003 enrollment_validated_flag_
enrollment..  1138    198   91.03622  23.36354       100  2004 enrollment_validated_all_
enrollment..   984    167   89.97362  16.62561       100  2004 enrollment_validated_fe_
enrollment..   984    168   91.00879  30.05576       100  2004 enrollment_validated_ma_
enrol~g_2004  1154      2   .1984402         0         1  2004 enrollment_validated_flag_
enrollment..  1138    198   91.44627  23.36354       100  2005 enrollment_validated_all_
enrollment..  1005    169    90.6321  16.62561       100  2005 enrollment_validated_fe_
enrollment..  1005    170   91.60455  30.05576       100  2005 enrollment_validated_ma_
enrol~g_2005  1154      2   .2668977         0         1  2005 enrollment_validated_flag_
enrollment..  1138    198   91.66042  23.36354       100  2006 enrollment_validated_all_
enrollment..  1015    171   91.04769  16.62561       100  2006 enrollment_validated_fe_
enrollment..  1015    172   91.82952  30.05576       100  2006 enrollment_validated_ma_
enrol~g_2006  1154      2   .2105719         0         1  2006 enrollment_validated_flag_
enrollment..  1138    199   92.14686  23.36354       100  2007 enrollment_validated_all_
enrollment..  1024    171   91.56207  16.62561       100  2007 enrollment_validated_fe_
enrollment..  1024    172   92.38092  30.05576       100  2007 enrollment_validated_ma_
enrol~g_2007  1154      2   .2339688         0         1  2007 enrollment_validated_flag_
enrollment..  1138    199   92.43602  23.36354       100  2008 enrollment_validated_all_
enrollment..  1025    169   91.93771  16.62561       100  2008 enrollment_validated_fe_
enrollment..  1025    170   92.64453  30.05576       100  2008 enrollment_validated_ma_
enrol~g_2008  1154      2   .2235702         0         1  2008 enrollment_validated_flag_
enrollment..  1138    199   92.60843  23.36354       100  2009 enrollment_validated_all_
enrollment..  1017    173   92.13411  16.62561       100  2009 enrollment_validated_fe_
enrollment..  1017    174   92.70576  30.05576       100  2009 enrollment_validated_ma_
enrol~g_2009  1154      2   .2140381         0         1  2009 enrollment_validated_flag_
enrollment..  1138    199    92.8519  23.36354       100  2010 enrollment_validated_all_
enrollment..  1024    171   92.36854  16.62561       100  2010 enrollment_validated_fe_
enrollment..  1024    172   92.94538  30.05576       100  2010 enrollment_validated_ma_
enrol~g_2010  1154      2   .2175043         0         1  2010 enrollment_validated_flag_
enrollment..  1138    199   93.07684  23.36354       100  2011 enrollment_validated_all_
enrollment..  1039    172    92.6179  16.62561       100  2011 enrollment_validated_fe_
enrollment..  1039    173   93.15245  30.05576       100  2011 enrollment_validated_ma_
enrol~g_2011  1154      2   .2261698         0         1  2011 enrollment_validated_flag_
enrollment..  1138    198   93.08996  23.36354       100  2012 enrollment_validated_all_
enrollment..  1009    171   92.56817  16.62561       100  2012 enrollment_validated_fe_
enrollment..  1009    172   92.96955  30.05576       100  2012 enrollment_validated_ma_
enrol~g_2012  1154      2   .2409012         0         1  2012 enrollment_validated_flag_
enrollment..  1138    198   93.19214  23.36354       100  2013 enrollment_validated_all_
enrollment..   949    163   92.57355  16.62561       100  2013 enrollment_validated_fe_
enrollment..   949    164   92.93221  30.05576       100  2013 enrollment_validated_ma_
enrol~g_2013  1154      2   .2140381         0         1  2013 enrollment_validated_flag_
enrollment..  1138    198   93.02178  23.36354       100  2014 enrollment_validated_all_
enrollment..   964    161   92.31749  16.62561       100  2014 enrollment_validated_fe_
enrollment..   964    162   92.66222  30.05576       100  2014 enrollment_validated_ma_
enrol~g_2014  1154      2   .1854419         0         1  2014 enrollment_validated_flag_
enrollment..  1138    198   93.11726  23.36354       100  2015 enrollment_validated_all_
enrollment..   943    157   92.45492  16.62561       100  2015 enrollment_validated_fe_
enrollment..   943    158   92.75012  30.05576       100  2015 enrollment_validated_ma_
enrol~g_2015  1154      2    .229636         0         1  2015 enrollment_validated_flag_
enrollment..  1138    198   93.22753  23.36354       100  2016 enrollment_validated_all_
enrollment..   952    160   92.58168  16.62561       100  2016 enrollment_validated_fe_
enrollment..   952    161   92.94098  30.05576       100  2016 enrollment_validated_ma_
enrol~g_2016  1154      2   .2062392         0         1  2016 enrollment_validated_flag_
enrollment..  1138    198   93.16103  23.36354       100  2017 enrollment_validated_all_
enrollment..   947    160   92.32779         0       100  2017 enrollment_validated_fe_
enrollment..   947    162   92.93298  30.05576       100  2017 enrollment_validated_ma_
enrol~g_2017  1154      2   .2538995         0         1  2017 enrollment_validated_flag_
enrollment..  1138    198   93.07388  23.36354       100  2018 enrollment_validated_all_
enrollment..   938    158   92.24454         0       100  2018 enrollment_validated_fe_
enrollment..   938    160   92.79049  30.05576       100  2018 enrollment_validated_ma_
enrol~g_2018  1154      2   .2573657         0         1  2018 enrollment_validated_flag_
enrollment..  1138    198   93.08077  23.36354       100  2019 enrollment_validated_all_
enrollment..   938    158   92.25194         0       100  2019 enrollment_validated_fe_
enrollment..   938    160   92.80043  30.05576       100  2019 enrollment_validated_ma_
enrol~g_2019  1154      2   .2573657         0         1  2019 enrollment_validated_flag_
enrollment..  1138    198   93.08077  23.36354       100  2020 enrollment_validated_all_
enrollment..   938    158   92.25194         0       100  2020 enrollment_validated_fe_
enrollment..   938    160   92.80043  30.05576       100  2020 enrollment_validated_ma_
enrol~g_2020  1154      2   .2573657         0         1  2020 enrollment_validated_flag_
enrollment..  1138    198   93.08077  23.36354       100  2021 enrollment_validated_all_
enrollment..   938    158   92.25194         0       100  2021 enrollment_validated_fe_
enrollment..   938    160   92.80043  30.05576       100  2021 enrollment_validated_ma_
enrol~g_2021  1154      2   .2573657         0         1  2021 enrollment_validated_flag_
enrollment..  1138    198   93.08077  23.36354       100  2022 enrollment_validated_all_
enrollment..   938    158   92.25194         0       100  2022 enrollment_validated_fe_
enrollment..   938    160   92.80043  30.05576       100  2022 enrollment_validated_ma_
enrol~g_2022  1154      2   .2573657         0         1  2022 enrollment_validated_flag_
enrollment..  1138    198   93.08077  23.36354       100  
enrollment..   938    158   92.25194         0       100  
enrollment..   938    160   92.80043  30.05576       100  
enrol~g_2023  1154      2   .2573657         0         1  
enrollment..  1138    198   86.36786  19.18834       100  1990 enrollment_interpolated_all_
enrollment..  1000    171   85.01366  15.47124       100  1990 enrollment_interpolated_fe_
enrollment..  1000    172   87.09667   22.7423       100  1990 enrollment_interpolated_ma_
enroll~g1990  1154      2   .1256499         0         1  1990 enrollment_interpolated_flag
enrollment..  1138    198   86.35951  19.18834       100  1991 enrollment_interpolated_all_
enrollment..   959    162   85.48772  15.57176       100  1991 enrollment_interpolated_fe_
enrollment..   959    163   87.31068   22.7423       100  1991 enrollment_interpolated_ma_
enroll~g1991  1154      2   .1161179         0         1  1991 enrollment_interpolated_flag
enrollment..  1138    198   86.27648  19.18834       100  1992 enrollment_interpolated_all_
enrollment..   948    161    84.6929  15.57176       100  1992 enrollment_interpolated_fe_
enrollment..   948    162   86.90379   22.7423       100  1992 enrollment_interpolated_ma_
enroll~g1992  1154      2   .0944541         0         1  1992 enrollment_interpolated_flag
enrollment..  1138    198   86.59724  19.18834       100  1993 enrollment_interpolated_all_
enrollment..   880    153   85.83277  15.57176       100  1993 enrollment_interpolated_fe_
enrollment..   880    154   87.78891   22.7423       100  1993 enrollment_interpolated_ma_
enroll~g1993  1154      2   .1031196         0         1  1993 enrollment_interpolated_flag
enrollment..  1138    198   86.89033  19.18834       100  1994 enrollment_interpolated_all_
enrollment..   897    150   86.17699  15.57176       100  1994 enrollment_interpolated_fe_
enrollment..   897    151   88.25802   22.7423       100  1994 enrollment_interpolated_ma_
enroll~g1994  1154      2   .0944541         0         1  1994 enrollment_interpolated_flag
enrollment..  1138    198   87.21223  21.94671       100  1995 enrollment_interpolated_all_
enrollment..   857    141   86.87568  16.62561       100  1995 enrollment_interpolated_fe_
enrollment..   857    141   88.87303  26.53065       100  1995 enrollment_interpolated_ma_
enroll~g1995  1154      2   .1074523         0         1  1995 enrollment_interpolated_flag
enrollment..  1138    198   87.62274  23.36354       100  1996 enrollment_interpolated_all_
enrollment..   887    144     87.969  16.62561       100  1996 enrollment_interpolated_fe_
enrollment..   887    144   89.93712  30.05576       100  1996 enrollment_interpolated_ma_
enroll~g1996  1154      2   .1325823         0         1  1996 enrollment_interpolated_flag
enrollment..  1138    197   87.78336  23.36354       100  1997 enrollment_interpolated_all_
enrollment..   834    133   87.61307  16.62561       100  1997 enrollment_interpolated_fe_
enrollment..   834    133   90.12324    29.307       100  1997 enrollment_interpolated_ma_
enroll~g1997  1154      2   .1689775         0         1  1997 enrollment_interpolated_flag
enrollment..  1138    198    88.7573  23.36354       100  1998 enrollment_interpolated_all_
enrollment..   839    136   87.92746  16.62561       100  1998 enrollment_interpolated_fe_
enrollment..   839    136   89.77421  29.43147       100  1998 enrollment_interpolated_ma_
enroll~g1998  1154      2   .2227036         0         1  1998 enrollment_interpolated_flag
enrollment..  1138    198   89.12836  23.36354       100  1999 enrollment_interpolated_all_
enrollment..   895    153   87.82068  16.62561       100  1999 enrollment_interpolated_fe_
enrollment..   895    153   89.86833  30.05576       100  1999 enrollment_interpolated_ma_
enroll~g1999  1154      2    .229636         0         1  1999 enrollment_interpolated_flag
enrollment..  1138    198   89.57435  23.36354       100  2000 enrollment_interpolated_all_
enrollment..   874    149   88.90429  16.62561       100  2000 enrollment_interpolated_fe_
enrollment..   874    150   90.09998  30.05576       100  2000 enrollment_interpolated_ma_
enroll~g2000  1154      2   .2001733         0         1  2000 enrollment_interpolated_flag
enrollment..  1138    197   90.07543  23.36354       100  2001 enrollment_interpolated_all_
enrollment..   819    142   90.29459  16.62561       100  2001 enrollment_interpolated_fe_
enrollment..   819    143    91.2111  30.05576       100  2001 enrollment_interpolated_ma_
enroll~g2001  1154      2   .2530329         0         1  2001 enrollment_interpolated_flag
enrollment..  1138    197   90.55406  23.36354       100  2002 enrollment_interpolated_all_
enrollment..   844    144   90.20802  16.62561       100  2002 enrollment_interpolated_fe_
enrollment..   844    145    91.0908  30.05576       100  2002 enrollment_interpolated_ma_
enroll~g2002  1154      2   .2253033         0         1  2002 enrollment_interpolated_flag
enrollment..  1138    198   90.78127  23.36354       100  2003 enrollment_interpolated_all_
enrollment..   880    145   90.17765  16.62561       100  2003 enrollment_interpolated_fe_
enrollment..   880    146   91.44926  30.05576       100  2003 enrollment_interpolated_ma_
enroll~g2003  1154      2   .2244367         0         1  2003 enrollment_interpolated_flag
enrollment..  1138    198   91.07592  23.36354       100  2004 enrollment_interpolated_all_
enrollment..   874    146   90.63599  16.62561       100  2004 enrollment_interpolated_fe_
enrollment..   874    147   91.67766  30.05576       100  2004 enrollment_interpolated_ma_
enroll~g2004  1154      2   .2183709         0         1  2004 enrollment_interpolated_flag
enrollment..  1138    198    91.3015  23.36354       100  2005 enrollment_interpolated_all_
enrollment..   917    150    90.9681  16.62561       100  2005 enrollment_interpolated_fe_
enrollment..   917    151    91.8422  30.05576       100  2005 enrollment_interpolated_ma_
enroll~g2005  1154      2   .2660312         0         1  2005 enrollment_interpolated_flag
enrollment..  1138    198   91.58075  23.36354       100  2006 enrollment_interpolated_all_
enrollment..   904    146   91.23154  16.62561       100  2006 enrollment_interpolated_fe_
enrollment..   904    147   92.07687  30.05576       100  2006 enrollment_interpolated_ma_
enroll~g2006  1154      2   .2357019         0         1  2006 enrollment_interpolated_flag
enrollment..  1138    199   92.15919  23.36354       100  2007 enrollment_interpolated_all_
enrollment..   915    147   92.00286  16.62561       100  2007 enrollment_interpolated_fe_
enrollment..   915    148   92.72738  30.05576       100  2007 enrollment_interpolated_ma_
enroll~g2007  1154      2   .2426343         0         1  2007 enrollment_interpolated_flag
enrollment..  1138    199   92.46621  23.36354       100  2008 enrollment_interpolated_all_
enrollment..   868    145   92.17774  16.62561       100  2008 enrollment_interpolated_fe_
enrollment..   868    146   92.83599  30.05576       100  2008 enrollment_interpolated_ma_
enroll~g2008  1154      2   .2062392         0         1  2008 enrollment_interpolated_flag
enrollment..  1138    199   92.53681  23.36354       100  2009 enrollment_interpolated_all_
enrollment..   824    138   92.75802  16.62561       100  2009 enrollment_interpolated_fe_
enrollment..   824    139   93.09403  30.05576       100  2009 enrollment_interpolated_ma_
enroll~g2009  1154      2   .2131716         0         1  2009 enrollment_interpolated_flag
enrollment..  1138    199   92.85964  23.36354       100  2010 enrollment_interpolated_all_
enrollment..   836    137   92.62379  16.62561       100  2010 enrollment_interpolated_fe_
enrollment..   836    138   93.31898  30.05576       100  2010 enrollment_interpolated_ma_
enroll~g2010  1154      2   .2244367         0         1  2010 enrollment_interpolated_flag
enrollment..  1138    199   93.05553  23.36354       100  2011 enrollment_interpolated_all_
enrollment..   922    149    92.9376  16.62561       100  2011 enrollment_interpolated_fe_
enrollment..   922    150   93.35306  30.05576       100  2011 enrollment_interpolated_ma_
enroll~g2011  1154      2   .2400347         0         1  2011 enrollment_interpolated_flag
enrollment..  1138    198   93.16632  23.36354       100  2012 enrollment_interpolated_all_
enrollment..   938    153   93.01777  16.62561       100  2012 enrollment_interpolated_fe_
enrollment..   938    154   93.36594  30.05576       100  2012 enrollment_interpolated_ma_
enroll~g2012  1154      2    .254766         0         1  2012 enrollment_interpolated_flag
enrollment..  1138    198   93.13659  23.36354       100  2013 enrollment_interpolated_all_
enrollment..   875    144    92.7297  16.62561       100  2013 enrollment_interpolated_fe_
enrollment..   875    144   93.14414  30.05576       100  2013 enrollment_interpolated_ma_
enroll~g2013  1154      2   .2305026         0         1  2013 enrollment_interpolated_flag
enrollment..  1138    198    93.0204  23.36354       100  2014 enrollment_interpolated_all_
enrollment..   902    144   92.79807  16.62561       100  2014 enrollment_interpolated_fe_
enrollment..   902    145   92.93588  30.05576       100  2014 enrollment_interpolated_ma_
enroll~g2014  1154      2   .1854419         0         1  2014 enrollment_interpolated_flag
enrollment..  1138    198   93.13926  23.36354       100  2015 enrollment_interpolated_all_
enrollment..   867    144   92.93001  16.62561       100  2015 enrollment_interpolated_fe_
enrollment..   867    145     93.108  30.05576       100  2015 enrollment_interpolated_ma_
enroll~g2015  1154      2    .229636         0         1  2015 enrollment_interpolated_flag
enrollment..  1138    198    93.1957  23.36354       100  2016 enrollment_interpolated_all_
enrollment..   880    146   92.87692  16.62561       100  2016 enrollment_interpolated_fe_
enrollment..   880    147   93.25391  30.05576       100  2016 enrollment_interpolated_ma_
enroll~g2016  1154      2   .2062392         0         1  2016 enrollment_interpolated_flag
enrollment..  1138    198   93.15409  23.36354       100  2017 enrollment_interpolated_all_
enrollment..   942    157    92.3922         0       100  2017 enrollment_interpolated_fe_
enrollment..   942    158   93.00545  30.05576       100  2017 enrollment_interpolated_ma_
enroll~g2017  1154      2   .2538995         0         1  2017 enrollment_interpolated_flag
enrollment..  1138    198   93.07372  23.36354       100  2018 enrollment_interpolated_all_
enrollment..   938    158   92.24454         0       100  2018 enrollment_interpolated_fe_
enrollment..   938    160   92.79049  30.05576       100  2018 enrollment_interpolated_ma_
enroll~g2018  1154      2   .2573657         0         1  2018 enrollment_interpolated_flag
enrollment..  1138    198   93.08077  23.36354       100  2019 enrollment_interpolated_all_
enrollment..   938    158   92.25194         0       100  2019 enrollment_interpolated_fe_
enrollment..   938    160   92.80043  30.05576       100  2019 enrollment_interpolated_ma_
enroll~g2019  1154      2   .2573657         0         1  2019 enrollment_interpolated_flag
enrollment..  1138    198   93.08077  23.36354       100  2020 enrollment_interpolated_all_
enrollment..   938    158   92.25194         0       100  2020 enrollment_interpolated_fe_
enrollment..   938    160   92.80043  30.05576       100  2020 enrollment_interpolated_ma_
enroll~g2020  1154      2   .2573657         0         1  2020 enrollment_interpolated_flag
enrollment..  1138    198   93.08077  23.36354       100  2021 enrollment_interpolated_all_
enrollment..   938    158   92.25194         0       100  2021 enrollment_interpolated_fe_
enrollment..   938    160   92.80043  30.05576       100  2021 enrollment_interpolated_ma_
enroll~g2021  1154      2   .2573657         0         1  2021 enrollment_interpolated_flag
enrollment..  1138    198   93.08077  23.36354       100  2022 enrollment_interpolated_all_
enrollment..   938    158   92.25194         0       100  2022 enrollment_interpolated_fe_
enrollment..   938    160   92.80043  30.05576       100  2022 enrollment_interpolated_ma_
enroll~g2022  1154      2   .2573657         0         1  2022 enrollment_interpolated_flag
enrollment..  1138    198   93.08077  23.36354       100  
enrollment..   938    158   92.25194         0       100  
enrollment..   938    160   92.80043  30.05576       100  
enroll~g2023  1154      2   .2573657         0         1  
year_en~1990  1138     31   1996.264      1990      2022  1990 year_enrollment_
year_en~1991  1138     31   1996.559      1990      2022  1991 year_enrollment_
year_en~1992  1138     31   1996.975      1990      2022  1992 year_enrollment_
year_en~1993  1138     31   1997.373      1990      2022  1993 year_enrollment_
year_en~1994  1138     31   1997.783      1990      2022  1994 year_enrollment_
year_en~1995  1138     31   1998.406      1990      2022  1995 year_enrollment_
year_en~1996  1138     29   1998.996      1991      2022  1996 year_enrollment_
year_en~1997  1138     28    1999.61      1991      2022  1997 year_enrollment_
year_en~1998  1138     27   2000.069      1991      2022  1998 year_enrollment_
year_en~1999  1138     27   2000.664      1991      2022  1999 year_enrollment_
year_en~2000  1138     26   2001.338      1995      2022  2000 year_enrollment_
year_en~2001  1138     27     2002.2      1995      2022  2001 year_enrollment_
year_en~2002  1138     27   2003.099      1995      2022  2002 year_enrollment_
year_en~2003  1138     26    2003.88      1996      2022  2003 year_enrollment_
year_en~2004  1138     26   2004.766      1996      2022  2004 year_enrollment_
year_en~2005  1138     24    2005.93      1996      2022  2005 year_enrollment_
year_en~2006  1138     24   2006.852      1996      2022  2006 year_enrollment_
year_en~2007  1138     22   2007.665      1996      2022  2007 year_enrollment_
year_en~2008  1138     22   2008.743      1996      2022  2008 year_enrollment_
year_en~2009  1138     22   2009.523      1996      2022  2009 year_enrollment_
year_en~2010  1138     21   2010.496      1996      2022  2010 year_enrollment_
year_en~2011  1138     20   2011.388      1996      2022  2011 year_enrollment_
year_en~2012  1138     20     2012.2      1996      2022  2012 year_enrollment_
year_en~2013  1138     20   2012.959      1996      2022  2013 year_enrollment_
year_en~2014  1138     19   2013.801      1996      2022  2014 year_enrollment_
year_en~2015  1138     19   2014.561      1996      2022  2015 year_enrollment_
year_en~2016  1138     19   2015.456      1996      2022  2016 year_enrollment_
year_en~2017  1138     19   2016.216      1996      2022  2017 year_enrollment_
year_en~2018  1138     19   2016.506      1996      2022  2018 year_enrollment_
year_en~2019  1138     19   2016.523      1996      2022  2019 year_enrollment_
year_en~2020  1138     19   2016.523      1996      2022  2020 year_enrollment_
year_en~2021  1138     19   2016.523      1996      2022  2021 year_enrollment_
year_en~2022  1138     19   2016.523      1996      2022  2022 year_enrollment_
year_en~2023  1138     19   2016.523      1996      2022  
population~e  1154      1          .         .         .  The source used for population variables
po~e_10_2010  1154    217   271715.9     105.5  1.22e+07  2010 population_fe_10_
~e_0516_2010  1154    217    3274941    1276.5  1.46e+08  2010 population_fe_0516_
population..  1098    198    1850681     717.5  7.39e+07  2010 population_fe_primary_
population..  1144    213   982058.9     349.5  3.67e+07  2010 population_fe_9plus_
po~a_10_2010  1154    217   286639.3     113.5  1.35e+07  2010 population_ma_10_
~a_0516_2010  1154    217    3449105      1354  1.61e+08  2010 population_ma_0516_
population..  1098    198    1950144     769.5  8.16e+07  2010 population_ma_primary_
population..  1144    213    1033253       386  4.06e+07  2010 population_ma_9plus_
po~l_10_2010  1154    217   558355.1       221  2.57e+07  2010 population_all_10_
~l_0516_2010  1154    217    6724047    2635.5  3.06e+08  2010 population_all_0516_
population..  1098    198    3800825      1487  1.56e+08  2010 population_all_primary_
population..  1144    213    2015312     735.5  7.72e+07  2010 population_all_9plus_
~e_1014_2010  1154    217    1348744       511  6.02e+07  2010 population_fe_1014_
~a_1014_2010  1154    217    1420711       558  6.65e+07  2010 population_ma_1014_
~l_1014_2010  1154    217    2769455      1069  1.27e+08  2010 population_all_1014_
po~e_10_2011  1154    216   273194.4       104  1.24e+07  2011 population_fe_10_
~e_0516_2011  1154    217    3285518    1268.5  1.46e+08  2011 population_fe_0516_
population..  1098    198    1861568       732  7.40e+07  2011 population_fe_primary_
population..  1144    213   984574.1       217  3.70e+07  2011 population_fe_9plus_
po~a_10_2011  1154    217   288170.9       109  1.37e+07  2011 population_ma_10_
~a_0516_2011  1154    217    3461303    1331.5  1.61e+08  2011 population_ma_0516_
population..  1098    198    1961641     801.5  8.17e+07  2011 population_ma_primary_
population..  1144    212    1036010       218  4.09e+07  2011 population_ma_9plus_
po~l_10_2011  1154    217   561365.3       217  2.60e+07  2011 population_all_10_
~l_0516_2011  1154    217    6746821    2608.5  3.07e+08  2011 population_all_0516_
population..  1098    198    3823209    1533.5  1.56e+08  2011 population_all_primary_
population..  1144    213    2020584       435  7.79e+07  2011 population_all_9plus_
~e_1014_2011  1154    217    1351016       507  6.06e+07  2011 population_fe_1014_
~a_1014_2011  1154    216    1424076       544  6.70e+07  2011 population_ma_1014_
~l_1014_2011  1154    216    2775092      1051  1.28e+08  2011 population_all_1014_
po~e_10_2012  1154    217   273739.2     103.5  1.24e+07  2012 population_fe_10_
~e_0516_2012  1154    217    3301819    1260.5  1.46e+08  2012 population_fe_0516_
population..  1098    198    1874716     719.5  7.38e+07  2012 population_fe_primary_
population..  1144    213   986974.5       218  3.72e+07  2012 population_fe_9plus_
po~a_10_2012  1154    217   288490.1     107.5  1.37e+07  2012 population_ma_10_
~a_0516_2012  1154    217    3479226    1349.5  1.61e+08  2012 population_ma_0516_
population..  1098    198    1975210     802.5  8.15e+07  2012 population_ma_primary_
population..  1144    212    1038291     217.5  4.10e+07  2012 population_ma_9plus_
po~l_10_2012  1154    217   562229.3       215  2.62e+07  2012 population_all_10_
~l_0516_2012  1154    217    6781045    2643.5  3.07e+08  2012 population_all_0516_
population..  1098    198    3849926      1522  1.55e+08  2012 population_all_primary_
population..  1144    213    2025265     435.5  7.82e+07  2012 population_all_9plus_
~e_1014_2012  1154    217    1355484       513  6.11e+07  2012 population_fe_1014_
~a_1014_2012  1154    217    1429230       539  6.75e+07  2012 population_ma_1014_
~l_1014_2012  1154    217    2784715      1052  1.29e+08  2012 population_all_1014_
po~e_10_2013  1154    217   275322.6      99.5  1.24e+07  2013 population_fe_10_
~e_0516_2013  1154    217    3324418    1247.5  1.46e+08  2013 population_fe_0516_
population..  1098    198    1890538       708  7.35e+07  2013 population_fe_primary_
population..  1144    213     964664       226  3.71e+07  2013 population_fe_9plus_
po~a_10_2013  1154    214   289940.5     110.5  1.37e+07  2013 population_ma_10_
~a_0516_2013  1154    217    3503458      1383  1.61e+08  2013 population_ma_0516_
population..  1098    198    1991410       800  8.10e+07  2013 population_ma_primary_
population..  1144    213    1014582     224.5  4.10e+07  2013 population_ma_9plus_
po~l_10_2013  1154    217   565263.1       212  2.60e+07  2013 population_all_10_
~l_0516_2013  1154    217    6827876    2630.5  3.07e+08  2013 population_all_0516_
population..  1098    198    3881948      1508  1.54e+08  2013 population_all_primary_
population..  1144    213    1979246     450.5  7.81e+07  2013 population_all_9plus_
~e_1014_2013  1154    217    1361830       509  6.14e+07  2013 population_fe_1014_
~a_1014_2013  1154    217    1435796       540  6.78e+07  2013 population_ma_1014_
~l_1014_2013  1154    217    2797625      1068  1.29e+08  2013 population_all_1014_
po~e_10_2014  1154    217   277897.1        96  1.23e+07  2014 population_fe_10_
~e_0516_2014  1154    217    3352826      1231  1.46e+08  2014 population_fe_0516_
population..  1098    198    1911205       699  7.30e+07  2014 population_fe_primary_
population..  1138    212   978539.4       234  3.69e+07  2014 population_fe_9plus_
po~a_10_2014  1154    217   292606.2     113.5  1.36e+07  2014 population_ma_10_
~a_0516_2014  1154    217    3533433      1377  1.61e+08  2014 population_ma_0516_
population..  1098    198    2012781     794.5  8.04e+07  2014 population_ma_primary_
population..  1138    212    1028825       235  4.07e+07  2014 population_ma_9plus_
po~l_10_2014  1154    217   570503.2     209.5  2.59e+07  2014 population_all_10_
~l_0516_2014  1154    217    6886259      2608  3.07e+08  2014 population_all_0516_
population..  1098    198    3923986    1493.5  1.53e+08  2014 population_all_primary_
population..  1138    212    2007364       469  7.76e+07  2014 population_all_9plus_
~e_1014_2014  1154    217    1370637       492  6.16e+07  2014 population_fe_1014_
~a_1014_2014  1154    217    1444560       546  6.80e+07  2014 population_ma_1014_
~l_1014_2014  1154    217    2815197      1044  1.30e+08  2014 population_all_1014_
po~e_10_2015  1154    216   280832.9      95.5  1.22e+07  2015 population_fe_10_
~e_0516_2015  1154    217    3384293    1219.5  1.46e+08  2015 population_fe_0516_
population..  1098    198    1935159     694.5  7.25e+07  2015 population_fe_primary_
population..  1122    211   999251.1       240  3.66e+07  2015 population_fe_9plus_
po~a_10_2015  1154    217   295794.9     111.5  1.35e+07  2015 population_ma_10_
~a_0516_2015  1154    217    3566428      1373  1.61e+08  2015 population_ma_0516_
population..  1098    198    2038020     793.5  7.99e+07  2015 population_ma_primary_
population..  1122    211    1050518     250.5  4.03e+07  2015 population_ma_9plus_
po~l_10_2015  1154    216   576627.8       207  2.57e+07  2015 population_all_10_
~l_0516_2015  1154    217    6950721    2592.5  3.07e+08  2015 population_all_0516_
population..  1098    198    3973179      1488  1.52e+08  2015 population_all_primary_
population..  1122    211    2049770     490.5  7.69e+07  2015 population_all_9plus_
~e_1014_2015  1154    217    1380522       478  6.16e+07  2015 population_fe_1014_
~a_1014_2015  1154    217    1454333       544  6.80e+07  2015 population_ma_1014_
~l_1014_2015  1154    217    2834856      1022  1.30e+08  2015 population_all_1014_
po~e_10_2016  1154    217   284250.2        98  1.21e+07  2016 population_fe_10_
~e_0516_2016  1154    217    3415989      1216  1.46e+08  2016 population_fe_0516_
population..  1098    198    1959021     695.5  7.21e+07  2016 population_fe_primary_
population..  1122    211    1013003       248  3.62e+07  2016 population_fe_9plus_
po~a_10_2016  1154    217   299442.1       111  1.33e+07  2016 population_ma_10_
~a_0516_2016  1154    217    3599256      1370  1.61e+08  2016 population_ma_0516_
population..  1098    198    2063280     798.5  7.95e+07  2016 population_ma_primary_
population..  1122    211    1065163     269.5  4.00e+07  2016 population_ma_9plus_
po~l_10_2016  1154    216   583692.3       209  2.54e+07  2016 population_all_10_
~l_0516_2016  1154    216    7015245      2586  3.06e+08  2016 population_all_0516_
population..  1098    198    4022301      1494  1.52e+08  2016 population_all_primary_
population..  1122    211    2078166     517.5  7.62e+07  2016 population_all_9plus_
~e_1014_2016  1154    216    1391680       469  6.13e+07  2016 population_fe_1014_
~a_1014_2016  1154    216    1465569       539  6.76e+07  2016 population_ma_1014_
~l_1014_2016  1154    217    2857249      1008  1.29e+08  2016 population_all_1014_
po~e_10_2017  1154    217   288856.4     100.5  1.20e+07  2017 population_fe_10_
~e_0516_2017  1154    217    3447837    1219.5  1.45e+08  2017 population_fe_0516_
population..  1098    198    1981152     705.5  7.18e+07  2017 population_fe_primary_
population..  1121    210    1030869     258.5  3.60e+07  2017 population_fe_9plus_
po~a_10_2017  1154    217   304375.7       114  1.32e+07  2017 population_ma_10_
~a_0516_2017  1154    217    3632027    1370.5  1.60e+08  2017 population_ma_0516_
population..  1098    198    2086741     804.5  7.91e+07  2017 population_ma_primary_
population..  1121    210    1084209     287.5  3.97e+07  2017 population_ma_9plus_
po~l_10_2017  1154    217   593232.2     214.5  2.52e+07  2017 population_all_10_
~l_0516_2017  1154    217    7079864      2590  3.05e+08  2017 population_all_0516_
population..  1098    198    4067893      1510  1.51e+08  2017 population_all_primary_
population..  1121    210    2115078       546  7.56e+07  2017 population_all_9plus_
~e_1014_2017  1154    215    1406381       464  6.09e+07  2017 population_fe_1014_
~a_1014_2017  1154    216    1480942       540  6.71e+07  2017 population_ma_1014_
~l_1014_2017  1154    217    2887324      1004  1.28e+08  2017 population_all_1014_
po~e_10_2018  1154    216   293495.3       104  1.19e+07  2018 population_fe_10_
~e_0516_2018  1154    217    3479793      1226  1.45e+08  2018 population_fe_0516_
population..  1098    198    2002653     569.5  7.15e+07  2018 population_fe_primary_
population..  1121    210    1047908     270.5  3.59e+07  2018 population_fe_9plus_
po~a_10_2018  1154    217   309313.1     117.5  1.32e+07  2018 population_ma_10_
~a_0516_2018  1154    217    3665140    1376.5  1.59e+08  2018 population_ma_0516_
population..  1098    198    2109482       813  7.88e+07  2018 population_ma_primary_
population..  1121    210    1102349       305  3.95e+07  2018 population_ma_9plus_
po~l_10_2018  1154    216   602808.4     221.5  2.51e+07  2018 population_all_10_
~l_0516_2018  1154    217    7144933    2602.5  3.04e+08  2018 population_all_0516_
population..  1098    198    4112135    1539.5  1.50e+08  2018 population_all_primary_
population..  1121    209    2150257     575.5  7.54e+07  2018 population_all_9plus_
~e_1014_2018  1154    216    1424098       472  6.04e+07  2018 population_fe_1014_
~a_1014_2018  1154    217    1499842       548  6.66e+07  2018 population_ma_1014_
~l_1014_2018  1154    217    2923940      1020  1.27e+08  2018 population_all_1014_
po~e_10_2019  1154    217   296331.1     108.5  1.20e+07  2019 population_fe_10_
~e_0516_2019  1154    217    3512063      1235  1.44e+08  2019 population_fe_0516_
population..  1098    198    2022684       447  7.13e+07  2019 population_fe_primary_
population..  1121    209    1061731     205.5  3.58e+07  2019 population_fe_9plus_
po~a_10_2019  1154    217     312309       120  1.32e+07  2019 population_ma_10_
~a_0516_2019  1154    217    3698716    1387.5  1.58e+08  2019 population_ma_0516_
population..  1098    198    2130429     848.5  7.84e+07  2019 population_ma_primary_
population..  1121    210    1116982     319.5  3.95e+07  2019 population_ma_9plus_
po~l_10_2019  1154    217     608640     228.5  2.51e+07  2019 population_all_10_
~l_0516_2019  1154    217    7210778    2622.5  3.02e+08  2019 population_all_0516_
population..  1098    198    4153113    1619.5  1.50e+08  2019 population_all_primary_
population..  1121    210    2178713     603.5  7.53e+07  2019 population_all_9plus_
~e_1014_2019  1154    217    1442072       490  6.01e+07  2019 population_fe_1014_
~a_1014_2019  1154    217    1519058       557  6.62e+07  2019 population_ma_1014_
~l_1014_2019  1154    217    2961129      1047  1.26e+08  2019 population_all_1014_
po~e_10_2020  1154    216   297747.5      80.5  1.19e+07  2020 population_fe_10_
~e_0516_2020  1154    217    3542621      1251  1.43e+08  2020 population_fe_0516_
population..  1098    198    2032622     368.5  7.08e+07  2020 population_fe_primary_
population..  1111    208    1065829     113.5  3.58e+07  2020 population_fe_9plus_
po~a_10_2020  1154    215   313804.8       121  1.32e+07  2020 population_ma_10_
~a_0516_2020  1154    217    3730494      1400  1.57e+08  2020 population_ma_0516_
population..  1098    198    2140502       854  7.78e+07  2020 population_ma_primary_
population..  1111    209    1121360       330  3.94e+07  2020 population_ma_9plus_
po~l_10_2020  1154    217   611552.3       232  2.51e+07  2020 population_all_10_
~l_0516_2020  1154    217    7273115      2651  2.99e+08  2020 population_all_0516_
population..  1098    198    4173124      1634  1.49e+08  2020 population_all_primary_
population..  1111    209    2187188       628  7.51e+07  2020 population_all_9plus_
~e_1014_2020  1154    217    1459327       511  5.98e+07  2020 population_fe_1014_
~a_1014_2020  1154    216    1537425       572  6.59e+07  2020 population_ma_1014_
~l_1014_2020  1154    217    2996752      1083  1.26e+08  2020 population_all_1014_
po~e_10_2021  1154    217   299565.3      41.5  1.19e+07  2021 population_fe_10_
~e_0516_2021  1154    217    3569630      1272  1.42e+08  2021 population_fe_0516_
population..  1098    198    2042896     349.5  7.02e+07  2021 population_fe_primary_
population..  1111    209    1075359       120  3.56e+07  2021 population_fe_9plus_
po~a_10_2021  1154    217   315649.1       123  1.31e+07  2021 population_ma_10_
~a_0516_2021  1154    217    3758466    1411.5  1.56e+08  2021 population_ma_0516_
population..  1098    198    2150729     854.5  7.70e+07  2021 population_ma_primary_
population..  1111    209    1131296     338.5  3.92e+07  2021 population_ma_9plus_
po~l_10_2021  1154    217   615214.3     237.5  2.49e+07  2021 population_all_10_
~l_0516_2021  1154    217    7328096    2683.5  2.97e+08  2021 population_all_0516_
population..  1098    198    4193626      1639  1.47e+08  2021 population_all_primary_
population..  1111    208    2206655       650  7.48e+07  2021 population_all_9plus_
~e_1014_2021  1154    217    1473641       529  5.96e+07  2021 population_fe_1014_
~a_1014_2021  1154    217    1552588       591  6.57e+07  2021 population_ma_1014_
~l_1014_2021  1154    217    3026229      1120  1.25e+08  2021 population_all_1014_
po~e_10_2022  1154    215   302671.8      81.5  1.18e+07  2022 population_fe_10_
~e_0516_2022  1154    217    3593503    1293.5  1.41e+08  2022 population_fe_0516_
population..  1098    198    2051809       383  6.96e+07  2022 population_fe_primary_
population..  1111    209    1084869       153  3.54e+07  2022 population_fe_9plus_
po~a_10_2022  1154    217     318816       125  1.30e+07  2022 population_ma_10_
~a_0516_2022  1154    217    3782846    1426.5  1.54e+08  2022 population_ma_0516_
population..  1098    198    2159300       853  7.63e+07  2022 population_ma_primary_
population..  1111    209    1140981     343.5  3.89e+07  2022 population_ma_9plus_
po~l_10_2022  1154    217   621487.8       241  2.47e+07  2022 population_all_10_
~l_0516_2022  1154    217    7376349      2720  2.95e+08  2022 population_all_0516_
population..  1098    198    4211109      1633  1.46e+08  2022 population_all_primary_
population..  1111    209    2225850     666.5  7.42e+07  2022 population_all_9plus_
~e_1014_2022  1154    217    1486835       546  5.94e+07  2022 population_fe_1014_
~a_1014_2022  1154    217    1566330       603  6.54e+07  2022 population_ma_1014_
~l_1014_2022  1154    217    3053164      1149  1.25e+08  2022 population_all_1014_
po~e_10_2023  1154    217   304524.6      71.5  1.17e+07  2023 population_fe_10_
~e_0516_2023  1154    217    3610220    1196.5  1.40e+08  2023 population_fe_0516_
population..  1098    198    2058183     405.5  6.89e+07  2023 population_fe_primary_
population..  1111    209    1093444      92.5  3.50e+07  2023 population_fe_9plus_
po~a_10_2023  1154    217   320590.5       123  1.28e+07  2023 population_ma_10_
~a_0516_2023  1154    217    3799359      1445  1.53e+08  2023 population_ma_0516_
population..  1098    198    2165147       853  7.54e+07  2023 population_ma_primary_
population..  1111    209    1149561       348  3.90e+07  2023 population_ma_9plus_
po~l_10_2023  1154    217   625115.1       237  2.45e+07  2023 population_all_10_
~l_0516_2023  1154    217    7409580      2762  2.93e+08  2023 population_all_0516_
population..  1098    198    4223330      1474  1.44e+08  2023 population_all_primary_
population..  1111    209    2243006       467  7.34e+07  2023 population_all_9plus_
~e_1014_2023  1150    212    1501980       558  5.92e+07  2023 population_fe_1014_
~a_1014_2023  1150    213    1581913       609  6.51e+07  2023 population_ma_1014_
~l_1014_2023  1150    213    3083893      1167  1.24e+08  2023 population_all_1014_
po~e_10_2024  1154    217   305371.7        21  1.15e+07  2024 population_fe_10_
~e_0516_2024  1154    217    3617515      1021  1.39e+08  2024 population_fe_0516_
population..  1098    198    2058310       464  6.83e+07  2024 population_fe_primary_
population..  1111    209    1100483        52  3.45e+07  2024 population_fe_9plus_
po~a_10_2024  1154    217   321331.8     120.5  1.26e+07  2024 population_ma_10_
~a_0516_2024  1154    217    3805656      1461  1.52e+08  2024 population_ma_0516_
population..  1098    198    2164264     855.5  7.46e+07  2024 population_ma_primary_
population..  1111    209    1156471     284.5  3.90e+07  2024 population_ma_9plus_
po~l_10_2024  1154    217   626703.6       168  2.41e+07  2024 population_all_10_
~l_0516_2024  1154    217    7423171    2799.5  2.91e+08  2024 population_all_0516_
population..  1098    198    4222574    1461.5  1.43e+08  2024 population_all_primary_
population..  1111    209    2256953     336.5  7.28e+07  2024 population_all_9plus_
~e_1014_2024  1150    213    1510459       563  5.87e+07  2024 population_fe_1014_
~a_1014_2024  1150    213    1590350       609  6.45e+07  2024 population_ma_1014_
~l_1014_2024  1150    213    3100809      1172  1.23e+08  2024 population_all_1014_
po~e_10_2025  1154    217   306172.1        31  1.13e+07  2025 population_fe_10_
~e_0516_2025  1154    217    3616889       927  1.38e+08  2025 population_fe_0516_
population..  1098    198    2051754       595  6.76e+07  2025 population_fe_primary_
population..  1111    209    1104948        78  3.41e+07  2025 population_fe_9plus_
po~a_10_2025  1154    217   322017.2       120  1.24e+07  2025 population_ma_10_
~a_0516_2025  1154    217    3803230      1474  1.50e+08  2025 population_ma_0516_
population..  1098    198    2156111       828  7.37e+07  2025 population_ma_primary_
population..  1111    209    1160645       268  3.87e+07  2025 population_ma_9plus_
po~l_10_2025  1154    217   628189.3     168.5  2.37e+07  2025 population_all_10_
~l_0516_2025  1154    217    7420119      2831  2.88e+08  2025 population_all_0516_
population..  1098    198    4207865    1605.5  1.41e+08  2025 population_all_primary_
population..  1111    209    2265593       346  7.22e+07  2025 population_all_9plus_
~e_1014_2025  1150    213    1518613       561  5.81e+07  2025 population_fe_1014_
~a_1014_2025  1150    213    1598277       609  6.38e+07  2025 population_ma_1014_
~l_1014_2025  1150    213    3116890      1172  1.22e+08  2025 population_all_1014_
po~e_10_2026  1154    217   306043.4        47  1.13e+07  2026 population_fe_10_
~e_0516_2026  1154    217    3611358     909.5  1.36e+08  2026 population_fe_0516_
population..  1098    198    2040425     728.5  6.69e+07  2026 population_fe_primary_
population..  1111    209    1106932       104  3.39e+07  2026 population_fe_9plus_
po~a_10_2026  1154    217   321737.1       120  1.24e+07  2026 population_ma_10_
~a_0516_2026  1154    217    3795328    1483.5  1.49e+08  2026 population_ma_0516_
population..  1098    198    2142760     764.5  7.28e+07  2026 population_ma_primary_
population..  1111    208    1162188     262.5  3.84e+07  2026 population_ma_9plus_
po~l_10_2026  1154    217   627780.5     177.5  2.37e+07  2026 population_all_10_
~l_0516_2026  1154    217    7406686      2857  2.85e+08  2026 population_all_0516_
population..  1098    198    4183184      1493  1.40e+08  2026 population_all_primary_
population..  1111    209    2269119     366.5  7.18e+07  2026 population_all_9plus_
~e_1014_2026  1150    213    1524973       554  5.76e+07  2026 population_fe_1014_
~a_1014_2026  1150    213    1604238       606  6.31e+07  2026 population_ma_1014_
~l_1014_2026  1150    213    3129211      1163  1.21e+08  2026 population_all_1014_
po~e_10_2027  1154    217   304832.7        57  1.12e+07  2027 population_fe_10_
~e_0516_2027  1154    217    3604287       982  1.35e+08  2027 population_fe_0516_
population..  1098    198    2025924       678  6.63e+07  2027 population_fe_primary_
population..  1111    209    1104684       131  3.37e+07  2027 population_fe_9plus_
po~a_10_2027  1154    216   320334.8     121.5  1.22e+07  2027 population_ma_10_
~a_0516_2027  1154    217    3785584      1492  1.47e+08  2027 population_ma_0516_
population..  1098    198    2125918       720  7.20e+07  2027 population_ma_primary_
population..  1111    209    1159059     274.5  3.76e+07  2027 population_ma_9plus_
po~l_10_2027  1154    217   625167.4       189  2.35e+07  2027 population_all_10_
~l_0516_2027  1154    217    7389871      2878  2.82e+08  2027 population_all_0516_
population..  1098    198    4151842      1398  1.38e+08  2027 population_all_primary_
population..  1111    209    2263743     405.5  7.04e+07  2027 population_all_9plus_
~e_1014_2027  1150    212    1527076       552  5.70e+07  2027 population_fe_1014_
~a_1014_2027  1150    213    1605687       603  6.24e+07  2027 population_ma_1014_
~l_1014_2027  1150    213    3132763      1155  1.19e+08  2027 population_all_1014_
po~e_10_2028  1154    217   301595.4        74  1.11e+07  2028 population_fe_10_
~e_0516_2028  1154    217    3595883      1119  1.34e+08  2028 population_fe_0516_
population..  1098    198    2010334       637  6.57e+07  2028 population_fe_primary_
population..  1111    209    1097723       178  3.34e+07  2028 population_fe_9plus_
po~a_10_2028  1154    217   316609.5     117.5  1.21e+07  2028 population_ma_10_
~a_0516_2028  1154    217    3774317    1499.5  1.46e+08  2028 population_ma_0516_
population..  1098    198    2107938     682.5  7.11e+07  2028 population_ma_primary_
population..  1111    209    1150856       294  3.63e+07  2028 population_ma_9plus_
po~l_10_2028  1154    216   618204.9     216.5  2.32e+07  2028 population_all_10_
~l_0516_2028  1154    217    7370200    2892.5  2.80e+08  2028 population_all_0516_
population..  1098    198    4118272    1319.5  1.37e+08  2028 population_all_primary_
population..  1111    209    2248579       472  6.97e+07  2028 population_all_9plus_
~e_1014_2028  1150    213    1524108       556  5.65e+07  2028 population_fe_1014_
~a_1014_2028  1150    213    1601656       605  6.16e+07  2028 population_ma_1014_
~l_1014_2028  1150    213    3125764      1161  1.18e+08  2028 population_all_1014_
po~e_10_2029  1154    217   297777.7     103.5  1.10e+07  2029 population_fe_10_
~e_0516_2029  1154    217    3584923      1235  1.33e+08  2029 population_fe_0516_
population..  1098    198    1996494       614  6.52e+07  2029 population_fe_primary_
population..  1111    208    1088179       234  3.30e+07  2029 population_fe_9plus_
po~a_10_2029  1154    217   312275.9     110.5  1.19e+07  2029 population_ma_10_
~a_0516_2029  1154    217    3760276      1503  1.44e+08  2029 population_ma_0516_
population..  1098    198    2091763     658.5  7.04e+07  2029 population_ma_primary_
population..  1111    209    1139836       308  3.57e+07  2029 population_ma_9plus_
po~l_10_2029  1154    216   610053.7       214  2.30e+07  2029 population_all_10_
~l_0516_2029  1154    217    7345199      2900  2.77e+08  2029 population_all_0516_
population..  1098    198    4088257    1272.5  1.36e+08  2029 population_all_primary_
population..  1111    209    2228015       542  6.87e+07  2029 population_all_9plus_
~e_1014_2029  1150    213    1516460       565  5.60e+07  2029 population_fe_1014_
~a_1014_2029  1150    213    1592539       613  6.10e+07  2029 population_ma_1014_
~l_1014_2029  1150    213    3108999      1178  1.17e+08  2029 population_all_1014_
po~e_10_2030  1154    216   293909.2       103  1.08e+07  2030 population_fe_10_
~e_0516_2030  1154    217    3572445    1375.5  1.32e+08  2030 population_fe_0516_
population..  1098    198    1985256       608  6.48e+07  2030 population_fe_primary_
population..  1111    208    1077998     281.5  3.25e+07  2030 population_fe_9plus_
po~a_10_2030  1154    215   307948.7     109.5  1.17e+07  2030 population_ma_10_
~a_0516_2030  1154    217    3744628    1478.5  1.43e+08  2030 population_ma_0516_
population..  1098    198    2078207     647.5  6.98e+07  2030 population_ma_primary_
population..  1111    209    1127947       320  3.52e+07  2030 population_ma_9plus_
po~l_10_2030  1154    217   601857.9     212.5  2.25e+07  2030 population_all_10_
~l_0516_2030  1154    217    7317073    2868.5  2.75e+08  2030 population_all_0516_
population..  1098    198    4063463    1255.5  1.35e+08  2030 population_all_primary_
population..  1111    209    2205945     601.5  6.77e+07  2030 population_all_9plus_
~e_1014_2030  1150    212    1504138       577  5.55e+07  2030 population_fe_1014_
~a_1014_2030  1150    213    1578405       614  6.03e+07  2030 population_ma_1014_
~l_1014_2030  1150    213    3082543      1195  1.16e+08  2030 population_all_1014_
source_ass~t   937      6          .         .         .  Source of assessment data
enrollment~e  1154      4          .         .         .  The source used for this enrollment value
enrollment~n  1154      6          .         .         .  The definition used for this enrollment value
min_profic~d   935     20          .         .         .  Minimum Proficiency Threshold (assessment-specific)
surveyid       937    691          .         .         .  SurveyID (countrycode_year_assessment)
countryname   1154    217          .         .         .  Country Name
region        1154      7          .         .         .  Region Code
regionname    1154      7          .         .         .  Region Name
adminregion    590      6          .         .         .  Administrative Region Code
adminregio~e   590      6          .         .         .  Administrative Region Name
incomelevel   1154      5          .         .         .  Income Level Code
incomeleve~e  1154      5          .         .         .  Income Level Name
lendingtype   1154      4          .         .         .  Lending Type Code
lendingty~me  1154      4          .         .         .  Lending Type Name
cmu            866     48          .         .         .  WB Country Management Unit
---------------------------------------------------------------------------------------------------------------------------------------


~~~~
