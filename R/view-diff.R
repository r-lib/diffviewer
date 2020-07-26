#' Create an htmlwidget that shows differences between files or directories
#'
#' This function can be used for viewing differences between current test
#' results and the expected results
#'
#' @param old,new Names of the old and new directories to compare.
#'   Alternatively, they can be a character vectors of specific files to
#'   compare.
#' @param pattern A filter to apply to the old and new directories.
#' @param width,height Width and height of widget.
#'
#' @export
#' @examples
#' path1 <- tempfile(fileext = ".png")
#' path2 <- tempfile(fileext = ".png")
#'
#' png(path1)
#' plot(1:10)
#' dev.off()
#'
#' png(path2)
#' plot(1:10, xlab = "x")
#' dev.off()
#'
#' diffviewer_widget(path1, path2)
diffviewer_widget <- function(old, new, width = NULL, height = NULL,
  pattern = NULL)
{

  if (xor(is.dir(old), is.dir(new))) {
      stop("`old` and `new` must both be directories, or character vectors of filenames.")
  }

  # If `old` or `new` are directories, get a list of filenames from both directories
  if (is.dir(old)) {
    all_filenames <- sort(unique(c(
      dir(old, recursive = TRUE, pattern = pattern),
      dir(new, recursive = TRUE, pattern = pattern)
    )))

    old <- file.path(old, filename)
    new <- file.path(new, filename)
  } else {
    stopifnot(length(old) == length(new))
  }

  get_both_file_contents <- function(old, new) {
    list(
      filename = basename(old),
      old = get_file_contents(old),
      new = get_file_contents(new)
    )
  }
  diff_data <- Map(get_both_file_contents, old, new)

  htmlwidgets::createWidget(
    name = "diffviewer",
    list(diff_data = diff_data),
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      defaultHeight = "100%",
      browser.padding = 10,
      viewer.fill = FALSE
    ),
    width = width,
    height = height,
    package = "diffviewer"
  )
}

get_file_contents <- function(path) {
  if (!file.exists(path)) {
    return(NULL)
  }

  bin_data <- read_raw(path)
  ext <- tools::file_ext(path)

  switch(ext,
    download = ,
    json = raw_to_utf8(bin_data),
    png = paste0("data:image/png;base64,", jsonlite::base64_enc(bin_data)),
    ""
  )
}
