test_that("rerun is identical with reproduce", {
  opts <- options()
  scoped_temporary_project()
  repro_template(".")
  automate()
  expect_equal(suppressWarnings(rerun(cache = TRUE)), reproduce(cache = TRUE))
  expect_equal(suppressWarnings(rerun(cache = FALSE)), reproduce(cache = FALSE))
  options(opts)
})

test_that("rerun warns about deprication", {
  opts <- options()
  scoped_temporary_project()
  repro_template(".")
  automate()
  expect_warning(rerun(cache = TRUE), "deprecated")
  expect_warning(rerun(cache = TRUE), "renamed")
  options(opts)
})