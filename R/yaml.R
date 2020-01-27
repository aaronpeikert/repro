read_yaml <- function(path, ...){
  x <- readLines(path)
  yaml_ind <- which(x == "---")
  stopifnot(length(yaml_ind) == 2L)
  stripped <- stringr::str_c(x[seq(yaml_ind[[1]] + 1, yaml_ind[[2]] - 1)],
                      collapse = "\n")
  yaml <- yaml::read_yaml(text = stripped, ...)
  return(yaml)
}

yaml_repro <- function(yaml){
  if("repro" %in% names(yaml)){
    return(yaml$repro)
  } else {
    if("repro" %in% names(yaml$params)){
      return(yaml$params$repro)
    } else{
      return(NULL)
    }
  }
}

yamls_packages <- function(path = ".", ...){
  rmds <- fs::dir_ls(path, recurse = TRUE, glob = "*.Rmd")
  ymls <- lapply(rmds, read_yaml, ...)
  ymls <- lapply(ymls, yaml_repro)
  packages_list <- lapply(ymls, function(x)x$packages)
  package_lengths <- vapply(packages_list, function(x)length(x), FUN.VALUE = vector("integer", 1L))
  packages <- unlist(packages_list[order(package_lengths, decreasing = TRUE)])
  if(!is.character(packages))usethis::ui_oops("Something seems to be wrong with the package specification in one of the RMarkdowns.")
  return(packages)
}

yaml_repro_current <- function() {
  if (length(yaml_repro(rmarkdown::metadata)) > 0L) {
    return(yaml_repro(rmarkdown::metadata))
  } else{
    if (exists("params"))
      yml <- params
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
