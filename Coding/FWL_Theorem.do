* This do file uses a data set to show the magic of Frisch-Waugh-Lovell Theorem.
* Author: Ian Ho
* Date: September 10, 2023
* Package Needed: estout


sysuse auto, clear

**# Three-Step Version

* Regress Y on X1, X2, and X3
eststo long_reg: reg price weight foreign mpg

* We focus on beta1 (coefficient of weight) only
* (1) Regress Y on all the other regressors, X2 and X3
eststo step1: reg price foreign mpg
predict res1, residuals

* (2) Regress X1 on X2 and X3
eststo step2: reg weight foreign mpg
predict res2, residuals

* (3) Regress res1 on res2
eststo step3: reg res1 res2

* Compare the results
estout long_reg step*, ///
	varlabels(_cons "Constant") ///
	coll(none) cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) ///
	stats(N r2_a, nostar labels("Observations" "Adj. R2") fmt("%9.0fc" 3))



**# Two-Step Version

* We still focus on beta1 (coefficient of weight) only
* (1) Regress X1 on X2 and X3
eststo step1: reg weight foreign mpg
predict res, residuals

* (2) Regress Y on res
eststo step2: reg price res

* Compare the results
estout long_reg step1 step2, ///
	varlabels(_cons "Constant") ///
	coll(none) cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels(* .1 ** .05 *** .01) ///
	stats(N r2_a, nostar labels("Observations" "Adj. R2") fmt("%9.0fc" 3))