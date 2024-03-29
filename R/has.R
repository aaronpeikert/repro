option_is_na <- function(opt){
  is.na(getOption(opt))
}
option_exists <- function(opt){
  !is.null(getOption(opt))
}

dangerous <- function(func, condition = getOption("repro.pkgtest"), ...){
  # while testing, functions which rely on the specific computer infrastructure
  # should not be called
  func_chr <- deparse(substitute(func))
  condition_chr <- deparse(substitute(condition))
  if(length(list(...)) != 0L)usethis::ui_stop("Do not pass additional args to dangerous. Pass them to the resulting function.")
  function(...){
    # !isFALSE is most conservative, everything that is not FALSE triggers it
    if(!isFALSE(condition)){
      usethis::ui_stop("{usethis::ui_code(condition_chr)} forbids the use of {usethis::ui_code(func_chr)}.")
    } else {
      return(do.call(func, list(...)))
    }
  }
}

dangerous_succeeds <-  function(func, condition = getOption("repro.pkgtest"), ...) {
  fenced <- dangerous(func, condition)
  function(...) {
    # returns TRUE if the dangerous commands succeeds
    !inherits(try(do.call(fenced, list(...)),
                  silent = TRUE),
              "try-error")
  }
}

has_n_check <- function(has, check){
  # this function is useful if you want to verify that everything is ok
  # but only notify the user on failure
  if(!do.call(has, list()))do.call(check, list())
  do.call(has, list())
}

has_factory <- function(name, option, internal, msg = msg_installed){
  # all has-functions are extremely similar
  # hence a function factory pattern is used to avoid redundant code
  function(silent = TRUE, force_logical = TRUE){
    # test with internal function only when option is NA or not existing
    if(!option_exists(option) || option_is_na(option)){
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
has_docker_running_ <- function()all(fs::file_exists("/.dockerenv"))
has_choco_ <- function()silent_command("choco", "-v") == 0L
has_brew_ <- function()silent_command("brew", "--version") == 0L
has_ssh_ <- function(){
  !inherits(try(credentials::ssh_read_key(), silent = TRUE)
                               ,
                               "try-error")
}
has_github_token_ <- function()gh::gh_token() != ""
has_gitub_token_access_ <- function(){
  result <- tryCatch(gh::gh("/user"), error = function(e)e)
  if(inherits(result, "gh_response"))return(TRUE)
  if(inherits(result, "http_error_401"))return("bad_credentials")
  if(inherits(result, "rlib_error") && grepl("one of these forms", result$message))return("bad_format")
  else return(FALSE)
}
has_github_ssh_ <- function(){
  temp <- tempfile()
  system2("ssh", "-T git@github.com", stdout = temp, stderr = temp)
  output <- readLines(temp)
  if(any(grepl("authenticity", output)))return("recheck_authenticity")
  if(any(grepl("success", output)))return(TRUE)
  else return(FALSE)
}
has_github_ <- function()has_git() && has_github_ssh() && has_github_token() && has_github_token_access()

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
has_docker_running <- has_factory("Docker",
                                  "repro.docker.running",
                                  dangerous(has_docker_running_),
                                  msg_docker_running)

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
has_github_token_access <- has_factory("GitHub token access", "repro.github.token.access", dangerous(has_github_token_access_), msg_github_token_access)

#' @rdname has
#' @export
has_github_ssh <- has_factory("GitHub ssh", "repro.github.ssh", dangerous(has_github_ssh_), msg_github_ssh)

#' @rdname has
#' @export
has_github <- has_factory("GitHub", "repro.github", has_github_, msg_service)
