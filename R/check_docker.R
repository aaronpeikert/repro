#' Check Docker
#'
#' Check if docker is installed and if not it recommends how to install it
#' depending on the operating system.
#' @param install Should we give recommendations on the installation?
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
        usethis::ui_todo("Restart your computer.")
      } else if(get_os() == "osx"){
        usethis::ui_info("We recommend Homebrew for OS X users.")
        check_brew()
        usethis::ui_todo("Run {usethis::ui_code('brew cask docker')} in an admin terminal to install docker.")
        usethis::ui_todo("Restart your computer.")
      } else if(get_os() == "linux"){
        usethis::ui_info("Adapt to your native package manager (deb, rpm, brew, csw, eopkg).")
        usethis::ui_info("You may need admin-rights, use {usethis::ui_code('sudo apt install docker')} in this case.")
        usethis::ui_todo("Run {usethis::ui_code('apt install docker')} in a terminal to install docker.")
        usethis::ui_todo("Add your user to the docker user group. Follow instructions on {usethis::ui_value('https://docs.docker.com/install/linux/linux-postinstall/')}")
        usethis::ui_todo("Restart your computer.")
      }
    }
  }
}
