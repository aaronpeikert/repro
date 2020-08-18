#' Use Docker
#'
#' Add or modify the Dockerfile in the current project.
#'
#' @param rver Which r version to use, defaults to current version.
#' @param stack Which stack to use, possible values are `c("r-ver", "rstudio", "tidyverse", "verse", "geospatial")`.
#' @param date Which date should be used for package instalation, defaults to today.
#' @param file Which file to save to
#' @param open Open the newly created file for editing? Happens in RStudio, if applicable, or via utils::file.edit() otherwise.
#' @export

use_docker <- function(rver = NULL, stack = "verse", date = Sys.Date(), file = "Dockerfile", open = TRUE){
  if (is.null(rver)) {
    rver <- glue::glue(R.version$major, ".", R.version$minor)
  }
  usethis::use_template(
    "Dockerfile",
    file,
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
#' @param file Where is the 'Dockerfile'?
#' @param write Should the 'Dockerfile' be modified?
#' @param open Should the file be opened?
#' @param append Should the return value be appended to the 'Dockerfile'?
#' @export

use_docker_packages <- function(packages, github = NULL, strict = TRUE, file = "Dockerfile", write = TRUE, open = write, append = TRUE){
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
    cran_entry <- docker_entry_install(on_cran,
                                       "install2.r",
                                       "--error --skipinstalled")
    to_write <- c(to_write, cran_entry)
  }
  if(length(on_github) > 0){
    github_entry <- docker_entry_install(on_github, "installGithub.r")
    to_write <- c(to_write, github_entry)
  }
  docker_entry(to_write, file, write, open, append, quiet = TRUE)
}

use_docker_apt <- function(apt, update = TRUE, file = "Dockerfile", write = TRUE, open = write, append = TRUE){
  if(length(apt) == 0L)return(NULL)
  to_write <- "RUN "
  if(update)to_write <- stringr::str_c(to_write, "apt-get update -y && ")
  to_write <- stringr::str_c(to_write, "apt-get install -y ")
  to_write <- stringr::str_c(to_write, stringr::str_c(apt, collapse = " "))
  docker_entry(to_write, file, write, open, append, quiet = TRUE)
}

docker_entry <- function(entry, file = "Dockerfile", write, open, append, quiet = FALSE) {
  if (!fs::file_exists(file)) {
    usethis::ui_oops(glue::glue("There is no {usethis::ui_path(file)}!"))
    usethis::ui_todo(
      glue::glue(
        "Run {usethis::ui_code('use_docker()')} to create {usethis::ui_path(file)}."
      )
    )
    return(invisible(NULL))
  }
  # read dockerfile
  path <- usethis::proj_path(file)
  dockerfile <- xfun::read_utf8(path)
  if(!quiet){
    usethis::ui_done("Adding {usethis::ui_value(entry)} to {usethis::ui_path(file)}")
  }
  if(append)entry <- c(dockerfile, entry)
  if (write) {
    xfun::write_utf8(entry, path)
    if (open) {
      usethis::edit_file(path)
    }
    return(invisible(entry))
  } else {
    return(entry)
  }
}

docker_entry_install <- function(packages, cmd, flags = NULL){
  entry <- stringr::str_c("RUN", cmd, flags, "\\\ ", sep = " ")
  if(length(packages) == 1L){
    entry <- c(entry, stringr::str_c("  ", packages))
  } else {
    entry <- c(entry,
               stringr::str_c("  ", packages[-length(packages)], " \\\ "),
               stringr::str_c("  ", packages[length(packages)]))
  }
  entry
}

docker_get_install <- function(dockerfile){
  starts <- stringr::str_detect(dockerfile, "^(RUN install)(.*)(\\.)[Rr](.*)$")
  possible_range <- c(rep(which(starts), each = 2L)[-1], length(dockerfile))
  possible_list <- apply(matrix(possible_range, ncol = 2L), 1, function(x)list(x))
  possible_pos <- lapply(possible_list, function(x)seq(x[[1]][1], x[[1]][2]))
  possible <- lapply(possible_pos, function(x)dockerfile[x])
  pos_raw <- lapply(possible, function(x)which(stringr::str_detect(x, "^(  )")))
  out <- vector("list", length(pos_raw))
  for(i in seq_along(pos_raw)){
    out[[i]] <- c(possible[[i]][1], possible[[i]][pos_raw[[i]]])
  }
  return(out)
}

docker_get_packages <- function(file = "Dockerfile"){
  if (!fs::file_exists(file)) {
    usethis::ui_oops(glue::glue("There is no {usethis::ui_path(file)}!"))
    usethis::ui_todo(
      glue::glue(
        "Run {usethis::ui_code('use_docker()')} to create {usethis::ui_path(file)}."
      )
    )
    return(invisible(NULL))
  }else{
    dockerfile <- readLines(file)
  }
  entry <- docker_get_install(dockerfile)
  packages_raw <- lapply(entry, function(x)x[stringr::str_detect(x, "^(  )")])
  packages <- lapply(packages_raw, function(x)stringr::str_extract(x, "[a-zA-z]+"))
  packages_sorted <- sort(unique(unlist(packages)))
  return(packages_sorted)
}

dir2imagename <- function(dir){
  dir <- basename(dir)
  stopifnot(length(dir) == 1L)
  dir <- stringr::str_extract_all(dir, "[A-z0-9]")[[1]]
  dir <- stringr::str_c(dir, collapse = "")
  dir <- stringr::str_to_lower(dir)
  dir <- stringr::str_remove(dir, "^[0-9]")
  dir
}