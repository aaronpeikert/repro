context("Test yaml related functions")
test_file1 <- '
---
title: "Test"
author: "Aaron Peikert"
date: "1/13/2020"
output: html_document
repro:
  packages:
    - dplyr
    - usethis
    - anytime
  data:
    - iris.csv
  scripts:
    - load.R
    - clean.R
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

'

test_file2 <- '
---
title: "Test2"
author: "Aaron Peikert"
date: "1/13/2020"
output: html_document
repro:
  packages:
    - lubridate
    - readr
  data:
    - mtcars.csv
  scripts:
    - analyze.R
    - plots.R
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

'

test_that("yaml is corectly read", {
  scoped_temporary_project()
  cat(test_file1, file = "test.Rmd")
  expect_identical(names(read_yaml("test.Rmd")),
                   c("title", "author", "date", "output", "repro"))
  expect_identical(names(yaml_repro("test.Rmd")),
                   c("packages", "data", "scripts"))
})

test_that("packages are recognized", {
  scoped_temporary_project()
  cat(test_file1, file = "test.Rmd")
  fs::dir_create("test")
  cat(test_file2, file = "test/test2.Rmd")
  packages <- yamls_packages()
  expect_true(all(c("dplyr", "usethis", "anytime", "lubridate", "readr") %in%
                    packages))
})