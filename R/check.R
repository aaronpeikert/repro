#' Check System Dependencies
#'
#' Check if a dependency is installed and if not it recommends how to install it
#' depending on the operating system. Most importantly it checks for
#' `git`, `make` & `docker`. And just for convenience of the installation it
#' checks on OS X for `Homebrew` and on Windows for `Chocolately`.
#' @param install Should something be installed? Defaults to "ask", but can be TRUE/FALSE.
#' @name check
#' @family checkers
NULL

#' @rdname check
#' @export
check_docker <- function(){
  if(has_docker_running())has_docker_running(silent = FALSE)
  else if(!has_docker(silent = FALSE)){
    msg_install_with_choco("Docker", "choco install -y docker-desktop")
    msg_install_with_brew("Docker", "brew cask install docker", {
      usethis::ui_todo("Open 'Docker'/'Docker Desktop for Mac' once to make it available.")
    })
    msg_install_with_apt("Docker", "apt install docker", {
      usethis::ui_todo("Add your user to the docker user group. Follow instructions on:\n{usethis::ui_value('https://docs.docker.com/install/linux/linux-postinstall/')}")
      })
    msg_restart()
    usethis::ui_info("For more infos visit:\n{usethis::ui_value('https://docs.docker.com/install/')}")
  }
  invisible(has_docker())
}

#' @rdname check
#' @export

check_make <- function(){
  if(!has_make(silent = FALSE)){
    choco <- "Chocolately"
    msg_install_with_choco(choco, "choco install -y make")
    msg_install_with_brew(choco, "brew install make")
    msg_install_with_apt(choco, "apt install make")
    msg_restart()
  }
  invisible(has_make())
}

#' @rdname check
#' @export
check_git <- function(){
  if(!has_git(silent = FALSE)) {
    msg_install_with_choco("Git", "choco install -y git")
    msg_install_with_brew("Git", "brew install git")
    msg_install_with_apt("Git", "apt install git")
  }
  invisible(has_git())
}

#' @rdname check
#' @export
check_brew <- function(){
  if(!has_brew(silent = FALSE)){
    usethis::ui_todo("To install it, follow directions on:\n{usethis::ui_value('https://docs.brew.sh/Installation')}")
    usethis::ui_todo("Restart your computer.")
  }
  invisible(has_brew())
}

#' @rdname check
#' @export
check_choco <- function(){
  if(!has_choco(silent = FALSE)){
    usethis::ui_todo(
      "To install it, follow directions on:\n{usethis::ui_value('https://chocolatey.org/docs/installation')}"
    )
    usethis::ui_info("Use an administrator terminal to install chocolately.")
    usethis::ui_todo("Restart your computer.")
  }
  invisible(has_choco())
}

#' @rdname check
#' @export
check_ssh <- function(install = getOption("repro.install")) {
  if (!has_ssh(silent = FALSE)) {
    if (install == "ask")
      install <- !usethis::ui_nope("Do you want to generate SSH keys?")
    if (install) {
      options(repro.ssh = dangerous_succeeds(credentials::ssh_keygen)())
      msg_rerun("check_ssh()", " to verify the new ssh keys.")
    }
  }
  invisible(has_ssh())
}

#' @rdname check
#' @export
check_github_token <- function(install = getOption("repro.install")){
  if(!has_github_token(silent = FALSE)){
    if(install == "ask")install <- usethis::ui_nope("Do you want to generate a GitHub token?")
    if(install){
      usethis::browse_github_token()
      msg_rerun("check_github_token()", " to verify the new GitHub token.")
    }
  }
  invisible(has_github_token())
}

#' @rdname check
#' @export
check_github_ssh <- function() {
  if (!has_github_ssh(silent = FALSE)) {
    if (has_github_ssh(force_logical = FALSE) == "recheck_authenticity") {
      usethis::ui_todo(
        "Run {usethis::ui_code('ssh -T git@github.com')} in a terminal. Answer yes if asked."
      )
      msg_rerun("check_github_ssh()")
    } else if (!has_ssh()) {
      check_ssh()
    } else {
      usethis::ui_todo("Read {usethis::ui_value('https://happygitwithr.com/ssh-keys.html')}.")
    }
  }
  invisible(has_github_ssh())
}

#' @rdname check
#' @export
check_github <- function(){
  if (!has_n_check(has_git, check_git)) {
    msg_rerun("check_github()")
    return(FALSE)
  } else if (!has_n_check(has_ssh, check_ssh)) {
    msg_rerun("check_github()")
    return(FALSE)
  } else if (!has_n_check(has_github_ssh, check_github_ssh)) {
    msg_rerun("check_github()")
    return(FALSE)
  } else if (!has_n_check(has_github_token, check_github_token)) {
    msg_rerun("check_github()")
    return(FALSE)
  } else {
    invisible(has_github(silent = FALSE))
  }
}
