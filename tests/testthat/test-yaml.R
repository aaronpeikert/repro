context("Test yaml related functions")

test_that("yaml is corectly read", {
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  expect_identical(names(read_yaml("test.Rmd")),
                   c("title", "author", "date", "output", "repro"))
  expect_identical(names(yaml_repro(read_yaml("test.Rmd"))),
                   c("packages", "data", "scripts", "output"))
})

test_that("packages are recognized", {
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  fs::dir_create("test")
  cat(test_rmd2, file = "test/test2.Rmd")
  packages <- yamls_packages()
  expect_true(all(c("dplyr", "usethis", "anytime", "lubridate", "readr") %in%
                    packages))
})

test_that("RMDs without yaml are skipped", {
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  fs::dir_create("test")
  cat(test_rmd2, file = "test/test2.Rmd")
  cat("# Title\nTextText\n", file = "test/test3.Rmd")

  packages <- yamls_packages()
  expect_true(all(c("dplyr", "usethis", "anytime", "lubridate", "readr") %in%
                    packages))
})

test_that("yaml boundaries with whitespace work", {
  scoped_temporary_project()
  test_rmd1_space <- strsplit(test_rmd1, "\n", fixed = TRUE)[[1]]
  test_rmd1_space[2] <- "--- "
  cat(test_rmd1_space, file = "test.Rmd", sep = "\n")
  expected <-
    list(
      title = "Test",
      author = "Aaron Peikert",
      date = "1/13/2020",
      output = "html_document",
      repro = list(
        packages = c("dplyr",
                     "usethis", "anytime"),
        data = "iris.csv",
        scripts = c("load.R",
                    "clean.R")
      )
    )
  expect_identical(read_yaml("test.Rmd"), expected)
})
