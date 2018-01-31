
# These are the global includes in Shiny web application.
# & First import of data 
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
#
library(shiny) 
library(stringr)
library(plotly)
library(ggplot2)
library(shinydashboard)
library(shinythemes)
library(shinyjs)  
#library(dplyr)

library(rsconnect)
library(reshape2)
library(data.table)
library(DT)
library(dtplyr)
library(splitstackshape)
#library(foreach)
 
 
df    <-fread('testdata.csv', header = TRUE, sep = ";", stringsAsFactors = TRUE)  
 


