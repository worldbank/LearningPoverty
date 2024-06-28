
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
---------------------------------------------------------------------------------------------------------------------------------------
countrycode   7161    217         .         .     .  WB country code (3 letters)
year          7161     33      2006      1990  2022  Year
en~dated_all  6699   2923  88.19532  19.18834   100  Validated % of children enrolled in school (using closest year, both genders)
enr~dated_fe  5705   2535  86.34887         0   100  Validated % of children enrolled in school (using closest year, female only)
enr~dated_ma  5705   2537  88.05561   22.7423   100  Validated % of children enrolled in school (using closest year, male only)
e~dated_flag  7161      2  .2266443         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  6699   3881  88.22627  19.18834   100  Validated % of children enrolled in school (using interpolation, both genders)
enr~lated_fe  5106   2721   87.1734         0   100  Validated % of children enrolled in school (using interpolation, female only)
enr~lated_ma  5106   2723  88.71156   22.7423   100  Validated % of children enrolled in school (using interpolation, male only)
e~lated_flag  7161      2   .226784         0     1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
enrollmen~ce  7161      4         .         .     .  The source used for this enrollment value
enrollment~n  7161      6         .         .     .  The definition used for this enrollment value
year_enrol~t  6699     32  2007.069      1990  2022  The year that the enrollment value is from
---------------------------------------------------------------------------------------------------------------------------------------


~~~~
