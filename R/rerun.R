#' Find entrypoint for analysis and suggest how to reproduce it.
#'
#' `rerun()` was renamed to [`reproduce()`]. `rerun()` is deprecated.
#'
#' @param ... passed to [`reproduce()`].
#' @seealso reproduce_funs
#' @name rerun
#' @export

rerun <- function(...){
  usethis::ui_warn("{usethis::ui_code('rerun()')} is deprecated/renamed.\nUse {usethis::ui_code('reproduce()')} instead.")
  reproduce(...)
}