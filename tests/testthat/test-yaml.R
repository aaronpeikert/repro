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