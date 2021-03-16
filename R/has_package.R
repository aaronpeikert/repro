#' Check if package exists
#'
#'
#' @param pkg Which package are we talking about?
#' @inheritParams has
#' @family checkers
#' @export
has_package <- function(pkg, silent = TRUE, force_logical = TRUE){
  has_factory_package(pkg)(silent = silent, force_logical = silent)
}

has_factory_package <- function(pkg){
  has_factory(pkg,
              stringr::str_c("repro.", pkg),
              function()requireNamespace(pkg, quietly = TRUE))
}

#' @rdname has
#' @export
has_renv <- has_factory_package("renv")

#' @rdname has
#' @export
has_targets <- has_factory_package("targets")

#' @rdname has
#' @export
has_targets <- has_factory_package("worcs")