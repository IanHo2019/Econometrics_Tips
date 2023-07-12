# Load packages ----------------------------------------------------------------
library(psych)    # for computing different means



# Read data --------------------------------------------------------------------
setwd("C:/Users/ianho/Downloads/Econometrics_Tips")

logtrans <- read.csv("./Data/lgtrans.csv")
View(logtrans)

write <- logtrans$write
read <- logtrans$read
math <- logtrans$math



# Different types of means for "write" (our dependent variable) ----------------

## Means over the whole dataset
sprintf("The arithmetic mean of writing scores is %6.4f.", mean(write))
sprintf("The geometric mean of writing scores is %6.4f.", geometric.mean(write))
sprintf("The harmonic mean of writing scores is %6.4f.", harmonic.mean(write))

## Means by gender groups
aggregate(logtrans$write, list(logtrans$female), FUN=mean)
aggregate(logtrans$write, list(logtrans$female), FUN=geometric.mean)
aggregate(logtrans$write, list(logtrans$female), FUN=harmonic.mean)



# Generate a dummy indicating female -------------------------------------------
female <- ifelse(logtrans$female == 'female', 1, 0)



# When dependent variable is log transformed -----------------------------------

## Reg ln(write) on a constant term
lm1 <- lm(log(write) ~ 1)
summary(lm1)

### The exponentiated value of intercept is equal to the geometric mean of "write".
exp(coef(lm1)["(Intercept)"])


## Reg ln(write) on 1 and the gender dummy
lm2 <- lm(log(write) ~ female)
summary(lm2)

### Switching from male students to female students, we expect to see an about 10.88% increase in the geometric mean of writing scores.
round((exp(coef(lm2)["female"]) - 1) * 100, digits=2)


## Reg ln(write) on 1, gender dummy, read, and math
lm3 <- lm(log(write) ~ female + read + math)
summary(lm3)

### Writing scores will be 12.16% higher for the female students than for the male students.
round((exp(coef(lm3)["female"]) - 1) * 100, digits=2)

### With a one-unit increase in reading score, we expect to see a 0.67% increase in writing score.
round((exp(coef(lm3)["read"]) - 1) * 100, digits=2)

### With a ten-unit increase in reading score, we expect to see a 6.86% increase in writing score.
round((exp(coef(lm3)["read"] * 10) - 1) * 100, digits=2)



# When some independent variables are log transformed --------------------------
lm4 <- lm(write ~ female + log(read) + log(math))
summary(lm4)

### The expected mean difference in writing scores between the female and male groups is about 5.39 points.
round(coef(lm4)["female"], digits=2)

### For a 1% increase in reading score, the difference in the expected mean writing scores will be 0.17 points.
round(coef(lm4)["log(read)"] * log(1+0.01), digits=2)

### For a 10% increase in reading score, the difference in the expected mean writing scores will be 1.61 points.
round(coef(lm4)["log(read)"] * log(1+0.1), digits=2)



# When both dependent variable and some independent variables are log transformed ----
lm5 <- lm(log(write) ~ female + read + log(math))
summary(lm5)

### The expected percent increase in geometric mean from male group to female group is about 12.10%.
round((exp(coef(lm5)["female"])-1)*100, digits=2)

### For a one-unit increase in reading score, we expect to see an about 0.66% increase in the geometric mean of writing score.
round((exp(coef(lm5)["read"])-1)*100, digits=2)

### For a 1% increase in math score, we expect to see an about 0.41% increase in writing score.
round(((1+0.01)^(coef(lm5)["log(math)"])-1)*100, digits=2)

### For a 10% increase in math score, we expect to see an about 3.97% increase in writing score.
round(((1+0.1)^(coef(lm5)["log(math)"])-1)*100, digits=2)