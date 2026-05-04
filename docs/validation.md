# Data Pipeline Validation Report

**Last Ran: 04/05/2026**

## **General Data Quality**

| total_records | missing_distance | missing_pickup | missing_dropoff | incorrect_sum_fees |
|--------------:|--------------:|--------------:|--------------:|--------------:|
| 773343351 | 0 | 0 | 0 | 52463 |

## **Logical Validation**

| total_trips | valid_distance | valid_fare | pct_valid_distance | pct_valid_fare |
|--------------:|--------------:|--------------:|--------------:|--------------:|
|   773343351 |      766751077 |  770780119 |           99.14756 |       99.66855 |

## **Edge case documentation**

#### (Most expensive fares on record)

| tpep_pickup_datetime | trip_distance | fare_amount | total_amount |
|:---------------------|--------------:|------------:|-------------:|
| 2015-01-18 19:24:15  |          5.32 |        22.0 |    3950611.6 |
| 2019-03-15 19:00:45  |          0.00 |    943274.8 |    1084772.2 |
| 2020-03-10 09:58:11  |          0.00 |         2.5 |    1000003.8 |
| 2020-10-07 10:35:56  |          0.70 |    998310.0 |     998325.6 |
| 2018-08-09 05:40:49  |          0.10 |    907070.2 |     907071.0 |

## **Performance Test**

#### (Test System: 2022 M2 MacBook Air)

**Code run:**

``` R
perf_test <- yellow_s3_data |>
  group_by(year) |>
  summarize(total_rev = sum(total_amount, na.rm = TRUE)) |>
  collect()
```

**Callback Message:**

Yearly Revenue Aggregation: 363.73 sec elapsed
