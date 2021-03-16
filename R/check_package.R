#' Check if package exists
#'
#' @param pkg Which package are we talking about?
#' @param install Should we install the package in case its missing?
#' @param github A github username/package from which the package is installed.
#' If NULL (the default) CRAN (or whatever repo) you have set is used.
#' @family checkers
#' @export

check_package <- function(pkg, install = getOption("repro.install"), github){
  check_package_factory(pkg, github)(install = install)
}

check_package_factory <- function(pkg, github = NULL) {
  function(install = getOption("repro.install")) {
    if (!has_factory_package(pkg)(silent = FALSE)) {
      if (install == "ask" && is.character(github)) {
        install <-
          !usethis::ui_nope(
            "Do you want to install the {usethis::ui_code(pkg)}-package from github.com/{github}?"
          )
      } else if (install == "ask") {
        install <-
          !usethis::ui_nope("Do you want to install the {usethis::ui_code(pkg)}-package?")
      }
      if (install) {
        if (is.character(github) &&
            check_package_factory("remotes", github = NULL)(install = install)) {
          options(repro.ssh = dangerous_succeeds(remotes::install_github)(github))
        } else {
          options(repro.ssh = dangerous_succeeds(utils::install.packages)(pkg))
        }
        msg_restart_r()
        msg_rerun(
          glue::glue("check_{pkg}()"),
          glue::glue(" to verify that {usethis::ui_code(pkg)} is installed.")
        )
      }
    }
    invisible(has_factory_package(pkg)())
  }
}

#' @rdname check
#' @export
check_renv <- check_package_factory("renv")

#' @rdname check
#' @export
check_targets <- check_package_factory("targets", "wlandau/targets")

#' @rdname check
#' @export
check_worcs <- check_package_factory("worcs", "cjvanlissa/worcs")
