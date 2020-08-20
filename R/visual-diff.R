#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
visual_diff <- function(file_old, file_new, ..., width = NULL, height = NULL, elementId = NULL) {

  stopifnot(
    file.exists(file_old),
    file.exists(file_new),
    tolower(tools::file_ext(file_old)) %in% EXT_SUPP,
    tolower(tools::file_ext(file_old)) == tolower(tools::file_ext(file_new))
  )

  ext_file <- tolower(tools::file_ext(file_old))
  typediff <- NULL

  if(ext_file %in% EXT_DIFF) {
    typediff <- "text"
  } else if(ext_file %in% EXT_IMGS) {
    typediff <- "image"
  } else if(ext_file %in% EXT_DAFF) {
    typediff <- "data"
  }

  stopifnot(!is.null(typediff))

  # forward options using x
  x = list(
    old = file_data(file_old),
    new = file_data(file_new),
    filename = basename(file_old),
    typediff = typediff
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'visual_diff',
    x,
    width = width,
    height = height,
    package = 'diffviewer',
    elementId = elementId
  )
}

#' Shiny bindings for visual_diff
#'
#' Output and render functions for using visual_diff within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a visual_diff
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name visual_diff-shiny
#'
#' @export
visual_diffOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'visual_diff', width, height, package = 'diffviewer')
}

#' @rdname visual_diff-shiny
#' @export
renderVisual_diff <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, visual_diffOutput, env, quoted = TRUE)
}
