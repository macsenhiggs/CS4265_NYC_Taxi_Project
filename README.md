# Examining the Taxi Industry in New York City Using Spark

**Course:** CS 4265\
**Author:** Macsen Higgins\
**README Last Updated:** April 5, 2026

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

While `getParquets.py` and `yellow_parquets_to_s3.Rmd` encompass the majority of code that has gone into the development thus far, their purpose is to serve as a pipeline from the CloudFront-hosted parquet files provided by the TLC to lightly-processed parquet files stored in my personal S3 bucket. Given this single-use purpose, users have no need to run either file to access the data and can instead move directly into `s3_to_spark.Rmd` to pull the data from the S3 bucket and preview it themselves. Once in `s3_to_spark.Rmd`,

1.  Run chunk 1, which will start a fresh Spark connection and create a custom schema to read the parquet files in.
2.  Run chunk 2, which will make an S3 bucket read request using the provided URI and create a Spark DataFrame in your local session from the parquet files contained within the bucket.
3.  Upon the completion of chunk 2's processes, a preview of your DataFrame will print in the console, showing that the data was successfully obtained and that the schema of the different files have coalesced without error. The data is now ready for processing and deep analysis, the basis of M4.

## What's Next

With the lightly-processed yellow taxi data now available remotely on S3, the next steps heading into M4 mostly center around the actual data analysis that will make up my final report. Below is a rough list of next steps within the data pipeline heading into M4:

1.  Create simple pipeline in Sparklyr to obtain parquet data from AWS S3 and store in DataFrame.
2.  Process DataFrame along applied data analytics principles using dplyr-type operations in Spark (e.g. filter, mutate, group, summarize) to uncover trends, discrepancies, and other noteworthy narratives beneath the data’s surface.
3.  Save findings in persistent storage (either S3 or GitHub repository depending on size) in the form of summarized datasets, charts, and other documents for future analysis and pending final report.
4.  Write final report documenting analytical findings and what they can tell us about the New York City taxi industry’s past, present, and future.

With this road map laid out, I feel confident in my ability to produce a strong final deliverable and provide noteworthy analytics on the data I have dedicated my time to storing, processing, and studying this semester.
