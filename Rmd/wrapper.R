# This wrapper script runs the markdown file lib_content.Rmd
# The markdonw run is paramaterized based on the unique LIBVER values found
# in the df dataframe in global.R
# Authors : F. Michel-Sendis & L. Fiorito 
#
source('global_vars.R')
# Define report tibble with output filenames and parameters

mylib<-"JEFF-3.3"

#df2<-filter(df, LIBVER==mylib)

df2<-df%>%subset(LIBVER==mylib & X=="Pu")


df2$SYMAMLIBVER<-paste(df2$SYMAM,"-",df2$LIB,"-",df2$VER, sep="")

reports <- tibble(
  SYMAMLIBVER = unique(df2$SYMAMLIBVER),
  SYMAMS = unique(df2$SYMAM),
  myparams = purrr::map(SYMAMLIBVER, ~ list(SYMAMLIBVER= .)),
  dirname = mylib,
  filename = paste(SYMAMS,".html", sep="")
)

# Parametrized rendering of the lib_content.Rmd markdown script using reports parameters as inputs
reports %>%
  select(output_dir = dirname, output_file = filename, params= myparams) %>%
  purrr::pwalk(rmarkdown::render, input = "Map.Rmd")
