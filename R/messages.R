msg_restart <- function(consider = TRUE){
  if(consider)usethis::ui_todo("Consider restarting your computer.")
  else usethis::ui_todo("Restart your computer.")
}

msg_restart_r <- function(consider = TRUE){
  if(consider)usethis::ui_todo("Consider restarting R (command/ctrl + shift + F10).")
  else usethis::ui_todo("Restart R (command/ctrl + shift + F10).")
}

msg_installed <- function(what, installed = TRUE) {
  if (isTRUE(installed)) {
    usethis::ui_done("{what} is installed, don't worry.")
  } else if (isFALSE(installed)) {
    usethis::ui_oops("{what} is not installed.")
  } else {
    usethis::ui_oops("Something is wrong with {what}.")
  }
  return(invisible(installed))
}

msg_ssh_keys <- function(what, installed){
  if (isTRUE(installed))usethis::ui_done("You have SSH-keys, don't worry.")
  else usethis::ui_oops("You have no SSH-keys.")
}

msg_github_token <- function(what, installed){
  if (isTRUE(installed))usethis::ui_done("You have a GitHub token, don't worry.")
  else usethis::ui_oops("You have no GitHub token.")
}

msg_github_ssh <- function(what, installed){
  if (isTRUE(installed))usethis::ui_done("You have SSH access to GitHub, don't worry.")
  else if (isFALSE(installed))usethis::ui_oops("You have no access to GitHub.")
  else usethis::ui_oops("You have currently no access to GitHub.")
}

msg_docker_running <- function(what, installed){
  if(isTRUE(installed))usethis::ui_done("You are inside a Docker containter!")
  else usethis::ui_oops("You are *not* inside a Docker container!")
}

msg_service <- function(what, installed){
  if(isTRUE(installed))usethis::ui_done("You and {what} are on good terms, don't worry.")
  else usethis::ui_oops("Your {what} configuration is slightly off.")
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

msg_rerun <- function(what, why = "."){
  usethis::ui_todo("You may want to rerun {usethis::ui_code(what)}{why}")
}

msg_reproduce <- function(command){
  usethis::ui_todo("To reproduce this project, run the following code in a terminal:")
  usethis::ui_code_block(command)
}
