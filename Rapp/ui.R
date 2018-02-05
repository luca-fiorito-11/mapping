
# This is the user-interface definition of a Shiny web application.
#  
# MAPPING app  
# Authors : F. Michel-Sendis & L. Fiorito 
#

library(shiny)

dtitle<-tagList(tags$img(src='dna-strand.png', height='40'))

header <- dashboardHeader(title=dtitle)

sidebar <- dashboardSidebar(disable = TRUE, width = 250)

body <- dashboardBody(
  useShinyjs(),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  fluidPage(
     
    box(title = tag('b', "Map"), status="warning", collapsible = TRUE,# collapsed=TRUE, 
        width = 12,
    #tabBox(title=tagList(shiny::icon("bug")), #height = '1000px',
           #tabPanel(tag('h4',"Overview"),    
    fluidRow(
      column(3,selectInput('LIBVER',tag('h4', 'Library'),choices = unique(df$LIBVER),multiple=FALSE, 
                           selected ="JEFF-3.3")),
      column(3,selectInput('X',tag('h4', 'Element'),choices = unique(df$X),multiple=FALSE)),
      column(3,selectInput('A',tag('h4', 'Mass Number'),choices = unique(df$A),multiple=FALSE, selected="238")),
      column(3,selectInput('M',tag('h4', 'Isomer'),choices = unique(df$M),multiple=FALSE, selected="g"))
    ),
    fluidRow(
      column(12,
             plotlyOutput("plot_map", height = '500px')
             )
      ) 
    ),#end box
     
   box(title = tag('b', "Compare"), status="warning", collapsible = TRUE,# collapsed=TRUE,
       width = 12,
       fluidRow(
         column(12,
                plotlyOutput("plot_compare", height = '1000px')
         )
       )
   )

    )# end fluidPage
  )# end dashboardbody

  dashboardPage(
    skin="black",
    header,
    #dashboardHeader(disable = FALSE),
    sidebar,
    body)


