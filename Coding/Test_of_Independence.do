* This do file shows how to do a chi-squared test of independence.
* Author: Ian Ho
* Date: Dec 1, 2023
* Stata Version: 18
********************************************************************************

import delimited "..\Data\iris.csv", clear

* Generate a discrete variable
sum sepallength, detail

gen length = "Short" if sepallength < `r(p50)'
replace length = "Long" if length == ""

* Visualize the frequencies
encode species, gen(species_code)	// The histogram command doesn't permit string variable.
label list species_code

histogram species_code, by(length, note("Grouped by Sepal Length")) ///
	discrete frequency width(0.5) ///
	xlab(1 "Setosa" 2 "Versicolor" 3 "Virginica", nogrid) xti("Species") ///
	ylab(0(10)50)

* Do a test of independence
tab species length, chi2
return list