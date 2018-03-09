# These are the global includes for all Rmd applications
# First import of data
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

list.of.packages <- c("plotly", "shinythemes", "shinyjs",
                      "data.table", "DT", "dplyr", "flexdashboard")

new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)



#set environment variable to pass proxy
#Sys.setenv(HTTPS_PROXY="http://proxy-vip1.oecd-nea.org:3128")

#customize rendering of plotly plots: 
returnMyplotly <- function(p, xtitle="X title", ytitle="Y title"){
  axisfont <- list(
    family = "Helvetica",
    size = 14,
    color = "DarkGray"
  )
  yaxis=list(
    titlefont= axisfont,
    title = ytitle 
    )
  xaxis=list( 
    titlefont= axisfont,
    title = xtitle,
    zeroline = FALSE,
    showline = FALSE,
    showticklabels = TRUE,
    showgrid = TRUE
  )

  p<-p%>%config(displayModeBar = 'pan',showLink=FALSE,senddata=FALSE,editable=FALSE,
           displaylogo=FALSE, collaborate=FALSE, cloud=FALSE,
           modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian',
                                    'hoverCompareCartesian'))%>%
    layout(autosize = F,yaxis=yaxis,xaxis=xaxis,showlegend = TRUE)
  return(p)
}

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

# dataframe containing 562 (JEFF.33 correspondences between MAT and Z,A,M)
mats <- fread(paste0(gpath,'matzsymam.csv'))#,
              # header = TRUE,
              # sep = ",",
              # stringsAsFactors = FALSE)

# dataframe containing descriptions for each MF
mts<-fread(paste0(gpath,'MTs.csv'))  

# dataframe containing descriptions for each MT
mfs<-fread(paste0(gpath,'MF.csv'))  

# dataframe coming from the mapping run
df <- fread(paste0(gpath,'CHUNKS-JEFF.csv')) 
df$LIBVERORIG <- paste(df$LIBORIG,"-",df$VERORIG, sep='')
df$LIBVER <- paste(df$LIB,"-",df$VER, sep='')

# Merge dataframes
df <- df %>% merge(mats, by = "MAT", all.x = TRUE)  

df <- df %>% merge(mfs, by = "MF", allow.cartesian = T)

df <- df %>% merge(mts, by = "MT", all.x = TRUE, allow.cartesian = T) 
  

decay <- fread(paste0(gpath,'decay_data_jeff33.csv'))
decay$HalfLife<-lapply(decay$HL, function(x)returnHumanReadableHalfLife(x)) 
decay$HL<-lapply(decay$HL, function(x){formatC(x, format="e", digits=1)}) 

# Add unique ID MFMT as new column
df$MFMT <- paste(df$MF*1000+df$MT)

df$SYMA <- paste(df$X,"-",df$A, sep='')
df$SYMAM <- paste(df$X,"-",df$A,"-",df$M, sep='')
df <- df[order(df$X),]

df$MF <- factor(df$MF)
df$MT <- factor(df$MT)

# dataframe containing colors associated to each lib version
colors <- fread(paste0(gpath,'my_colors.csv'))
#needs to be a named vector :
my_colors<- setNames(as.character(colors$LIBVERCOLOR), as.character(colors$LIBVER))

# dates for libraries release, can be used to establish precedence 
libdates <- fread(paste0(gpath,'libdate.csv'), header = TRUE, sep = ",", stringsAsFactors = TRUE)
libdates$LIBVER<-paste(libdates$LIB,libdates$VER, sep="-")
libdates<- setNames(as.character(libdates$YY), as.character(libdates$LIBVER))



