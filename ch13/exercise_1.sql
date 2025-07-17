WITH temp_collapsed (station_name, max_temperature_group) AS
    (SELECT station_name,
            CASE
                WHEN max_temp >= 90 THEN '90 or more'
                WHEN max_temp >= 88
                     AND max_temp <= 89 THEN '88-89'
                WHEN max_temp >= 86
                     AND max_temp <= 87 THEN '86-87'
                WHEN max_temp >= 84
                     AND max_temp <= 85 THEN '84-85'
                WHEN max_temp >= 82
                     AND max_temp <= 83 THEN '82-83'
                WHEN max_temp >= 80
                     AND max_temp <= 81 THEN '80-81'
                WHEN max_temp <= 79 THEN '79 or less'
                ELSE 'No reading'
            END AS max_temperature_group
     FROM temperature_readings)
SELECT station_name, max_temperature_group, count(*)
FROM temp_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, max_temperature_group;