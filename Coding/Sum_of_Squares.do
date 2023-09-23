* This do file shows how to obtain the sum of squares and R squared after a regression.
* Author: Ian Ho
* Date: September 23, 2023
* Stata Version: 18
* Data Source: https://doi.org/10.5014/ajot.44.6.493

clear all


********************************************************************************
**# Calculate sum of squares and R squared
use "..\Data\DR1990.dta", clear

* Model 1
reg acl vocab

display %9.4f e(mss)			    // SS_reg
display %9.4f e(rss)			    // SS_res
display %9.4f e(mss) + e(rss)	// SS_tot
display %9.4f e(r2)				    // R squared
display %9.4f e(r2_a)			    // adjusted R squared

scalar mss1 = e(mss)
scalar rss1 = e(rss)


* Model 2
reg acl vocab sdmt

display %9.4f e(mss)			    // SS_reg
display %9.4f e(rss)			    // SS_res
display %9.4f e(mss) + e(rss)	// SS_tot

scalar mss2 = e(mss)
scalar rss2 = e(rss)

display %9.4f mss2 - mss1	// Sequential sum of squares of adding "sdmt" to a model already with "vocab"


********************************************************************************
**# ANOVA command

* Partial SS
anova acl c.vocab c.sdmt

* Manually calculate the partial sum of squares of "vocab"
reg acl sdmt
scalar mss3 = e(mss)
display %9.4f mss2 - mss3


* Sequential SS
anova acl c.vocab c.sdmt, sequential

* Manually calculate the seq. sum of squares of "vocab"
reg acl
scalar mss0 = e(mss)
display %9.4f mss1 - mss0


* Order matters!
anova acl c.vocab c.sdmt, sequential
anova acl c.sdmt c.vocab, sequential	// The outputs look different.
