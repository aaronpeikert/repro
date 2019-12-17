#' Add dependencies to Dockerfile
#'
#' Adds dependencies as a new RUN statement to Dockerfile
#'
#' @param packages Which packages to add.
#' @param github Are there github packages?
#' @param strict Defaults to TRUE, force a specific version for github packages.
#' @export

  use_docker_packages <- function(packages, github = NULL, strict = TRUE){
  save_as <- "Dockerfile"
  if(!fs::file_exists(save_as)){
    usethis::ui_oops(glue::glue("There is no {usethis::ui_path(save_as)}!"))
    usethis::ui_todo(glue::glue("Run {ui_code('use_docker()')} to create {usethis::ui_path(save_as)}."))
    return(invisible(NULL))
  }

  # read dockerfile
  path <- usethis::proj_path("Dockerfile")
  dockerfile <- xfun::read_utf8(path)

  # github stuff has these symbols
  on_github <- stringr::str_detect(packages, "[/|@]")
  github <- packages[on_github]
  # everything else is assumed to be on cran
  cran <- packages[!on_github]
  if(!isTRUE(github) && any(on_github)){
    usethis::ui_warn("Some packages seem to come from GitHub.
            Set {usethis::ui_code('github = TRUE')} to silence this warning.")
  }
  if(isTRUE(strict) & any(!stringr::str_detect(github, "@"))){
    usethis::ui_stop("Some github packages are without fixed version. Use the following scheme:
            {usethis::ui_code('author/package@version')}
            version can be a git tag or hash")
  }

  # sort alphabetically and remove duplicates
  github <- unique(github)
  github <- sort(github)
  cran <- unique(cran)
  cran <- sort(cran)

  # construct Dockerfile entries
  # and write them appended to Dockerfile
  to_write <- character()
  if(length(cran) > 0){
    cran_code <- c(
      "RUN install2.r --error --skipinstalled \\\ ",
      stringr::str_c("  ", cran[-length(cran)], " \\\ "),
      stringr::str_c("  ", cran[length(cran)]))
    to_write <- c(to_write, cran_code)
  }
  if(length(github) > 0){
    github_code <- c(
      "RUN installGithub.r \\\ ",
      stringr::str_c("  ", github[-length(github)], " \\\ "),
      stringr::str_c("  ", github[length(github)]))
    to_write <- c(to_write, github_code)
  }
  if(!isTRUE(length(to_write) > 0L)){
    usethis::ui_oops("No new packages added!")
    return(invisible(NULL))
  }
  # write out
  usethis::ui_done("Adding {ui_value(to_write)} to {ui_path('Dockerfile')}")
  xfun::write_utf8(c(dockerfile, to_write), path)
  usethis::edit_file(path)
}
