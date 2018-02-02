
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
library(wesanderson)
library(rsconnect)
library(reshape2)
library(data.table)
library(DT)
library(dtplyr)
library(splitstackshape)
#library(foreach)
 
 
df    <-fread('csv/testdata.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)  
# mats contains 562 (JEFF.33 correspondeces between MAT and Z,A,M)
mats  <-fread('csv/matzsymam.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)  
df<-merge(df, mats)
df$MFMT<-paste(df$MF*1000+df$MT)
df<- df[order(df$MFMT),]
df$LIBVERORIG<-paste(df$LIBORIG, df$VERORIG, sep='-')
df$LIBVER<-paste(df$LIB, df$VER, sep='-')

df$MF<-factor(df$MF)
df$MT<-factor(df$MT)
df$LIBVERORIG<-factor(df$LIBVERORIG)
df$LIBVER<-factor(df$LIBVER)

#remove this line when data is good : 
df<-filter(df, LIBVER=="JEFF-3.3")

dcount<-count(df, LIBVER, Z,X,A,M)
dcount$TOT_CHUNKS<-dcount$n
dcount$n<-NULL
df<-merge(df, dcount)

dcount<-count(df, Z, X, A, M, LIBVER, LIBVERORIG, TOT_CHUNKS)
dcount$N_CHUNKS<-dcount$n
dcount$n<-NULL
dcount$ORIG_PCT<-round(dcount$N_CHUNKS/dcount$TOT_CHUNKS*100,1) # keep 1 decimal place


dcount2<-count(df, Z, X, A, M,LIBVER, MF)
dcount2$TOT_MT_IN_MF<-dcount2$n
dcount2$n<-NULL

dcount3<-count(df, Z, X, A, M,LIBVER, LIBVERORIG, MF)
dcount3$N_MTLIBVER_IN_MF<-dcount3$n
dcount3$n<-NULL

dcount2<-merge(dcount2, dcount3)
dcount3<-NULL
dcount2$PCT_MT_IN_MF<-round(dcount2$N_MTLIBVER_IN_MF/dcount2$TOT_MT_IN_MF,1)*100




 
 
my_colors<-c(
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








