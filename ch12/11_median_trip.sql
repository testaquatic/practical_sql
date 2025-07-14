SET TIME ZONE 'US/Eastern';


SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
       percentile_cont(.5) WITHIN GROUP (
                                         ORDER BY tpep_dropoff_datetime - tpep_pickup_datetime) AS median_trip
FROM nyc_yellow_taxi_trips
GROUP BY trip_hour
ORDER BY trip_hour;