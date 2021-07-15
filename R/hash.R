#' Report Current Hash
#'
#' Find out what the currently checked out commit is and report its respective
#' hash.
#'
#' @param length The length to which the hash is cut.
#' @param backend Can be either of `NULL`, "gert", or "git". If `NULL` Git is
#'   used with preference and `gert` as a fallback.
#' @export

current_hash <- function(length = 7L, backend = NULL) {
  if (is.null(backend)) {
    if (has_git())
      backend <- "git"
    else if (has_gert())
      backend <- "gert"
    else
      usethis::ui_stop("Neither Git nor the gert package detected.")
  } else {
    if (!isTRUE(backend %in% c("git", "gert")))
      usethis::ui_stop("{usethis::ui_code('backend')} is neither \"git\" nor \"gert\".")
  }
  if (backend == "git") {
    hash <-
        suppressWarnings(system2(
          "git",
          c("rev-parse", "HEAD"),
          stdout = TRUE,
          stderr = TRUE
        ))
    if(isFALSE(is.null(attr(hash, "status"))))usethis::ui_stop("Maybe not a Git repository.")
  } else {
    hash <- gert::git_commit_id()
  }
  strtrim(hash, length)
}
