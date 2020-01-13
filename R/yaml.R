read_yaml <- function(path, ...){
  x <- readLines(path)
  yaml_ind <- which(x == "---")
  stopifnot(length(yaml_ind) == 2L)
  yaml <- yaml::read_yaml(text = x[seq(yaml_ind[[1]], yaml_ind[[2]])])
  return(yaml)
}
