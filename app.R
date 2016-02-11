#
# Color-code a brain image according to values.
# The brain image was created with polygons using QGIS (http://www.qgis.org/) and saved as a shapefile.
# The shapefile can then be read into R using maptools and treated as a map and each polygon
# can be colored according to a scalar.
# 
# Brain image taken from http://www.highlands.edu/academics/divisions/scipe/biology/faculty/harnden/2121/images/brainlandmarks.jpg
#

library(shiny)

server <- function(input, output) {
}

ui <- shinyUI(fluidPage(
))

shinyApp(ui = ui, server = server)
