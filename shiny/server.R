#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(lubridate)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # making a limited dataset based on inputs
  # NOTE: values with NA are being dropped
  dat <- reactive(txhousing %>% 
                    filter(!is.na(median) & !is.na(listings)) %>% 
                    mutate(date = ym(paste(year, month, "-"))) %>% 
                    filter(city %in% input$cities) %>% 
                    filter(between(sales, input$sales[1], input$sales[2])) %>% 
                    filter(between(listings, input$listings[1], input$listings[2]))
                  )
  # making model
  mod <- reactive(lm(median ~ date, data = dat()))
  # making predictions
  date <- reactive(ym(paste(input$year, input$month, "-")))
  pred <- reactive(predict(mod(), newdata = data.frame(date = date())))

  # exporting plot
    output$plot <- renderPlot({
      
      dat() %>% 
        ggplot(aes(date, median)) + 
        geom_point(alpha = 0.33, aes(color = city)) +
        geom_smooth(method = "lm") + 
        geom_hline(yintercept = pred(), color = "red") +
        geom_vline(xintercept = date(), color = "red") +
        labs(x = "Year/Month", y = "Median Sale Price", color = "City") +
        scale_y_continuous(labels = scales::label_dollar(suffix =  "K", scale = 1/1000)) +
        theme(text = element_text(size = 15))

    })
    
    # exporting price estimate
    output$est <- renderText(
      paste0(paste0("$", format(pred(), digits = 2, big.mark = ",")))

    )

})


