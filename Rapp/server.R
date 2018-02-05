
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
    
    yaxis = list(
      title = 'MT',
      #type='category',
      range = c(0,50)
    )
    
    g<-ggplot(pdf, aes(x=MF, y=MT)) + 
      geom_point(shape=15, size=5, aes(fill = LIBVERORIG)) + 
      #coord_flip() + 
      scale_fill_discrete(name="Origin", drop=FALSE)+
      #scale_fill_manual(name="Origin", values=my_colors, drop=FALSE)+
      #scale_fill_discrete(drop=FALSE) + 
      scale_x_discrete(drop=FALSE)+
      scale_y_discrete(drop=FALSE)+ 
      theme_light() + 
      theme(legend.title=element_blank(),  
            plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
            plot.margin = unit(c(0, 1, 0.5, 0.5), "cm"))
     
    p<-ggplotly(g)
    p%>%config(displayModeBar = 'hover',showLink=FALSE,senddata=FALSE,editable=FALSE,
                 displaylogo=FALSE, collaborate=FALSE, cloud=FALSE,
                 modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian',
                                          'hoverCompareCartesian'))%>%
      layout(autosize = F, width = 550, height = 1200, yaxis=yaxis)
  })
 })
