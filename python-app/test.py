# -*- coding: utf-8 -*-
"""
Created on Thu Feb  1 13:00:05 2018

@author: fiorito_l
"""

import pandas as pd
import plotly.offline as py
import plotly.graph_objs as go
import matplotlib.pyplot as plt
from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot

url = "https://raw.githubusercontent.com/luca-fiorito-11/mapping/master/U-JEFF.csv"
file = "U-JEFF.csv"
df = pd.read_csv(url, dtype=str)

#releases =
df['REL'] = df.LIB + "-" + df.VER
df['OREL'] = df.OLIB + "-" + df.OVER
releases = df.OREL.unique()
# project selection
proj = "JEFF"
sel_proj = df.LIB == proj



# MAT selection
MAT = '9228'
sel_mat = df.MAT == MAT



reduced_df = df[ sel_proj & sel_mat ]
orels = reduced_df.OREL.unique()
data = []
for orel in orels:
	counts = reduced_df[reduced_df.OREL == orel].REL.value_counts()
	trace = {
		  'x': counts.keys(),
		  'y': list(counts.values),
		  'name': orel,
		  'type': 'bar'
		  };
	data.append(trace)

layout = {
  'xaxis': {'title': 'X axis'},
  'yaxis': {'title': 'Y axis'},
  'barmode': 'relative',
  'title': 'Relative Barmode'
};
plot({'data': data, 'layout': layout}, filename='barmode-relative')
