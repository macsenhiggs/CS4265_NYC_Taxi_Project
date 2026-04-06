# Examining the Taxi Industry in New York City Using Spark

**Course:** CS 4265\
**Author:** Macsen Higgins

## Project Description

This project analyzes a decade of New York City Taxi and Limousine Commission (TLC) trip record data to uncover trends within the taxi industry. Processing billions of rows of data requires distributed computing frameworks; therefore, this project utilizes Apache Spark.

Initially designed using PySpark and AWS S3, the pipeline was pivoted to a hybrid approach due to cloud permission constraints. It currently utilizes Python for automated data extraction from public HTTP endpoints and R (`sparklyr`) for large-scale data manipulation, schema enforcement, and analysis.

## Dependencies Setup Instructions

If you do not have R and R Studio installed:

-   Download R for your system [here](https://cran.r-project.org/)

-   Download R Studio for your system [here](https://posit.co/download/rstudio-desktop/)

Once R and R Studio are installed, follow the instructions laid out in `Setup.Rmd` to set up the rest of the tools required for the project.

-   This project requires your machine's JAVA_HOME directory to be set to an installation of Java 17, and chunk 1 in `Setup.Rmd` will systematically detect your operating system and assign a valid installation to the directory if it exists. If it does not exist, it will attempt to automatically install the language on your system (with user permission, barring sudo constraints)

-   A handful of R libraries from the CRAN project are required for this project, and they will be automatically installed and instantiated in chunk 2 of `Setup.Rmd`

-   Lastly, Spark requires a separate installation outside of the `sparklyr` library (which communicates with Spark but does not contain it), and running chunk 3 of `Setup.Rmd` will do so

## Environment Setup

While `getParquets.py` and `yellow_parquets_to_s3.Rmd` encompass the majority of code that has gone into the development thus far, their purpose is to serve as a pipeline from the Cloudfront-hosted parquet files provided by the TLC to lightly-processed parquet files stored in my personal S3 bucket. Given this single-use purpose, users have no need to run either file to access the data and can instead move directly into `s3_to_spark.Rmd` to pull the data from the S3 bucket and preview it themselves.

## What's Next

With the core data acquisition and Spark initialization complete, the upcoming milestones for this project include:

-   Data Cleaning & Unification: Finalizing the resolution of schema mismatches (e.g., handling the evolution of column types across the 10-year dataset) to ensure robust, error-free loading.

-   Distributed Processing: Utilizing sparklyr's dplyr backend to perform distributed filtering, aggregations, and feature engineering across the massive DataFrames.

-   Inference & Analysis: Extracting actionable insights and historical trends regarding the NYC taxi industry (Yellow, Green, FHV, and FHVHV) for the final phase of the project.
