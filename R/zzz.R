.onLoad <- function(...){
  op <- options()
  op.repro <- list(
    repro.docker = NA,
    repro.make = NA,
    repro.git = NA,
    repro.choco = NA,
    repro.brew = NA,
    repro.os = NA
    )
  toset <- !(names(op.repro) %in% names(op))
  if(any(toset)) options(op.repro[toset])
  invisible()
}

.onAttach <- function(...){
  packageStartupMessage(
    usethis::ui_info(
      "repro is BETA software! Please report any bugs:
    {usethis::ui_value('https://github.com/aaronpeikert/repro/issues')}")
  )
}

get_os <- function(){
  sysinf <- Sys.info()
  if(is.na(getOption("repro.os"))){
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
    os <- tolower(os)
    options(repro.os = os)
    return(os)
  } else {
    return(getOption("repro.os"))
  }
}

silent_command <- function(...){
  suppressMessages(suppressWarnings(system2(..., stdout = tempfile(), stderr = tempfile())))
}
