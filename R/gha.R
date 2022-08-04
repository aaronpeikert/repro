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
  usethis::use_template(template = template, save_as = save_as, data = data, ignore = ignore, open = FALSE, package = package)
  location <- usethis::proj_path(save_as)
  intermediate <- xfun::read_utf8(location)
  out <- stringr::str_replace_all(intermediate, escape)
  xfun::write_utf8(out, location)
  if(open)usethis::edit_file(location)
  invisible()
}

#' Use GitHub Action to Build Dockerimage
#'
#' Add an standard actions that builds and publishes an Dockerimage from the `Dockerfile`.
#'
#' @param file Which file to save to.
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @export

use_gha_docker <- function(file = getOption("repro.gha.docker"), open = TRUE){
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


#' Use GitHub Action to Publish Results
#'
#' Add an standard actions that builds the `publish`-target, and publishes the results on the `gh-pages` branch.
#' Requires a Dockerimage published within the same GitHub repository. See [`use_gha_docker()`].
#'
#' @param file Which file to save to.
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @export

use_gha_publish <- function(file = getOption("repro.gha.publish"), open = TRUE){
  if(uses_gha_docker()){
    fs::dir_create(fs::path_dir(file))
    use_template_template(
      "publish.yml",
      file,
      data = list(),
      ignore = FALSE,
      open = open,
      package = "repro"
    )
    automate_make_rmd_check(path = ".", target = "publish")
  } else {
    invisible()
  }
}
