# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot
import plotly.graph_objs as go

data = [go.Bar(
					x=['giraffes', 'orangutans', 'monkeys'],
					y=[20, 14, 23]
					)]

plot(data, filename='basic-bar.html')