
# This is the server logic for a Shiny web application.
#
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
# 

shinyServer(function(input, output) {

  ###############
  
  df_iso<-reactive({
    # Create a Progress object
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    
    progress$set(message = "Retrieving Data", value = 1/2)
    
    dfi<-filter(df, SYMA==input$SYMA, M==input$M)
    validate(need(dim(dfi)[1]>0,"No data for this selection"))
    
    progress$set(message = "Filtering Data", value = 1)
    dfi
  })
  
  df_iso_lib<-reactive({
    # Create a Progress object
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    
   # progress$set(message = "Retrieving Data", value = 1/2)
    
    dfu<-filter(df_iso(), LIBVER==input$LIBVER)
    validate(need(dim(dfu)[1]>0,"No data for this selection"))
     
    progress$set(message = "Filtering Data", value = 1)
    dfu
  })
  
  
  output$plot_map<-renderPlotly({ 
    
    #pdf<-filter(df, X==input$X, A==input$A, M==input$M, LIBVER==input$LIBVER)
    pdf<-df_iso_lib()
    title<-paste(input$SYMA," from ", input$LIBVER)
    
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
      scale_y_discrete(drop=FALSE)+ 
      scale_fill_manual(values=my_colors)+
      theme_light() + 
      theme(legend.title=element_blank(),  
            plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
            plot.margin = unit(c(0.7, 0, 2, 1), "cm")) #top, right, bottom, left
    
    if(input$ALLMT==1) g1<-g1+ scale_x_discrete(drop=FALSE)
    
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
  
  pdf<-df_iso()  
  
  lib1<-subset(filter(pdf, LIBVER==input$LIBVER1),select = c('MF', 'MFDES', 'MT', "MTDES", 'LIBVER', 'LIBVERORIG'))
  lib2<-subset(filter(pdf, LIBVER==input$LIBVER2),select = c('MF', 'MFDES', 'MT', "MTDES", 'LIBVER', 'LIBVERORIG'))
  comp<-merge(lib1, lib2, by = c('MF', 'MFDES', 'MT', "MTDES"))
  
  setnames(comp, old=c("LIBVERORIG.x","LIBVERORIG.y"), new=c("LIB1","LIB2"))
  setnames(comp, old=c("MFDES","MTDES"), new=c("MF TYPE","MT TYPE"))
  
  comp<-subset(comp,
               select = c('MF TYPE', 'MT TYPE', 'MF', 'MT', 'LIB1', 'LIB2'))
  
  d<-filter(comp, LIB1!=LIB2) # diff occurrences
  s<-filter(comp, LIB1==LIB2) # same occurrences
  
  setnames(d, old=c("LIB1","LIB2"), new=c(input$LIBVER1,input$LIBVER2))
  setnames(s, old=c("LIB1","LIB2"), new=c(input$LIBVER1,input$LIBVER2))
  
  if('All'%in%input$MF || is.na(input$MF)) 
  {
    if(input$CHOICE=='2') s
    else if(input$CHOICE=='1') d
  }
  else if (!is.na(input$MF))
  {
    if(input$CHOICE=='2') filter(s, MF%in%input$MF)
    else if(input$CHOICE=='1') filter(d, MF%in%input$MF)
  }
   
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

 