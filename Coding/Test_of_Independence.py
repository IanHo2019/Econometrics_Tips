"""
This Python script shows how to do a chi-squared test of independence.
Author: Ian He
Date: Dec 1, 2023
Python Version: 3.11.4
"""

# %% Load packages
import pandas as pd             # for data wrangling
import matplotlib.pyplot as plt # for plotting
import researchpy as rp         # for statistical testing


# %% Import data
df = pd.read_csv('..\\Data\\iris.csv')
df.info()

# Shorten the species labels
df['species'] = df['species'].replace({'Iris-setosa': 'Setosa',
                                       'Iris-versicolor': 'Versicolor',
                                       'Iris-virginica': 'Virginica'})


# %% Generate a discrete variable
df['length'] = pd.cut(df['sepal length'],
                      bins=[0, df['sepal length'].median(), float('Inf')],
                      right=False,
                      labels=['short', 'long'])


# %% Visualization of frequencies
fig, ax = plt.subplots(figsize=(6, 5))

group1 = df.loc[df['length']=='long', 'species']
group2 = df.loc[df['length']=='short', 'species']

group = [group1, group2]

plt.hist(group, bins=3,
         alpha=0.5, color=['red', 'blue'],
         label=['long', 'short'],
         align='mid')

ax.set_ylabel('Frequency')
ax.set_xlabel('Species')

plt.legend()

ax.spines['right'].set_visible(False)
ax.spines['top'].set_visible(False)


# %% Test of independence
crosstab, result, expected = rp.crosstab(df["species"], df["length"],
                                         test= "chi-square",
                                         expected_freqs= True)

crosstab    # a contingency table as before
result      # test results
expected    # expected counts for each cell