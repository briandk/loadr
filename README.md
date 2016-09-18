# loadr
Defensive package loading for R

## What does this package do?

1. You declare all the packages your code requires.
2. `loadr` installs and loads those dependencies for anyone who runs your code.
3. There is no step 3. Go forth and code.

## Installation instructions

```r
# If you don't currently have devtools
install.packages("devtools")

# then
devtools::install_github("briandk/loadr")
```

## Examples of how you use it

```r
packages_my_code_needs <- c(
  "ggplot2",
  "tidyr",
  "hadley/devtools" # you can specify user/repo combinations for github packages
)

# Automatically installs packages you don't have
#   and automatically loads everything via `require()`
loadr::load_required_packages(packages_my_code_needs)
```

## Why would I use this?

I wrote this package because sometimes
`checkpoint` and `packrat` are burdensome when you're doing rapid development (or
rapid manuscript-writing). These functions ensure your scripts and documents
will run for anyone with R.
