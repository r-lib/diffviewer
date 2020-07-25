read_raw <- function(file) {
  readBin(file, "raw", n = file.info(file)$size)
}

raw_to_utf8 <- function(data) {
  res <- rawToChar(data)
  Encoding(res) <- "UTF-8"
  res
}

is.dir <- function(x) {
  file.info(x)$isdir
}
