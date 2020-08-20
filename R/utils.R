read_raw <- function(file) {
  readBin(file, "raw", n = file.info(file)$size)
}

raw_to_utf8 <- function(data) {
  res <- rawToChar(data)
  Encoding(res) <- "UTF-8"
  gsub("\r", "", res, fixed = TRUE)
}

is.dir <- function(x) {
  file.info(x)$isdir
}

file_data <- function(path) {

  raw <- read_raw(path)

  ext <- tolower(tools::file_ext(path))

  if(ext %in% EXT_DIFF){

    filedata <- raw_to_utf8(raw)

  } else if(ext %in% EXT_IMGS){

    filedata <- switch(
      ext,
      png  = paste0("data:image/png;base64,", jsonlite::base64_enc(raw)),
      svg  = paste0("data:image/svg+xml;base64,", jsonlite::base64_enc(raw))
    )

  } else {

    filedata <- paste0("data:text/csv;base64,", jsonlite::base64_enc(raw))

  }

  filedata

}

EXT_DIFF <- c("r", "json", "js", "yaml")

EXT_IMGS <- c("png", "svg")

EXT_DAFF <- c("csv")

EXT_SUPP <- c(EXT_DIFF, EXT_IMGS, EXT_DAFF)
