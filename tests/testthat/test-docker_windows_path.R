context("Test windows path for Docker")
test_that("path generation works", {
  expect_equal(docker_windows_path("C:/Users/someuser/Documents/myproject/"),
               "//c/Users/someuser/Documents/myproject/")
})

test_that("path recognizes non windows paths", {
  expect_error(docker_windows_path("/Users/someuser/Documents/myproject/"))
  expect_error(docker_windows_path("C:/C:/Users/someuser/Documents/myproject/"))
})