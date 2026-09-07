## Pedometrics 2026 – check required R packages
## Short training: Soil Organic Carbon Stock Change Quantification
## Alexandre M. J.-C. Wadoux and Gerard B.M. Heuvelink
## Pedometrics 2026
##
## This script can be called directly from the R console with:
##
##   source("https://raw.githubusercontent.com/AlexandreWadoux/AlexandreWadoux.github.io/master/Pedometrics2026_check_packages.R")
##
## It will:
##  1) Check whether the installed version of R is sufficiently recent
##  2) Update already installed packages where possible
##  3) Install any packages required for the course that are missing
##  4) Check that all required packages are installed
##  5) Check that all required packages can be loaded


#### Course requirements ####

# Minimum recommended R version
str_minimal_R_version <- "4.3.0"

# Packages used in the Pedometrics 2026 practical exercises
vs_packages_to_install <- c(
  "terra",
  "sf",
  "gstat",
  "stars",
  "ggplot2",
  "patchwork",
  "dplyr",
  "cvTools",
  "ranger"
)


#### Welcome message ####

cat(
  "\n",
  "Pedometrics 2026\n",
  "Soil Organic Carbon Stock Change Quantification\n",
  "=================================================\n\n",
  sep = ""
)


#### 1. Check R version ####

cat("1. Checking your R version...\n\n")

if (compareVersion(str_minimal_R_version, as.character(getRversion())) > 0) {

  stop(
    "Your version of R (", as.character(getRversion()), ") is too old for this course.\n",
    "Please install a recent version of R and restart RStudio.\n\n",
    "Download R from:\n",
    "https://cran.r-project.org/\n\n",
    "If RStudio continues to use an older R installation, go to:\n",
    "Tools -> Global Options -> General -> R version\n"
  )

} else {

  cat(
    "Your version of R (", as.character(getRversion()),
    ") is sufficient.\n\n",
    sep = ""
  )
}


#### Determine preferred package type ####

str_type_of_package <- getOption("pkgType")

if (identical(str_type_of_package, "both")) {
  str_type_of_package <- "binary"
}


#### 2. Update existing packages ####

cat(
  "2. Trying to update already installed packages.\n",
  "   This can take a while. If an individual package cannot be updated,\n",
  "   the script will continue with the course package installation.\n\n",
  sep = ""
)

try(
  suppressWarnings(
    update.packages(
      ask = FALSE,
      checkBuilt = TRUE,
      type = str_type_of_package
    )
  ),
  silent = TRUE
)


#### 3. Install missing packages ####

cat("\n3. Checking and installing packages required for the course...\n\n")

for (pkg in vs_packages_to_install) {

  if (!requireNamespace(pkg, quietly = TRUE)) {

    message("Installing package: ", pkg)

    try(
      suppressWarnings(
        install.packages(
          pkg,
          dependencies = TRUE,
          type = str_type_of_package
        )
      ),
      silent = TRUE
    )

  } else {

    message(pkg, " is already installed.")
  }
}


#### 4. Check whether all required packages are installed ####

cat("\n4. Checking package installation...\n\n")

df_installed_packages <- installed.packages()

package_status <- data.frame(
  Package = vs_packages_to_install,
  Installed = vs_packages_to_install %in% rownames(df_installed_packages),
  row.names = NULL
)

print(package_status)

if (all(package_status$Installed)) {

  cat("\nAll packages required for the Pedometrics 2026 course are installed.\n")

} else {

  missing_packages <- package_status$Package[!package_status$Installed]

  cat(
    "\nSome packages could not be installed:\n  ",
    paste(missing_packages, collapse = ", "),
    "\n\n",
    "Please keep a copy or screenshot of the messages shown above and contact the course instructor.\n",
    sep = ""
  )
}


#### 5. Check whether packages can be loaded ####

cat("\n5. Checking whether the packages can be loaded...\n\n")

load_status <- vapply(
  vs_packages_to_install,
  function(pkg) {
    suppressPackageStartupMessages(
      require(pkg, character.only = TRUE, quietly = TRUE)
    )
  },
  logical(1)
)

load_status_table <- data.frame(
  Package = names(load_status),
  Loaded = unname(load_status),
  row.names = NULL
)

print(load_status_table)


#### Final message ####

if (all(load_status)) {

  cat(
    "\n=================================================\n",
    "Everything is ready.\n",
    "All R packages required for the Pedometrics 2026 short training\n",
    "\"Soil Organic Carbon Stock Change Quantification\" are installed\n",
    "and can be loaded successfully.\n",
    "=================================================\n\n",
    sep = ""
  )

} else {

  failed_packages <- names(load_status)[!load_status]

  cat(
    "\n=================================================\n",
    "The following packages are installed but could not be loaded:\n  ",
    paste(failed_packages, collapse = ", "),
    "\n\n",
    "Please keep a copy or screenshot of the messages shown above and\n",
    "contact the course instructor before the course.\n",
    "=================================================\n\n",
    sep = ""
  )
}
