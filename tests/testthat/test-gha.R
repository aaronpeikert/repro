test_that("github action is created", {
  op <- options()
  scoped_temporary_project()
  use_github_action_docker()
  expect_proj_file()
  options(op)
})
