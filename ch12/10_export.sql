\copy
  (SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
          count(*)
   FROM nyc_yellow_taxi_trips
   GROUP BY trip_hour
   ORDER BY trip_hour) TO './data/hourly_pickups.csv' WITH (FORMAT CSV,
                                                            HEADER);