test_rmd1 <- '
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

test_rmd2 <- '
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
