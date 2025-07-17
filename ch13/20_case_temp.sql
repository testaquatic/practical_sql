WITH temp_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
            CASE
                WHEN max_temp >= 90 THEN 'Hot'
                WHEN max_temp >= 70
                     AND max_temp < 90 THEN 'Warm'
                WHEN max_temp >= 50
                     AND max_temp < 70 THEN 'Pleasant'
                WHEN max_temp >= 33
                     AND max_temp < 50 THEN 'Cold'
                WHEN max_temp >= 20
                     AND max_temp < 33 THEN 'Frigid'
                WHEN max_temp < 20 THEN 'Inhumane'
                ELSE 'No reading'
            END
     FROM temperature_readings)
SELECT station_name,
       max_temperature_group,
       count(*)
FROM temp_collapsed
GROUP BY station_name,
         max_temperature_group
ORDER BY station_name,
         count(*) DESC;