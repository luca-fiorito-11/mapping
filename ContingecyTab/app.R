#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Old Faithful Geyser Data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
         sliderInput("bins",
                     "Number of bins:",
                     min = 1,
                     max = 50,
                     value = 30)
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
        DT::dataTableOutput('table')
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  TT <- as.matrix(ftable(df[,c("LIBVER","LIBVERORIG")]))
  output$table <- DT::renderDataTable(
    datatable(TT) %>% formatStyle("JEFF-3.1.1", backgroundColor=styleEqual(1, "red"))
    )
}

# Run the application 
shinyApp(ui = ui, server = server)

