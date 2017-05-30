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

col_p1<-brewer.pal(8,"Dark2")[1:4]
col_p2<-brewer.pal(9, "BuPu")

# Define server logic required to draw a plot
shinyServer(function(input, output) {
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
})
