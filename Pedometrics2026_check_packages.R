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
##  6) Offer to download the course files from the public Google Drive folder


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
  "ranger",
  "googledrive"
)

course_files_url <- "https://drive.google.com/drive/folders/19DI1yxz0HPwReAcifxGfqtmguUihXxKW?usp=sharing"


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


#### Final package-check message ####

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


#### 6. Optional download of course files ####

# Download all files from the public Google Drive folder, including subfolders.
download_course_folder <- function(folder_url, destination) {

  googledrive::drive_deauth()
  dir.create(destination, recursive = TRUE, showWarnings = FALSE)

  download_one_folder <- function(folder, local_folder) {

    items <- googledrive::drive_ls(googledrive::as_id(folder))

    if (nrow(items) == 0) {
      return(invisible(NULL))
    }

    items <- googledrive::drive_reveal(items, "mime_type")

    for (i in seq_len(nrow(items))) {

      item_name <- items$name[i]
      item_id <- items$id[i]
      item_type <- items$mime_type[i]

      if (identical(item_type, "application/vnd.google-apps.folder")) {

        new_local_folder <- file.path(local_folder, item_name)
        dir.create(new_local_folder, recursive = TRUE, showWarnings = FALSE)
        download_one_folder(item_id, new_local_folder)

      } else {

        cat("Downloading: ", item_name, "\n", sep = "")

        googledrive::drive_download(
          googledrive::as_id(item_id),
          path = file.path(local_folder, item_name),
          overwrite = TRUE
        )
      }
    }
  }

  download_one_folder(folder_url, destination)
  invisible(destination)
}

# Use a predictable local destination. Students are not asked to enter a path.
get_course_destination <- function() {

  if (.Platform$OS.type == "windows") {
    documents <- file.path(Sys.getenv("USERPROFILE"), "Documents")
    if (!dir.exists(documents)) {
      documents <- path.expand("~")
    }
  } else {
    documents <- path.expand("~/Documents")
    if (!dir.exists(documents)) {
      documents <- path.expand("~")
    }
  }

  file.path(documents, "Pedometrics2026_course_files")
}

if (interactive() && requireNamespace("googledrive", quietly = TRUE)) {

  answer <- trimws(tolower(readline(
    paste0(
      "Would you like to download the Pedometrics 2026 course files now? ",
      "[y/N]: "
    )
  )))

  if (answer %in% c("y", "yes")) {

    destination <- get_course_destination()
    dir.create(destination, recursive = TRUE, showWarnings = FALSE)
    destination <- normalizePath(destination, winslash = "/", mustWork = TRUE)

    cat(
      "\nDownloading course files to:\n",
      destination, "\n\n",
      sep = ""
    )

    download_ok <- tryCatch(
      {
        download_course_folder(course_files_url, destination)
        TRUE
      },
      error = function(e) {
        cat(
          "\nAutomatic download was not successful.\n",
          "Reason: ", conditionMessage(e), "\n\n",
          "The course files can still be downloaded manually from:\n",
          course_files_url, "\n",
          sep = ""
        )
        FALSE
      }
    )

    if (download_ok) {
      cat(
        "\n=================================================\n",
        "Course files downloaded successfully.\n",
        "They are stored in:\n",
        destination, "\n",
        "=================================================\n\n",
        sep = ""
      )
    } else {
      try(browseURL(course_files_url), silent = TRUE)
    }

  } else {

    cat(
      "\nPlease download the course files before the course and save them in a local folder:\n",
      course_files_url, "\n\n",
      sep = ""
    )
  }

} else {

  cat(
    "\nCourse files must also be downloaded before the course from:\n",
    course_files_url, "\n",
    "Save them in a local folder on your computer.\n\n",
    sep = ""
  )
}
