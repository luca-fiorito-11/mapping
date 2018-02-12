
# This is the user-interface definition of a Shiny web application.
#  
# MAPPING app  
# Authors : F. Michel-Sendis & L. Fiorito 
#
 

#dtitle<-tagList(tags$img(src='dna-strand.png', height='40'))
dtitle<-c("ND DNA Mapping")

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
      column(2,selectInput('LIBVER',tag('h4', 'Library'),choices = unique(df$LIBVER),multiple=FALSE, 
                           selected ="JEFF-3.3")),
      column(2,selectInput('SYMA',tag('h4', 'Element'),choices = unique(df$SYMA), selected="U - 238", multiple=FALSE)),
      #column(3,selectInput('A',tag('h4', 'Mass Number'),choices = unique(df$A),multiple=FALSE, selected="238")),
      column(2,selectInput('M',tag('h4', 'Isomer'),choices = unique(df$M),multiple=FALSE, selected="g")),
      
      column(2,radioButtons('ALLMT',tag('h5', "Display all MT categories"),
                            list("Yes" = 1, "No" = 2), 
                            selected = 2, inline = TRUE))
      
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
          column(2,selectInput('MF',tag('h4', 'Select MF'),choices = c('All', unique(df$MF)), selected='All',
                               multiple=TRUE)),
         
          column(2,selectInput('LIBVER1',tag('h4', 'Library 1'),choices = unique(df$LIBVER),multiple=FALSE, 
                               selected ="JEFF-3.3")),
          column(2,selectInput('LIBVER2',tag('h4', 'Library 2'),choices = unique(df$LIBVER),multiple=FALSE, 
                               selected ="JEFF-3.2")),
          column(3, 
                 radioButtons('CHOICE', label = h4("Display :"),
                              choices = list("Different MF/MT" = 1, "Identical MF/MT" = 2), 
                              selected = 1,inline = TRUE))),
        fluidRow(
          column(12,
                 #plotlyOutput("diffs", height = '600px')
                 dataTableOutput('diffs')
                 )
        )
    ),#end box
    
   # Box for the DNA evolution of an evaluated file
   box(title = tag('b', "Evolution"), status="warning", collapsible = TRUE,# collapsed=TRUE,
       width = 12,
       fluidRow(
         column(3,selectInput('LIB',
                              tag('h4', 'Library'),
                              choices = unique(df$LIB),
                              multiple=FALSE,
                              selected ="JEFF")),
         column(3,selectInput('MAT',
                              tag('h4', 'MAT'),
                              choices = unique(df$MAT),
                              multiple=FALSE))
       ),
       fluidRow(
         column(12,
                plotlyOutput("tempPlot", height = '500px')
         )
       )
   )#end box
   )# end fluidPage
  )# end dashboardbody




  dashboardPage(
    skin="black",
    header,
    #dashboardHeader(disable = FALSE),
    sidebar,
    body)


