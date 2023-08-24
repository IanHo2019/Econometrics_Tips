# This R code file shows how to calculate moments of a probability distribution.
# Code Author: Ian Ho
# Date: Aug 24, 2023
# R Version: 4.3.1


# Packages ---------------------------------------------------------------------
library(ggplot2)   # for plotting
library(HistData)    # interesting data sets in history of statistics
library(moments)     # calculation of high-order moments


# Moments in Pseudo Data -------------------------------------------------------
df <- data.frame(X = c(1, 2, 3, 4),
                 Pr = c(0.2, 0.3, 0.4, 0.1))

# Distribution plot
ggplot(df, aes(X, Pr)) +
  geom_col(color='deepskyblue3', fill='deepskyblue3', width = 0.5) +
  xlab('X') + ylab('PMF') +
  theme(panel.background = element_rect(fill='white'),
        panel.grid.major.y = element_line(color='gray85', linetype='dotted'),
        axis.line.x.bottom = element_line(color='black'),
        axis.line.y.left = element_line(color='black'))


# Calculate 1st raw moment: mean
X_Pr <- df$X * df$Pr
mean <- Reduce('+', X_Pr)    # Reduce() reduces a vector to a single value by recursively calling a function, two arguments at a time.


# Calculate 2nd central moment: variance
dev <- df$X - mean
dev2 <- dev^2
dev2_Pr <- dev2 * df$Pr
variance <- Reduce('+', dev2_Pr)

std_dev <- sqrt(variance)


# Calculate 3rd standardized moment: skewness
dev3_Pr <- dev^3 * df$Pr
skew <- Reduce('+', dev3_Pr) / (std_dev^3)    # Negative skewness says this distribution is left-skewed.


# Calculate 4th standardized moment: kurtosis
dev4_Pr <- dev^4 * df$Pr
kurt <- Reduce('+', dev4_Pr) / (std_dev^4)
excess_kurt <- kurt - 3    # Negative excess kurtosis says this distribution is platykurtic.



# Moments in Real-World Data ---------------------------------------------------
rm(list = ls())

data('EdgeworthDeaths')    # data were from Registrar General's report in 1883; Freq is a vector collecting death rate per 1000 population in each British county

data_mean <- mean(EdgeworthDeaths$Freq)

spl_var <- var(EdgeworthDeaths$Freq)    # sample variance, using degree of freedom (n - 1)
pop_var <- var(EdgeworthDeaths$Freq) * (length(EdgeworthDeaths$Freq)-1) / length(EdgeworthDeaths$Freq)    # population variance

spl_std <- sqrt(spl_var)    # sample standard deviation
pop_std <- sqrt(pop_var)    # population standard deviation

skewness(EdgeworthDeaths$Freq)    # population skewness
kurtosis(EdgeworthDeaths$Freq)    # population kurtosis


# Running the following codes yields the same skewness and kurtosis.
# Clearly they are biased estimates if we consider them as sample skewness and kurtosis.
dev <- EdgeworthDeaths$Freq - data_mean
dev3 <- dev^3
dev4 <- dev^4
Reduce('+', dev3) / length(EdgeworthDeaths$Freq) / (pop_std^3)
Reduce('+', dev4) / length(EdgeworthDeaths$Freq) / (pop_std^4)


# Calculate all (population) moments at one time
# Note: the 0th moment is always equal to 1.
raw_moments <- all.moments(EdgeworthDeaths$Freq, order.max = 4)
central_moments <- all.moments(EdgeworthDeaths$Freq, order.max = 4, central=TRUE)

mean <- raw_moments[2]
var <- central_moments[3]
std_dev <- sqrt(central_moments[3])
skew <- central_moments[4] / (std_dev^3)
kurt <- central_moments[5] / (std_dev^4)