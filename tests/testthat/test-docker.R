context("Test docker or Dockerfile related function.")

test_that("use_docker creates a Dockerfile",{
  scoped_temporary_project()
  use_docker()
  expect_proj_file("Dockerfile")
})

test_that("use_docker_packages fails if there is no Dockerfile",{
  scoped_temporary_project()
  expect_oops(use_docker_packages("here"))
})

test_that("use_docker_packages warns about github packages",{
  scoped_temporary_project()
  use_docker()
  # should warn about no github=TRUE
  expect_warning(use_docker_packages("r-lib/usethis@b2e894e", open = FALSE),
                 "github = TRUE")
  # should warn about missing fixed version
  expect_error(
    use_docker_packages("r-lib/usethis",
                        github = TRUE,
                        open = FALSE),
    "fixed version",
    class = "usethis_error"
  )
  # shouldn't warn about anything
  expect_warning(use_docker_packages("r-lib/usethis@b2e894e",
                                     github = TRUE,
                                     open = FALSE),
                 NA)
})

test_that("docker_entry_install returns only characters", {
  expect_length(docker_entry_install("test",
                                     "installGithub.r",
                                     collapse = FALSE), 2L)

  expect_length(docker_entry_install(c("test", "another_test"),
                                     "installGithub.r",
                                     collapse = FALSE), 3L)

  expect_length(docker_entry_install(c("test", "another_test"),
                                     "installGithub.r",
                                     collapse = TRUE), 1L)
  expect_match(docker_entry_install(c("test", "another_test"),
                                     "installGithub.r",
                                     collapse = TRUE),
                "test")
  expect_match(docker_entry_install(c("test", "another_test"),
                                    "installGithub.r",
                                    collapse = TRUE),
               "another_test")
})
