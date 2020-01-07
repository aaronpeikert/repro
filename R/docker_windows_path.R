#' Generate the weird format for docker on windows.
#' @param path Some windows path. If NULL the current directory.
#' @param todo Should an actionable advice be given. Defaults to TRUE.
#' @export
docker_windows_path <- function(path = NULL, todo = interactive()){
  if(is.null(path))path <- usethis::proj_path()
  path <- stringr::str_split(path, ":")[[1]]
  if(length(path) != 2L)usethis::ui_stop("This does not seem to be a Windows path.")
  path[[1]] <- stringr::str_c("//", stringr::str_to_lower(path[[1]]))
  out <- stringr::str_c(path[[1]], path[[2]])
  if(todo)usethis::ui_todo("Replace in {usethis::ui_value('Makefile')}:\n{usethis::ui_value('WINPATH = //c/Users/someuser/Documents/myproject/')}\nwith:\n{usethis::ui_value(stringr::str_c('WINPATH = ', out))}")
  out
}
