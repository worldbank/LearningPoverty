
Documentation of Enrollment
=====================================================================

<sup>back to the [Repo Structure](https://github.com/worldbank/LearningPoverty/blob/master/00_documentation/002_repo_structure/Repo_Structure.md) :leftwards_arrow_with_hook:</sup>

Dataset of enrollment. Long in countrycode and year, wide in enrollment definitions (ie: interpolated, validated) and subgroups (all, male, female).

**Metadata** stored in this dataset:

~~~~
sources:     Multiple enrollment definitions were combined according to a ranking. Original data from World Bank (country team validation, ANER) and UIS (TNER, NET, GER)
lastsave:    16 Oct 2019 20:42:20 by wb255520
~~~~


About the **13 variables** in this dataset:

~~~~
The variables belong to the following variable classifications:
idvars valuevars traitvars

idvars:    countrycode year
valuevars: enrollment_validated_all enrollment_validated_fe enrollment_validated_ma enrollment_validated_flag enrollment_interpolated_all enrollment_interpolated_fe enrollment_interpolated_ma enrollment_interpolated_flag
traitvars: enrollment_source enrollment_definition year_enrollment

. codebook, compact

Variable       Obs Unique      Mean       Min       Max  Label
----------------------------------------------------------------------------------------------------------------------------------------
countrycode   6293    217         .         .         .  WB country code (3 letters)
year          6293     29      2004      1990      2018  Year
en~dated_all  5771   2908  87.21567  19.10539       100  Validated % of children enrolled in school (using closest year, both genders)
enr~dated_fe  5348   2742  86.29536  15.50506       100  Validated % of children enrolled in school (using closest year, female only)
enr~dated_ma  5348   2743  87.94001     22.14  100.4548  Validated % of children enrolled in school (using closest year, male only)
e~dated_flag  6293      2   .194184         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
en~lated_all  5771   3755  87.24924  19.10539       100  Validated % of children enrolled in school (using interpolation, both genders)
enr~lated_fe  4739   2857  87.20877  15.50506       100  Validated % of children enrolled in school (using interpolation, female only)
enr~lated_ma  4739   2858  88.61073     22.14  100.4548  Validated % of children enrolled in school (using interpolation, male only)
e~lated_flag  6293      2  .1978389         0         1  Flag for enrollment by gender filled up from aggregate (>=98.5%)
enrollmen~ce  6293      5         .         .         .  The source used for this enrollment value
enrollment~n  6293      5         .         .         .  The definition used for this enrollment value
year_enrol~t  5771     29  2005.041      1990      2018  The year that the enrollment value is from
----------------------------------------------------------------------------------------------------------------------------------------

~~~~
