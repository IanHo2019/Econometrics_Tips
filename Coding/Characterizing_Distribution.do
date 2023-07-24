* This do file shows how to plot true/empirical PMF, PDF, and CDF of a distribution.
* Author: Ian He
* Date: Jul 24, 2023
* Stata version: 18

********************************************************************************
**# PMF of Possion(5)
clear

set obs 16

gen X = _n-1
gen pmf = poissonp(5, X)

twoway bar pmf X, ///
	xtitle("X") ytitle("PMF") ///
	xlab(0(1)15, nogrid) barwidth(0.8) color(midblue%50) ///
	mlabel(pmf) mlabf(%5.4f) mlabc(gray) mlabsize(7pt)


********************************************************************************
**# PDF of N(0,1), N(0,4), and N(2,4)
clear

set obs 20

gen X = _n - 11

expand 50

bysort X: replace X = X + 0.02 * (_n-1)

gen pdf1 = normalden(X, 0, 1)
gen pdf2 = normalden(X, 0, 2)
gen pdf3 = normalden(X, 2, 2)

twoway line pdf1 pdf2 pdf3 X, ///
	lc(cranberry ebblue green) lwidth(medthick medthick medthick) ///
	xline(0, lc(gs12)) xline(2, lc(gs12)) ///
	xtitle("X") ytitle("PDF") ///
	xlabel(-10(1)10, nogrid) ///
	legend(order(1 "N(0,1)" 2 "N(0,4)" 3 "N(2,4)") cols(1) size(*0.8) position(11) ring(0) region(lc(black)))


********************************************************************************
**# CDF of Binomial(15, 0.4)
clear

set obs 16

gen X = _n-1
gen cdf = binomial(15, X, 0.4)

twoway line cdf X, ///
	connect(J) lwidth(medthick) lc(orange) ///
	xtitle("X") ytitle("CDF") ///
	xlab(0(1)15, nogrid)


********************************************************************************
**# Empirical PDF and CDF of N(0, 4)
clear

set obs 10000
set seed 230722

* Empirical PDF
gen X = rnormal(0, 2)
tab X	// return a table showing empirical PDF and CDF

gen true_pdf = normalden(X, 0, 2)

twoway (histogram X, bcolor(olive_teal)) ///
	(line true_pdf X, sort lc(red) lwidth(medthick)) ///
	(kdensity X, lc(blue) lwidth(medthick)), ///
	xtitle("X") xlab(-6(2)6, nogrid) ///
	legend(order(1 "Data density" 3 "Kernel density" 2 "N(0, 4) PDF") cols(1) size(*0.8) position(11) ring(0) region(lc(black)))


* Empirical CDF
sort X
gen frequency = 1/_N
gen ecdf = sum(frequency)

gen true_cdf = normal(X/2)	// Stata cannot calculate a CDF of nonstandard normal distribution, but we can first normalize the nonstandard one and then use Stata function to calculate.

twoway line true_cdf ecdf X, ///
	connect(J) lc(cranberry ebblue) lwidth(medthick medthick) ///
	xtitle("X") ytitle("Culmulative Probability") ///
	xlab(-6(2)8, nogrid) ///
	legend(order(2 "Empirical CDF" 1 "True CDF") cols(1) size(*0.8) position(11) ring(0) region(lc(black)))