## What is Learning Poverty?
Learning Poverty means being unable to read and understand a short, age-appropriate text by age 10. All foundational skills are important, but we focus on reading because: (i) reading proficiency is an easily understood measure of learning; (ii) reading is a student’s gateway to learning in every other area; and, (iii) reading proficiency can serve as a proxy for foundational learning in other subjects, in the same way that the absence child stunting is a marker of healthy early childhood development.

### How is Learning Poverty measured?
This indicator brings together schooling and learning. It starts with the share of children in school who haven’t achieved minimum reading proficiency and adjusts it by the proportion of children who are out of school. Formally, we do this by calculating Learning Poverty as:

_<p align="center"> LP = [BMP * (1-OoS)] + [1 * OoS] </p>_

where, _LP_ is Learning Poverty; _BMP_ is share of children in school below minimum proficiency; and _OoS_ is the percentage of out-of-school children.

Our decision was to treat out-of-school children as non-proficient in reading. This means that Learning Poverty will always be higher than the share of children in school who haven't achieved minimum reading proficiency. For countries with a very low Out-of-School population, the share of pupils Below Minimum Proficiency will be very close to the reported Learning Poverty. Given that this measure is intended to motivate action by governments and societies more generally, discounting for Out-of-School population avoids giving countries an incentive to improve their rate by encouraging dropout of marginal students.

### Estimating growth

In order to simulate reductions in learning poverty, a second empirical challenge is to measure how reading proficiency has improved in recent years, to better understand how quickly countries will improve in the future.  Doing this is even more challenging than estimating levels, because of the lack of data and thresholds that are comparable over time.  For any individual country, there may be multiple estimates of proficiency rates available for the past 15 years, but simply calculating growth using those estimates would be misleading.  Often, those estimates are based on data from different assessments—PIRLS and PASEC, for example.  Although the equating process described in our technical documentation aims to harmonize the proficiency levels across assessments to allow calculation of proficiency levels, this process is too imprecise to be used for growth estimates.  Given that growth rates are typically much smaller than the levels (e.g., 1% annual growth rate on a baseline of 50%), the noise introduced by mixing assessments is likely to swamp the signal (the actual change in proficiency).  See the technical report for more details on how we calculate growth.

### Regional aggregation
The Regional number is the population weighted aggregation for the countries from a specific region with assessment data following the Reporting Rule. Regional numbers are only reported if at least 40% of the 10-14 population is covered by an actual learning assessment.

### Global aggregation
The Global number is the population weighted regional number weighted by the actual 10-14 population from each region. In this case, the implicit assumption is that the population from countries with no reading poverty, are assigned with their respective regional averages.

### Confidence Intervals
We calculate confidence intervals that are reported in the figures in the following way. In short, we use a bootstrapping technique, which captures sampling error in the proportion of students minimally proficient at the country-year-assessment level.

Using our student level assessment microdata, we form an indicator for whether each student is above the minimum proficiency level defined above and estimate the mean to produce the proportion proficient in each country, along with the standard error of that mean estimate for each country-year-assessment combination. Applying the Central Limit Theorem, which can be justified because the assessment databases typically contain several hundred student observations, our estimator of the proportion above minimum proficiency in each country follows an asymptotically Normal distribution. To produce standard errors for our final numbers, which are based on these country-year-assessment level proficiency numbers, we take 100 bootstrap random draws of our country-year-assessment level proficiency database, where each individual observation in our database is drawn from the Normal distribution with the mean of this distribution being our estimate of the proportion minimally proficient and the variance being the squared standard error of that estimated proportion. Then our final global and regional numbers are calculated in each of these 100 bootstrap simulated databases, and our standard error is the standard deviation of our estimate across those 100 bootstrap datasets.

We assume that enrollment numbers, which also feed into our adjusted non-proficiency measure, are reported without error, as they are typically calculated using administrative records. We acknowledge that in some cases, even using administrative records can lead to inaccurate counts of students enrolled in schools. These types of misreporting errors are difficult to account for, and we are unable to incorporate this type of error into our standard error calculations. We acknowledge this as a limitation.

Special Cases for Standard Error Calculations
In some cases, where we are using country-year observations based on national assessments, we do not have a standard error associated with this observation. When no standard error is available, we use the median standard error across all country-year-assessment combinations used.
