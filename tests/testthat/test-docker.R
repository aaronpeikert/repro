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
  expect_warning(use_docker_packages("usethis",
                                     github = TRUE,
                                     open = FALSE),
                 NA)
})

test_that("docker_entry_install returns only characters", {
  expect_length(docker_entry_install("test",
                                     "installGithub.r"), 2L)

  expect_length(docker_entry_install(c("test", "another_test"),
                                     "installGithub.r"), 3L)

  expect_identical(docker_entry_install("test",
                                        "installGithub.r"),
                   c("RUN installGithub.r \\ ", "  test"))

  expect_identical(docker_entry_install(c("test", "another_test"),
                                     "installGithub.r"),
                c("RUN installGithub.r \\ ", "  test \\ ", "  another_test"))
})

test_that("use_docker_packages actually adds them to the Dockerfile", {
  scoped_temporary_package()
  use_docker()
  use_docker_packages(c("test1", "test2"))
  dockerfile <- readLines("Dockerfile")
  expect_match(dockerfile, "test1", all = FALSE)
  expect_match(dockerfile, "test2", all = FALSE)
})

test_that("docker entry only appends stuff", {
  scoped_temporary_package()
  use_docker()
  dockerfile1 <- readLines("Dockerfile")
  docker_entry("test", write = TRUE, open = TRUE, append = TRUE)
  dockerfile2 <- readLines("Dockerfile")
  expect_identical(dockerfile1, dockerfile2[-length(dockerfile2)])
  expect_identical(dockerfile2[length(dockerfile2)], "test")

  dockerfile3 <- docker_entry("test", write = FALSE, open = TRUE, append = TRUE)
  expect_identical(dockerfile3, c(dockerfile2, "test"))
})

test_that("docker_get extracts correct lines", {
  scoped_temporary_project()
  cat(dockerfile, file = "Dockerfile")
  expect_identical(docker_get_packages(),
                   c("anytime", "dplyr", "lubridate", "readr", "usethis"))
})
