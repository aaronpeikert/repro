expect_unicode_output <- function(object, match){
  output <- capture_output(val <- object)
  expect(
    stringr::str_detect(output, match),
    glue::glue("Nothing in:
               '{stringr::str_sub(output)}'
               does not match:
               '{stringi::stri_unescape_unicode(match)}'.")
  )
  invisible(val)
}
expect_ok <- function(object){
  expect_unicode_output(object, "^\\u2714")
}
expect_oops <- function(object){
  expect_unicode_output(object, "^\\u2716")
}