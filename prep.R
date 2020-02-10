#### Instructions ####
# Unfortunatly you cannot run this script mindlessly and be fine.
# Read it carefully, execute line by line and see how your computer responds.
# Any line that does not start with '#' is meant to run in R.
# Be kind, most computers are pretty sensitive.

#### R/RStudio ####
# Have you updated your R/RStudio in the last year?
# No -> Update!!! Both!
# Not sure -> Update. Both.
# Yes -> Updating is still a good idea.
# I don't use RStudio -> I am not sure what to say ... you're on your own.
# Links for your convinience:
# https://cran.r-project.org
# https://rstudio.com/products/rstudio/download/#download

#### GitHub ####
# Do you have a GitHub Account?
# Yes -> Make sure you remember passwort and username.
# No -> Visit https://github.com/join

# Have you requested a researcher/student discount?
# Not really needed, just nice to have.
# Yes -> Cool.
# No -> Visit https://education.github.com/benefits

#### repro-package ####
if(!requireNamespace("devtools"))install.packages("devtools")
if(!requireNamespace("repro"))devtools::install_github("aaronpeikert/repro")

#### Git/Make/Docker ####
# follow instructions, rerun, if your told to not worry, do not worry.
repro::check_git()
repro::check_make()
repro::check_docker()

#### Git Setup ####
# Introduce yourself to Git. It's the polite thing to do.
# Edit name and email.
use_git_config(user.name = "Jane Doe", user.email = "jane@example.org")

#### SSH Keys ####
# We'll connect your computer/Git and GitHub in the workshop.
# If you have a moment, skim over (or go ahead eager beaver try it yourself):
# https://happygitwithr.com/ssh-keys.html

#### Wifi ####
# You'll need internet access at the location of the workshop.
# Your best bet is to have a working eduroam configuration.
# If you're not 100% sure you'll have internet, come early, we'll figure it out.

#### This doesn't work ####
# If you right now hate any of the following:
# * me
# * your computer
# * yourself
# * the world
# Or it simply doesn't work:
# It's okay, we all have been there. Keep calm, do these three things:
# 1. raise an isse: https://github.com/aaronpeikert/repro/issues/new
# 2. Come early to the workshop:
#   * We figure it out together.
#   * I'll usually be there about an hour early.
# 3. Watch cute video on youtube: https://www.youtube.com/watch?v=GdP44iBIvck

#### Looking forward to see you! ####
