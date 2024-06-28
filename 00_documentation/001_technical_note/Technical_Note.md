# Learning Poverty Technical Note
<sup>back to the [README](https://github.com/worldbank/LearningPoverty/blob/master/README.md) :leftwards_arrow_with_hook:</sup>

### Table of Contents
1. [The Measure](#the-measure)  
  1.1. [An early-warning indicator for the Human Capital Project](#An-early-warning-indicator-for-the-Human-Capital-Project)  
  1.2. [Why measure Learning Poverty?](#Why-measure-Learning-Poverty?)  
  1.3. [What is Learning Poverty?](#What-is-Learning-Poverty?)    
  1.4. [How is Learning Poverty measured?](#How-is-Learning-Poverty-measured?)    
1. [Data source selection](#data-source-selection)  
  2.1. [Learning Assessments Selection](#learning-assessments-selection)  
  2.2. [Enrollment Data Selection](#enrollment-data-selection)  
  2.3. [Population Data](#population-data)  
1. [Global Aggregation](#global-aggregation)   
  3.1. [Countries Included](#countries-included)    
  3.2. [Reporting Levels](#reporting-levels)   
  3.3. [Estimating Growth](#estimating-growth)   
  3.4. [Calculation of Standard Errors](#calculation-of-standard-errors)   
***

## The Measure

### An early-warning indicator for the Human Capital Project
The Human Capital Project seeks to raise awareness and increase demand for interventions to build human capital. It aims to accelerate better and more investments in people.

In low- and middle-income countries, the learning crisis means that deficits in education outcomes are the single largest contributor to human capital deficits. On average, 80% of the distance to the global frontier is explained by shortcomings in the quality and quantity of schooling.  

For more information, please visit the **[Human Capital Project website](https://www.worldbank.org/humancapitalproject)**.

### Why measure Learning Poverty?
All children should be able to read by age 10. As a major contributor to human capital deficits, the learning crisis undermines sustainable growth and poverty reduction. This new synthetic indicator, _**Learning Poverty**_, was designed to help spotlight and galvanize action to address this crisis.  

The new data show that **more than half of all children in low- and middle-income countries suffer from Learning Poverty**. Eliminating Learning Poverty is as urgent as eliminating extreme monetary poverty, stunting, or hunger, and will require a multisectoral approach.

### What is Learning Poverty?
Learning Poverty means being unable to read and understand a short, age-appropriate text by age 10. All foundational skills are important, but we focus on reading because: (i) reading proficiency is an easily understood measure of learning; (ii) reading is a student’s gateway to learning in every other area; and, (iii) reading proficiency can serve as a proxy for foundational learning in other subjects, in the same way that the absence child stunting is a marker of healthy early childhood development.

### How is Learning Poverty measured?
This indicator brings together schooling and learning. It starts with the share of children in school who haven’t achieved minimum reading proficiency and adjusts it by the proportion of children who are out of school. Formally, we do this by calculating Learning Poverty as:

_<p align="center"> LP = [BMP * (1-OoS)] + [1 * OoS] </p>_

where,
  * _LP_ = Learning poverty
  * _BMP_ = Share of children at the end of primary who read at below the minimum proficiency level, as defined by the Global Alliance to Monitor Learning (GAML) in the context of the SDG 4.1.1 monitoring
  * _OOS_ = Out-of-school children, as a share of children of primary school age, and in which all OOS are regarded as being below the minimum proficiency level

Our decision was to treat out-of-school children as non-proficient in reading. This means that _learning poverty_ will always be higher than the share of children in school who haven't achieved minimum reading proficiency. For countries with a very low OOS, the BMP will be very close to the LP. Given that this measure is intended to motivate action by governments and societies more generally, discounting for out-of-school population avoids giving countries an incentive to improve their _learning poverty_ rate by encouraging dropout of marginal students.

***

## Data Source Selection

This section describes in details which assessments were used and how we chose one proficiency measure when multiple assessment exist. It also discusses the sources used for enrollment and population and how we handled data gaps.

### Learning Assessments Selection

The _learning poverty_ calculations use data from both cross-national and national large-scale assessments that are judged as being of sufficient quality in terms of design, implementation, comparability, timeliness, frequency, documentation, and access. The goal of “reading by age 10” is an ideal: to achieve it, not only should all children be reading proficiently after three full years in primary education, but they should also have entered school at age 6 or 7.

By contrast, our actual measurement of _learning poverty_ is based on cross-national or national assessments that are administered in Grades 4, 5, or 6 and therefore at ages between 10 and about 14. The _Learning Poverty_ results presented here therefore may be a conservative estimate of the extent of the literacy challenge for in-school children, since many children have been tested well after age 10.

The data used to calculate Learning Poverty has been made possible thanks to the work of Global Alliance to Monitor Learning led by the UNESCO Institute for Statistics (UIS), which established Minimum Proficiency Levels (MPLs) that enable countries to benchmark learning across different cross-national and national assessments. To operationalize this concept, we follow the current SDG monitoring process by defining “proficiency” as reaching at least the Low International Benchmark on the international PIRLS literacy assessment. Because PIRLS is the major global primary-age assessment focused on reading, we believe this to be an appropriate anchor for this exercise of equating.

#### Learning Assessments Source

##### **International**: Progress in International Reading Literacy Study ([PIRLS](https://nces.ed.gov/surveys/pirls/))

PIRLS is the anchor assessment used in our dataset. Of the major multi-country assessments, it is the one that is administered to children at roughly the target age: it assesses a random sample of Grade 4 students in each country, and the average age of tested children was 10.1 years in 2016, the last round of assessment. The minimum proficiency level considered is Level 2, the Low International Benchmark, which means a score of 400 points.

##### **International**: Trends in International Mathematics and Science Study ([TIMSS](https://nces.ed.gov/timss/))

For some countries we use proficiency data from TIMSS international math and science assessment in grades 3-6 (most countries participated in grade 4). For these countries, we use the science scores as a proxy for reading scores, counting children as proficient if they exceeded the Low International Benchmark of 400 points (Minimum Proficiency Level 2). We have two rationales for using this proxy. The first is conceptual: the ability to decipher science questions requires reading proficiency, since most science questions are word problems. The second is empirical: across the countries for which we have data for both subject areas, proficiency on science is highly correlated with reading proficiency. Within the PISA assessment, the science-reading correlation is 0.97, and for countries that have participated in both TIMSS and PIRLS, the correlation between the two is 0.99. Only in the case of Jordan, for which had no science scores, we are using mathematics proficiency as a proxy for reading proficiency (same MPL of 2, Low International Benchmark, a score of 400 points).

##### **Regional**: Latin American Laboratory for Assessment of the Quality of Education ([LLECE](http://www.unesco.org/new/en/santiago/education/education-assessment-llece/))

LLECE has implemented three rounds of regional assessments in Latin America (PERCE, SERCE and TERCE). The most recent for which we have data, the TERCE, was carried out in 2013 and covered 15 countries. The TERCE scores were reported in two scales: we choose to use the SERCE-compatible reporting scale, for historical comparability. In the SERCE scale, we defined minimum proficiency as reaching Level 3 in language (a score of 513.66 points).

##### **Regional**: CONFEMEN Education Systems Analysis Program ([PASEC](http://www.pasec.confemen.org))

PASEC has carried out several rounds of data collection in Francophone African countries. The most recent round was carried out in 2014, and we used data from that round of PASEC to provide estimates for 10 countries, considering minimum reading proficiency as reaching Level 4 in language for 6th graders (a score of 595.1 points).

Other rounds of PASEC were also included in our dataset, with proficiency data extracted from official reports instead of generated from the harmonized microdata in the Global Learning Assessment Database ([GLAD](https://github.com/worldbank/GLAD)). From all the countries included in the global number, this is the case for 3: Dem. Rep. of Congo, Madagascar and Mali (COD MLI MDG).

##### **Regional**: Southern and Eastern Africa Consortium for Monitoring Educational Quality ([SACMEQ](http://www.sacmeq.org/))

SACMEQ has carried out several rounds of data collection for Eastern and Southern African countries. The latest round of the SACMEQ assessment was carried out in 2013 (SACMEQ IV). Due to concerns on the quality of the data for this round, however, we do not use this to establish levels. We do, however, use this data for estimating changes in proficiency over time. We considered as minimum proficiency reaching Level 5 in reading (a score of 509 points).

##### **Country-specific**: National Learning Assessments (NLA)

Finally, for some larger-population countries that have participated in none of the assessments listed above, we have used proficiency estimates from national learning assessments. As with the regional assessments, this required deciding on the appropriate level of proficiency to map to the global benchmark. We made these judgments by: (1) drawing on the proficiency benchmarks and competency descriptions within each national assessment to select the level that most closely matched the global description of reading proficiency; and then (2) consulting the GAML initiative from UIS to determine whether any adjustment was necessary.  

There are 12 countries for which we used NLAs: Afghanistan, Bangladesh, China, Ethiopia, India, Kyrgyz Republic, Cambodia, Sri Lanka, Malaysia, Pakistan, Uganda and Vietnam (AFG BGD CHN ETH IND KGZ KHM LKA MYS PAK UGA VNM). Because the microdata from those NLAs have not yet been harmonized and included in the Global Learning Assessment Database ([GLAD](https://github.com/worldbank/GLAD)), from which we extracted proficiency for the other assessments, we rely on [this table](https://github.com/worldbank/LearningPoverty/blob/master/04_repo_update/041_rawdata/national_assessment_proficiency.md) to retrieve proficiency thresholds and averages for those countries.

#### Equating across assessments

If all countries participated in PIRLS, we would be able to construct global estimates of proficiency simply by using that assessment. However, most PIRLS participating countries are high-income, and only a small minority of low- and middle-income countries participate in PIRLS. So to extend the sample and fill out the database, we draw on several other types of assessments of late-primary reading and cognitive skills. To incorporate these other assessments into the analysis, we need to harmonize their benchmarks of reading proficiency with the PIRLS Low International Benchmark.  We do this by drawing on the agreed definition of minimum proficiency developed in 2018 by the Global Alliance to Monitor Learning (GAML) under the leadership of the UNESCO Institute of Statistics (UIS):

>Students interpret and give some explanation about the main and secondary ideas in different types of texts.  They establish connections between main ideas on a text and their personal experiences as well as general knowledge.

For each new assessment incorporated into the database, the harmonization process requires looking at the definitions of each level of proficiency and selecting the one that maps most clearly into this definition. For PIRLS, the corresponding Minimum Proficiency Level (MPL) is Level 2, whereas for the PASEC regional assessment (to take one example), the MPL is Level 4.  This level then is used to define the reading proficiency rate for that country, which is calculated as the share of students scoring at or above the minimum proficiency level.  

The GAML created an initial mappings between three regional assessments (PASEC, LLECE, and SACMEQ) as part of the SDG monitoring process ([2018a](http://gaml.uis.unesco.org/wp-content/uploads/sites/2/2018/12/4.1.1_29_Consensus-building-meeting-package.pdf), [2018b](http://gaml.uis.unesco.org/wp-content/uploads/sites/2/2018/10/Final-Report-of-September-2018-Paris-Consensus-Meeting.pdf)). These mappings, however, are provisional.  These have been updated during GAML workshops in 2019, and there is a process underway to validate them using analysis of individual items, but it will be some time before that process reaches any conclusions. While we typically use these thresholds, summarized in the table below, we triangulate these with other data where possible.

|Assessment| Minimum Proficiency Level (MPL) | Grade(s) assessed | Most recent year | Number of low- and middle-income countries w/ data after 2011 |
|---|---|---|---|---|
|PIRLS|Level 2 (Low international benchmark, 400 points)|4|2016|15|
|TIMSS|Level 2 (Low international benchmark, 400 points)|4|2015|7|
|LLECE|Level 3 (513.66 points)|6|2013|15|
|PASEC|Level 4 (595.1 points)|5 and 6|2014|13|
|SACMEQ|Level 5 (509 points) |6|2007|-|
|NLAs|Varies by country|4, 5 and 6|2017|12||

##### Preferred Learning Assessments Order

When a given country had administered multiple types of assessments, we applied a hierarchy of assessments in the order listed below. While we are always want to use as recent data as possible, we also want to use the data most comparable across countries. For some countries the most comparable assessment data is not the most recent and we will have to weigh recent against comparable. This section describes the decision tree used when deciding which learning assessment data that is used for each country.

| Preferred Rank | Learning Assessment Name | Type of Assessment |
|---|---|---|
|1 | Progress in International Reading Literacy Study (PIRLS) | International Assessments |
|2 | Trends in International Mathematics and Science Study (TIMSS) | International Assessments |
|3 | Latin American Laboratory for Assessment of the Quality of Education (LLECE) | Regional Assessments |
|3 | CONFEMEN Education Systems Analysis Program (PASEC) | Regional Assessments |
|3 | Southern and Eastern Africa Consortium for Monitoring Educational Quality (SEACMEQ) | Regional Assessments |
|4 | National Large Scale Learning Assessment (NLA) | National Learning Assessments ||

There are a few exceptions to the general rule above:
  * For 3 countries, we use LLECE 2013, even though a recent PIRLS exist: Chile, Honduras and Colombia (CHL HND COL)

Since our target population is children at the end of primary, we only consider proficiency assessments in Grades 3-6. Some assessments are administered to pupils in multiple grades in the same year, thus we use the following rank of grades according to our preferred choice:  
  * Grade 4 > Grade 5 > Grade 6 > Grade 3

### Enrollment Data Selection

Enrollment is the share of children in a specific age group that is attending school, with the out-of-school indicator being its complement. For most countries, the out-of-school children indicator is built using Adjusted Net Enrollment Rate (ANER) data for primary school from Unesco Institute of Statistics (UIS). In a few cases, where those data are inconsistent with other evidence, household surveys are used to estimate the out-of-school indicator.

#### General rules

We construct an enrollment dataset from 1990 to 2018, relying on multiple enrollment definition. Our dataset is constructed from these sources: World Bank ([WB Open Data](https://data.worldbank.org/)), UIS ([UNESCO Institute of Statistics](http://data.uis.unesco.org/#)) and other sources suggested by regional or country teams. We follow this hierarchy of enrollment definitions:
1. Adjusted Net Enrollment Rate (ANER)
2. Total Net Enrollment Rate (TNER)
3. Net enrollment rate (NER)
4. Gross Enrollment Rate (GER): if the gross enrollment rate is higher than 100%, it is adjusted to be 100%.

The _learning_poverty_ measure for each country pairing proficiency and enrollment data, using the year of the preferred assessment as the base. For that, we first fill missing enrollment values, we use a step function used and fill the data in with the value of the closest year. If there are data available for two years equally close to the year to fill, the older value is used. This procedure to extrapolate enrollment for missing values is required for us to pair the proficiency measure with enrollment measures from the same year, or its best proxy when enrollment is not available for the same year of the assessment.

#### Country specific decision

The regional focal points and country TTLs have validated the enrollment data and proposed alternative data/source for several countries. We have reviewed and justified using some of them. These validated enrollment data would take precedence over the data imported from WB or UIS. The list of them can be found in the link below. If the decision stated "use", the enrollment data for that country/year would be replaced. If the decision stated "accepted", the enrollment data are recognized but not replaced due to concerns about trends. [Validated enrollment data](https://github.com/worldbank/LearningPoverty/blob/master/01_data/011_rawdata/hosted_in_repo/enrollment_validated.md)

### Population Data

#### Population Source

Our source of population is the official United Nations populations estimates and projections (2017 Revision), prepared by the Population Division of the Department of Economic and Social Affairs of the United Nations Secretariat. The 2017 Revision is the twenty-fifth round of global population estimates and projections produced by the Population Division since 1951. The detailed description of the methodology on the way that country estimates have been prepared, including the assumptions that were used to project fertility, mortality and international migration up to
the year 2100 can be found on the [website of the Population Division](www.unpopulation.org).

This work uses the **10-14 age group** UN Population Division’s “medium fertility” scenario. The data can be also found at [HealthStats' Population Estimates and Projection database](https://databank.worldbank.org/data/source/health-nutrition-and-population-statistics:-population-estimates-and-projections). See also: [graphs](https://esa.un.org/unpd/wpp/Graphs/Probabilistic/) and [methodology](https://population.un.org/wpp/Publications/Files/WPP2017_Methodology.pdf).

***

## Global Aggregation

### Countries Included

In this product 217 countries are included, however, for some of them we can not calculate _learning poverty_, as we do not have data on either enrollment or proficiency. Those countries are still included in the final data sets for the sake of completeness, but they will have only missing values. [Full list of countries included in the dataset](https://github.com/worldbank/LearningPoverty/blob/master/01_data/011_rawdata/hosted_in_repo/country_metadata.csv).

We then use this consolidated global data base on reading proficiency for two purposes: to estimate the current level of _learning poverty_ globally, and to estimate how _learning poverty_ rates have changed over time.  

### Reporting levels

Estimating the current level of _learning poverty_ requires deciding how to define “current.”  We have chosen to set the anchor year for the current estimates as 2015, and to include results of assessments within four years before or after that year (2011 to 2019). In other words, the global estimate given below is labelled as 2015 but represents a range of years. This decision is driven by data availability. The international and regional assessments in the database are carried out only every 3 to 4 years, and even where assessments have been carried out recently, there is a lag of a couple of years before the data are available. One exception is the  Democratic Republic of Congo (COD), for which we are using 2010 PASEC assessment.

The most recent year of the four global and regional assessments ranges from 2013 (TERCE) to 2016 (PIRLS).  This might suggest creating a narrower window around 2015, but some countries that are not covered by those assessments have good data available only for 2011-12, and a handful of other countries have more recent data.  Therefore, to broaden the population coverage while still ensuring that data are recent enough to be relevant, we use a band of plus or minus four years around 2015. Note that this band is intended as a moving window.  For future rounds of estimates, we would use the same eight-year window around the new anchor year.  PASEC, TIMSS, and ERCE (the LLECE round after TERCE) are all being implemented in 2019, and PIRLS will follow in 2021, providing a wealth of new data to draw on.  New rounds of national assessments will be available for some of the countries that have not applied the international assessments.

#### Regional aggregation
The Regional number is the population weighted aggregation for the countries from a specific region with assessment data following the reporting rule of a rolling window of 8 years around our anchor year. Regional numbers are only reported if at least 40% of the 10-14 population is covered by an actual learning assessment.

#### Global aggregation
The Global number is the population weighted regional number weighted by the actual 10-14 population from each region. In this case, the implicit assumption is that the population from countries with no _learning poverty_, are assigned with their respective regional averages. This approach allows us to produce a global estimate based on data from **100 countries representing 81% of the target population**, or **62 low- and middle-income countries representing 80% of its population**. We report those two global aggregates separately to broadcast the fact that **most of the learning poor children are in the low- and middle-income countries**.

### Estimating Growth

A second empirical goal is to measure how _learning poverty_  has improved over the 2000-15 period, in order to simulate growth in the 2015-2030 period.  Doing this is even more challenging than estimating levels, because of the lack of data and thresholds that are comparable over time.  For any individual country, there may be multiple estimates of proficiency rates available for the past 15 years, but simply calculating growth using those estimates would be misleading.  Often, those estimates are based on data from different assessments — PIRLS and PASEC, for example.  Although the equating process described above aims to harmonize the proficiency levels across assessments to allow calculation of proficiency levels, this process is too imprecise to be used for growth estimates.  Given that growth rates are typically much smaller than the levels (e.g., 1% annual growth rate on a baseline of 50%), the noise introduced by mixing assessments is likely to swamp the signal (the actual change in proficiency).  

### Calculation of Standard Errors

Our Learning Poverty measure is a weighted average of two indicators, namely the share of learners below a minimum proficiency threshold and the share of out-of-school children. The first indicator is estimated using sample-based learning assessments, the latter is estimated in virtually all cases using administrative records from national Education Management Information System and the population census. Both measures have an associated error term, however they are of very different nature.

Our learning data is sample-based, and as such their error term reflect the sample error and the psychometrical procedure used to estimate the latent learning variable; our out-of-school measure is a population measure estimated using administrative records and census data, as such does not have a sample error. Both measures, however, are also affected by non-sampling error, such as questionnaire or measurement error, implementation challenges, and behavior effects. Unfortunately, we have no basis to capture this later term, hence we use bootstrap for error propagation of the sample error associated with our learning measure.

Using our student level assessment microdata, we form an indicator for whether each student is above the minimum proficiency level defined above and estimate the mean to produce the proportion proficient in each country, along with the standard error of that mean estimate for each country-year-assessment combination. Applying the Central Limit Theorem, which can be justified because the assessment databases typically contain several hundred student observations, our estimator of the proportion above minimum proficiency in each country follows an asymptotically Normal distribution. To produce standard errors for our final numbers, which are based on these country-year-assessment level proficiency numbers, we take 100 bootstrap random draws of our country-year-assessment level proficiency database, where each individual observation in our database is drawn from the Normal distribution with the mean of this distribution being our estimate of the proportion minimally proficient and the variance being the squared standard error of that estimated proportion. Then our final global and regional numbers are calculated in each of these 100 bootstrap simulated databases, and our standard error is the standard deviation of our estimate across those 100 bootstrap datasets.

As discussed, our enrollment numbers, which also feed into our Learning Poverty measure, are population measures based on administrative records without an associated sample error. We acknowledge that this indicator might suffer from non-sample errors, which can lead to inaccurate counts of students enrolled in schools. Non-sample errors affect both of our measures, as they have a direct impact on the out-of-school measure, and an indirect effect in our learning estimates as they impact the sample frame.  These types of misreporting errors are difficult to account for, and we are unable to incorporate this type of error into our standard error calculations. We acknowledge this as a limitation.

#### Special Cases for Standard Error Calculations
In some cases, where we are using country-year observations based on national assessments, we do not have a standard error associated with this observation.  When no standard error is available, we use a value of 1.2pp, which is approximately the median standard error across all country-year-assessment combinations used.
