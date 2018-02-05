
# This is the user-interface definition of a Shiny web application.
#  
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
#

library(shiny)

dtitle<-tags$img(src='dna-strand.png', height='50')

header <- dashboardHeader(title=dtitle)

sidebar <- dashboardSidebar(disable = TRUE, width = 250)

body <- dashboardBody(
  useShinyjs(),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
  fluidPage(
    fluidRow(
      column(8,
             fluidRow(plotlyOutput("plot_map"))
             ),
      column(4,
      box(title = tag('b', "Filter"), status="warning", collapsible = TRUE,# collapsed=TRUE, width = 12,
      
      selectInput('LIBVER',tag('h4', 'Library'),
                  choices = unique(df$LIBVER), 
                  multiple=FALSE, selected ="JEFF-3.3"),
      
      selectInput('X',tag('h4', 'Element'),
                  choices = unique(df$X), 
                  multiple=FALSE),
      
      selectInput('A',tag('h4', 'Mass Number'),
                  choices = unique(df$A), 
                  multiple=FALSE),
      
      selectInput('M',tag('h4', 'Isomer'),
                  choices = unique(df$M), 
                  multiple=FALSE, selected="g")
            ) #end box
      )
      )# end fluidRow
    )# end fluidPage
  )# end dashboardbody

  dashboardPage(
    skin="black",
    header,
    #dashboardHeader(disable = FALSE),
    sidebar,
    body)



# 
# #########
# shinyUI(fluidPage(
# 
#   # Application title
#   titlePanel("ND Mapping"),
# 
#   # Sidebar with a slider input for number of bins
#   sidebarLayout(
#     sidebarPanel(
#       
#       selectInput('LIBVER',tag('h4', 'Library'),
#                   choices = unique(df$LIBVER), 
#                   multiple=FALSE, selected ="JEFF-3.3"),
#       
#       selectInput('X',tag('h4', 'Element'),
#                   choices = unique(df$X), 
#                   multiple=FALSE),
#       
#       selectInput('A',tag('h4', 'Mass Number'),
#                   choices = unique(df$A), 
#                   multiple=FALSE),
#       selectInput('M',tag('h4', 'Isomer'),
#                   choices = unique(df$M), 
#                   multiple=FALSE, selected="g")
#       
#       
#        
#       # selectInput('MF',tag('h4', 'MF'),
#       #             choices = unique(df$MF), 
#       #             multiple=FALSE,
#       #             selected="3"
#       #             )
#       # #selectInput('MT',tag('h4', 'MT'),
#       #  #           choices = unique(df$MT), 
#       #   #          multiple=FALSE)
#     
#        
#     ),
# 
#     # Show a plot of the generated distribution
#     mainPanel(
#       plotlyOutput("plot_map")
#     )
#   )
# ))
