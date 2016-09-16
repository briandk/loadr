# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload Package:  'Cmd + Shift + B'
#   Check Package:             'Cmd + Shift + E'
#   Test Package:              'Cmd + Shift + T'

# defensive package loading in pure R
# inspired by @wildoane

install_packages_if_necessary <- function (dependencies, installed_packages = utils::installed.packages()) {
  packages_to_install <- setdiff(dependencies, installed_packages)
  for (package in packages_to_install) {
    install.packages(package, dependencies = TRUE)
  }
}

load_required_packages <- function (required_packages) {
  install_packages_if_necessary(required_packages)
  sapply( X = required_packages
          , FUN = require
          , warn.conflicts = TRUE
  )
}