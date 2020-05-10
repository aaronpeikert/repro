
<!-- README.md is generated from README.Rmd. Please edit that file -->

# repro

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/aaronpeikert/repro.svg?branch=master)](https://travis-ci.org/aaronpeikert/repro)
[![Codecov test
coverage](https://codecov.io/gh/aaronpeikert/repro/branch/master/graph/badge.svg)](https://codecov.io/gh/aaronpeikert/repro?branch=master)
[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

The goal of `repro` is to make the setup of reproducible workflows as
easy as possible. To that end it builds upon the great
[`usethis`-package](https://github.com/r-lib/usethis). `repro` currently
undergoes significant changes to support more workflows than just the
one proposed by [Peikert & Brandmaier
(2019)](https://psyarxiv.com/8xzqy/). You may want to install the
[`worcs`](https://github.com/cjvanlissa/worcs) package from CRAN for a
user-friendly workflow that meets most requirements of reproducibility
and open science.

## Installation

You can install the latest version of repro from
[GitHub](https://github.com/aaronpeikert/repro) with:

``` r
if(!requireNamespace("remotes"))install.packages("remotes")
remotes::install_github("aaronpeikert/repro")
```

## Contribution

I am more then happy if you want to contribute, but I ask you kindly to
note that the ‘repro’ project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By contributing to this project, you agree
to abide by its terms.
