.onAttach <- function(...){
  packageStartupMessage(
    usethis::ui_info(
    "repro is BETA software! Please report any bugs:
    {usethis::ui_value('https://github.com/aaronpeikert/repro/issues')}")
  )
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
