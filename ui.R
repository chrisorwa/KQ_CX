library(shiny)
library(ggplot2)

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("KQ Customer Experience Dashboard"),
  
  # Bar Chart
  plotOutput("brandBar")
  
)

