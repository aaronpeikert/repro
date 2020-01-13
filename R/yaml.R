read_yaml <- function(path, ...){
  x <- readLines(path)
  yaml_ind <- which(x == "---")
  stopifnot(length(yaml_ind) == 2L)
  stripped <- stringr::str_c(x[seq(yaml_ind[[1]] + 1, yaml_ind[[2]] - 1)],
                      collapse = "\n")
  yaml <- yaml::read_yaml(text = stripped, ...)
  return(yaml)
}
repro_yaml <- function(path, ...){
  yaml <- read_yaml(path, ...)
  if(!("repro" %in% names(yaml)))stop("This is not a repro-yaml.")
  yaml$repro
}