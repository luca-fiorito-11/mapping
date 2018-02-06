
# This is the server logic for a Shiny web application.
#
# MAPPING app 
# Authors : F. Michel-Sendis & L. Fiorito 
# 

shinyServer(function(input, output) {

  output$plot_map<-renderPlotly({ 
    
    pdf<-filter(df, X==input$X, A==input$A, M==input$M, LIBVER==input$LIBVER)
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
     
    
    #pdf1<-filter(pdf, as.integer(MT)<=70)
    #pdf2<-filter(pdf, as.integer(MT)>70)
     
    
    # g1<-ggplot(pdf, aes(x=MT, y=MF)) + 
    #   geom_point(shape=15, size=3, aes(fill = LIBVERORIG)) + 
    #  # coord_flip() + 
    #   scale_fill_discrete(name="Origin", drop=FALSE)+ 
    #   scale_x_discrete(drop=FALSE)+
    #   scale_y_discrete(drop=FALSE)+ 
    #   theme_light() + 
    #   theme(legend.title=element_blank(),  
    #         plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
    #         plot.margin = unit(c(0.7, 0, 2, 1), "cm")) #top, right, bottom, left
    
    g1<-ggplot(pdf, aes(MT, MF)) + geom_tile(aes(fill=LIBVERORIG)) +
      scale_x_discrete(drop=FALSE)+
      scale_y_discrete(drop=FALSE)+ 
      scale_fill_manual(values=my_colors)+
      theme_light() + 
      theme(legend.title=element_blank(),  
            plot.background=element_rect(fill="white"), #can be 'darkseagreen' too...
            plot.margin = unit(c(0.7, 0, 2, 1), "cm")) #top, right, bottom, left
    p<-ggplotly(g1)
    
    # p<-subplot(p1, p2, nrows = 2, shareX = FALSE)
    
    p%>%config(displayModeBar = 'pan',showLink=FALSE,senddata=FALSE,editable=FALSE,
                 displaylogo=FALSE, collaborate=FALSE, cloud=FALSE,
                 modeBarButtonsToRemove=c('select2d', 'lasso2d','hoverClosestCartesian',
                                          'hoverCompareCartesian'))%>%
      layout(title=title, autosize = F, width = 1200, height = 500, 
             yaxis=yaxis , xaxis=xaxis)
  })
 })







# dcount<-count(df, LIBVER, Z,X,A,M)
# dcount$TOT_CHUNKS<-dcount$n
# dcount$n<-NULL
# df<-merge(df, dcount)
# 
# dcount<-count(df, Z, X, A, M, LIBVER, LIBVERORIG, TOT_CHUNKS)
# dcount$N_CHUNKS<-dcount$n
# dcount$n<-NULL
# dcount$ORIG_PCT<-round(dcount$N_CHUNKS/dcount$TOT_CHUNKS*100,1) # keep 1 decimal place
# 
# 
# dcount2<-count(df, Z, X, A, M,LIBVER, MF)
# dcount2$TOT_MT_IN_MF<-dcount2$n
# dcount2$n<-NULL
# 
# dcount3<-count(df, Z, X, A, M,LIBVER, LIBVERORIG, MF)
# dcount3$N_MTLIBVER_IN_MF<-dcount3$n
# dcount3$n<-NULL
# 
# dcount2<-merge(dcount2, dcount3)
# dcount3<-NULL
# dcount2$PCT_MT_IN_MF<-round(dcount2$N_MTLIBVER_IN_MF/dcount2$TOT_MT_IN_MF,1)*100
