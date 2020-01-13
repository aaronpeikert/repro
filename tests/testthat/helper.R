expect_unicode_message <- function(object, match, label = NULL){
  withr::with_options(c(crayon.enabled = FALSE), {
    act <- testthat:::quasi_capture(rlang::enquo(object), label, testthat::capture_messages)
    })
  expect(
    any(stringr::str_detect(act$cap, match)),
    glue::glue("Nothing in:
               '{stringr::str_sub(act$cap)}'
               does not match:
               '{stringi::stri_unescape_unicode(match)}'.")
  )
  invisible(act$cap)
}
expect_ok <- function(object){
  expect_unicode_message(object, "^\\u2714")
}
expect_oops <- function(object){
  expect_unicode_message(object, "^\\u2716")
}
