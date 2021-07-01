
library(shiny)

shinyUI(fluidPage(

    # Application title
    titlePanel("Demonstration of central limit theorem"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("samples",
                        "Number of samples:",
                        min = 1,
                        max = 5000,
                        value = 500),
            selectInput('choice', 'Select the distribution for the samples',
                        choices = c('Uniform', 'Normal', 'Poisson', 'Binomial'),
                        selected = 'Uniform'),
            numericInput('mean', 'Mean of the distribution', value = 0, 
                         min = -100, max = 100, step = 1),
            numericInput('std', 'Standard Deviation of the distribution',
                         value = 1, min = -10, max = 10, step = 1),
            numericInput('lambda', 'Lambda for poisson distribution', value = 5,
                         min = -20, max = 20, step = 1),
            numericInput('size', 'Size for binomial distribution (n)', value = 10,
                         min = 0, max = 100, step = 1),
            numericInput('prob', 'Probability of success for binomial (p)', value = 0.5,
                         min = 0, max = 1, step = 0.05),
            numericInput('size_sampling', 'Number of means computed', value = 1000,
                         min = 0, max = 10000, step = 5)
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = 'tabs',
            tabPanel('Samples', br(), plotOutput('histPlot')),
            tabPanel('Means', br(), plotOutput('samplingHist')),
            tabPanel('Comparison', br(), plotOutput('comparison')),
            tabPanel('QQ-plot', br(), plotOutput('qqplot'))),
            verbatimTextOutput ('description')
            )
        )
    )
)
