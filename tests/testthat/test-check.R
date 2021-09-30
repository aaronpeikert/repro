context("Test the different checking functions.")

test_that("options set to TRUE are recognized.", {
  withr::with_options(
    list(
      repro.docker = TRUE,
      repro.make = TRUE,
      repro.git = TRUE,
      repro.choco = TRUE,
      repro.brew = TRUE,
      repro.renv = TRUE,
      repro.targets = TRUE,
      repro.worcs = TRUE
    ),
    {
      expect_ok(check_docker())
      expect_ok(check_make())
      expect_ok(check_git())
      expect_ok(check_choco())
      expect_ok(check_brew())
      expect_ok(check_renv())
      expect_ok(check_targets())
      expect_ok(check_worcs())

      expect_true(check_docker())
      expect_true(check_make())
      expect_true(check_git())
      expect_true(check_choco())
      expect_true(check_brew())
      expect_true(check_renv())
      expect_true(check_targets())
      expect_true(check_worcs())
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
      repro.renv = FALSE,
      repro.targets = FALSE,
      repro.worcs = FALSE,
      repro.os = "linux"
    ),
    {
      expect_oops(check_docker())
      expect_oops(check_make())
      expect_oops(check_git())
      expect_oops(check_choco())
      expect_oops(check_brew())
      expect_oops(check_renv())
      expect_oops(check_targets())
      expect_oops(check_worcs())

      expect_false(check_docker())
      expect_false(check_make())
      expect_false(check_git())
      expect_false(check_choco())
      expect_false(check_brew())
      expect_false(check_renv())
      expect_false(check_targets())
      expect_false(check_worcs())
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
  dangerous_hello <- dangerous(hello, getOption("repro.pkgtest"))
  expect_usethis_error(dangerous_hello())
  expect_usethis_error(has_git())
})

test_that("github function recognize options set to FALSE", {
  withr::with_options(list(
    repro.git = FALSE,
    repro.ssh = FALSE,
    repro.github.ssh = FALSE,
    repro.github.token = FALSE,
    repro.os = "linux"), {
      expect_false(check_ssh(install = FALSE))
      expect_false(check_github_ssh())
      expect_false(check_github_token(install = FALSE))
      expect_false(check_github())

      expect_oops(check_ssh(install = FALSE))
      expect_oops(check_github_ssh())
      expect_oops(check_github_token(install = FALSE))
      expect_oops(check_github())
      })
})

test_that("github function recognize options set to TRUE", {
  withr::with_options(list(
    repro.git = TRUE,
    repro.ssh = TRUE,
    repro.github.ssh = TRUE,
    repro.github.token = TRUE,
    repro.os = "linux"), {
      expect_true(check_ssh())
      expect_true(check_github_ssh())
      expect_true(check_github_token())
      expect_true(check_github())

      expect_ok(check_ssh())
      expect_ok(check_github_ssh())
      expect_ok(check_github_token())
      expect_ok(check_github())
    })
})

test_that("github function works token only", {
  withr::with_options(list(
    repro.git = TRUE,
    repro.ssh = FALSE,
    repro.github.ssh = FALSE,
    repro.github.token = TRUE,
    repro.os = "linux"), {
      expect_false(check_ssh())
      expect_false(check_github_ssh())
      expect_true(check_github_token())
      expect_true(check_github())

      expect_oops(check_ssh())
      expect_oops(check_github_ssh())
      expect_ok(check_github_token())
      expect_ok(check_github())
    })
})

test_that("github function works ssh only", {
  withr::with_options(list(
    repro.git = TRUE,
    repro.ssh = TRUE,
    repro.github.ssh = TRUE,
    repro.github.token = FALSE,
    repro.os = "linux"), {
      expect_true(check_ssh())
      expect_true(check_github_ssh())
      expect_false(check_github_token())
      expect_true(check_github(auth_method = "ssh"))

      expect_ok(check_ssh())
      expect_ok(check_github_ssh())
      expect_oops(check_github_token())
      expect_ok(check_github(auth_method = "ssh"))
    })
})

test_that("check functions return invisibly", {
  withr::with_options(
    list(
      repro.docker = TRUE,
      repro.make = TRUE,
      repro.git = TRUE,
      repro.choco = TRUE,
      repro.brew = TRUE,
      repro.ssh = TRUE,
      repro.github.ssh = TRUE,
      repro.github.token = TRUE,
      repro.os = "linux",
      repro.renv = TRUE,
      repro.targets = TRUE,
      repro.worcs = TRUE
    ),
    {
      check_funs <- stringr::str_subset(ls("package:repro"), "^check_")
      check_funs <- check_funs[!stringr::str_detect(check_funs, "^check_package")]
      lapply(check_funs, function(x)eval(bquote(expect_invisible(do.call(.(x), list())))))
    })
})
