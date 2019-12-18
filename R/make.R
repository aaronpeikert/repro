#' Use Make
#'
#' Add a (GNU-)Makefile(s) with special emphasis on the use of containers.
#' @param docker If true a setup is created that can partially send make commands to a Docker container
#' @param singularity If true a setup is created that can partially send make commands to a Singularity container (which requires the Dockerimage)
#' @param torque If true a setup is created that can partially send make comands to a TORQUE job scheduler. Especially usefull in combination with a Singularity container.
#' @param use_docker If true `use_docker()` is called.
#' @param dockerignore If true a .dockerignore file is created.
#' @name make
NULL

#' @rdname make
#' @export
use_make <- function(docker = FALSE, singularity = FALSE, torque = FALSE){
  if(docker)use_make_docker()
  template_data <- list(wrapper = FALSE,
                        docker = FALSE,
                        winpath = NULL,
                        singularity = FALSE,
                        torque = FALSE)
  if(fs::file_exists("Makefile_Docker") & docker){
    template_data$wrapper <- TRUE
    template_data$docker <- TRUE
    template_data$winpath <- docker_windows_path(
      "C:/Users/someuser/Documents/myproject/"
      )
  }
  if(fs::file_exists("Makefile")){
    usethis::ui_oops("Makefile already exists.")
  } else {
    usethis::use_template(
      "Makefile.txt",
      "Makefile",
      data = template_data,
      ignore = TRUE,
      open = TRUE,
      package = "repro"
    )
    rmds <- fs::path_rel(
      fs::dir_ls(usethis::proj_path(), glob = "*.Rmd", recurse = TRUE),
      usethis::proj_path()
    )
    usethis::ui_info("You probably want to add:\n{usethis::ui_value(rmds)}\nto the {usethis::ui_value('Makefile')}.\nHint: {usethis::ui_code('repro::use_make_rmd()')}")
  }
}

#' @rdname make
#' @export
use_make_docker <- function(use_docker = TRUE, dockerignore = TRUE){
  if(!fs::file_exists("Dockerfile") & use_docker)use_docker()
  usethis::use_template(
    "Makefile_Docker",
    "Makefile_Docker",
    ignore = FALSE,
    open = FALSE,
    package = "repro"
  )
  if(dockerignore){
    usethis::use_template(
      "dockerignore",
      ".dockerignore",
      ignore = FALSE,
      open = FALSE,
      package = "repro"
    )
  }
}
