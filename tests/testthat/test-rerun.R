test_that("rerun recognizes a standard repro project", {
  opts <- options()
  scoped_temporary_project()
  repro_template(".")
  automate()
  expect_message(rerun(cache = TRUE), regexp = "make docker")
  expect_message(rerun(cache = FALSE), regexp = "-B")
  expect_true(rerun())
  options(opts)
})

test_that("rerun recognizes a standard repro project", {
  opts <- options()
  scoped_temporary_project()
  repro_template(".")
  automate()
  file_delete(".repro/Makefile_Docker")
  expect_message(rerun(cache = TRUE), regexp = "make")
  expect_message(rerun(cache = FALSE), regexp = "-B")
  expect_true(rerun())
  options(opts)
})