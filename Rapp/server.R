
# This is the server logic for a Shiny web application.
#
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
# 

shinyServer(function(input, output) {

  output$plot_map<-renderPlotly({ 
    
    pdf<-filter(df, X==input$X, A==input$A, M==input$M, LIBVER==input$LIBVER)
    #pdf<-filter(pdf, MF==input$MF)
    #title<-paste("Distribution for ",input$LIBVER," evaluation of ",input$X,"-",input$A)
    
    scale_color_manual(breaks = c("8", "6", "4"),
                       values=c("red", "blue", "green"))
    
    
    g<-ggplot(pdf, aes(x=MF, y=MT)) + 
      geom_point(aes(size=5.5, fill = LIBVERORIG, shape=LIBORIG)) + 
      coord_flip() + 
      scale_fill_manual(values=my_colors, drop=FALSE)+
      theme_light() + 
      theme(legend.title=element_blank(), 
            plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
            plot.margin = unit(c(0, 1, 0.5, 0.5), "cm"))
    
    p<-ggplotly(g)  
      
    p%>%config(displayModeBar = 'hover',showLink=FALSE,senddata=FALSE,editable=FALSE, 
                 displaylogo=FALSE, collaborate=FALSE, cloud=FALSE, 
                 modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian',
                                          'hoverCompareCartesian'))
     
    
     
  })
 })
