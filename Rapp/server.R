
# This is the server logic for a Shiny web application.
#
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
# 

shinyServer(function(input, output) {

  ###############
  dfu<-reactive({
    # Create a Progress object
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    
    progress$set(message = "Retrieving Data", value = 1/2)
    
    dfu<-filter(df, X==input$X, A==input$A, M==input$M, LIBVER==input$LIBVER)
    validate(need(dim(dfu)[1]>0,"No data for this selection"))
     
    progress$set(message = "Filtering Data", value = 1)
    dfu
  })
  
  
  output$plot_map<-renderPlotly({ 
    
    #pdf<-filter(df, X==input$X, A==input$A, M==input$M, LIBVER==input$LIBVER)
    pdf<-dfu()
    title<-paste(input$X,"-",input$A, "from ", input$LIBVER)
    
    axisfont <- list(
      family = "Helvetica",
      size = 14,
      color = "blue"
    )
    
    yaxis=list(
      titlefont= axisfont
      )
    xaxis=list( 
      titlefont= axisfont,
      title = "MT",
      zeroline = FALSE,
      showline = FALSE,
      showticklabels = TRUE,
      showgrid = TRUE,
      tickangle=80
    )
      
    g1<-ggplot(pdf, aes(MT, MF)) + geom_tile(aes(fill=LIBVERORIG)) +
      scale_x_discrete(drop=FALSE)+
      scale_y_discrete(drop=FALSE)+ 
      scale_fill_manual(values=my_colors)+
      theme_light() + 
      theme(legend.title=element_blank(),  
            plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
            plot.margin = unit(c(0.7, 0, 2, 1), "cm")) #top, right, bottom, left
    p<-ggplotly(g1)
    
    p%>%config(displayModeBar = 'pan',showLink=FALSE,senddata=FALSE,editable=FALSE,
                 displaylogo=FALSE, collaborate=FALSE, cloud=FALSE,
                 modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian',
                                          'hoverCompareCartesian'))%>%
      layout(title=title, autosize = F, width = 1200, height = 500, 
             yaxis=yaxis , xaxis=xaxis)
  })

  # Plot DNA evolution using ggplot 
  output$tempPlot <- renderPlotly({
    count_df = df[LIB==input$LIB & MAT==input$MAT , .(count=.N) , by="LIBVER,LIBVERORIG"]
    title<-paste("AAA")
    
    axisfont <- list(
      family = "Helvetica",
      size = 14,
      color = "blue"
    )
    
    yaxis=list(
      titlefont= axisfont
    )
    xaxis=list(
      titlefont= axisfont,
      title = "Library Release",
      zeroline = FALSE,
      showline = FALSE,
      showticklabels = TRUE,
      showgrid = TRUE
      # tickangle=80
    )
    
    # If you want the heights of the bars to represent values in the data, use stat="identity" and map a variable to the y aesthetic.
    g <- ggplot(count_df, aes(x=LIBVER, y=count)) +
      geom_bar(aes(fill=LIBVERORIG),
               stat = "identity") +
      scale_fill_manual(values=my_colors) +
      theme_light() + 
      theme(legend.title=element_blank(),  
            plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
            plot.margin = unit(c(0.7, 0, 2, 1), "cm")) #top, right, bottom, left
    p <- ggplotly(g)
    p%>%config(displayModeBar = 'pan',
               showLink=FALSE,
               senddata=FALSE,
               editable=FALSE,
               displaylogo=FALSE,
               collaborate=FALSE,
               cloud=FALSE,
               modeBarButtonsToRemove=c('select2d',
                                        'lasso2d',
                                        'hoverClosestCartesian',
                                        'hoverCompareCartesian'))%>%
      layout(title=title,
             autosize = F,
             width = 1200,
             height = 500,
             yaxis=yaxis,
             xaxis=xaxis)
  })  


#### Compute differences in MFMT chuncks for two given library versions

output$diffs <- renderDataTable({
  #pdf<-dfu() 
  pdf<-filter(df, A==235)
  lib1<-subset(filter(pdf, LIBVER==input$LIBVER1),select = c('MF', 'MT','LIBVER', 'LIBVERORIG'))
  lib2<-subset(filter(pdf, LIBVER==input$LIBVER2),select = c('MF', 'MT','LIBVER', 'LIBVERORIG'))
  comp<-merge(lib1, lib2, by = c("MF", "MT"))
  
  d<-filter(comp, LIBVERORIG.x!=LIBVERORIG.y) #same occurrences
  s<-filter(comp, LIBVERORIG.x==LIBVERORIG.y) #different occurrences
    
  if(input$CHOICE=='2') s<-s
  if(input$CHOICE=='1') s<-d
    
  s
  # g1<-ggplot() + geom_tile(data=s, aes(MT, MF))+
  #   #scale_x_discrete(drop=FALSE)+
  #   #scale_y_discrete(drop=FALSE)+  
  #   theme_light() + 
  #   theme(legend.title=element_blank(),  
  #         plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
  #         plot.margin = unit(c(0.7, 0, 2, 1), "cm")) #top, right, bottom, left
  # ggplotly(g1)
  
})

 
})
 

#  Command for saving local html :
#  htmlwidgets::saveWidget(as_widget(p), "test.html")

 