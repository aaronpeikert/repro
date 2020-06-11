option_is_na <- function(opt){
  is.na(getOption(opt))
}
dangerous <- function(func, condition = getOption("repro.pkgtest"), ...){
  # while testing, functions which rely on the specific computer infrastructure
  # should not be called
  func_chr <- deparse(substitute(func))
  condition_chr <- deparse(substitute(condition))
  function(...){
    # !isFALSE is most conservative, everything that is not FALSE triggers it
    if(!isFALSE(condition)){
      usethis::ui_stop("{usethis::ui_code(condition_chr)} forbids the use of {usethis::ui_code(func_chr)}.")
    } else {
      return(do.call(func, list(...)))
    }
  }
}

has_n_check <- function(has, check){
  # this function is usefull if you wan't to verify that everything is ok
  # but only notify the user on failure
  if(!do.call(has, list()))do.call(check, list())
  do.call(has, list())
}

has_factory <- function(name, option, internal, msg = msg_installed){
  # all has-functions are extremely similar
  # hence a function factory pattern is used to avoid redundant code
  function(silent = TRUE, force_logical = TRUE){
    # test with internal function only when option is NA
    if(option_is_na(option)){
      # getOption("repro.pkgtest") is set to TRUE while testing
      to_set <- list(do.call(internal, list()))
      names(to_set) <- option
      options(to_set)
    }
    # message status of option
    if(!silent)do.call(msg, list(name, getOption(option)))
    # return status of option
    if(force_logical){
      # can only be true/false
      return(isTRUE(getOption(option)))
    } else {
      return(getOption(option))
    }
  }
}

has_make_ <- function(){
  # if I can get a make version, make must be there
  # successfull bash commands return 0
  silent_command("make", "-v") == 0L
}
has_git_ <- function()silent_command("git", "--version") == 0L
has_docker_ <- function()silent_command("docker", "-v") == 0L
has_choco_ <- function()silent_command("choco", "-v") == 0L
has_brew_ <- function()silent_command("brew", "--version") == 0L
has_ssh_ <- function(){
  !inherits(try(credentials::ssh_read_key(), silent = TRUE)
                               ,
                               "try-error")
}
has_github_token_ <- function()usethis::github_token() != ""
has_github_ssh_ <- function(){
  temp <- tempfile()
  system2("ssh", "-T git@github.com", stdout = temp, stderr = temp)
  output <- readLines(temp)
  if(any(grepl("authenticity", output)))return("recheck_authenticity")
  if(any(grepl("success", output)))return(TRUE)
  else return(FALSE)
}
has_github_ <- function()has_git() && has_github_ssh() && has_github_token()

#' Check System Dependencies
#'
#' Corresponding functions to [`check`], but intended for programatic use.
#'
#' @param silent Should a message be printed that informs the user?
#' @param force_logical Should the return value be passed through [`isTRUE`](base)?
#' @name has
#' @family checkers
NULL

#' @rdname has
#' @export
has_make <- has_factory("Make", "repro.make", dangerous(has_make_))

#' @rdname has
#' @export
has_git <- has_factory("Git", "repro.git", dangerous(has_git_))

#' @rdname has
#' @export
has_docker <- has_factory("Docker", "repro.docker", dangerous(has_docker_))

#' @rdname has
#' @export
has_choco <- has_factory("Chocolately", "repro.choco", dangerous(has_choco_))

#' @rdname has
#' @export
has_brew <- has_factory("Homebrew", "repro.brew", dangerous(has_brew_))

#' @rdname has
#' @export
has_ssh <- has_factory("SSH", "repro.ssh", dangerous(has_ssh_), msg_ssh_keys)

#' @rdname has
#' @export
has_github_token <- has_factory("GitHub token", "repro.github.token", dangerous(has_github_token_), msg_github_token)

#' @rdname has
#' @export
has_github_ssh <- has_factory("GitHub ssh", "repro.github.ssh", dangerous(has_github_ssh_), msg_github_ssh)

#' @rdname has
#' @export
has_github <- has_factory("GitHub", "repro.github", has_github_, msg_service)
