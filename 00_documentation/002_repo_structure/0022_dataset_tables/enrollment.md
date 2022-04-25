
Documentation of Enrollment
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of enrollment. Long in countrycode and year, wide in enrollment definitions (ie: interpolated, validated) and subgroups (all, male, female).

**Metadata** stored in this dataset:

~~~~
sources:     Multiple enrollment definitions were combined according to a ranking. Original data from World Bank (country team validation, ANER) and UIS (TNER, NET, GER)
~~~~


About the **13 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year
valuevars: enrollment_validated_all enrollment_validated_fe enrollment_validated_ma enrollment_validated_flag enrollment_interpolated_all enrollment_interpolated_fe enrollment_interpolated_ma enrollment_interpolated_flag
traitvars: enrollment_source enrollment_definition year_enrollment

. codebook, compact

Variable       Obs Unique      Mean       Min   Max  Label
<<<<<<< HEAD
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   6727    217         .         .     .  WB country code (3 letters)
year          6727     31      2005      1990  2020  Year
en~dated_all  6231   2964  87.78292  19.18834   100  Validated % of children enrolled in school (using closest year, both genders)
enr~dated_fe  5220   2565  86.06985  15.47124   100  Validated % of children enrolled in school (using closest year, female only)
enr~dated_ma  5224   2567  87.75847   22.7423   100  Validated % of children enrolled in school (using closest year, male only)
e~dated_flag  6727      2  .2332392         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  6231   3967  87.81469  19.18834   100  Validated % of children enrolled in school (using interpolation, both genders)
enr~lated_fe  4614   2766  87.00985  15.47124   100  Validated % of children enrolled in school (using interpolation, female only)
enr~lated_ma  4618   2769  88.48919   22.7423   100  Validated % of children enrolled in school (using interpolation, male only)
=======
-----------------------------------------------------------------------------------------------------------------------
countrycode   6727    217         .         .     .  WB country code (3 letters)
year          6727     31      2005      1990  2020  Year
en~dated_all  6231   2964  87.78292  19.18834   100  Validated % of children enrolled in school (using closest year,...
enr~dated_fe  5220   2565  86.06985  15.47124   100  Validated % of children enrolled in school (using closest year,...
enr~dated_ma  5224   2567  87.75847   22.7423   100  Validated % of children enrolled in school (using closest year,...
e~dated_flag  6727      2  .2332392         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  6231   3967  87.81469  19.18834   100  Validated % of children enrolled in school (using interpolation...
enr~lated_fe  4614   2766  87.00985  15.47124   100  Validated % of children enrolled in school (using interpolation...
enr~lated_ma  4618   2769  88.48919   22.7423   100  Validated % of children enrolled in school (using interpolation...
>>>>>>> develop
e~lated_flag  6727      2  .2357663         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
enrollmen~ce  6727      4         .         .     .  The source used for this enrollment value
enrollment~n  6727      6         .         .     .  The definition used for this enrollment value
year_enrol~t  6231     30  2005.948      1990  2019  The year that the enrollment value is from
<<<<<<< HEAD
---------------------------------------------------------------------------------------------------------------------------------------
=======
-----------------------------------------------------------------------------------------------------------------------
>>>>>>> develop

~~~~
