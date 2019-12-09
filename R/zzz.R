.onAttach <- function(...){
  do.call("library", list("usethis", character.only = TRUE))
  usethis::ui_info("Attaching {usethis::ui_code('usethis')}.")
}