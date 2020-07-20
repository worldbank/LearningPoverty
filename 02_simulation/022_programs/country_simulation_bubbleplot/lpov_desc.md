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

### Growth Rates
|<pre>  Region </pre> |  <pre>  Average Growth   </pre>     | <pre>   50th Percentile   </pre>        | <pre>  60th Percentile    </pre>        | <pre>  70th Percentile   </pre>        | <pre>   80th Percentile   </pre>       |  <pre>  90th Percentile   </pre>        | <pre>   95th Percentile   </pre>      | <pre>   99th Percentile   </pre>     |
| -----  |	:--------------:  |	:-------------:  |	:--------------:  |	:--------------:  |	:--------------:  |	:--------------:	| :--------------:	| :--------------:  |
|<pre> East Asia & Pacific </pre>| .993    | .782  | 1.094  | 1.481  | 1.836  | 2.320  | 2.580 | 3.120 |
|<pre> Europe and Central Asia </pre>| .535    | .580  | .759   | .994  | 1.251  | 1.509  | 1.509 | 2.244 |
|<pre> Latin America and Caribbean </pre>|  .876   | .616  | .642  | 1.291  | 1.8081  | 2.016  | 2.138 | 3.340 |
|<pre> Middle East and North Africa </pre>| 1.167    | 1.020  | 1.164  | 1.749  | 1.837  | 2.796 | 3.301 | 3.301 |
|<pre> South Asia </pre>| .9928978    | .782  | 1.094  | 1.481 | 1.836   | 2.320  | 2.5807 | 3.120 |
|<pre> Sub-Saharan Africa </pre>|  1.549   | 1.011  | 1.908  | 2.141  | 2.656  | 3.459| 3.883 | 3.883 |
