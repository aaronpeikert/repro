#' Use Make
#'
#' Add a (GNU-)Makefile(s) with special emphasis on the use of containers.
#' @param file Path to the file that is to be created.
#' @param docker If true or a path a setup is created that can partially send make commands to a Docker container.
#' @param singularity If true or a path a setup is created that can partially send make commands to a Singularity container (which requires the Dockerimage)
#' @param torque If true a or a path setup is created that can partially send make comands to a TORQUE job scheduler. Especially usefull in combination with a Singularity container.
#' @param use_docker If true `use_docker()` is called.
#' @param use_singularity If true `use_singularity()` is called.
#' @param dockerignore If true a .dockerignore file is created.
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @name make
NULL

#' @rdname make
#' @export
use_make <- function(docker = FALSE, singularity = FALSE, torque = FALSE, open = TRUE){
  # start out with the simplist Makefile possible
  template_data <- list(wrapper = FALSE,
                        docker = FALSE,
                        winpath = NULL,
                        singularity = FALSE,
                        torque = FALSE,
                        rmds = FALSE,
                        makefile_docker = getOption("repro.makefile.docker"),
                        makefile_singularity = getOption("repro.makefile.singularity"),
                        makefile_torque = getOption("repro.makefile.torque"),
                        makefile_rmds = getOption("repro.makefile.rmds")
                        )
  # add Docker & Wrapper to template
  if(isTRUE(docker) | is.character(docker)){
    do.call(use_make_docker, list(file = docker))
  } else if(fs::file_exists("Dockerfile")){
    use_make_docker(use_docker = FALSE)
  }
  if(fs::file_exists(getOption("repro.makefile.docker"))){
    template_data$wrapper <- TRUE
    template_data$docker <- TRUE
    template_data$winpath <- docker_windows_path(
      "C:/Users/someuser/Documents/myproject/",
      todo = FALSE
      )
  }
  if(fs::file_exists(getOption("repro.makefile.rmds"))){
    template_data$rmds <- TRUE
  }
  # add Singularity (and implicitly Docker)
  if(isTRUE(singularity) | is.character(singularity)){
      do.call(use_make_singularity, list(file = singularity))
    }
  if(fs::file_exists(getOption("repro.makefile.singularity"))){
    if(!fs::file_exists("Dockerfile"))usethis::ui_stop("Singularity depends in this setup on Docker.\nSet {usethis::ui_code('docker = TRUE')} & {usethis::ui_code('singularity = TRUE')}")
    template_data$singularity <- TRUE
  }
  usethis::use_template(
    "Makefile.txt",
    "Makefile",
    data = template_data,
    ignore = FALSE,
    open = open,
    package = "repro"
  )
}

#' @rdname make
#' @export
use_make_docker <- function(file, use_docker = TRUE, dockerignore = TRUE, open = FALSE){
  if(missing(file))file <- getOption("repro.makefile.docker")
  if(isTRUE(file))file <- getOption("repro.makefile.docker")
  if(use_docker)use_docker()
  usethis::use_template(
    "Makefile_Docker",
    file,
    ignore = FALSE,
    open = open,
    package = "repro"
  )
  if(dockerignore){
    usethis::use_template(
      "dockerignore",
      ".dockerignore",
      ignore = FALSE,
      open = open,
      package = "repro"
    )
  }
}

#' @rdname make
#' @export
use_make_singularity <- function(file, use_singularity = TRUE, open = FALSE){
  if(missing(file))file <- getOption("repro.makefile.singularity")
  if(isTRUE(file))file <- getOption("repro.makefile.singularity")
  if(use_singularity)usethis::ui_oops("{usethis::ui_code('use_singularity')} is not implemented, yet.")
  usethis::use_template(
    "Makefile_Singularity",
    file,
    ignore = FALSE,
    open = FALSE,
    package = "repro"
  )
}