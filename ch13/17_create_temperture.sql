BEGIN;


CREATE TABLE IF NOT EXISTS temperature_readings (station_name TEXT, observation_date DATE, max_temp INTEGER, min_temp INTEGER, CONSTRAINT temp_key PRIMARY KEY (station_name,
                                                                                                                                                                observation_date));

\copy temperature_readings
FROM './data/temperature_readings.csv' WITH (FORMAT CSV,
                                             HEADER);


SELECT *
FROM temperature_readings
LIMIT 10;


COMMIT;

-- => 1077

SELECT count(*)
FROM temperature_readings;