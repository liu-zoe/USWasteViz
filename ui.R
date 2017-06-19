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
    theme = shinytheme("journal"),
     
  # Application title
  titlePanel("Data Essay: The Throw-Away Culture"),
  navbarPage("Start here -->",
    #########################Tab 1: Intro ##################         
    tabPanel("Intro", 
             fluidRow(
                 column(6, 
                        h1("Motivation"), 
                        p("I stumbeled upon a", 
                          a("zero-waste", target="_blank", href="http://www.zerowastehome.com/") ,
                            "webiste in early 2017 and started
                          to get really interested in the zero waste movement 
                          (and slowly become a tree-hugging hipster orz). Before that, for a very long time, I 
                          lived like every other consumer and thought it was normal to use disposable
                          products. When things are broken or old, I just throw them", strong("AWAY"), ". I have
                          never thought about where that",strong("AWAY"),"really is?"),
                        p("It's sorta like a fairy-tale that
                          we tell ourselves: once we put them into the trash can, they will magically disappear. 
                          Yes, they did disappear from my life, but not from this planet... because", 
                          a("there is no away.", target="_blank", href="http://thereisnoaway.net/"),
                          "Since then, I've had the following questions
                          in my mind:"), 
                        strong(em("      1. Living in the 'throw-away' culture, how much waste do we produce?")),
                        br(),
                        strong(em("      2. Where do the waste go?")),
                        br(), br(),
                        p("Naturally, as a statistician, I 
                          answer questions by digging into data and that is the motivation of 
                          this data essay.")
                        ),
                 column(6)
                        )
                 ),
    ########################Tab 2: City of Austin Discarded Material#########################
    tabPanel("Story I: What do we throw away?", 
             fluidRow(
                 column(3),
                 column(6, 
                        p("I was hoping to find categorized data on discarded material for the 
                          whole country but at the time of working on this project, 
                          I only found the 3-year worth of discarded material data 
                          of Austin. I'm sure there are country level data out there.
                          For now, we will take a close look at Austin and use it 
                          as a way to approximate what happens
                          in the rest of the country."),
                        h1("How much discarded materials were genreated 
                           in the city of Austin?"), 
                        p("City of Austin provided data of discarded material
                          by different categories from 2013 to 2015. In those three years, 
                          a total of 5.92 million pounds of waste are produced, with 
                          an average of 1.97 million pounds per year."), 
                        p("About two-thirds of the material are recycled and resued, with 
                          the rest one-third going to landfill. Even though the percentage
                          of landfill flucatuated, the total weight of material goes into
                          landfill increased consistently
                          from 2013 to 2015.")),
                 column(3)
                        ),
             fluidRow(
                 column(3), 
                 column(6, 
                        plotlyOutput("barplot")
                 ), 
                 column(3)
             ),
             br(), 
             br(),
             fluidRow(
                 column(3),
                 column(6, 
                        h1("When do people throw things away?"), 
                        p("We divided the year by quarters and present
                          how much did people throw things away in each
                          quarter. It seems that there's a trend of more
                          things being discarded in the first half of the year. 
                          Spring cleaning maybe?")
                        ),
                 column(3)
                        ), 
             fluidRow(
                 column(3), 
                 column(6, 
                        plotlyOutput("heatmap")
                 ), 
                 column(3)
             ),
             br(), 
             br(),
             fluidRow(
                 column(3),
                 column(6, 
                        h1("What are the things people discard?"), 
                        p("Among recycled material, compost, grease trap waste, and cardboard
                          are the most recycled. In the resued cateogry, large amount of discarded
                          things go to State Surplus Store, reused by municipal contractors or Texas Facilities Commision.")
                 ),
                 column(3)
             ), 
             fluidRow(
                 column(4),
                 column(2,
                        checkboxGroupInput("yr", 
                                           "Year", 
                                           choices=list(2013, 2014, 2015), 
                                           selected=list(2013, 2014, 2015), 
                                           inline=T
                        )
                 ),
                 column(3,
                        checkboxGroupInput("cate", 
                                           "Category", 
                                           choices=list("Recycled", "Resued", "Landfill"), 
                                           selected=list("Recycled", "Resued", "Landfill"), 
                                           inline=T)
                 ),
                 column(5)
             ), 
             br(),
             fluidRow(
                 column(2),
                 column(8, 
                        plotlyOutput("pieplot")
                 ),
                 column(2)
             ),
             br(), 
             br(), 
             fluidRow( #sec6
                 column(2),
                 column(8,
                        h2("What about landfills?"), 
                        p("Unfortunately, we don't know a whole lot about what exactly
                          were those dicarded material that eventually ended up in landfills
                          in Austin... except that two landfill sites named 'Unit B' and 'Unit A' 
                          contains majority of the landfill waste generated by Austinians."), 
                        p("The good news is that we do have national level data on landfill sites.
                          In the next section, we will tale a look at landfills across the 
                          United Sates in the past 100 years."), 
                        img(src="Landfill.jpg", height=400, width=600)
                 ),
                 column(2)
             )
                 ),#tabPanel
    ######################Tab 3: Landfill###################         
      tabPanel("Story II: Landfill",
        fluidRow( #sec1
            column(2), 
            column(8,
                   p("In this part of the story, our focus will be landfills. We'll
                     look at how they are scattered geographically and chronically. 
                     We'll look back and find out which era called for needs of 
                     largest landfills."),
                   h1("Where are the landfills in United States?"),
                   p("We see a lot of landfills on the East and West coast,
                     which are densely populated. In addition, there are large 
                     clusters of landfills in the Northeast and Southeast. 
                     Click the play button on the right to see how many 
                     landfills opened across time.")
                   ),
            column(2)
        ), #closing sec1       
        br(),
        br(),
        
        fluidRow( #sec2
            column(8,
                   plotlyOutput("plot1")
                   ), 
            column(4, 
                   sliderInput("openyr",
                                "Year",
                                min = 1920,
                                max = 2017,
                                value = 2017, 
                                step=5, 
                                animate=TRUE,
                                round=,-2), #SlideInput
                   checkboxGroupInput("ownert", 
                                      "Ownership Type:", 
                                      choices=list("Public", "Private"), 
                                      selected=list("Public", "Private"), 
                                      inline=T,
                                      width="50%"
                                      
                   ),#CheckboxGroupInput
                   checkboxGroupInput("status", 
                                      "Landfill Status:", 
                                      choices=list("Closed", "Open"), 
                                      selected=list("Closed", "Open"), 
                                      inline=T,
                                      width="50%"
                                      
                   )#checkboxGroupInput
                   )#Close sidebar
        ), #sec2
        br(),
        br(),
        
        fluidRow( #sec3
            column(2),
            column(8,
                   h1("What era generated the most landfills?"), 
                   p("Landfills are organized by open year and the total 
                     waste in place of the landfills in each year is calculated.
                     We see peaks in late 50s and early 70s."),
                   plotlyOutput("plot2a")
                   ),
            column(2)
        ), #sec3
        br(),
        br(),
        
        fluidRow( #sec4
            column(2),
            column(8,
                   p("The number of newly-opened landfills dropped in late 90s and early odds. 
                 However, don't be fooled to think that the amount of garbage
                 we generated decreased. Check out the plot below for the cumulative 
                    waste we generated in the past 100 years."),
                   h1("How much waste sit in the landfills?"),
                   plotlyOutput("plot2b"),
                   br(),
                   p("The growth of waste really took off in the 50s and 60s!
                     (Am I the only one who thought of Mad Man when looking at this?)"), 
                   img(src="waste_v_expd1.png")
                   ),
            column(2)
        ), #sec4
        br(),
        br(),
                       
        fluidRow( #sec5
            column(2),
            column(8,
                   h4("Let's pause for a minute and think about where did all the trash come from?"),
                   p("There can be many answers to that question: end of WWII, 
                     increase of income, baby booming, rise of advertisement and 
                     consumer culture, introduction of TVs... 
                     All of them telling part of the story. 
                     Here's another way to look at the question: we are SPENDING more. 
                     In the graph below, personal expenditure data (scaled in thousands
                     of dollars) are projected onto the cumulative waste graph."), 
                   plotlyOutput("plot2c")
                   ),
            column(2)
        ), 
        br(),
        br()
      ),#tabpanel
    ############################Tab 4: Epilogue############################
    tabPanel("Epilogue", 
             fluidPage(
                 fluidRow(
                     column(6,
                            h1("Epilogue"),
                            h4("Many of those shiny toys, kitchen gadgets, or latest fashion that
                              people bought eventually ended up in one of those landfills."), 
                            h4("So think twice before you purchase that 50'' flat screen tv or 
                               the latest iPhone."),
                            h3("Will today's purchase sit in one of the 
                               landfills someday?"), 
                            img(src="perth-landfill-australia.jpg", 
                                height=400, width=600), 
                            p(a("Perth Landfill, Australia", target="_blank", 
                                                       href="https://www.goodfreephotos.com/australia/western-australia/perth/perth-landfill-australia.jpg.php"))
                            ),
                     column(6)
                 )
             )),
      ############################Tab 5: Info Tab############################
      tabPanel("Info", 
        fluidPage(
            fluidRow(
                h3("Author"),
                p("Zoe Liu"), 
                p("Email: zoelzh@gmail.com")
            ),
            fluidRow(
                h3("Data"),
                p("Landfill", a("data", target="_blank", href="https://www.epa.gov/sites/production/files/2017-02/lmopdata.xlsx"),
                  "is retrieved from the Landfill Methane Outreach Program",
                  a("(LMOP)",target="_blank", href="https://www.epa.gov/lmop/landfill-gas-energy-project-data-and-landfill-technical-data"),
                  "page on the EPA webiste in May 2017."),
                p("Personal expenditure data is retrieved from", 
                  a("FRED Economic Data", target="_blank", 
                    href="https://fred.stlouisfed.org/series/DPCERX1A020NBEA"), 
                  "."), 
                p("The data of discarded material in the city of Austin can be 
                  retrieved from the", a("official City of Austin open data protal", 
                                         targe="_blank", 
                                         href="https://data.austintexas.gov/Environmental/ACCD-Discarded-Materials-Fiscal-Year-2015/bvdj-b937/about"), 
                ".")
                        )
                    )
               )
    )#Navbar
  )#Fluidpage
)#ShinyUI
