"""
This file shows how to calculate sum of squares and R squared for a regression model.
Author: Ian Ho
Date: Sep 25, 2023
Python Version: 3.11.4
"""

#%% Load Packages
import numpy as np                        # for numerical methods
import pandas as pd                       # for reading and handling data
import statsmodels.formula.api as smf     # for regressions


#%% Calculating R Sqaured and Sum of Squares
df = pd.read_stata('..\Data\DR1990.dta')

model1 = smf.ols('acl ~ vocab', data=df).fit()
print(model1.summary())

print('R squared is {0:6.4f}.'.format(model1.rsquared))
print('Adjusted R squared is {0:6.4f}.'.format(model1.rsquared_adj))

ss_reg1 = np.sum((model1.fittedvalues - df['acl'].mean())**2)
ss_res1 = np.sum((df['acl'] - model1.fittedvalues)**2)
ss_tot1 = ss_reg1 + ss_res1


#%% Calculating Sequential Sum of Squares of Adding "sdmt" to the Original Model
model2 = smf.ols('acl ~ vocab + sdmt', data=df).fit()

ss_reg2 = np.sum((model2.fittedvalues - df['acl'].mean())**2)

print("Sequential sum of squares of adding 'sdmt' to the original model is {0:6.4f}".format(ss_reg2 - ss_reg1))