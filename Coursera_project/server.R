library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
    dist <- reactive({d <- switch(input$choice, 
                   'Uniform' = runif(input$samples),
                   'Normal' = rnorm(input$samples, input$mean, input$std),
                   'Poisson' = rpois(input$samples, input$lambda),
                   'Binomial' = rbinom(input$samples, input$size, input$prob))
    df <- data.frame(samples = d)
    df
    })
    
    dists <- reactive({
        d <- switch(input$choice, 
                   'Uniform' = colMeans(replicate(input$size_sampling, runif(input$samples))),
                   'Normal' = colMeans(replicate(input$size_sampling, rnorm(input$samples, input$mean, input$std))),
                   'Poisson' = colMeans(replicate(input$size_sampling, rpois(input$samples, input$lambda))),
                   'Binomial' = colMeans(replicate(input$size_sampling, rbinom(input$samples, input$size, input$prob))))
        dfs <- data.frame(samples = d)
        dfs
    })
    
    output$histPlot <- renderPlot({
        
        p <- ggplot(data = dist()) + 
            geom_histogram(aes(x = samples, y = ..density..),
                                                fill = 'lightblue', color = 'blue') +
            geom_density(aes(x = samples, y = ..density..), color = 'red')
        p
    })
    
    output$samplingHist <- renderPlot({
        
        p <- ggplot(data = dists()) + 
            geom_histogram(aes(x = samples, y = ..density..),
                                                fill = 'lightblue', color = 'blue') +
            geom_density(aes(x = samples, y = ..density..), color = 'red')
        p
    })
    
    output$comparison <- renderPlot({
       
        p <- ggplot(data = dists(), aes(samples)) +
            geom_line(stat="density", size = 1, color = 'red') +
            stat_function(fun = dnorm, n = input$size_sampling, 
                          args = list(mean = mean(dists()$samples), sd = sd(dists()$samples)), 
                          color = 'blue', size = 1)
        p
    })
    
    output$qqplot <- renderPlot({
        p <- ggplot(data = dists(), aes(sample = samples)) +
            geom_qq() +
            geom_qq_line(color = 'red')
        p
    })
    
    output$description <- renderText({
        "\tThis app serves to show the central limit theorem in statistics, by drawing samples from different distributions
        (uniform, normal, poisson and binomial). Then, the sampling distribution of the means is computed in the 'Means' pannel
        with a distribution size that can be changed. In order to prove the normality of the distribution, the probability density function
        of the sampling distribution is shown compared to a gaussian on the 'Comparison' pannel. Finally, a QQ-plot is plotted in the 'QQ-plot'
        pannel.
        
        Based on the distribution used, you can change the population parameters:
        - number of samples with the slidebar
        - mean and std for the normal distribution
        - lambda for the poisson distribution
        - size and probability (n and p) for the binomial distribution
        - number of samples means for the sampling distribution
        "
        
    })
})
