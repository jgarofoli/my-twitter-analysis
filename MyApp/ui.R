library(shiny)
# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Justin's Twitter Report!"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
                 radioButtons("user", "Choose User:", c("justing","jgwx") )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      htmlOutput("twitter")
    ),
  )
))
