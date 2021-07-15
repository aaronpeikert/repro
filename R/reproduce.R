#' Find entrypoint for analysis and suggest how to reproduce it.
#'
#' `reproduce()` inspects the files of a project and suggest a way to reproduce the project.
#'
#' `reproduce()` walks through a list of functions that check for a specific entrypoint.
#' As soon as a function returns a possible entrypoint the search stops.
#' If no function is supplied the standard list of [reproduce_funs] is used.
#'
#' @param fun a function that inspects `dir` and advises on how to reproduce the analysis. Defaults to [reproduce_funs].
#' @param ... more functions like `fun`.
#' @param path Were should I look for entrypoints?
#' @param cache Default is `FALSE`. Some entrypoints have a cache, which you probably do not want to use in a reproduction.
#' @param silent Should a message be presented?
#' @return Returns invisibly `TRUE` if an entrypoint was found and `FALSE` if not.
#' @seealso reproduce_funs
#' @name reproduce
#' @export
reproduce <- function(fun, ..., path = ".", cache = FALSE, silent = FALSE){
  dots <- list(...)
  if(missing(fun)) {
    if(!is.na(getOption("repro.reproduce.msg"))){
      eval(getOption("repro.reproduce.msg"))
      return(invisible(TRUE))
    }
    funs <- getOption("repro.reproduce.funs", repro::reproduce_funs)
  } else {
    funs <- c(list(fun), list(...))
  }
  args <- rep(list(list(path = path, cache = cache)), length(funs))
  walk_trough_funs(funs, args)
}

walk_trough_funs <- function(funs, args){
  if(missing(args)) {
    # no args case
    for(f in funs) {
      condition <- isTRUE(do.call(f, list()))
      if(condition) break
    }
  } else {
    # at least one arg
    if(length(args) == 1L) {
      args <- rep(args, length(funs))
    }
    stopifnot(length(funs) == length(args))
    stopifnot(do.call(all, lapply(funs, is.function)))
    for(i in seq_along(funs)){
      condition <- isTRUE(do.call(funs[[i]], args[[i]]))
      if(condition) break
    }
  }
  return(invisible(condition))
}

dir_ls <- function(...){
  dots <- list(...)
  stopifnot(any(c("regexp", "glob") %in% names(dots)))
  if(is.null(dots$all)) dots$all <- TRUE
  if(is.null(dots$type)) dots$type <- "file"
  if(is.null(dots$recurse)) dots$recurse <- TRUE
  do.call(fs::dir_ls, dots)
}

file_is_somewhere <- function(file, ...){
  stopifnot(is.character(file), length(file) == 1)
  isTRUE(fs::file_exists(dir_ls(regexp = stringr::str_c(".*/", file, "$"))))
}

#' @rdname reproduce
#' @export
reproduce_make <- function(path, cache = FALSE, silent = FALSE){
  candidates <- dir_ls(path = path, regexp = "^Makefile$")
  if(verify_reproduce_candidates(candidates, silent = silent)){
    command <- "make "
    if(isFALSE(cache))command <- stringr::str_c(command, "-B ")
    if(file_is_somewhere("Makefile_Docker")){
      command <- stringr::str_c("make docker &&\n", command, "DOCKER=TRUE ")
    }
    msg_reproduce(command)
  }
  return(invisible(verify_reproduce_candidates(path)))
}

verify_reproduce_candidates <- function(path, silent = TRUE){
  n <- length(path)
  exist <- fs::file_exists(path)
  if(n == 1L && isTRUE(exist))return(TRUE)
  else if(n == 0L)return(FALSE)
  else {
    path <- path[exist]
    if(!silent)usethis::ui_warn("Potential entrypoint candidates are: {usethis::ui_value(path)}")
    return(FALSE)
  }
}

#' A list of functions to detect entrypoints.
#'
#' At the moment only reproduce_make is available.
#'
#' @details `reproduce_make` detects make as an entrypoint if there is a Makefile at top level.
#' If it does also encounter a Makefile_Docker somewhere it recognizes the different make instructions.
#' @name reproduce_funs
#' @seealso reproduce
#' @export
reproduce_funs <- list(reproduce_make)