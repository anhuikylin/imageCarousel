#' Server logic for image carousel
#'
#' @param id Unique identifier matching the UI
#' @param img_dir Path to the directory containing PNG images
#' @param thumb_width Width of thumbnails (in pixels)
#' @param auto_play Logical, whether to auto-play the carousel (default FALSE)
#' @param interval Auto-play interval in milliseconds (default 2000)
#'
#' @return Server logic for the carousel
#' @export
imageCarouselServer <- function(id, img_dir = "www/img", thumb_width = "60px",
                                auto_play = FALSE, interval = 2000) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # Get image files
    files <- list.files(img_dir, pattern = "\\.png$", full.names = TRUE)
    rel_files <- list.files(img_dir, pattern = "\\.png$", full.names = FALSE)

    if (length(files) == 0) {
      showNotification("No PNG images found in the specified folder", type = "warning")
      return()
    }

    # Reactive values
    rv <- reactiveValues(index = 1)

    # Navigation handlers
    observeEvent(input$prev, {
      rv$index <- ifelse(rv$index > 1, rv$index - 1, length(files))
    })

    observeEvent(input$`next`, {
      rv$index <- ifelse(rv$index < length(files), rv$index + 1, 1)
    })

    # Thumbnail click handler
    observeEvent(input$thumbnail_click, {
      rv$index <- as.integer(input$thumbnail_click) + 1
    })

    # Auto-play functionality (optional)
    if (auto_play) {
      auto_play_timer <- reactiveTimer(interval)
      observe({
        auto_play_timer()
        rv$index <- ifelse(rv$index < length(files), rv$index + 1, 1)
      })
    }

    # Main image display
    output$main_image <- renderImage({
      req(rv$index)
      list(
        src = files[rv$index],
        contentType = "image/png",
        alt = rel_files[rv$index],
        width = "100%"
      )
    }, deleteFile = FALSE)

    # Image title
    output$title <- renderText({
      paste("Image:", rel_files[rv$index])
    })

    # Thumbnails
    output$thumbnails <- renderUI({
      req(rel_files)
      tagList(
        lapply(seq_along(rel_files), function(i) {
          tags$img(
            src = file.path("img", rel_files[i]),
            onclick = sprintf("Shiny.setInputValue('%s', %d, {priority: 'event'})",
                              ns("thumbnail_click"), i - 1),
            class = ifelse(i == rv$index, "active", ""),
            style = sprintf("width: %s;", thumb_width)
          )
        })
      )
    })

    # Image download
    output$download_image <- downloadHandler(
      filename = function() {
        rel_files[rv$index]
      },
      content = function(file) {
        file.copy(files[rv$index], file)
      }
    )
  })
}
