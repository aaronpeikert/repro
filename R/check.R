#' Check System Dependencies
#'
#' Check if a dependency is installed and if not it recommends how to install it
#' depending on the operating system. Most importantly it checks for
#' `git`, `make` & `docker`. And just for convinience of the installation it
#' checks on OS X for `Homebrew` and on Windows for `Chocolately`.
#' @param install Should we give recommendations on the installation?
#' @name check
NULL

#' @rdname check
#' @export
check_docker <- function(install = TRUE){
  # ask for the docker version
  docker <- silent_command("docker", "-v")
  # a command that is succesfull returns in shell returns 0
  if(isTRUE(docker == 0L))usethis::ui_done("Docker is installed, don't worry.")
  else{
    usethis::ui_oops("Docker is not installed.")
    if(install){
      if(get_os() == "windows"){
        usethis::ui_info("We recommend Chocolately for Windows users.")
        check_choco()
        usethis::ui_todo("Run {usethis::ui_code('choco install -y docker-desktop')} in an admin terminal to install docker.")
        usethis::ui_todo("Consider restarting your computer.")
      } else if(get_os() == "osx"){
        usethis::ui_info("We recommend Homebrew for OS X users.")
        check_brew()
        usethis::ui_todo("Run {usethis::ui_code('brew cask docker')} in an admin terminal to install docker.")
        usethis::ui_todo("Consider restarting your computer.")
      } else if(get_os() == "linux"){
        usethis::ui_info("Adapt to your native package manager (deb, rpm, brew, csw, eopkg).")
        usethis::ui_info("You may need admin-rights, use {usethis::ui_code('sudo apt install docker')} in this case.")
        usethis::ui_todo("Run {usethis::ui_code('apt install docker')} in a terminal to install docker.")
        usethis::ui_todo("Add your user to the docker user group. Follow instructions on:\n{usethis::ui_value('https://docs.docker.com/install/linux/linux-postinstall/')}")
        usethis::ui_todo("Consider restarting your computer.")
      }
    }
  }
}

#' @rdname check
#' @export
check_make <- function(install = TRUE){
  # ask for the docker version
  make <- silent_command("make", "-v")
  # a command that is succesfull returns in shell returns 0
  if(isTRUE(make == 0L))usethis::ui_done("Make is installed, don't worry.")
  else{
    usethis::ui_oops("Make is not installed.")
    if(install){
      if(get_os() == "windows"){
        usethis::ui_info("We recommend Chocolately for Windows users.")
        check_choco()
        usethis::ui_todo("Run {usethis::ui_code('choco install -y make')} in an admin terminal to install make.")
        usethis::ui_todo("Consider restarting your computer.")
      } else if(get_os() == "osx"){
        usethis::ui_info("We recommend Homebrew for OS X users.")
        check_brew()
        usethis::ui_todo("Run {usethis::ui_code('brew cask make')} in an admin terminal to install make.")
        usethis::ui_todo("Consider restarting your computer.")
      } else if(get_os() == "linux"){
        usethis::ui_todo("Run {usethis::ui_code('apt install make')} in a terminal to install make.")
        usethis::ui_info("Adapt to your native package manager (deb, rpm, brew, csw, eopkg).")
        usethis::ui_info("You may need admin-rights, use {usethis::ui_code('sudo apt install make')} in this case.")
        usethis::ui_todo("Consider restarting your computer.")
      }
    }
  }
}

#' @rdname check
#' @export
check_git <- function(install = TRUE){
  # ask for the docker version
  make <- silent_command("git", "--version")
  # a command that is succesfull returns in shell returns 0
  if(isTRUE(make == 0L))usethis::ui_done("Git is installed, don't worry.")
  else{
    usethis::ui_oops("Git is not installed.")
    if(install){
      if(get_os() == "windows"){
        usethis::ui_info("We recommend Chocolately for Windows users.")
        check_choco()
        usethis::ui_todo("Run {usethis::ui_code('choco install -y git')} in an admin terminal to install Git.")
        usethis::ui_todo("Consider restarting your computer.")
      } else if(get_os() == "osx"){
        usethis::ui_info("We recommend Homebrew for OS X users.")
        check_brew()
        usethis::ui_todo("Run {usethis::ui_code('brew cask git')} in an admin terminal to install git")
        usethis::ui_todo("Consider restarting your computer.")
      } else if(get_os() == "linux"){
        usethis::ui_todo("Run {usethis::ui_code('apt install git')} in a terminal to install git")
        usethis::ui_info("Adapt to your native package manager (deb, rpm, brew, csw, eopkg).")
        usethis::ui_info("You may need admin-rights, use {usethis::ui_code('sudo apt install git')} in this case.")
        usethis::ui_todo("Consider restarting your computer.")
      }
    }
  }
}

#' @rdname check
#' @export
check_brew <- function(install = TRUE){
  # ask for the chocolately version
  choco <- silent_command("brew", "--version")
  if(choco == 0L){
    usethis::ui_done("Homebrew is installed.")
  } else {
    usethis::ui_oops("Homebrew is not installed.")
    if(install){
      usethis::ui_todo("To install it, follow directions on: {usethis::ui_value('https://docs.brew.sh/Installation')}")
      usethis::ui_todo("Restart your computer.")
    }
  }
}

#' @rdname check
#' @export
check_choco <- function(install = TRUE){
  # ask for the chocolately version
  choco <- silent_command("choco", "-v")
  if(choco == 0L){
    usethis::ui_done("Chocolately is installed.")
  } else {
    usethis::ui_oops("Chocolately is not installed.")
    if(install){
      usethis::ui_todo("To install it, follow directions on: {usethis::ui_value('https://chocolatey.org/install')}")
      usethis::ui_info("Use an administrator terminal to install chocolately.")
      usethis::ui_todo("Restart your computer.")
    }
  }
}
