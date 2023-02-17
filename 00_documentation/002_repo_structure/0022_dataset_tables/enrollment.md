
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
-----------------------------------------------------------------------------------------------------------------------------------------
countrycode   6944    217         .         .     .  WB country code (3 letters)
year          6944     32    2005.5      1990  2021  Year
en~dated_all  6432   2964  87.86989  19.18834   100  Validated % of children enrolled in school (using closest year, both genders)
enr~dated_fe  5379   2565  86.16633  15.47124   100  Validated % of children enrolled in school (using closest year, female only)
enr~dated_ma  5384   2567  87.82458   22.7423   100  Validated % of children enrolled in school (using closest year, male only)
e~dated_flag  6944      2   .234591         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  6432   3967  87.90066  19.18834   100  Validated % of children enrolled in school (using interpolation, both genders)
enr~lated_fe  4773   2766  87.08727  15.47124   100  Validated % of children enrolled in school (using interpolation, female only)
enr~lated_ma  4778   2769  88.53922   22.7423   100  Validated % of children enrolled in school (using interpolation, male only)
e~lated_flag  6944      2  .2370392         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
enrollmen~ce  6944      4         .         .     .  The source used for this enrollment value
enrollment~n  6944      6         .         .     .  The definition used for this enrollment value
year_enrol~t  6432     30  2006.249      1990  2019  The year that the enrollment value is from
-----------------------------------------------------------------------------------------------------------------------------------------


~~~~
