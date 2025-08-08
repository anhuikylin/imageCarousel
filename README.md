# imageCarousel
Provides tools to create responsive, interactive image carousels      for R Markdown documents and Shiny applications. Supports automatic      slideshows, navigation controls, and custom styling options to showcase      image collections in an engaging format.

### install
```
devtools::install_github("anhuikylin/imageCarousel")
```

### use
Place some images (.png) in the E:/count/www/img folder.
```
library(shiny)
library(base64enc)
library(imageCarousel)
# In your Shiny app:
ui <- fluidPage(
  titlePanel("My App"),
  imageCarousel("carousel1", img_dir = "E:/count/www/img", thumb_width = "60px")
)

server <- function(input, output, session) {
  imageCarouselServer("carousel1", img_dir = "E:/count/www/img", thumb_width = "60px")
}

shinyApp(ui, server)

```
