repro_template <- function(path, ...) {
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
