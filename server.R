library(shiny)

crossOver <- function(x) {
    cross <- (summary(x)$coefficients[1, 1] / summary(x)$coefficients[2, 1] * -1)
    return(cross)
}

shinyServer(function(input, output) {

    output$logPlot <- renderPlot({
        set.seed(1)
        
        x       = rnorm(1300, 1, 3)
        linpred = input$intercept + x * input$beta
        prob    = exp(linpred)/(1 + exp(linpred))
        runis   = runif(1300, 0, 1)
        y       = ifelse(runis < prob, 1, 0)
    
        df <- data.frame(prop = y, x = x)
        df <- df[with(df, order(x)), ]
        df$stim <- rep(seq(-60, 60, by = 10), each = 100)
    
        fit  <- glm(prop ~ stim, data = df, family = 'binomial')
        cop <- crossOver(fit)
    
        plot(fit$fitted.values ~ stim, data = df, type = 'n', 
        xaxt = 'n', xlab = "VOT", yaxt = 'n', ylab  = "", 
        main = "Phoneme boundary for /ba/ - /pa/ continuum")
        curve(predict(fit, data.frame(stim = x),type="resp"), 
              add = TRUE, lty = 1, lwd = 1.5, 
              col = rgb(0, 0, 204, 102, maxColorValue = 255)) 
        abline(v = cop, h = 0.5, 
               col = rgb(150, 0, 204, 102, maxColorValue = 255))
        abline(h = 0.5, col = 'grey')
        axis(2, at = c(0, 0.5, 1), label = c("/b/", "0.5", "/p/"), 
             las = 2)
        axis(1, at = seq(-60, 60, by = 10), label = seq(-60, 60, 
                                                        by = 10))
    })

    output$crossOP <- renderText({
        set.seed(1)
        x       = rnorm(1300, 1, 3)
        linpred = input$intercept + x * input$beta
        prob    = exp(linpred)/(1 + exp(linpred))
        runis   = runif(1300, 0, 1)
        y       = ifelse(runis < prob, 1, 0)
        
        df <- data.frame(prop = y, x = x)
        df <- df[with(df, order(x)), ]
        df$stim <- rep(seq(-60, 60, by = 10), each = 100)
        
        fit  <- glm(prop ~ stim, data = df, family = 'binomial')
        paste0("The perceptual boundary is located at: ", 
               round(crossOver(fit), 2), " (ms).")
    })
})