
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
library(VIM)
# library(wesanderson)
library(rsconnect)
library(reshape2)
library(data.table)
library(DT)
library(dtplyr)
library(dplyr)
library(splitstackshape)
#library(foreach)
 
# set environment variable to pass proxy
Sys.setenv(HTTPS_PROXY="http://proxy-vip1.oecd-nea.org:3128")

df <- fread('csv/testdata.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)  
# mats contains 562 (JEFF.33 correspondences between MAT and Z,A,M)
mats <- fread('csv/matzsymam.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)  
df <- merge(df, mats)
df$MFMT <- paste(df$MF*1000+df$MT)
df <- df[order(df$MFMT),]
# add fields release (LIBVER) and origin release (LIBVERORIG)
df$LIBVERORIG <- paste(df$LIBORIG, df$VERORIG, sep='-')
df$LIBVER <- paste(df$LIB, df$VER, sep='-')

df$MF <- factor(df$MF)
df$MT <- factor(df$MT)
 
my_colors <- c(
"JEFF-3.3"="#097C28",
"JEFF-3.2"="#72FD7A",
"JEFF-3.1.2"="#2CA743",
"JEFF-3.1.1"="#3DBC51",
"JEFF-3.1"="#4FD25E",
"JEFF-3.0"="#60E76C",
"JEFF-2.2"="#46f0f0",
"JENDL-4.0"="#f032e6",
"ENDFB-8.0"="#FFC129",
"ENDFB-7.1"="#FADB32",
"ENDFB-7.0"="#F5F63C",
"ENDFB-6.8"="#F4F50A",
"TENDL-2017"="#aa6e28",
"TENDL-2016"="#fffac8",
"TENDL-2015"="#800000",
"TENDL-2014"="#aaffc3",
"TENDL-2013"="#808000",
"TENDL-2012"="#ffd8b1",
"TENDL-2011"="#000080",
"TENDL-2010"="#808080",
"TENDL-2009"="#000000"
)


libdates <- fread('csv/libdate.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)






