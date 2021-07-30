context("Test automate stuff")
test_that("docker automate works", {
  op <- options()
  scoped_temporary_project()
  cat(test_rmd1, file = "test.Rmd")
  fs::dir_create("test")
  cat(test_rmd2, file = "test/test2.Rmd")
  automate()
  expect_proj_dir(".repro")
  expect_proj_file(".repro", "Dockerfile_base")
  expect_proj_file(".repro", "Dockerfile_packages")
  expect_proj_file(".repro", "Dockerfile_manual")
  expect_proj_file(".repro", "Makefile_Docker")
  expect_proj_file("Dockerfile")
  expect_proj_file("Makefile")
  expect_proj_file(".dockerignore")
  options(op)
})

test_that("the inference of the resulting file of an Rmd works", {
  expect_equal(get_output_file("test.Rmd", "html_document"), "test.html")
  expect_equal(get_output_file("test.Rmd", "pdf_document"), "test.pdf")
  expect_equal(get_output_file("test.Rmd", "slidy_presentation"), "test.html")
  expect_equal(get_output_file("test.Rmd", "rmarkdown::pdf_document"), "test.pdf")
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
  op <- options()
  scoped_temporary_project()
  automate_dir()
  expect_proj_dir(".repro")
  options(op)
})

test_that("automate doesn't fail when there is no RMD", {
  op <- options()
  scoped_temporary_project()
  automate()
  expect_proj_dir(".repro")
  expect_proj_file(".repro", "Dockerfile_base")
  expect_proj_file(".repro", "Dockerfile_packages")
  expect_proj_file(".repro", "Dockerfile_manual")
  expect_proj_file(".repro", "Makefile_Docker")
  expect_proj_file("Dockerfile")
  expect_proj_file("Makefile")
  options(op)
})

test_that("automate doesn't fail when the RMD has no output", {
  opts <- options()
  scoped_temporary_project()
  test_rmd1_no_out <- strsplit(test_rmd1, "\n", fixed = TRUE)[[1]]

  test_rmd1_no_out <- test_rmd1_no_out[!grepl("output", test_rmd1_no_out)]
  cat(test_rmd1_no_out, file = "test.Rmd", sep = "\n")
  automate()
  expect_proj_dir(".repro")
  expect_proj_file(".repro", "Dockerfile_base")
  expect_proj_file(".repro", "Dockerfile_packages")
  expect_proj_file(".repro", "Dockerfile_manual")
  expect_proj_file(".repro", "Makefile_Docker")
  expect_proj_file(".repro", "Makefile_Rmds")
  expect_proj_file("Dockerfile")
  expect_proj_file("Makefile")
  options(opts)
})

test_that("automate doesn't require scripts or data or packages", {
  opts <- options()
  dir <- scoped_temporary_project()
  cat(test_rmd3, file = "test.Rmd")
  automate()
  expect_proj_dir(".repro")
  expect_proj_file(".repro", "Dockerfile_base")
  expect_proj_file(".repro", "Dockerfile_packages")
  expect_proj_file(".repro", "Dockerfile_manual")
  expect_proj_file(".repro", "Makefile_Docker")
  expect_proj_file(".repro", "Makefile_Rmds")
  expect_proj_file("Dockerfile")
  expect_proj_file("Makefile")
  expect_equal(do.call(yaml_to_make, get_yamls(".")[[1]]),
               "test.html: test.Rmd\n\t$(RUN1) Rscript -e 'rmarkdown::render(\"$(WORKDIR)/$<\", \"all\")' $(RUN2)")
  makefile_rmds <- readLines(".repro/Makefile_Rmds")
  expect_identical(makefile_rmds[[1]],
                   "test.html: test.Rmd")
  expect_identical(makefile_rmds[[2]],
                   "\t$(RUN1) Rscript -e 'rmarkdown::render(\"$(WORKDIR)/$<\", \"all\")' $(RUN2)")
  options(opts)
})

test_that("automate identifies other dependencies like bibliography etc.", {
  opts <- options()
  dir <- scoped_temporary_project()
  cat(test_rmd4, file = "test.Rmd")
  automate()
  expect_equal(do.call(yaml_to_make, get_yamls(".")[[1]]),
               "test.html: test.Rmd mtcars.csv analyze.R plots.R temp.bib images/test.jpg test.zip\n\t$(RUN1) Rscript -e 'rmarkdown::render(\"$(WORKDIR)/$<\", \"all\")' $(RUN2)")
  makefile_rmds <- readLines(".repro/Makefile_Rmds")
  expect_identical(makefile_rmds[[1]],
                   "test.html: test.Rmd mtcars.csv analyze.R plots.R temp.bib images/test.jpg test.zip")
  expect_identical(makefile_rmds[[2]],
                   "\t$(RUN1) Rscript -e 'rmarkdown::render(\"$(WORKDIR)/$<\", \"all\")' $(RUN2)")
  options(opts)
})
