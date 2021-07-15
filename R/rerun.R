#' Find entrypoint for analysis and suggest how to reproduce it.
#'
#' `rerun()` was renamed to [`reproduce()`]. `rerun()` is deprecated.
#'
#' @param fun a function that inspects `dir` and advises on how to reproduce the analysis. Defaults to [reproduce_funs].
#' @param ... more functions like `fun`.
#' @param path Were should I look for entrypoints?
#' @param cache Default is `FALSE`. Some entrypoints have a cache, which you probably do not want to use in a reproduction.
#' @param silent Should a message be presented?
#' @return Returns invisibly `TRUE` if an entrypoint was found and `FALSE` if not.
#' @seealso reproduce_funs
#' @name rerun
#' @export

rerun <- function(fun, ..., path = ".", cache = FALSE, silent = FALSE){
  usethis::ui_warn("{usethis::ui_code('rerun()')} is deprecated/renamed.\nUse {usethis::ui_code('reproduce()')} instead.")
  reproduce(fun, ..., path = ".", cache = FALSE, silent = FALSE)
}