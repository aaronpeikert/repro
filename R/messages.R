msg_restart <- function(consider = TRUE){
  if(consider)usethis::ui_todo("Consider restarting your computer.")
  else usethis::ui_todo("Restart your computer.")
}
msg_installed <- function(what, installed = TRUE){
  if(isTRUE(installed)){
    usethis::ui_done(stringr::str_c(what, ", is installed, don't worry."))
    return(invisible(installed))
  } else {
    usethis::ui_oops(stringr::str_c(what, ", is not installed."))
    return(invisible(installed))
  }
}

msg_install_with_choco <- function(what, how, todo, check = TRUE, windows_only = TRUE){
  if(get_os() == "windows" || !windows_only){
    usethis::ui_info("We recommend Chocolately for Windows users.")
    if(check) check_choco()
    if(!missing(how)){
      usethis::ui_todo("Run {usethis::ui_code(how)} in an admin terminal to install {what}.")
    }
    if(!missing(todo))eval(todo)
  }
  return(invisible(NULL))
}

msg_install_with_brew <- function(what, how, todo, check = TRUE, osx_only = TRUE){
  if(get_os() == "osx" || !osx_only){
    usethis::ui_info("We recommend Homebrew for OS X users.")
    if(check) check_brew()
    if(!missing(how)){
      usethis::ui_todo("Run {usethis::ui_code(how)} in an admin terminal to install {what}.")
    }
    if(!missing(todo))eval(todo)
  }
  return(invisible(NULL))
}

msg_install_with_apt <- function(what, how, todo, linux_only = TRUE){
  if(get_os() == "linux" || !linux_only){
    if(!missing(how)){
      usethis::ui_info("Adapt to your native package manager (deb, rpm, brew, csw, eopkg).")
      usethis::ui_info("You may need admin-rights, use {usethis::ui_code('sudo')} in this case.")
      usethis::ui_todo("Run {usethis::ui_code(how)} in a terminal to install {what}.")
    }
    if(!missing(todo))eval(todo)
  }
  return(invisible(NULL))
}
