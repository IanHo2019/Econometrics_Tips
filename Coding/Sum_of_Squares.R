# This R code file shows how to obtain the sums of squares and R squared after a regression.
# Code Author: Ian Ho
# Date: Sep 24, 2023
# R Version: 4.3.1
# Data Source: https://doi.org/10.5014/ajot.44.6.493


# Packages ---------------------------------------------------------------------
library(haven)    # for reading dta file


# Calculation ------------------------------------------------------------------
df <- read_dta('../Data/DR1990.dta')

model1 <- lm(acl ~ vocab, data=df)
summary(model1)

# Obtain R squared
summary(model1)$r.squared
summary(model1)$adj.r.squared

# Obtain sums of squares
ss_reg1 <- sum((fitted(model1) - mean(df$acl))^2)
ss_res1 <- sum((df$acl - fitted(model1))^2)
ss_tot1 <- ss_reg1 + ss_res1

# Obtain sequential SS of adding 'sdmt' to the previous model
model2 <- lm(acl ~ vocab + sdmt, data=df)

ss_reg2 <- sum((fitted(model2) - mean(df$acl))^2)
ss_res2 <- sum((df$acl - fitted(model2))^2)

# Either of two following values represent the sequential sum of squares.
seqSS_reg <- ss_reg2 - ss_reg1
seqSS_res <- ss_res1 - ss_res2
