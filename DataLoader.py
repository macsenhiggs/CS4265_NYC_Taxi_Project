from pyspark.sql import SparkSession
from pyspark.sql import DataFrame

def load_taxi_data(spark: SparkSession, year: str, month: str) -> DataFrame:
    spark._jsc.hadoopConfiguration().set("fs.s3a.aws.credentials.provider",
                                         "org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider")

    file_path = f"s3a://nyc-tlc/yellow/PUYear={year} / PUMonth = {month}/ yellow_tripdata_{year} - {month}.parquet"
    print(f"Attempting to load data from: {file_path}")

    df = spark.read.parquet(file_path)
    return df
