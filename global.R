# These are the global includes in Shiny web application.
# & First import of data
# MAPPING app
# Authors : F. Michel-Sendis & L. Fiorito
#


library(plotly)
library(shinythemes)
library(shinyjs)
library(DT)
library(data.table)
library(dplyr)
library(flexdashboard)
library(knitr)

#library(rmarkdown)
#library(shiny)
#library(ggplot2)
#library(shinydashboard)
#library(VIM)
#library(dtplyr)
#library(splitstackshape)
#library(stringr)
#library(rsconnect)
#library(reshape2)

# install packages if not already present : 
# 
# list.of.packages <- c("plotly", "shinythemes", "shinyjs",
#                       "data.table", "DT", "dplyr", "flexdashboard")
# 
# new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
# if(length(new.packages)) install.packages(new.packages)



# set environment variable to pass proxy
#Sys.setenv(HTTPS_PROXY="http://proxy-vip1.oecd-nea.org:3128")

#user function for Half-Life display: 
returnHumanReadableHalfLife <- function(seconds){
  MIN=60
  HOUR=60*MIN
  DAY=24*HOUR
  YEAR=365.25*DAY
  MYEAR=1e+6*YEAR
  BYEAR=1e+9*YEAR
   
  seconds<-as.numeric(seconds)
  HL<-seconds
  #HL<-formatC(seconds, format="e", digits=1) 
  unit<-"s"
  
  if (seconds==0) return("stable")
  if (seconds >0 & seconds<MIN) {}
  if (seconds >MIN & seconds<HOUR){
    HL<-seconds/MIN
    unit<-"min"}
  if (seconds >HOUR & seconds<DAY){
    HL<-seconds/HOUR
    unit<-"h"
  }
  if (seconds >DAY & seconds<YEAR){
    HL<-seconds/DAY
    unit<-"d"
  }
  if (seconds >YEAR & seconds<MYEAR){
    HL<-seconds/YEAR
    unit<-"y"
  }
  if (seconds >MYEAR & seconds<BYEAR){
    HL<-seconds/MYEAR
    unit<-"Myr"
  }
  if (seconds>BYEAR){
    HL<-seconds/BYEAR
    unit<-"Byr"
  }
  
  HL<-round(HL,1)
  if(HL>101) HL<-formatC(HL, format="G", digits = 1)
  HL<-paste(HL,unit)
  return(HL)
}

gpath<-"../../csv/"
#gpath<-"https://raw.githubusercontent.com/luca-fiorito-11/mapping/r-app/csv/"

# dataframe coming from the mapping run
df <- fread(paste0(gpath,'CHUNKS-JEFF.csv'),
            header = TRUE,
            sep = ",",
            stringsAsFactors = FALSE)

# dataframe containing 562 (JEFF.33 correspondences between MAT and Z,A,M)
mats <- fread(paste0(gpath,'matzsymam.csv'),
              header = TRUE,
              sep = ",",
              stringsAsFactors = FALSE)

# dataframe containing 562 (JEFF.33 correspondences between MAT and Z,A,M)
decay <- fread(paste0(gpath,'decay_data_jeff33.csv'),
              header = TRUE,
              sep = ",",
              stringsAsFactors = FALSE)
decay$HalfLife<-lapply(decay$HL, function(x)returnHumanReadableHalfLife(x)) 
decay$HL<-lapply(decay$HL, function(x){formatC(x, format="e", digits=1)}) 


# dataframe containing descriptions for each MF
mts<-fread(paste0(gpath,'MTs.csv'),
           header = TRUE,
           sep = ",",
           stringsAsFactors = TRUE)

# dataframe containing descriptions for each MT
mfs<-fread(paste0(gpath,'MF.csv'),
           header = TRUE,
           sep = ",",
           stringsAsFactors = TRUE)

# Merge dataframes
df <- df %>%
  merge(mats) %>%
  # use allow.cartesian as precautionary measure when the result of duplicating keys gets bigger than max(nrow(x), nrow(i))
  merge(mfs, by = "MF", allow.cartesian = T) %>%
  merge(mts, by = "MT", allow.cartesian = T)

# Add unique ID MFMT as new column
df$MFMT <- paste(df$MF*1000+df$MT)

# add fields release (LIBVER) and origin release (LIBVERORIG)
df$LIBVERORIG <- paste(df$LIBORIG,"-",df$VERORIG, sep='')
df$LIBVER <- paste(df$LIB,"-",df$VER, sep='')

df$SYMA <- paste(df$X,"-",df$A, sep='')
df$SYMAM <- paste(df$X,"-",df$A,"-",df$M, sep='')
df <- df[order(df$X),]

df$MF <- factor(df$MF)
df$MT <- factor(df$MT)

# dataframe containing colors associated to eahc lib version
colors <- fread(paste0(gpath,'my_colors.csv'))
#needs to be a named vector :
my_colors<- setNames(as.character(colors$LIBVERCOLOR), as.character(colors$LIBVER))

libdates <- fread(paste0(gpath,'libdate.csv'), header = TRUE, sep = ",", stringsAsFactors = TRUE)
libdates$LIBVER<-paste(libdates$LIB,libdates$VER, sep="-")
libdates<- setNames(as.character(libdates$YY), as.character(libdates$LIBVER))



