#' Check Homewbrew
#'
#' Check if Homewbrew is installed and if not it recommends how to install it.
#' @param install Should we give recommendations on the installation?
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
