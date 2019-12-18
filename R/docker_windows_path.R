#' Genereate the weird format for docker on windows.
#' @param path Some windows path. If NULL the current directory.
docker_windows_path <- function(path = NULL){
  if(is.null(path))path <- usethis::proj_path()
  path <- stringr::str_split(path, ":")[[1]]
  if(length(path) != 2L)usethis::ui_stop("This does not seem to be a Windows path.")
  path[[1]] <- stringr::str_c("//", stringr::str_to_lower(path[[1]]))
  stringr::str_c(path[[1]], path[[2]])
}
