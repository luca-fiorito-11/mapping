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
library(rsconnect)
library(reshape2)
library(data.table)
library(DT)
library(dtplyr)
library(dplyr)
library(splitstackshape)
library(rmarkdown)
library(flexdashboard)

# set environment variable to pass proxy
#Sys.setenv(HTTPS_PROXY="http://proxy-vip1.oecd-nea.org:3128")

gpath<-"https://raw.githubusercontent.com/luca-fiorito-11/mapping/r-app/csv/"

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