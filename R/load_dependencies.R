# defensive package loading inspired by @wildoane

is_github_package <- function (packages, user_repo_pattern = "[^/]+/[^/]+") {
  return(stringr::str_detect(packages, user_repo_pattern))
}

#' @import magrittr
resolve_package_name_for_loading <- function (package_names) {
  resolved_names <- sapply(
    X = package_names,
    USE.NAMES = FALSE,
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
  return(resolved_names)
}

#' Selectively install the packages you specify
#'
#' This function takes a vector of packages, determines which packages aren't
#' currently installed, and installs only the missing dependencies.
#'
#' @param dependencies A character vector of packages your code requires. If you
#'   want to depend on a CRAN package, just use its bare name: \code{"ggplot"}.
#'   If you want to depend on a package hosted on Github, specify your package
#'   as \code{"user/repo"} and loadr will automatically install the package from
#'   Github.
#' @param installed_packages A character vector of packages already installed.
#'   loadr will not attempt to install these packages. loadr will only install
#'   packages in \code{dependencies} that do not appear here. The parameter
#'   defaults to \code{utils::installed.packages()}, which I'm pretty sure is
#'   what you want. But on the off chance you want to supply some alternative
#'   list of packages, you can just override this default.
#'
#' @return An invisible character vector of the packages that were required but
#'   not present in \code{installed_packages}. Ideally, this should be a vector
#'   of just the packages that were installed, but on the off chance an
#'   installation fails, a package name may appear here even if it wasn't
#'   successfully installed. So, I'll try to work on that.
#'
#' @examples
#' \dontrun{
#' install_packages_if_necessary("ggplot2")
#' # specifying a package as "user/repo" will
#' # install from Github using devtools::install_github()
#' install_packages_if_necessary("briandk/granovagg")
#' my_dependencies = c("tidyr", "hadley/testthat")
#' install_packages_if_necessary(my_dependencies)
#' }
#'
#' @import magrittr
#' @export
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
  return (packages_to_install %>% invisible())
}

#' Load packages you need; optionally install them if they're not already
#' installed
#'
#' @param required_packages A character vector of the quoted names of packages
#'   you'd like loaded via the \code{library()} function. Because
#'   \code{library()} isn't vectorised, this function lets you avoid typing a
#'   separate \code{library()} call for each package you want loaded.
#'
#' @param try_installing_if_not_present Should the function try to install any
#'   of your dependencies if need be? This setting is useful if you know what
#'   your code requires, but you can't safely assume which (if any) of your
#'   required packages will be installed on a user's system. Defaults to
#'   \code{TRUE}
#'
#' @return an invisible copy of the dependencies you passed in
#'
#' @examples
#' load_required_packages(c("boot", "MASS"))
#'
#' # If you wish to be super-careful,
#' # you can say NO to automatic package installation.
#' # If you say no, the function will only try to load your requirements;
#' # it won't attempt to install anything new even if the package
#' # you're requiring isn't currently installed
#' load_required_packages("utils", try_installing_if_not_present = FALSE)
#' \dontrun{ #
#' https://github.com/hadley/tidyverse
#' some_packages_from_the_tidyverse <- c( "ggplot2"
#'                                        , "tidyr"
#'                                        , "broom" )
#' load_required_packages(some_packages_from_the_tidyverse) }
#'
#' @import magrittr
#' @export

load_required_packages <- function (required_packages, try_installing_if_not_present = TRUE) {
  if (try_installing_if_not_present == TRUE) {
    install_packages_if_necessary(required_packages)
  }
  for (package_name in required_packages) {
    require( package_name
           , warn.conflicts = TRUE
           , character.only = TRUE
           , quietly = FALSE)
  }
  return (required_packages %>% invisible())
}