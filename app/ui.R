
# This is the user-interface definition of a Shiny web application.
#  
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("ND Mapping"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      selectInput('MAT',tag('h4', 'Material'),
                  choices = unique(df$MAT), 
                  multiple=FALSE, selected="9234"),
      
      selectInput('LIB',tag('h4', 'Library'),
                  choices = unique(df$LIB), 
                  multiple=FALSE, selected="JEFF"),
      
      selectInput('VER',tag('h4', 'Version'),
                  choices = unique(df$VER), 
                  multiple=FALSE, selected="3.3"),
      
      selectInput('MF',tag('h4', 'MF'),
                  choices = unique(df$MF), 
                  multiple=FALSE,
                  selected="3"
                  )
      #selectInput('MT',tag('h4', 'MT'),
       #           choices = unique(df$MT), 
        #          multiple=FALSE)
    
       
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("plot_map")
    )
  )
))
