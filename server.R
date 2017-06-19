#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(datasets)
library(dplyr)
library(plotly)
library(RColorBrewer)

#Load data
load("lmop.Rda")
load("Waste.By.Year.Rda")
load("Expenditure.Rda")
load("weightbygrp.Rda")
load("weightbycate.Rda")
load("heatmapdat.Rda")

#Define color scheme
col_p1<-brewer.pal(8,"Dark2")[1:4]
col_p2<-brewer.pal(9, "BuPu")
col_set3<-brewer.pal(12, "Set3")
col_BuPu<-brewer.pal(9, "BuPu")

#Define font
f1 <- list(
    family = "verdana",
    size = 14,
    color = "black"
)


# Define server logic required to draw a plot
shinyServer(function(input, output) {
    #########################TAB 2################################
    #Plot1
  output$plot1 <- renderPlotly({
      #Screen dataset by filters
      df<-filter(lmop, Landfill.Open.Year<=input$openyr) #OpenYear
      df<-filter(df, Ownership.Type %in% input$ownert) #Ownership Type
      df<-filter(df, Current.Landfill.Status %in% input$status) #Landfill Status
      
      #Set the options of the map
      g1<-list(
          scope="usa", 
          projection=list(type="albers usa"), 
          showland=TRUE,
          landcolor=toRGB("grey85"), 
          subunitwidth=1,
          countrywidth=1,
          subunitcolor=toRGB("white"), 
          countrycolor=toRGB("white")
      )   
      #Draw the map
      p1<-plot_geo(df, locationmode="USA-states", sizes=c(1, 300)) %>%
          add_text(
              x = state.center[["x"]], y = state.center[["y"]], 
              size = I(12), color = I("white"), hoverinfo = "none", 
              text=state.abb, name="Hide States"
          ) %>%
          add_markers(
              x=~Longitude,
              y=~Latitude, 
              #size=~Waste.In.Place.Tons, 
              color=~Waste.Q2,
              text=~paste(df$City, ",", df$County, " ", df$State,"<br />", 
                          round(df$Waste.In.Place.Tons, -2), "Short Tons", "<br />", 
                          "Landfill Name: ", df$Landfill.Name)
          ) %>% layout(geo=g1, 
                       font=list(color=I("navy")),
                       legend=list(orientation="v"))
      #Render the plot
      p1
    
  })
  #Plot2a
  output$plot2a<- renderPlotly({
      #First plot the Waste In Place By Year
      p2a<-plot_ly(data=Waste.By.Year, x=~Year) %>%
          add_trace(y=~Waste.In.Place.Tons, 
                    name="Waste (Tons)", 
                    type="scatter", mode="lines", 
                    line = list(color=col_p2[6])) %>%
          layout(xaxis=list(title="Landfill Open Year"), 
                 yaxis=list(title="Waste (Tons)"))
      p2a
  })
  #Plot2b
  output$plot2b<- renderPlotly({
      #Secondly plot the acumulative Waste In Place
      p2b<-plot_ly(data=Waste.By.Year, x=~Year) %>%
          add_trace(y=~Cumulated.Waste.In.Place.Tons, 
                    name="Cumulated Waste (Tons)",
                    type="scatter", mode="lines+markers",
                    line = list(color=col_p2[9])) %>%
          add_trace(y=~Waste.In.Place.Tons, 
                    name="Waste (Tons)", 
                    type="scatter", mode="lines",
                    line = list(color=col_p2[6])) %>%
          layout(xaxis=list(title="Landfill Open Year"), 
                 yaxis=list(title="Waste (Tons)"))
      p2b
  })
  #Plot2c
  output$plot2c<- renderPlotly({
      #Thirdly plot the accumulated waste against the personal expenditure
      p2c<-plot_ly() %>%
          add_trace(x=~expd$Year,
                    y=~expd$Exp_k, 
                    name="Personal Expenditure in Thousands of $", 
                    type="scatter", mode="lines",
                    line=list(color=col_p2[8])) %>%
          add_trace(x=~Waste.By.Year$Year, 
                    y=~Waste.By.Year$Cumulated.Waste.In.Place.Tons, 
                    name="Cumulated Waste (Tons)",
                    type="scatter", mode="lines+markers",
                    line = list(color=col_p2[9])) %>%
          layout(xaxis=list(title="Landfill Open Year"), 
                 yaxis=list(title="Waste (Tons)")) 
      p2c
  })
  
  ###########################TAB 3##################################
  #Waste by Cateogry
  output$barplot <- renderPlotly({
      text<-c("28.07%", "43.01%", "28.92%", 
              "26.35%", "38.05%", "35.60%", 
              "32.70%", "40.60%", "26.70%")
      x<-c(2012.75, 2013, 2013.25, 2013.75, 2014, 2014.25, 2014.75, 2015, 2015.25)
      y<-c(480000, 750000, 500000, 580000, 850000, 790000, 600000,750000, 480000)
      plot_ly(data=weight2b, x=~Year, y=~Landfill, name="Landfill", type="bar", marker=list(color=col_set3[9])) %>%
          add_trace(y=~Recycled, name="Recycled", marker=list(color=col_set3[3])) %>%
          add_trace(y=~Resued, name="Resued",marker=list(color=col_set3[5])) %>%
          layout(xaxis=list(title="Year", autotick=F, titlefont=f1), 
                 yaxis=list(title="Weight (lbs)")) %>%
          add_annotations(text = text,
                          x = x,
                          y = y,
                          xref = "x",
                          yref = "y",
                          font = list(family = 'Arial',
                                      size = 10,
                                      color = I("Black")),
                          showarrow = FALSE)
  })
  
  #When do people discard material
  output$heatmap <- renderPlotly({
      plot_ly(x=c(1,2,3,4), 
              y=c(2013, 2014, 2015),
              z=weight3c, type="heatmap", colors=col_BuPu) %>%
          layout(xaxis=list(title="Quarter", autotick=F, titlefont=f1), 
                 yaxis=list(title="Year", autotick=F))
  })
  
  
  #Waste by Material   
  output$pieplot <- renderPlotly({
      
      piedat<-filter(weightbygrp, Year %in% input$yr & 
                         Sub.Category %in% input$cate)
      
      p<-plot_ly(data=piedat, labels=~Group, values=~Total.Weight,
                 type="pie", hole=0.6, textposition = 'inside',
                 textinfo = 'label+percent', 
                 marker=list(colors=col_set3))%>%
          layout(title="Discarded Material by Type (Lbs)",
                 xaxis=list(showgrid=F, zeroline=F, showticklabels=F), 
                 yaxis=list(showgrid=F, zeroline=F, showticklabels=F))
      
      p
  })
})
