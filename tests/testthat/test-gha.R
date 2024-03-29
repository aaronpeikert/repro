test_that("github action is created only when Dockerfile exists", {
  op <- options()
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  expect_oops(use_gha_docker())
  expect_oops(use_gha_publish())
  automate()
  expect_oops(use_gha_publish())
  expect_ok(use_gha_docker())
  expect_ok(use_gha_publish())
  expect_proj_file(getOption("repro.gha.docker"))
  expect_proj_file(getOption("repro.gha.publish"))
  options(op)
})
