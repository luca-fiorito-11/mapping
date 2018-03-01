# This wrapper script runs the markdown file lib_content.Rmd
# The markdonw run is paramaterized based on the unique LIBVER values found
# in the df dataframe in global.R
# Authors : F. Michel-Sendis & L. Fiorito 
#
 

mylib<-"JEFF-3.3" 

df2<-df%>%subset(LIBVER==mylib & X=="P")
df2$SYMAMLIBVER<-paste(df2$SYMAM,"-",df2$LIB,"-",df2$VER, sep="")

# Define report tibble with output filenames and parameters
reports <- tibble(
  SYMAMLIBVER = unique(df2$SYMAMLIBVER),
  SYMAMS = unique(df2$SYMAM),
  params = purrr::map(SYMAMLIBVER, ~ list(SYMAMLIBVER= .)),
  dirname = mylib,
  filename = paste(SYMAMS,".html", sep="")
)
# Parametrized rendering of the lib_content.Rmd markdown script using reports parameters as inputs
reports %>%
  select(output_dir = dirname, output_file = filename, params) %>%
  purrr::pwalk(rmarkdown::render, input = "Map.Rmd")
