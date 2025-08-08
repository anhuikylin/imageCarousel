#' Image Carousel for Shiny Apps
#'
#' Creates a responsive image carousel that displays all PNG images from a specified folder.
#' Features include: navigation buttons, thumbnail navigation, and image downloading.
#'
#' @param id Unique identifier for the carousel module
#' @param img_dir Path to the directory containing PNG images
#' @param width Width of the main carousel image (in pixels or percentage)
#' @param height Height of the main carousel image (in pixels or auto)
#' @param thumb_width Width of thumbnails (in pixels)
#' @param border_color Color for the active thumbnail border
#' @importFrom shiny NS tagList tags HTML div actionButton
#' @importFrom shiny imageOutput uiOutput textOutput downloadButton
#' @importFrom shiny moduleServer showNotification reactiveValues observeEvent
#' @importFrom shiny reactiveTimer observe renderImage req renderText renderUI
#' @importFrom shiny downloadHandler
#' @importFrom htmltools tagList
#'
#' @return A Shiny UI element
#' @export
imageCarousel <- function(id, img_dir = "www/img", width = "500px", height = "auto",
                          thumb_width = "60px", border_color = "red") {

  # Create namespace
  ns <- NS(id)

  # CSS styles
  carousel_css <- sprintf("
    .carousel-main {
      width: %s;
      margin: auto;
      position: relative;
    }
    .carousel-main img {
      width: 100%%;
      height: %s;
      border: 1px solid #ccc;
      object-fit: contain;
    }
    .carousel-thumb img {
      width: %s;
      cursor: pointer;
      border: 1px solid #aaa;
      margin: 0 5px;
    }
    .carousel-thumb .active {
      border: 2px solid %s;
    }
    .carousel-thumb {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      margin-top: 10px;
    }
    .carousel-controls {
      margin-top: 10px;
      text-align: center;
    }
    .carousel-nav-btn {
      position: absolute;
      top: 50%%;
      transform: translateY(-50%%);
      z-index: 10;
      background: rgba(255,255,255,0.5);
      border: none;
      font-size: 1.5em;
      padding: 5px 10px;
    }
  ", width, height, thumb_width, border_color)

  # UI Component
  tagList(
    tags$head(tags$style(HTML(carousel_css))),
    div(
      class = "carousel-main",
      actionButton(ns("prev"), label = HTML("&lsaquo;"), class = "carousel-nav-btn", style = "left: 10px;"),
      imageOutput(ns("main_image"), inline = TRUE),
      actionButton(ns("next"), label = HTML("&rsaquo;"), class = "carousel-nav-btn", style = "right: 10px;")
    ),
    div(
      class = "carousel-thumb",
      uiOutput(ns("thumbnails"))
    ),
    div(
      class = "carousel-controls",
      textOutput(ns("title")),
      downloadButton(ns("download_image"), "Download Image",
                     class = "btn btn-primary")
    )
  )
}
