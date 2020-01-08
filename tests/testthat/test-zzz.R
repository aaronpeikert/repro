test_that("onload sets options to na", {
  expect_equal(2 * 2, 4)
  expect_invisible(.onLoad())
  expect_true(is.na(getOption("repro.docker")))
  expect_true(is.na(getOption("repro.make")))
  expect_true(is.na(getOption("repro.git")))
  expect_true(is.na(getOption("repro.choco")))
  expect_true(is.na(getOption("repro.brew")))
  expect_true(is.na(getOption("repro.os")))
})

test_that("onAttach sends a message", {
  expect_output(.onAttach())
})

test_that("silent_command is silent", {
  expect_output(silent_command("ls"), NA)
})