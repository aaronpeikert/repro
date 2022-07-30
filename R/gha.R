
#' Use GitHub Action to Build Dockerimage
#'
#' Add an standard actions that builds and publishes an Dockerimage from the `Dockerfile`.
#'
#' @param file Which file to save to.
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @export

use_github_action_docker <- function(file = ".github/workflows/push-container.yml"){
  if(uses_docker()){
    fs::dir_create(fs::path_dir(file))
    usethis::use_template(
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
