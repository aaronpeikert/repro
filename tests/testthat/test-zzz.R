test_that("onload sets options to na", {
  expect_invisible(.onLoad())
  expect_true(is.na(getOption("repro.docker")))
  expect_true(is.na(getOption("repro.make")))
  expect_true(is.na(getOption("repro.git")))
  expect_true(is.na(getOption("repro.choco")))
  expect_true(is.na(getOption("repro.brew")))
  expect_true(is.na(getOption("repro.os")))
})

test_that("onAttach sends a message", {
  expect_message(.onAttach())
})

test_that("onAttach is returns invisibly", {
  expect_invisible(.onAttach())
})

test_that("silent_command is silent", {
  expect_output(silent_command("ls"), NA)
})

test_that("get_os() fails while testing.",{
  expect_error(get_os(), regexp = "testing")
})