# -*- coding: utf-8 -*-
"""
Created on Thu Feb  1 13:00:05 2018

@author: fiorito_l
"""

import pandas as pd
import plotly.offline as py
import plotly.graph_objs as go

url = "https://raw.githubusercontent.com/luca-fiorito-11/mapping/master/U-JEFF.csv"
file = "U-JEFF.csv"
df = pd.read_csv(url)

#releases =
reduced_df = df[['ORIGIN-LIB', 'ORIGIN-VER']].drop_duplicates()
(df[['ORIGIN-LIB', 'ORIGIN-VER']].drop_duplicates())
# project selection
print (reduced_df["ORIGIN-LIB"] + "-" + reduced_df["ORIGIN-VER"].map(str))
proj = "JEFF"
sel_proj = df.LIBRARY == proj

# Version selection
vers = 3.3
sel_vers = df.VERSION == vers

reduced_df = df[ sel_proj & sel_vers ]


marks_data = [go.Bar(x=df.LIBRARY, y=df.VERSION)]
py.plot({'data': marks_data,
		   'layout': {'title': 'Marks Distribution',
							 'xaxis': {'title': 'Subjects'},
							 'yaxis': {'title': 'Marks '}}
		   })


