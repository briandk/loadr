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

is_github_package <- function (packages, user_repo_pattern = "[^/]+/[^/]+") {
  return(stringr::str_detect(packages, user_repo_pattern))
}

resolve_package_name_for_loading <- function (package_names) {
  sapply(
    X = package_names,
    FUN = function (package_name) {
      if (is_github_package(package_name)) {
        package_name %<>%
          stringr::str_split(pattern = "/") %>%
          `[[`(1) %>% # str_split returns a list of character vectors
          `[`(2)      # the second element of the character vector is the repo name
      }
      return (package_name)
    }
  )
}

install_packages_if_necessary <- function (dependencies, installed_packages = utils::installed.packages()) {
  packages_to_install <- setdiff(dependencies, installed_packages)
  for (package in packages_to_install) {
    if (is_github_package(package)) {
      devtools::install_github(package)
    }
    else {
      install.packages(package, dependencies = TRUE)
    }
  }
}

load_required_packages <- function (required_packages) {
  install_packages_if_necessary(required_packages)
  sapply( X = required_packages
          , FUN = library
          , warn.conflicts = TRUE
  )
}