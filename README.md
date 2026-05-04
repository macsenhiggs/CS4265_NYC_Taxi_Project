# Examining the New York City Taxi Industry  Using Spark Big Data Tools

**Course:** CS 4265\
**Author:** Macsen Higgins\
**README Last Updated:** May 3, 2026

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

## Pipeline Setup

While `getParquets.py` and `yellow_parquets_to_s3.Rmd` encompass the majority of code that has gone into the development thus far, their purpose is to serve as a pipeline from the CloudFront-hosted parquet files provided by the TLC to lightly-processed parquet files stored in my personal S3 bucket. Given this single-use purpose, users have no need to run either file to access the data and can instead move directly into `s3_to_spark.Rmd` to pull the data from the S3 bucket and preview it themselves. Once in `s3_to_spark.Rmd`,

1.  Run chunk 1, which will start a fresh Spark connection and create a custom schema to read the parquet files in.
2.  Run chunk 2, which will make an S3 bucket read request using the provided URI and create a Spark DataFrame in your local session from the parquet files contained within the bucket.
3.  Upon the completion of chunk 2's processes, a preview of your DataFrame will print in the console, showing that the data was successfully obtained and that the schema of the different files have coalesced without error. The data is now ready for processing and deep analysis.

## Final Steps

With the distributed DataFrame loaded into Spark, the user is now free to perform analysis as they see fit. An example has been provided at the end of `s3_to_spark.Rmd`, but the possibilities for investigative analysis are nearly endless. In future iterations of this project, I intend to further expand the practical analysis enabled by the pipeline and draw more meaningful conclusions about the shifting identity of the NYC taxi industry.
