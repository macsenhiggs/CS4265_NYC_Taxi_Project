#NEW USER SETUP----
install.packages("sparklyr")

#check for java environment
if (Sys.getenv("JAVA_HOME") == "") {
  stop("Please install Java 17 and set your JAVA_HOME in .Renviron")
}

#install correct spark version
spark_install(version = "3.5", hadoop_version = "3")

print("Environment ready")



library(sparklyr)
spark_disconnect(sc)

#The line I use to set my JAVA_HOME, probably not what you want for yourself.
#Sys.setenv(JAVA_HOME = "/opt/homebrew/Cellar/openjdk@17/17.0.18/libexec/openjdk.jdk/Contents/Home")

system("java -version")


#Initialize Spark Session----
conf <- spark_config()

conf$spark.app.name <- "NYC Taxi"

sc <- spark_connect(master = "local", version = "3.5.0", config = conf)

path_to_yellow <- paste0("file://", getwd(), "/downloads/yellow_tripdata_*.parquet")
path_to_green <- paste0("file://", getwd(), "/downloads/green_tripdata_*.parquet")
path_to_fhv <- paste0("file://", getwd(), "/downloads/fhv_tripdata_*.parquet")
path_to_fhvhv <- paste0("file://", getwd(), "/downloads/fhvhv_tripdata_*.parquet")


#ADD YELLOW TAXI DATAFRAME----
yellow_schema <- list(
  VendorID              = "integer64",
  tpep_pickup_datetime  = "timestamp",
  tpep_dropoff_datetime = "timestamp",
  passenger_count       = "integer64",
  trip_distance         = "double",
  RatecodeID            = "integer64",
  store_and_fwd_flag    = "character",
  PULocationID          = "integer64",
  DOLocationID          = "integer64",
  payment_type          = "integer64",
  fare_amount           = "double",
  extra                 = "double",
  mta_tax               = "double",
  tip_amount            = "double",
  tolls_amount          = "double",
  #improvement_surcharge = "double",
  total_amount          = "double"
  #Airport_fee           = "double",
  #congestion_surcharge  = "double",
  #cbd_congestion_fee    = "double",
)

yellow_data <- spark_read_parquet(
  sc = sc,
  name = "yellow_data",
  path = path_to_yellow,
  columns = yellow_schema,
  options = list(mergeSchema = "true"),
  memory = FALSE
                                ) |>
  # Force the conversion AFTER the read
  mutate(
    VendorID = as.numeric(VendorID)
  )


# GREEN TAXI - REVISED ROBUST SCHEMA
green_schema <- list(
  VendorID              = "double",      
  lpep_pickup_datetime  = "timestamp",
  lpep_dropoff_datetime = "timestamp",
  store_and_fwd_flag    = "character",
  RatecodeID            = "double",
  PULocationID          = "double",
  DOLocationID          = "double",
  passenger_count       = "double",
  trip_distance         = "double",
  fare_amount           = "double",
  extra                 = "double",
  tip_amount            = "double",
  tolls_amount          = "double",
  total_amount          = "double",
  payment_type          = "double",
  trip_type             = "double"
)

green_data <- spark_read_parquet(
  sc = sc,
  name = "green_data",
  path = path_to_green,
  columns = green_schema, # Spark will now cast INTs to DOUBLEs automatically
  options = list(mergeSchema = "false"),
  memory = FALSE
) |>
  mutate(
    VendorID = as.double(VendorID)
  )

print(str(green_data))


#ADD FHV DATAFRAME----
fhv_schema <- list(
  dispatching_base_num    = "character",
  pickup_datetime         = "timestamp",
  dropOff_datetime        = "timestamp",
  PUlocationID            = "integer64",
  DOlocationID            = "integer64",
  SR_Flag                 = "integer64",
  Affiliated_base_number  = "character"
)
fhv_data <- spark_read_parquet(
  sc = sc,
  name = "fhv_data",
  path = path_to_fhv,
  columns = fhv_schema,
  options = list(mergeSchema = "true"),
  memory = FALSE
) |>
  mutate(
    PUlocationID = as.numeric(PUlocationID)
  )


#ADD FHVHV DATAFRAME----
fhvhv_schema <- list(
  hvfhs_license_num       = "character",
  dispatching_base_num    = "character",
  originating_base_num    = "character",
  request_datetime        = "timestamp",
  on_scene_datetime       = "timestamp",
  pickup_datetime         = "timestamp",
  dropoff_datetime        = "timestamp",
  PULocationID            = "integer64",
  DOLocationID            = "integer64",
  trip_miles              = "double",
  trip_time               = "integer64",
  base_passenger_fare     = "double",
  tolls                   = "double",
  bcf                     = "double",
  #sales_tax               = "double",
  #congestion_surcharge    = "double",
  #airport_fee             = "double",
  tips                    = "double",
  driver_pay              = "double",
  shared_request_flag     = "character",
  shared_match_flag       = "character",
  access_a_ride_flag      = "character",
  wav_request_flag        = "character",
  wav_match_flag          = "character"
  #cbd_congestion_fee      = "double"
)

fhvhv_data <- spark_read_parquet(
  sc = sc,
  name = "fhvhv_data",
  path = path_to_fhvhv,
  columns = fhvhv_schema,
  options = list(mergeSchema = "true"),
  memory = FALSE
)



#CHECK ROWS ADDED CORRECTLY----
sdf_nrow(yellow_data)
sdf_nrow(green_data)
sdf_nrow(fhv_data)
sdf_nrow(fhvhv_data)

#NOTE: I understand that most of these datasets will not load in the viewer currently, as there is still some schema
#mismatch problems in the code. These will be fixed soon, but as a proof of concept yellow_data is up and running.
sdf_schema(yellow_data)

spark_write_parquet(yellow_data,
                    path = paste0("persistent_data/yellow_data_final"),
                    mode = "overwrite")

