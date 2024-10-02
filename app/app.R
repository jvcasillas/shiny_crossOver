# Load libraries
library("shiny")
library("shinythemes")
library("ggplot2")
library("stargazer")

set.seed(1)

# Crossover function
crossOver <- function(x) {
  cross <- (summary(x)$coefficients[1, 1] / summary(x)$coefficients[2, 1] * -1)
  return(cross)
}

# Creat UI
ui <- fluidPage(
  # Select theme
  theme = shinytheme("united"),

  # Application title
  titlePanel("Crossover", windowTitle = "Crossover"),

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
        tags$a("Github", href="https://github.com/jvcasill/shiny_crossOver/")
      )
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
)

# Make server
server <- function(input, output) {

  x <- sort(rnorm(1300, 1, 3))
  
  linpred <- reactive({
    linpred <- input$intercept + x * input$slope
  })
  
  prob <- reactive({
    linpred <- linpred()
    prob <- exp(linpred)/(1 + exp(linpred))
  })  
  
  runis <- runif(1300, 0, 1)
  
  y <- reactive({
    prob <- prob()
    y <- ifelse(runis < prob, 1, 0)
  })
  
  dataFrame <- reactive({
    y <- y()
    stim <- rep(seq(-60, 60, by = 10), each = 100)
    df <- data.frame(prop = y, x = x, stim = stim)
  })
  
  mod <- reactive({
    df <- dataFrame()
    fit <- glm(prop ~ stim, data = df, family = 'binomial')
  })
  
  cop <- reactive({
    fit <- mod()
    cop <- crossOver(fit)
  })
  
  output$logPlot <- renderPlot({
    df <- dataFrame()
    fit <- mod()
    cop <- cop()

    plot(fit$fitted.values ~ stim, data = df, type = 'n', 
         xaxt = 'n', xlab = "VOT", yaxt = 'n', ylab  = "", 
         main = "")
    curve(predict(fit, data.frame(stim = x),type="resp"), 
          add = TRUE, lty = 1, lwd = 1.5, 
          col = rgb(0, 0, 204, 102, maxColorValue = 255)) 
    abline(v = cop, h = 0.5, 
           col = rgb(150, 0, 204, 102, maxColorValue = 255))
    abline(h = 0.5, col = 'grey')
    axis(2, at = c(0, 0.5, 1), label = c("big", "50%", "pig"), 
         las = 2)
    axis(1, at = seq(-60, 60, by = 10), 
         label = seq(-60, 60, by = 10))
  })
  
  output$modelSum <- renderPrint({
    fit <- mod()
    stargazer(fit, type = 'html', single.row=FALSE, 
              dep.var.labels="Proportion 'pig'", 
              covariate.labels=c("VOT", "Intercept"),
              ci=TRUE, ci.level=0.95, 
              align=FALSE)
  })
  
  output$crossOP <- renderText({
    fit <- mod()
    paste0("The perceptual boundary is located at: ", 
           round(crossOver(fit), 2), " (ms).")
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
