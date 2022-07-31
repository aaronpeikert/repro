#' Check Project Configuration
#'
#' Check if a project uses certain things, e.g. Make or Docker.
#'
#' @param silent Defaults to `false`. Should a message be printed that informs the user?
#' @name uses
#' @family checkers
NULL

file_indicates_use <- function(file, silent = TRUE, what, remedy){
  if(!silent){
    if(fs::file_exists(file))usethis::ui_done("You already use {what}.")
    else usethis::ui_oops("You do not use {what} at the momement. Use {usethis::ui_code(remedy)} to add it to your project.")
  }
  invisible(fs::file_exists(file))
}

#' @rdname uses
#' @export
uses_make <- function(silent = FALSE)
  file_indicates_use("Makefile", silent, "Make", "use_make()")

#' @rdname uses
#' @export
uses_docker <- function(silent = FALSE)
  file_indicates_use("Dockerfile", silent, "Docker", "use_docker()")

#' @rdname uses
#' @export
uses_gha_docker <- function(silent = FALSE)
  file_indicates_use(getOption("repro.gha.docker"), silent, "GitHub Action Docker Push", "use_gha_docker()")

#' @rdname uses
#' @export
uses_gha_publish <- function(silent = FALSE)
  file_indicates_use(getOption("repro.gha.publish"), silent, "GitHub Action Publish", "use_gha_publish()")