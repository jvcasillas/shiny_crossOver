library(shiny); library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("united"),
    
    # Application title
    h3("Crossover"),
    
    sidebarLayout(
        sidebarPanel(width = 3,
            h5("Description:"),
            p("This application utilizes the function", 
              code("crossOver"), "in order to calculate the 50% 
            crossover point of a perceptual boundary for a /b/-/p/
            continuum. The application fits a linear function to 
            the log odds of selecting 'pig'."),
            withMathJax(helpText("$$\\log(\\frac{p}{1 - p}) = 
            \\beta_0 + \\beta_1VOT + \\epsilon$$")),
            p("You can adjust the intercept and slope of the 
            model in real time to obtain an updated calculation of 
            the crossover point in ms."),
            br(),
            sliderInput("intercept", 
                        "$$\\textrm{Intercept}\\: (\\,\\beta_0\\,)$$", 
                        min = -10, max = 5, value = -4, step = 0.5),
            br(),
            sliderInput("slope", 
                        "$$\\textrm{Slope}\\: (\\,\\beta_1VOT\\,)$$", 
                        min = -10, max = 10, value = 2.5, step = 0.5),
            br(),
            p(strong("Created by:"), 
              tags$a("Joseph V. Casillas", href="http://www.jvcasillas.com"),
              br(), strong("Source code:"), 
              tags$a("Github", href="https://github.com/jvcasill/shiny_crossOver/"))
        ),

        mainPanel(
            fluidRow(
                column(8,
                    div(align = "center",
                    h4("Perceptual boundary for /b/ - /p/ continuum"),
                    plotOutput("logPlot"))
                ),
                column(4,
                    div(align = "center",
                    h4("Model summary"),
                    br(),br(),br(),
                    tableOutput("modelSum"))
                )
            ),
            br(),
            br(),
            div(align = "center", h4(tableOutput("crossOP")))
        )
    )
))