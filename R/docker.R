#' Use Docker
#'
#' Add or modify the Dockerfile in the current project.
#'
#' @param rver which r version to use, defaults to current version.
#' @param stack which stack to use, possible values are `c("r-ver", "rstudio", "tidyverse", "verse", "geospatial")`.
#' @param date which date should be used for package instalation, defaults to today.
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @export

use_docker <- function(rver = NULL, stack = "verse", date = Sys.Date(), open = TRUE){
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
    ignore = FALSE,
    open = open,
    package = "repro"
  )
}

#' Add dependencies to Dockerfile
#'
#' Adds package dependencies as a new RUN statement to Dockerfile.
#' Sorts packages first into source (cran & github) and then alphabetically.
#'
#' @param packages Which packages to add.
#' @param github Are there github packages?
#' @param strict Defaults to TRUE, force a specific version for github packages.
#' @param write Should the file be written to disk?
#' @param open Should the file be opened?
#' @export

use_docker_packages <- function(packages, github = NULL, strict = TRUE, write = TRUE, open = write){
  # github stuff has these symbols
  on_github <- packages[stringr::str_detect(packages, "[/|@]")]
  # everything else is assumed to be on cran
  on_cran <- packages[!(packages %in% on_github)]
  if(!isTRUE(github) & (length(on_github) > 0)){
    usethis::ui_warn("Some packages seem to come from GitHub.
            Set {usethis::ui_code('github = TRUE')} to silence this warning.")
  }
  if(isTRUE(strict) & any(!stringr::str_detect(on_github, "@"))){
    usethis::ui_stop("Some github packages are without fixed version. Use the following scheme:
            {usethis::ui_code('author/package@version')}
            version can be a git tag or hash or
            set {usethis::ui_code('strict = FALSE')} on your own risk.")
  }

  # sort alphabetically and remove duplicates
  on_github <- unique(on_github)
  on_github <- sort(on_github)
  on_cran <- unique(on_cran)
  on_cran <- sort(on_cran)

  # construct Dockerfile entries
  # and write them appended to Dockerfile
  to_write <- character()
  if(length(on_cran) > 0){
    cran_entry <- docker_entry_install(on_github,
                                       "install2.r",
                                       "--error --skipinstalled")
    to_write <- c(to_write, cran_entry)
  }
  if(length(on_github) > 0){
    github_entry <- docker_entry_install(on_github, "installGithub.r")
    to_write <- c(to_write, github_entry)
  }
  docker_entry(to_write, "Dockerfile", write, open)
}

docker_entry <- function(entry, file, write, open){
  if(write){
    save_as <- "Dockerfile"
    if(!fs::file_exists(save_as)){
      usethis::ui_oops(glue::glue("There is no {usethis::ui_path(save_as)}!"))
      usethis::ui_todo(glue::glue("Run {usethis::ui_code('use_docker()')} to create {usethis::ui_path(save_as)}."))
      return(invisible(NULL))
    }
    # read dockerfile
    path <- usethis::proj_path("Dockerfile")
    dockerfile <- xfun::read_utf8(path)
    usethis::ui_done("Adding {usethis::ui_value(entry)} to {usethis::ui_path('Dockerfile')}")
    if(open){
      usethis::edit_file(path)
    }
    xfun::write_utf8(entry, path)
    return(invisible(entry))
  } else {
    return(entry)
  }
}

docker_entry_install <- function(packages, cmd, flags = NULL, collapse = TRUE, write = FALSE, open = write){
  entry <- stringr::str_c("RUN", cmd, flags, "\\\ ", sep = " ")
  if(length(packages) == 1L){
    entry <- c(entry, stringr::str_c("  ", packages))
  } else {
    entry <- c(entry,
               stringr::str_c("  ", packages[-length(packages)], " \\\ "),
               stringr::str_c("  ", packages[length(packages)]))
  }
  if(collapse)entry <- stringr::str_c(entry, collapse = "\n")
  docker_entry(entry, "Dockerfile", write, open)
}
