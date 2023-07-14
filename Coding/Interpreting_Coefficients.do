* This do file shows some examples about how to interpret coefficient estimates from a regression with log transformation.
* Example source: https://stats.oarc.ucla.edu/other/mult-pkg/faq/general/faqhow-do-i-interpret-a-regression-model-when-some-variables-are-log-transformed/
* Code Author: Ian He
* Date: Jun 28, 2023
* Stata Version: 18

clear all

global dtadir   "D:\research\Econometrics_Tips\Data"


********************************************************************************
import delimited "$dtadir\lgtrans.csv", clear

* Report different types of means for "write"
ameans write

bysort female: ameans write


* Generate a dummy indicating "female"
gen gender = (female=="female")
drop female
rename gender female


* Log transforming variables
gen lgwrite = ln(write)
gen lgread = ln(read)
gen lgmath = ln(math)


********************************************************************************
* When dependent variable is log transformed
reg lgwrite
display exp(_b[_cons])	// same as the geometric mean

reg lgwrite female
display exp(_b[_cons])	// same as the geometric mean of male
display exp(_b[female])


********************************************************************************
* When some independent variables are log transformed
reg write female lgmath lgread

* With a 10% increase in reading score, the difference in the expected mean writing scores will be ( ) units.
display _b[lgread] * ln(1.1)


********************************************************************************
* When outcome variable and some independent variables are log transformed
reg lgwrite female lgmath read

* The expected percent increase in geometric mean from male student group to female student group is about ( )%.
display (exp(_b[female]) - 1) * 100

* With a one-unit increase in reading score, we expect to see about ( )% of increase in the geometric mean of writing score.
display (exp(_b[read]) - 1) * 100

* For any 10% increase in math score, the expected ratio of the writing score will be ( ).
display (1.1)^(_b[lgmath])
