import os
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()
print("Hadoop Version:", spark._jvm.org.apache.hadoop.util.VersionInfo.getVersion())


os.environ['PYSPARK_SUBMIT_ARGS'] = (
    '--packages org.apache.hadoop:hadoop-aws:3.4.2 '
    '--conf "spark.driver.extraJavaOptions=-Djdk.security.allowNonStandardSubject=true" '
    '--conf "spark.executor.extraJavaOptions=-Djdk.security.allowNonStandardSubject=true" '
    'pyspark-shell'
)

def create_portable_spark_session():
    return SparkSession.builder \
        .appName("NYC_TLC_Portable_Project") \
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
        .config("spark.hadoop.fs.s3a.aws.credentials.provider", "org.apache.hadoop.fs.s3a.AnonymousAWSCredentialsProvider") \
        .config("spark.hadoop.fs.s3a.endpoint", "s3.amazonaws.com") \
        .config("spark.sql.warehouse.dir", "/tmp/spark-warehouse") \
        .getOrCreate()


if __name__ == "__main__":
    spark = create_portable_spark_session()

    # Path to NYC TLC Public Data
    s3_path = "s3a://nyc-tlc/trip data/yellow_tripdata_2024-01.parquet"

    try:
        print("Starting S3 Data Load...")
        # Spark will now fetch the data using the drivers it downloaded automatically
        df = spark.read.parquet(s3_path)

        print("\n--- Data Sample ---")
        df.select("vendorid", "tpep_pickup_datetime", "trip_distance", "total_amount").show(5)

    except Exception as e:
        print(f"Error: {e}")
    finally:
        spark.stop()