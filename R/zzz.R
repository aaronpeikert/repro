.onAttach <- function(...){
  do.call("library", list("usethis", character.only = TRUE))
  usethis::ui_info("Attaching {usethis::ui_code('usethis')}.")
}

get_os <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "osx"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "osx"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}

silent_command <- function(...){
  suppressMessages(suppressWarnings(system2(..., stdout = FALSE, stderr = FALSE)))
}
