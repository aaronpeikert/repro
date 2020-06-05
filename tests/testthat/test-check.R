context("Test the different checking functions.")

test_that("options set to TRUE are recognized.", {
  withr::with_options(
    list(
      repro.docker = TRUE,
      repro.make = TRUE,
      repro.git = TRUE,
      repro.choco = TRUE,
      repro.brew = TRUE
    ),
    {
      expect_ok(check_docker())
      expect_ok(check_make())
      expect_ok(check_git())
      expect_ok(check_choco())
      expect_ok(check_brew())

      expect_true(check_docker())
      expect_true(check_make())
      expect_true(check_git())
      expect_true(check_choco())
      expect_true(check_brew())
    })
})

test_that("options set to FALSE are recognized.", {
  withr::with_options(
    list(
      repro.docker = FALSE,
      repro.make = FALSE,
      repro.git = FALSE,
      repro.choco = FALSE,
      repro.brew = FALSE,
      repro.os = "linux"
    ),
    {
      expect_oops(check_docker())
      expect_oops(check_make())
      expect_oops(check_git())
      expect_oops(check_choco())
      expect_oops(check_brew())

      expect_false(check_docker())
      expect_false(check_make())
      expect_false(check_git())
      expect_false(check_choco())
      expect_false(check_brew())
    })
})

test_that("the correct instalation hint for Windows is given.", {
  withr::with_options(
    list(
      repro.docker = FALSE,
      repro.make = FALSE,
      repro.git = FALSE,
      repro.choco = FALSE,
      repro.os = "windows"
    ),
    {
      testthat::expect_message(check_docker(), "windows", ignore.case = TRUE)
      testthat::expect_message(check_docker(), "choco install", ignore.case = TRUE)
      testthat::expect_message(check_docker(), "chocolately", ignore.case = TRUE)
      testthat::expect_message(check_docker(), "docker", ignore.case = TRUE)

      testthat::expect_message(check_make(), "windows", ignore.case = TRUE)
      testthat::expect_message(check_make(), "choco install", ignore.case = TRUE)
      testthat::expect_message(check_make(), "chocolately", ignore.case = TRUE)
      testthat::expect_message(check_make(), "make", ignore.case = TRUE)

      testthat::expect_message(check_git(), "windows", ignore.case = TRUE)
      testthat::expect_message(check_git(), "choco install", ignore.case = TRUE)
      testthat::expect_message(check_git(), "chocolately", ignore.case = TRUE)
      testthat::expect_message(check_git(), "git", ignore.case = TRUE)

      testthat::expect_message(check_choco(), "choco", ignore.case = TRUE)
    }
  )
})

test_that("the correct instalation hint for OS X is given.", {
  withr::with_options(
    list(
      repro.docker = FALSE,
      repro.make = FALSE,
      repro.git = FALSE,
      repro.brew = FALSE,
      repro.os = "osx"
    ),
    {
      testthat::expect_message(check_docker(), "os x", ignore.case = TRUE)
      testthat::expect_message(check_docker(), "brew", ignore.case = TRUE)
      testthat::expect_message(check_docker(), "install", ignore.case = TRUE)
      testthat::expect_message(check_docker(), "docker", ignore.case = TRUE)


      testthat::expect_message(check_git(), "os x", ignore.case = TRUE)
      testthat::expect_message(check_git(), "brew", ignore.case = TRUE)
      testthat::expect_message(check_git(), "install", ignore.case = TRUE)
      testthat::expect_message(check_git(), "git", ignore.case = TRUE)

      testthat::expect_message(check_make(), "os x", ignore.case = TRUE)
      testthat::expect_message(check_make(), "brew", ignore.case = TRUE)
      testthat::expect_message(check_make(), "install", ignore.case = TRUE)
      testthat::expect_message(check_make(), "make", ignore.case = TRUE)

      testthat::expect_message(check_brew(), "brew", ignore.case = TRUE)
    })
})

test_that("the correct instalation hint for linux is given.", {
  withr::with_options(list(
    repro.docker = FALSE,
    repro.make = FALSE,
    repro.git = FALSE,
    repro.os = "linux"
  ),
  {
    testthat::expect_message(check_docker(), "package manager", ignore.case = TRUE)
    testthat::expect_message(check_docker(), "docker", ignore.case = TRUE)

    testthat::expect_message(check_git(), "package manager", ignore.case = TRUE)
    testthat::expect_message(check_git(), "git", ignore.case = TRUE)

    testthat::expect_message(check_make(), "package manager", ignore.case = TRUE)
    testthat::expect_message(check_make(), "make", ignore.case = TRUE)
  })
})

test_that("forbidden function raise an error", {
  hello <- function()cat("Hello")
  expect_usethis_error(call_dangerous(hello, getOption("repro.pkgtest")))
})