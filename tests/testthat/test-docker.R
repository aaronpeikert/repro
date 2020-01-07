context("Test docker or Dockerfile related function.")

test_that("use_docker creates a Dockerfile",{
  scoped_temporary_project()
  use_docker()
  expect_proj_file("Dockerfile")
})
