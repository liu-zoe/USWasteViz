#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)
library(datasets)
library(plotly)
library(dplyr)
library(RColorBrewer)

# Define UI for application that draws the map
shinyUI(fluidPage(
    #Select theme
    theme = shinytheme("readable"),
     
  # Application title
  titlePanel("US Landfill Waste"),
  navbarPage("",
    ######################Visualization Tab###################         
      tabPanel("Data Story",
          sidebarLayout(
            mainPanel(
               h3("Where are the landfills in United States?"),
               p("We see a lot of landfills on the East and West coast,
                 which are densely populated. In addition, there are large 
                 clusters of landfills in the Northeast and Southeast. 
                 Click the play button on the right to see how many 
                 landfills opened across time."),
               plotlyOutput("plot1"),
               br(),
               
               h3("What era generated the most landfills?"), 
               p("Landfills are organized by open year and the total 
                waste in place of the landfills in each year is calculated.
                 We see peaks in late 50s and early 70s."),
               plotlyOutput("plot2a"), 
               br(),
               p("The number of newly-opened landfills dropped in late 90s and early odds. 
                 However, don't be fooled to think that the amount of garbage
                 we generated decreased. Check out the plot below for the cumulative 
                    waste we generated in the past 100 years."),
               h3("How much waste sit in the landfills?"),
               plotlyOutput("plot2b"),
               br(),
               p("The growth of waste is almost exponential after the 60s!"),
               h4("Let's pause for a minute and think about where did all the trash come from?"),
               p("There can be many answers to that question: end of WWII, 
                 increase of income, baby booming, rise of advertisement and 
                 consumer culture, introduction of TVs... 
                 All of them telling part of the story. 
                 Here's another way to look at the question: we are SPENDING more. 
                 In the graph below, personal expenditure data (scaled in thousands
                 of dollars) are projected onto the cumulative waste graph."), 
               plotlyOutput("plot2c"),
               br(),
               p("Many of those shiny toys, kitchen gadgets, or latest fashion that
                 people bought eventually ended up in one of those landfills."), 
               h4("So think twice before you purchase that 50'' flat screen tv or 
                 the latest iPhone."),
               h3("Will today's purchase sit in one of the 
                 landfills someday?")

               
            ),
            sidebarPanel(
                sliderInput("openyr",
                            "Year",
                            min = 1920,
                            max = 2017,
                            value = 2017, 
                            step=5, 
                            animate=TRUE,
                            round=,-2), 
                checkboxGroupInput("ownert", 
                                   "Ownership Type:", 
                                   choices=list("Public", "Private"), 
                                   selected=list("Public", "Private"), 
                                   inline=T,
                                   width="50%"
                                   
                ),
                checkboxGroupInput("status", 
                                   "Landfill Status:", 
                                   choices=list("Closed", "Open"), 
                                   selected=list("Closed", "Open"), 
                                   inline=T,
                                   width="50%"
                                   
                )#checkboxGroupInput
            )#sidebarpanel
          )#SidebarLayout
      ),#tabpanel
      
      ##############Info Tab################
      tabPanel("Info", 
        fluidPage(
            fluidRow(
                h3("Author"),
                p("Zoe Liu"), 
                p("Email: zoelzh@gmail.com")
            ),
            fluidRow(
                h3("Data"),
                p("Landfill data is retrieved from the Landfill Methane Outreach Program(LMOP) page on the EPA webiste in May 2017."),
                a("LMOP Page",target="_blank", href="https://www.epa.gov/lmop/landfill-gas-energy-project-data-and-landfill-technical-data"),
                br(),
                a("Landfill Data", target="_blank", href="https://www.epa.gov/sites/production/files/2017-02/lmopdata.xlsx"), 
                br(),
                br(),
                p("Personal expenditure data is retrieved from FRED Economic Data at:"), 
                a("Real personal consumption expenditures", target="_blank", 
                  href="https://fred.stlouisfed.org/series/DPCERX1A020NBEA")
                        )
                    )
               )
    )#Navbar
  )#Fluidpage
)#ShinyUI
