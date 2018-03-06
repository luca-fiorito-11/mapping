# need to have assigned variables:
#  - df
#  - params$RELEASE
#  - selected_MF

library(plotly)

df_cov <- df %>%
  subset(LIBVER==params$RELEASE & MF==selected_MF)

breakdown_cov <- df_cov %>% 
  plyr::count('LIBVERORIG') %>% 
  transform(percent = scales::percent(freq / sum(freq)))

breakdown_cov <- breakdown_cov[rev(order(breakdown_cov$LIBVERORIG)),]

Chart <- plot_ly(breakdown_cov) %>%
  add_trace(x = ~LIBVERORIG, y = ~freq, type = 'bar',
            marker = list(color = my_colors))#%>%
            # textposition = 'inside',
            # textinfo = 'label+percent',
            # insidetextfont = list(color = '#FFFFFF'),
            # hoverinfo = 'text',
            # text = ~paste('$', LIBVERORIG, ' billions'),
            # marker = list(colors = my_colors,
            #               line = list(color = '#FFFFFF', width = 1)),
            # The 'pull' attribute can also be used to create space between the sectors
           # showlegend = F) %>%
  # layout(xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
  #        yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

# Must call Chart to show it in Dashboard
Chart