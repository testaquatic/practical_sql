SELECT max_temp,
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
       END AS temperature_group
FROM temperature_readings
ORDER BY station_name,
         observation_date;