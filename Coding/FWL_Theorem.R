# This R code file uses a real-world data set to see whether the FWL Theorem holds truly.
# Code Author: Ian Ho
# Date: Sep 12, 2023
# R Version: 4.3.1


# Packages ---------------------------------------------------------------------
library(dplyr)         # for data manipulation
library(wooldridge)    # containing 115 data sets from Wooldridge (2019)


# The OLS Model ----------------------------------------------------------------
data(wage1, package='wooldridge')

# My model is regressing 'wage' on 'educ', 'exper', 'female', and 'married', only on the sample of white people.
df <- subset(wage1, nonwhite == 0)
df <- select(df, wage, educ, exper, female, married)

model <- lm(wage ~ educ + exper + female + married, data=df)
summary(model)

sprintf("The coeffcient of education in the OLS model is %8.6f.", model$coefficients['educ'])


# Three-Step FWL Theorem -------------------------------------------------------
step1 <- lm(wage ~ exper + female + married, data=df)
res1 <- resid(step1)

step2 <- lm(educ ~ exper + female + married, data=df)
res2 <- resid(step2)

step3 <- lm(res1 ~ res2)

sprintf("The coeffcient after the three-step procedure is %8.6f.", step3$coefficients['res2'])


# Two-Step FWL Theorem -------------------------------------------------------
s1 <- lm(educ ~ exper + female + married, data=df)
residual <- resid(s1)

s2 <- lm(df$wage ~ residual)

sprintf("The coeffcient after the two-step procedure is %8.6f.", s2$coefficients['residual'])