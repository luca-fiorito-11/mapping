
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
 
 
df    <-fread('U-JEFF.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)  
# mats contains 562 (JEFF.33 correspondeces between MAT and Z,A,M)
mats  <-fread('matzsymam.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)  
df<-merge(df, mats)


