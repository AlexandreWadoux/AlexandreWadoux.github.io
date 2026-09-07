# R and RStudio setup for Pedometrics 2026

## Short training: Soil Organic Carbon Stock Change Quantification

**Instructors:** Alexandre M. J.-C. Wadoux and Gerard B.M. Heuvelink

Please complete the steps below **before the course**. Installing and updating the required R packages usually takes around 10–15 minutes, but it can take considerably longer on some computers.

## 1. Install or update R

The practical exercises use **R** for data analysis and modelling. We recommend installing the latest stable version of R.

### Windows

1. Go to <https://cloud.r-project.org/>.
2. Select **Download R for Windows**.
3. Select **base** (or **install R for the first time**).
4. Download the latest Windows installer.
5. Run the installer and keep the default options unless you have a specific reason to change them.

### macOS

1. Go to <https://cloud.r-project.org/>.
2. Select **Download R for macOS**.
3. Download the installer appropriate for your version of macOS and processor.
4. Run the installer and follow the default installation steps.

The course setup script requires **R 4.3.0 or newer**. Using the latest stable version is recommended.

## 2. Install RStudio Desktop

RStudio is the interface that we will use to write and run R code.

1. Go to <https://posit.co/download/rstudio-desktop/>.
2. Download the free version of **RStudio Desktop** for your operating system.
3. Install RStudio using the default options.
4. Open RStudio after installation.

R must be installed **before** RStudio. If you update R but RStudio still opens an older R version, restart RStudio. On Windows, you can also check **Tools > Global Options > General > R version** and select the most recent installation.

## 3. Install the packages required for the course

The course uses several R packages for spatial data processing, geostatistics, visualisation, regression kriging, random forests, and sampling exercises. A setup script has been prepared to check your R installation and install everything required automatically.

Open **RStudio** and locate the **Console** pane, usually in the lower-left part of the RStudio window. Copy and paste the following line into the Console:

```r
source("https://raw.githubusercontent.com/AlexandreWadoux/AlexandreWadoux.github.io/master/Pedometrics2026_check_packages.R")
```

Press **Enter**.

The script will:

1. check that your version of R is sufficiently recent;
2. attempt to update existing R packages;
3. install any course packages that are missing;
4. verify that all required packages are installed; and
5. check that the packages can be loaded successfully.

The required packages currently include `terra`, `sf`, `gstat`, `stars`, `ggplot2`, `patchwork`, `dplyr`, `cvTools`, and `ranger`.

## 4. What to expect

During installation you may see warnings or messages from R. Many warnings are harmless, particularly while packages and their dependencies are being installed or updated.

If everything is ready, the script will finish with a message similar to:

```text
Everything is ready.
All R packages required for the Pedometrics 2026 short training
"Soil Organic Carbon Stock Change Quantification" are installed
and can be loaded successfully.
```

If the script reports that your R version is too old, install the latest R version, restart RStudio, and run the `source(...)` command again.

If one or more packages cannot be installed or loaded, please keep a **screenshot of the complete Console output** and contact the course instructors before the practical session.

## 5. Final check before the course

You are ready for the practical exercises when:

- R 4.3.0 or newer is installed;
- RStudio opens normally;
- the setup script completes without missing packages; and
- the final package-loading check reports success.

You do not need to learn basic R syntax before attending the course. The purpose of this setup is simply to ensure that your computer is ready to run the practical exercises.
