
<!-- README.md is generated from README.Rmd. Please edit that file -->

diffviewer
==========

<!-- badges: start -->
<!-- badges: end -->

diffviewer provides an HTML widget for visually comparing files. It
currently wraps three javascript libraries:

-   [resemble.js](https://rsmbl.github.io/Resemble.js/) for comparing
    images.
-   [daff.js](https://paulfitz.github.io/daff/) for comparing data
    frames.
-   [jsdiff](https://github.com/kpdecker/jsdiff) for everything else.

It extracts out common UI provided by
[shinytest](https://rstudio.github.io/shinytest/index.html) and
[vdiffr](https://vdiffr.r-lib.org).

Installation
------------

You can install the released version of diffviewer from
[CRAN](https://CRAN.R-project.org) with:

    install.packages("diffviewer")

Example
-------

This is a basic example which shows you how to solve a common problem:

    library(diffviewer)
    path1 <- tempfile()
    writeLines(letters, path1)
    path2 <- tempfile()
    writeLines(letters[-(10:11)], path2)

    visual_diff(path1, path2)
