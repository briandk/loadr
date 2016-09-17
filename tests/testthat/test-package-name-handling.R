library(stringr)

context("detecting and resolving github packages")

############### Setup
multiple_packages <- c( "hadley/devtools" = TRUE
                        , "utils" = FALSE
                        , "base" = FALSE
                        , "briandk/granovaGG" = TRUE
                        , "hadley/tidyr" = TRUE
)
package_names <- names(multiple_packages)
############### End Setup

test_that("it can determine if a package should be installed from GitHub", {
  expected_is_github_values <- multiple_packages
  names(expected_is_github_values) <- NULL

  expect_equal(is_github_package("utils"), FALSE)
  expect_equal(is_github_package("hadley/devtools"), TRUE)
  expect_equal(
    is_github_package(package_names),
    expected_is_github_values
  )
})

test_that("it can resolve user/repo specifications to just their package names, while leaving bare pakage names alone", {
  expected_resolved_package_names <- c("devtools"
                                       , "utils"
                                       , "base"
                                       , "granovaGG"
                                       , "tidyr")
  expect_equal(resolve_package_name_for_loading("foo/bar"), "bar")
  expect_equal(resolve_package_name_for_loading(package_names), expected_resolved_package_names)
})

test_that("it can load multiple packages, installing them if necessary", {
  load_required_packages(c("boot", "MASS"))
})