#' @export
rerun <- function(fun, ..., cache = FALSE){
  dots <- list(...)
  if(missing(fun) && length(dots) == 0L)funs <- repro::rerun_funs
  else funs <- c(list(fun), list(...))
  rerun_(funs, args = list(cache = cache))
}

rerun_ <- function(funs, args){
  if(missing(args)) {
    # no args case
    for(f in funs) {
      if(isTRUE(do.call(f, list()))) break
    }
  } else {
    # at least one arg
    if(length(args) == 1L) {
      args <- rep(args, length(funs))
    }
    stopifnot(length(funs) == length(args))
    for(i in seq_along(funs)){
      if(isTRUE(do.call(funs[[i]], args[i]))) break
    }
  }
  return(invisible(NULL))
}

dir_ls <- function(...){
  dots <- list(...)
  stopifnot(any(c("regexp", "glob") %in% names(dots)))
  dots$all <- TRUE
  dots$type <- "file"
  dots$recurse <- TRUE
  do.call(fs::dir_ls, dots)
}

file_is_somewhere <- function(file, ...){
  stopifnot(is.character(file), length(file) == 1)
  isTRUE(fs::file_exists(dir_ls(regexp = stringr::str_c(".*/", file, "$"))))
}

return_t <- function(...){
  dots <- list(...)
  message("return_t was called.")
  if(length(dots) > 0)message("I got: ", names(list(...)))
  return(TRUE)
}

return_f <- function(...){
  dots <- list(...)
  message("return_f was called.")
  if(length(dots) > 0)message("I got: ", names(list(...)))
  return(FALSE)
}

#' @export
rerun_funs <- list(return_f, return_f, return_t, return_f)

#' @export
rerun_make <- function(path, cache, silent = FALSE){
  if(missing(path))path <- dir_ls(regexp = "^Makefile$")
  if(verify_rerun_candidates(path, silent = silent)){
    command <- "make "
    if(isFALSE(cache))command <- stringr::str_c(command, "-B ")
    if(file_is_somewhere("Makefile_Docker")){
      command <- stringr::str_c("make docker &&\n", command, "DOCKER=TRUE ")
    }
    usethis::ui_todo("To reproduce this project you have to run the following code block in a terminal:")
    usethis::ui_code_block(command)
  }
  return(invisible(verify_rerun_candidates(path)))
}

#' @export
verify_rerun_candidates <- function(path, silent = TRUE){
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