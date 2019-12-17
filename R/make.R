#' Use Make
#'
#' Add or modify the Makefile in the current project.
#' @export
use_make <- function(){
  # read dockerfile
  Makefile <- usethis::proj_path("Makefile")
  if(fs::file_exists(Makefile)){
    usethis::ui_oops("Makefile already exists.")
  } else {
    rmds <- fs::path_rel(
      fs::dir_ls(usethis::proj_path(), glob = "*.Rmd", recurse = TRUE),
      usethis::proj_path()
    )
    usethis::ui_info("You probably want to add:\n{usethis::ui_value(rmds)}\nto the {usethis::ui_value('Makefile')}.\nHint: {usethis::ui_code('repro::use_make_rmd()')}")
    save_as <- "Makefile"
    usethis::use_template(
      "Makefile.txt",
      save_as,
      ignore = TRUE,
      open = TRUE,
      package = "repro"
    )
  }
}