read_yaml <- function(path, ...){
  x <- readLines(path)
  yaml_ind <- stringr::str_which(x, "^---[[:space:]]*")
  if(length(yaml_ind) == 0L)return(NULL)
  stopifnot(length(yaml_ind) == 2L)
  stripped <- stringr::str_c(x[seq(yaml_ind[[1]] + 1, yaml_ind[[2]] - 1)],
                      collapse = "\n")
  yaml <- yaml::read_yaml(text = stripped, ...)
  return(yaml)
}

yaml_repro <- function(yaml){
  if("repro" %in% names(yaml)){
    out <- yaml$repro
  } else {
    if("repro" %in% names(yaml$params)){
      out <- yaml$params$repro
    } else{
      return(NULL)
    }
  }
  if("output" %in% names(yaml)){
    if(is.character(yaml$output))out$output <- yaml$output
    if(is.list(yaml$output))out$output <- names(yaml$output)
  }
  return(out)
}

get_yamls <- function(path = ".", ...){
  rmds <- fs::dir_ls(path, recurse = TRUE, glob = "*.Rmd")
  ymls <- lapply(rmds, read_yaml, ...)
  ymls <- lapply(ymls, yaml_repro)
  if(length(ymls) > 0)ymls[sapply(ymls, is.null)] <- NULL
  ymls <- lapply(names(ymls), function(x)c(list(file = x), ymls[[x]]))
  ymls
}

get_yamls_thing <- function(path = ".", what, ...){
  ymls <- get_yamls(path, ...)
  things <- lapply(ymls, function(x)x[[what]])
  things
}

yamls_packages <- function(path = ".", ...){
  packages_list <- get_yamls_thing(path, "packages", ...)
  if(length(unlist(packages_list)) == 0L)return(NULL)
  package_lengths <- vapply(packages_list, function(x)length(x), FUN.VALUE = vector("integer", 1L))
  packages <- unlist(packages_list[order(package_lengths, decreasing = TRUE)])
  if(!is.character(packages))usethis::ui_oops("Something seems to be wrong with the package specification in one of the RMarkdowns.")
  return(packages)
}

yamls_apt <- function(path = ".", ...){
  packages_list <- get_yamls_thing(path, "apt", ...)
  if(length(unlist(packages_list)) == 0L)return(NULL)
  package_lengths <- vapply(packages_list, function(x)length(x), FUN.VALUE = vector("integer", 1L))
  packages <- unlist(packages_list[order(package_lengths, decreasing = TRUE)])
  if(!is.character(packages))usethis::ui_oops("Something seems to be wrong with the apt specification in one of the RMarkdowns.")
  return(packages)
}

yaml_repro_current <- function() {
  if (length(yaml_repro(rmarkdown::metadata)) > 0L) {
    return(yaml_repro(rmarkdown::metadata))
  } else{
    if (exists("params"))
      yml <- get("params")
    else {
      if (requireNamespace("rstudioapi", quietly = TRUE)) {
        yml <- read_yaml(rstudioapi::getSourceEditorContext()$path)
      } else {
        usethis::ui_warn(
          "Can not find out where you currently are. Please install {usethis::ui_code('rstudioapi')}."
        )
        return(NULL)
      }
    }
  }
  yaml_repro(yml)
}
