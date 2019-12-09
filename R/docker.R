#' Using Docker
#'
#' Uses Docker in the current project.
#'
#' @param rver which r version to use, defaults to current version
#' @param stack from which stack to use, possible values are c("r-ver", "rstudio", "tidyverse", "verse", "geospatial")
#' @param date which date should be used for package instalation, defaults to today

use_docker <- function(rver = NULL, stack = "verse", date = Sys.Date()){
  if (is.null(rver)) {
    rver <- glue::glue(R.version$major, ".", R.version$minor)
  }
  save_as <- "Dockerfile"
  usethis::use_template(
    "Dockerfile",
    save_as,
    data = list(rver = rver,
                stack = stack,
                date = date),
    ignore = TRUE,
    open = TRUE,
    package = "repro"
  )
}