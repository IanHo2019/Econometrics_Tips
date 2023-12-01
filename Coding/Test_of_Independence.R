# This R script shows how to do a chi-squared test of independence.
# Author: Ian Ho
# Date: Dec 1, 2023
# R Version: 4.3.1

# Load Packages ----------------------------------------------------------------
library(ggplot2)


# Test of Independence ---------------------------------------------------------
df <- iris

# Generate a discrete variable
df$length <- ifelse(df$Sepal.Length < median(df$Sepal.Length), "short", "long")

# Create a contingency table
table(df$Species, df$length)

# Visualization of counts for each cell
ggplot(df) +
  aes(x = Species, fill = length) +
  geom_bar(position = "dodge")

# Chi-square test of independence
test <- chisq.test(table(df$Species, df$length))
test

test$statistic    # test statistic
test$p.value      # p-value
test$parameter    # degrees of freedom
test$observed     # observed counts
test$expected     # expected counts (under independence)