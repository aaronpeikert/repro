hash <- withr::with_options(
  list(repro.git = TRUE,
       repro.gert = TRUE),
  current_hash())

test_that("Git and gert give same hash", {
  expect_equal(current_hash(backend = "git"), current_hash(backend = "gert"))
})

test_that("gert is recognized as fallback", {
  withr::with_options(
    list(repro.git = FALSE,
         repro.gert = TRUE),
    expect_equal(current_hash(), hash))
})

test_that("it actually fails if there is no git or gert", {
  withr::with_options(list(repro.git = FALSE,
                           repro.gert = FALSE), {
                             expect_error(current_hash(), "gert")
                             expect_error(current_hash(), "Git")
                           })
})

test_that("it fails with grace when not within a git repo", {
  withr::with_tempdir(
    withr::with_options(list(repro.git = TRUE), {
      expect_error(current_hash(backend = "git"), "Maybe not a Git repository.")
    })
  )
  withr::with_tempdir(
    withr::with_options(list(repro.gert = TRUE), {
      expect_error(current_hash(backend = "gert"), "could not find repository")
    })
  )
})
