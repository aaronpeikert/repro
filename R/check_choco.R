#' Check Homewbrew
#'
#' Check if Homewbrew is installed and if not it recommends how to install it.
#' @param install Should we give recommendations on the installation?
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
