library(plotly)
library(shiny)
shinyUI(fluidPage(
    titlePanel("Predicting the risk of getting esophageal cancer"),
    sidebarLayout(
        sidebarPanel(
            numericInput("age", "Please select your age:", value = 35, min = 25, max = 85, step = 1),
            numericInput("alcohol", "Please select your average daily alcohol consumption (gram):", 
                         value = 40, min = 0, max = 160, step = 1),
            numericInput("tobacco", "Please select your average daily tobacco consumption (gram):", 
                         value = 20, min = 0, max = 40, step = 1)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            h3("The predicted risk of esophageal cancer"),
            textOutput("pred1"),
            h3("The predicted risk of esophageal cancer (the lower boundary of 95% CI)"),
            textOutput("pred2"),
            h3("The predicted risk of esophageal cancer (the upper boundary of 95% CI)"),
            textOutput("pred3"),
            h3("The 3D plot of the risk of esophageal cancer among the original data"),
            plotlyOutput("plot1")
        )
    )
))
