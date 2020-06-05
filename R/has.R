option_is_na <- function(opt){
  is.na(getOption(opt))
}
call_dangerous <- function(func, condition, ...){
  # while testing, functions which rely on the specific computer infrastructure
  # should not be called
  # !isFALSE is most conservative, everything that is not FALSE triggers it
  if(!isFALSE(condition)){
    usethis::ui_stop("{usethis::ui_code(deparse(substitute(condition)))} forbids the use of {usethis::ui_code(deparse(substitute(func)))}.")
  } else {
    return(do.call(func, list(...)))
  }
}

has_factory <- function(name, option, internal){
  # all has-functions are extremely similar
  # hence a function factory pattern is used to avoid redundant code
  function(silent = TRUE, allow_na = FALSE){
    # test with internal function only when option is NA
    if(option_is_na(option)){
      to_set <- list(call_dangerous(internal, getOption("repro.pkgtest")))
      names(to_set) <- option
      options(to_set)
    }
    # message status of option
    if(!silent)msg_installed(name, getOption(option))
    # return status of option
    if(allow_na){
      return(getOption(option))
    } else {
      # can only be true/false
      return(isTRUE(getOption(option)))
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

#' Check System Dependencies
#'
#' Corresponding functions to [`check`], but intended for programatic use.
#'
#' @param silent Should a message be printed that informs the user?
#' @param allow_na Is `NA` a valid return value? If `NA` is not allowed, FALSE is returned instead.
#' @name has
#' @family checkers
NULL

#' @rdname has
#' @export
has_make <- has_factory("Make", "repro.make", has_make_)

#' @rdname has
#' @export
has_git <- has_factory("Git", "repro.git", has_git_)

#' @rdname has
#' @export
has_docker <- has_factory("Docker", "repro.docker", has_docker_)

#' @rdname has
#' @export
has_choco <- has_factory("Chocolately", "repro.choco", has_choco_)

#' @rdname has
#' @export
has_brew <- has_factory("Homebrew", "repro.brew", has_brew_)
