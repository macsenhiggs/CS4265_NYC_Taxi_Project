# Examining the Taxi Industry in New York City Using Spark

**Course:** CS 4265\
**Author:** Macsen Higgins

## Project Description

This project analyzes a decade of New York City Taxi and Limousine Commission (TLC) trip record data to uncover trends within the taxi industry. Processing billions of rows of data requires distributed computing frameworks; therefore, this project utilizes Apache Spark.

Initially designed using PySpark and AWS S3, the pipeline was pivoted to a hybrid approach due to cloud permission constraints. It currently utilizes Python for automated data extraction from public HTTP endpoints and R (`sparklyr`) for large-scale data manipulation, schema enforcement, and analysis.

## Setup Instructions (Dependencies)

To replicate this environment, you will need to install the following tools:

1.  Java Development Kit (JDK): Java 17 is required to run a local Spark instance.
2.  Python 3.x: Required to execute the data acquisition script.
3.  R & RStudio: The primary environment for the Spark session.
4.  R Packages: Open R and install the following dependencies: \`\`\`R install.packages(c("sparklyr", "dplyr"))

## Environment Setup

While the NYC TLC data is public and does not require API keys, you must configure your local environment so that R can locate your Java installation.

1.  Find your Java 17 installation path (e.g., `/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home` on Mac or `C:\Program Files\Java\jdk-17` on Windows).

2.  Create a file named `.Renviron` in the root of this project directory.

3.  Add the following line to the `.Renviron` file, replacing the path with your own:

    `JAVA_HOME="YOUR_JAVA_PATH_HERE"`

## How to Run

1.  Download parquet files by calling `python getParquets.py` in your terminal, which will save them in the `downloads` folder.
2.  Open the `CS4265_NYC_Taxi_Project.Rproj` file to launch RStudio. This ensures your working directory and paths are correctly configured.
3.  Save the DataFrames with Spark by running `main.R` in sequential order.

## What's Next

With the core data acquisition and Spark initialization complete, the upcoming milestones for this project include:

-   Data Cleaning & Unification: Finalizing the resolution of schema mismatches (e.g., handling the evolution of column types across the 10-year dataset) to ensure robust, error-free loading.

-   Distributed Processing: Utilizing sparklyr's dplyr backend to perform distributed filtering, aggregations, and feature engineering across the massive DataFrames.

-   Inference & Analysis: Extracting actionable insights and historical trends regarding the NYC taxi industry (Yellow, Green, FHV, and FHVHV) for the final phase of the project.
