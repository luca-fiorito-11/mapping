library(DT)
library(dtplyr)
library(dplyr)
library(data.table)
df <-fread('JEFF33_vs_JEFF32.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE) %>% # RELATIVE PATH
  subset(MT!=451) %>%  # REMOVE MF1MT451
  dplyr::group_by(MAT) %>% 
  dplyr::summarize(OLD=all(VERORIG==3.2)) %>%
  subset(OLD==TRUE) %>% # SET TO FALSE TO HAVE MATS THAT HAVE NOT CHANGED
  merge(fread('../csv/matzsymam.csv', header = TRUE, sep = ",", stringsAsFactors = TRUE)) # MERGE TO HAVE MASS, CHARGE, ETC