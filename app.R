#
# Color-code a brain image according to values.
# The brain image was created with polygons using QGIS (http://www.qgis.org/) and saved as a shapefile.
# The shapefile can then be read into R using maptools and treated as a map and each polygon
# can be colored according to a scalar.
# 
# Brain image taken from http://www.highlands.edu/academics/divisions/scipe/biology/faculty/harnden/2121/images/brainlandmarks.jpg
#

library(shiny)
library(maptools)
library(RColorBrewer)

myMap <- readShapePoly('./data/brain_shape.shp')
labels.brain <- c('frontal lobe', 'precentral gyrus', 'postcentral gyrus', 'parietal lobe',
                  'occipital lobe', 'temporal lobe', 'cerebellum', 'pons', 'medulla oblongata')
colorScale <- c('Blues', 'Greens', 'Reds', 'PuBuGn', 'YlOrRd')
maxRange <- 200

server <- function(input, output) {
  
  output$sliders <- renderUI({
    lapply(1:length(labels.brain), function(i) {
      sliderInput(inputId = paste0('sl', i), label = labels.brain[i], min = 1, max = maxRange, value = floor(runif(1, 1, maxRange + 1)))
    })
  })
  
  output$brainMapLattice <- renderPlot({
    brainRows <- 3
    brainCols <- 5
    colorRamp <- colorRampPalette(brewer.pal(9, "Blues"))(maxRange)
    par(mfrow = c(brainRows, brainCols), mar = c(1 ,1 ,1 ,1))
    for (i in 1:brainRows) {
      for (j in 1:brainCols) {
        ref <- j + (i - 1) * brainCols
        values.brain <- floor(runif(11, 1, maxRange + 1))
        plot(myMap, col=colorRamp[values.brain], main = paste0('brain ref: ', ref))
      }
    }
  })
  
  output$brainMapLabels <- renderPlot({
    plot(myMap)
    text(coordinates(myMap), labels = labels.brain, cex=0.8)
  })
  
  output$brainMapInteractive <- renderPlot({
    values.brain <- c(input$sl1, input$sl2, input$sl3, input$sl4, input$sl5,
                      input$sl6, input$sl7, input$sl8, input$sl9)
    colorRamp <- colorRampPalette(brewer.pal(9, input$selCol))(maxRange)
    plot(myMap, col=colorRamp[values.brain])
  })
  
}

ui <- shinyUI(fluidPage(
  tabsetPanel(
    tabPanel('mutiple sets',
             br(),
             plotOutput('brainMapLattice'),
             fluidRow(
               column(6, offset = 3, plotOutput('brainMapLabels'))
             )),
    tabPanel('interactive',
             fluidRow(
               column(3, uiOutput('sliders')),
               column(9, selectInput('selCol', 'color palette', choices=colorScale),
                      plotOutput('brainMapInteractive'))
             )
    )
  )
))

shinyApp(ui = ui, server = server)
