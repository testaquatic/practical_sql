SELECT 
  tpep_pickup_datetime,
  tpep_dropoff_datetime,
  tpep_dropoff_datetime - tpep_pickup_datetime AS time_diff
FROM nyc_yellow_taxi_trips
ORDER BY time_diff;