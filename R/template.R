#' Create repro template
#'
#' Fills a newly created folder with examples of RMarkdown, scripts, and data, which work well with [repro::automate()].
#'
#' @param path character specifieng target folder. Will be created if it doesn't exist.
#' @param ... Passed down to the markdown template.
#' @name template
NULL

#' @rdname template
#' @export
repro_template <- function(path, ...) {
  stopifnot(length(path) == 1L)
  # ensure path exists
  fs::dir_create(path, recurse = TRUE)
  usethis::proj_set(path, force = TRUE)
  usethis::use_template("markdown.Rmd",
                        data = list(date = Sys.Date(), ...),
                        package = "repro")
  fs::dir_create(usethis::proj_path("data"))
  fs::dir_create(usethis::proj_path("R"))
  utils::write.csv(get("mtcars"), usethis::proj_path("data", "mtcars.csv"))
  usethis::use_template("clean.R",
                        "R/clean.R",
                        package = "repro")
}

#' @rdname template
#' @export
use_repro_template <- repro_template