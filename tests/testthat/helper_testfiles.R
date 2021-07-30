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

test_rmd3 <- '
---
title: "Test2"
author: "Aaron Peikert"
date: "1/13/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

'

test_rmd4 <- '
---
title: "Test4"
author: "Aaron Peikert"
date: "1/13/2020"
output: html_document
bibliography: temp.bib
repro:
  packages:
    - lubridate
    - readr
  data:
    - mtcars.csv
  scripts:
    - analyze.R
    - plots.R
  files:
    test.zip
  images:
    images/test.jpg
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.

'

dockerfile <- "FROM rocker/verse:3.6.1
ARG BUILD_DATE=2020-01-20
WORKDIR /home/rstudio
RUN install2.r --error --skipinstalled \
  anytime \
  dplyr \
  usethis
RUN install2.r --error --skipinstalled \
  anytime \
  lubridate \
  readr \
  usethis
"