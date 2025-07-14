SELECT corr(total_amount, extract(epoch
                                  FROM (tpep_dropoff_datetime-tpep_pickup_datetime))),
       regr_r2(total_amount, extract(epoch
                                     FROM (tpep_dropoff_datetime-tpep_pickup_datetime)))
FROM nyc_yellow_taxi_trips
WHERE (tpep_dropoff_datetime - tpep_pickup_datetime) <= '3 hours';


SELECT corr(total_amount, trip_distance),
       regr_r2(total_amount, trip_distance)
FROM nyc_yellow_taxi_trips
WHERE (tpep_dropoff_datetime - tpep_pickup_datetime) <= '3 hours';