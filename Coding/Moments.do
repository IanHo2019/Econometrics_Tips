* This do file shows how to calculate moments of a probability distribution.
* Author: Ian He
* Date: Aug 23, 2023
* Stata version: 18

clear all

global figdir "C:\Users\ianho\Downloads\Econometrics_Tips\Figures"


********************************************************************************
**# Pseudo Data

* Create a population
set obs 4

gen x = 0
forvalues i = 1/4 {
	replace x = `i' in `i'
}

gen pr = 0
replace pr = 0.2 in 1
replace pr = 0.3 in 2
replace pr = 0.4 in 3
replace pr = 0.1 in 4


* Plot
twoway bar pr x, ///
	xtitle("X") ytitle("PMF") ///
	xlab(, nogrid) ylab(0(0.1)0.4) barwidth(0.5)
graph export "$figdir\pmf_example.pdf", replace


* Calculate 1st raw moment: mean
* Alert: "gen sum()" returns a running sum; "egen sum()", like "egen total()" function, returns an overall sum.
gen x_pr = x * pr
egen mean = sum(x_pr)
display %9.4f mean[1]


* Calculate 2nd central moment: variance
gen dev_square = (x - mean)^2
gen devsq_pr = dev_square * pr
egen variance = sum(devsq_pr)

gen std_dev = sqrt(variance)

display %9.4f variance[1]


* Calculate 3rd standardized moment: skewness
gen dev_3 = (x - mean)^3
gen dev3_pr = dev_3 * pr
egen skew = sum(dev3_pr)
replace skew = skew/(std_dev^3)

display %9.4f skew[1]	// Negative skewness says this distribution is left-skewed.


* Calculate 4th standardized moment: kurtosis
gen dev_4 = (x - mean)^4
gen dev4_pr = dev_4 * pr
egen kurt = sum(dev4_pr)
replace kurt = kurt/(std_dev^4)

gen excess_kurt = kurt - 3

display %9.4f excess_kurt[1]	// Negative excess kurtosis says this distribution is platykurtic.



********************************************************************************
**# Real-World Data (Life Expectancy at Birth, 1998)

sysuse lifeexp, clear

summarize lexp, detail		// All moments are calculated as sample moments.

display r(mean)
display r(Var)					// sample variance
display r(Var) * (_N-1) / _N	// population variance
display r(skewness)             // biased skewness estimate
display r(kurtosis)             // biased kurtosis estimate