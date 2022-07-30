#' Deal with templates that are themselves whisker templates.
#'
#' If a template is itself used again as a whisker template, we need some other escape mechanism.
#' The `repro`-template than uses `[[]]` instead of `{{}}` which are than later reinstated.
#'
#' @param template [`usethis::use_template()`]
#' @param save_as [`usethis::use_template()`]
#' @param escape named vector, name is replacement (default curly), value is placeholder (default square)
#' @param data [`usethis::use_template()`]
#' @param ignore [`usethis::use_template()`]
#' @param open [`usethis::use_template()`]
#' @param package [`usethis::use_template()`]
use_template_template <- function(template, save_as = template, escape = c(`\\[\\[` = "{{", `\\]\\]` = "}}"), data = list(), ignore = FALSE, open = FALSE, package = "repro"){
  usethis::use_template(template, save_as, data, ignore, open, package)
  intermediate <- xfun::read_utf8(save_as)
  out <- stringr::str_replace_all(intermediate, escape)
  xfun::write_utf8(out, save_as)
}

#' Use GitHub Action to Build Dockerimage
#'
#' Add an standard actions that builds and publishes an Dockerimage from the `Dockerfile`.
#'
#' @param file Which file to save to.
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @export

use_github_action_docker <- function(file = ".github/workflows/push-container.yml", open = TRUE){
  if(uses_docker()){
    fs::dir_create(fs::path_dir(file))
    use_template_template(
      "push-container.yml",
      file,
      data = list(),
      ignore = FALSE,
      open = open,
      package = "repro"
    )
  } else {
    invisible()
  }
}
