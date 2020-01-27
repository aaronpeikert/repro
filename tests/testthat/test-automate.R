context("Test automate stuff")
test_that("docker automate works", {
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  fs::dir_create("test")
  cat(test_rmd2, file = "test/test2.Rmd")
  automate_docker()
  expect_proj_dir(".repro")
  expect_proj_file(".repro", "Dockerfile_base")
  expect_proj_file(".repro", "Dockerfile_packages")
  expect_proj_file(".repro", "Dockerfile_manual")
  expect_proj_file("Dockerfile")
})

test_that("automate respects options", {
  opts <- options()
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  fs::dir_create("test")
  cat(test_rmd2, file = "test/test2.Rmd")
  options(repro.dir = "somedir",
          repro.dockerfile.base = "base",
          repro.dockerfile.manual = "manual",
          repro.dockerfile.packages = "packages")
  automate_docker()
  expect_proj_dir("somedir")
  expect_proj_file("somedir", "base")
  expect_proj_file("somedir", "packages")
  expect_proj_file("somedir", "manual")
  options(opts)
})

test_that("automate dir works", {
  scoped_temporary_project()
  automate_dir()
  expect_proj_dir(".repro")
})
