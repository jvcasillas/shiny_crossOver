library(shiny)

shinyUI(pageWithSidebar(
    
    # Application title
    headerPanel("Crossover"),
    
    sidebarPanel(
        h3("Details:"),
        p("This application utilizes the function crossOver in 
          order to calculate the 50% crossover point of a 
          participants perceptual boundary for a /b/-/p/ 
          continuum. The application fits a linear 
          function to the log odds of selecting 'pig'."),
        withMathJax(helpText("$$\\log(\\frac{p}{1 - p}) = 
                             \\beta_0 + \\beta_1VOT + \\epsilon$$")),
        p("You can adjust the intercept and slope of the 
          model in real time to obtain an updated calculation of 
          the crossover point in ms."),
        sliderInput("intercept", "$$\\textrm{Intercept}\\: (\\,\\beta_0\\,)$$", min = -11.0, 
                    max = 6.0, value = -5.0, step = .25),
        sliderInput("slope", "$$\\textrm{Slope}\\: (\\,\\beta_1VOT\\,)$$", min = 2.25, max = 10, 
                    value = 2.75, step = .25),
        h5("Created by:"),
        tags$a("Joseph V. Casillas", 
               href="http://www.jvcasillas.com"),
        h5("Source code:"),
        tags$a("Github", 
               href="https://github.com/jvcasill/shiny_crossOver/")
    ),

    mainPanel(        
        plotOutput("logPlot"),
        tableOutput("modelSum"),
        tableOutput("space"),
        tableOutput("intEst"),
        tableOutput("slopeEst"),
        tableOutput("crossOP")
    )
))