#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/



library(shiny)
library(tidyverse)
library(lubridate)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Texas Housing Price Predicition"),
    p("This shiny app estimates the median sales price of texas houses based on user inputs
      using the 'txhousing' dataset. The user can control the month and year of the sale, along
      with factors such as the city and number of listing and other sales made that month. 
      Note, data with missing price or listings values were removed the dataset."),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          selectInput("year", "Select year of house sale:",
                      choices = unique(txhousing$year),
                      selected = 2010, multiple = FALSE),
          selectInput("month", "Select month of house sale:",
                      choices = unique(txhousing$month),
                      selected = 6, multiple = FALSE),
          selectInput("cities", "Select city of house sale (can select multiple):",
                      choices = unique(txhousing$city), 
                      selected = c("Dallas", "Austin", "Houston", "Fort Worth"),
                      multiple = TRUE),
          sliderInput("listings", "Select number of listings in a month:", 
                      min = min(txhousing$listings, na.rm = T), 
                      max = max(txhousing$listings, na.rm = T),
                      value = c(min(txhousing$listings, na.rm = T),
                                 max(txhousing$listings, na.rm = T))),
          sliderInput("sales", "Select number of sales in a month:", 
                      min = min(txhousing$sales, na.rm = T), 
                      max = max(txhousing$sales, na.rm = T),
                      value = c(min(txhousing$sales, na.rm = T),
                                 max(txhousing$sales, na.rm = T)))
          ),

        #  showing plot
        mainPanel(
          h3("Plot of median house sale price over time:"),
          plotOutput("plot"),
          h3("Predicted median house sale price:"),
          textOutput("est")
        )
    )
))
