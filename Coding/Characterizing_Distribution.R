# This R code file shows how to plot true/empirical PMF, PDF, and CDF of a probability distribution.
# Code Author: Ian He
# Date: Jul 24, 2023
# R Version: 4.3.1



# Packages ---------------------------------------------------------------------
library(tidyverse) # for data wrangling
library(tidyr)     # for reshaping the dataframe
library(ggplot2)   # for plotting



# PMF of Poisson(5) ------------------------------------------------------------
X <- seq.int(0, 15)
pmf <- dpois(X, 5)
df <- data.frame(X, pmf)

pdf(file='../Figures/PMF_Poisson5.pdf', width=10, height=5)    # two dots (..) in file path means navigating up directory
ggplot(df, aes(X, pmf)) +
  geom_col(color='deepskyblue3', fill='deepskyblue3') +
  geom_text(aes(label=sprintf('%5.4f', pmf)), size = 8/.pt, vjust=-0.5) +    # bar labels
  xlab('X') + ylab('PMF') +
  scale_x_continuous(breaks=seq(0, 15, by=1)) +    # customize x-axis ticks
  theme(plot.title = element_text(size=15, hjust=0.5),
        panel.background = element_rect(fill='white'),
        panel.grid.major.y = element_line(color='gray85', linetype='dotted'),
        axis.line.x.bottom = element_line(color='black'),
        axis.line.y.left = element_line(color='black'))
dev.off()



# PDF of N(0,1), N(0,4), and N(2,4) --------------------------------------------
rm(list = ls())    # clear environment

set.seed(230722)

X <- runif(1000, min=-10, max=10)
pdf1 <- dnorm(X, 0, 1)
pdf2 <- dnorm(X, 0, 2)
pdf3 <- dnorm(X, 2, 2)
df <- data.frame(X, pdf1, pdf2, pdf3)
df <- gather(df, key='distribution', value='pdf', c('pdf1', 'pdf2', 'pdf3'))

ggplot(df, aes(x=X, y=pdf, color=distribution)) +    # color varies across distributions
  geom_line(linetype=1, linewidth=0.7) +
  ggtitle('Normal Distribution') +
  labs(x='X', y='PDF', color=NULL) +    # color=NULL removes the title of legend
  scale_color_manual(labels=c('N(0,1)', 'N(0,4)', 'N(2,4)'),    # line labels
                     values=c('firebrick3', 'dodgerblue3', 'chartreuse4')) +    # lines colors
  scale_x_continuous(limits=c(-10,10), breaks=seq(-10, 10, by=2)) +
  theme(plot.title = element_text(size=15, hjust=0.5),
        panel.background = element_rect(fill='white'),
        axis.line.x.bottom = element_line(color='black'),
        axis.line.y.left = element_line(color='black'),
        legend.position = c(0.11,0.86),
        legend.key = element_blank(),    # remove the gray background of legend keys
        legend.background = element_rect(color='gray', linetype="solid"),
        legend.spacing.y = unit(-0.1, 'cm')) +    # reduce the vertical space above legend
  geom_vline(xintercept=0, linetype='dashed', color='gray') +
  geom_vline(xintercept=2, linetype='dashed', color='gray')



# CDF of Binomial(15, 0.4) -----------------------------------------------------
rm(list = ls())

set.seed(230722)

X <- runif(1000, min=0, max=15)
cdf <- pbinom(X, size=15, prob=0.4)
df <- data.frame(X, cdf)

ggplot(df, aes(X, cdf)) +
  geom_line(linetype=1, linewidth=0.7, color='orange') +
  ggtitle('Binomial(15, 0.4)') + xlab('X') + ylab('CDF') +
  scale_x_continuous(breaks=seq(0, 15, by=1)) +
  theme(plot.title = element_text(size=15, hjust=0.5),
        panel.background = element_rect(fill='white'),
        panel.grid.major.y = element_line(color='gray75', linetype='dotted'),
        axis.line.x.bottom = element_line(color='black'),
        axis.line.y.left = element_line(color='black'))



# Empirical PDF of N(0,4) ------------------------------------------------------
rm(list = ls())

set.seed(230722)

X <- rnorm(1000, 0, 2)
true_pdf <- dnorm(X, 0, 2)
df <- data.frame(X, true_pdf)

ggplot(df, aes(x=X)) +
  geom_histogram(aes(y=after_stat(density), fill='aquamarine3'), color='aquamarine3', bins=28) +
  geom_line(aes(y=true_pdf, color='Kernel Density'), linetype=1, lwd=0) +    # a pseudo line plot for adding a manual legend of the kernel density
  geom_line(aes(y=true_pdf, color='True PDF'), linetype=1, lwd=0.7) +
  geom_density(aes(color='Kernel Density'), linetype=1, lwd=1, show.legend=FALSE) +    # kernel density estimation
  labs(x='X', y='Density', title="N(0, 4)", color=NULL, fill=NULL) +
  scale_x_continuous(limits=c(-10, 10), breaks=seq(-10, 10, by=2)) +
  scale_color_manual(labels=c('Kernel density', 'True PDF'), values=c('royalblue', 'red3'), 
                     guide=guide_legend(override.aes=list(fill=c(NULL, NULL)))) +    # remove the boxes outside the keys in legend
  scale_fill_manual(labels=c('Data density'), values='aquamarine3', 
                    guide=guide_legend(override.aes=list(color=NULL))) +    # remove the box outside the key in legend
  theme(plot.title = element_text(size=15, hjust=0.5),
        panel.background = element_rect(fill='white'),
        axis.line.x.bottom = element_line(color='black'),
        axis.line.y.left = element_line(color='black'),
        legend.key = element_blank(),
        legend.key.size = unit(0.9, 'lines'),    # adjust the size of legend keys
        legend.position = c(0.86, 0.8),
        legend.spacing.y = unit(-0.15, 'cm'))



# Empirical CDF of N(0,4) ------------------------------------------------------
df$frequency <- 1/length(X)

df <- df[order(df$X, decreasing=FALSE),]    # sort dataframe by X
df$ecdf <- cumsum(df$frequency)

df$true_cdf <- pnorm(df$X, 0, 2)

ggplot(df, aes(x=X)) +
  geom_line(aes(y=true_cdf, color='True CDF'), linetype=1, linewidth=0.8) +
  geom_line(aes(y=ecdf, color='Empirical CDF'), linetype=1, linewidth=0.8) +
  labs(x='X', y='Cumulative Probability', title='N(0, 4)', color=NULL) +
  scale_x_continuous(limits=c(-6.5,8), breaks=seq(-6, 8, by=2)) +
  scale_color_manual(labels=c('Empirical CDF', 'True CDF'), values=c('royalblue', 'red3')) +
  theme(plot.title = element_text(size=15, hjust=0.5),
        panel.background = element_rect(fill='white'),
        axis.line.x.bottom = element_line(color='black'),
        axis.line.y.left = element_line(color='black'),
        legend.key = element_blank(),
        legend.position = c(0.15, 0.9),
        legend.background = element_rect(color='gray', linetype='solid'),
        legend.spacing.y = unit(-0.1, 'cm'))
