
# This is the server logic for a Shiny web application.
#
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
# 

shinyServer(function(input, output) {

  output$plot_map<-renderPlotly({ 
    
    y_layout<-list(
      title='MT', 
      showticklabels = TRUE,
      ticks = "outside",
      titlefont= list( family='Helvetica',
                       size='14',
                       color='gray')
    )
    
    x_layout<-list(
      title='Source', 
      showticklabels = TRUE,
      titlefont= list( family='Helvetica',
                       size='14',
                       color='gray')
    )
    m <- list(
      l = 100,
      r = 0,
      b = 20,
      t = 50,
      pad = 0
    )
    
    
    df<-filter(df, X==input$X && A==input$A)
    #df<-filter(df, MF==input$MF)
    
    p<-plot_ly(df, x=~VER, y=~MT, color=~VERORIG, 
               type='scatter', mode='markers')%>%
      layout(margin=m, xaxis=x_layout, yaxis=y_layout, showlegend=TRUE)
    
    p<-p%>%config(displayModeBar = 'hover',showLink=FALSE,senddata=FALSE,editable=FALSE, 
                  displaylogo=FALSE, collaborate=FALSE, cloud=FALSE, 
                  modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian',
                                           'hoverCompareCartesian'))
    p
  })
 })
