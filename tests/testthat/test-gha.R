test_that("uses works", {
  op <- options()
  scoped_temporary_project()
  use_github_action_docker()
  expect_proj_file()
  options(op)
})
