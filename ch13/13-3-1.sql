CREATE EXTENSION tablefunc;

CREATE TABLE ice_cream_survey (
    response_id INTEGER PRIMARY KEY,
    office      TEXT,
    flavor      TEXT
);

-------------------psql
\copy ice_cream_survey FROM './data/ice_cream_survey.csv' WITH (FORMAT CSV, HEADER);
-------------------
SELECT *
FROM
    ice_cream_survey
ORDER BY
    response_id
LIMIT 5;


SELECT *
FROM
    crosstab('SELECT office, flavor, count(*) FROM ice_cream_survey GROUP BY office, flavor ORDER BY office',
             'SELECT flavor FROM ice_cream_survey GROUP by flavor ORDER by flavor') AS (office TEXT, chocolate BIGINT, strawberry BIGINT, vanilla BIGINT);

CREATE TABLE temperature_readings (
    station_name     TEXT,
    observation_date DATE,
    max_temp         INTEGER,
    min_temp         INTEGER,
    CONSTRAINT temp_key PRIMARY KEY (station_name, observation_date)
);

-------------------psql
\copy temperature_readings FROM './data/temperature_readings.csv' WITH (FORMAT CSV, HEADER);
-------------------

SELECT
    station_name,
    DATE_PART('month', observation_date),
    PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY max_temp)
FROM
    temperature_readings
GROUP BY
    station_name, DATE_PART('month', observation_date)
ORDER BY
    station_name;

SELECT
    month
FROM
    GENERATE_SERIES(1, 12) month;

SELECT *
FROM
    crosstab('SELECT
    station_name,
    DATE_PART(''month'', observation_date),
    PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY max_temp)
FROM
    temperature_readings
GROUP BY
    station_name, DATE_PART(''month'', observation_date)
ORDER BY
    station_name', 'SELECT
    month
FROM
    GENERATE_SERIES(1, 12) month
') AS (station_text TEXT, jan NUMERIC(3, 0), feb NUMERIC(3, 0),
       mar NUMERIC(3, 0), apr NUMERIC(3, 0),
       may NUMERIC(3, 0), jun NUMERIC(3, 0),
       jul NUMERIC(3, 0), aug NUMERIC(3, 0),
       sep NUMERIC(3, 0), oct NUMERIC(3, 0),
       nov NUMERIC(3, 0), dec NUMERIC(3, 0));

SELECT
    max_temp,
    CASE
        WHEN max_temp >= 90 THEN 'Hot'
        WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
        WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
        WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
        WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
        WHEN max_temp < 20 THEN 'Inhumane'
        ELSE 'No reading'
    END AS temperature_group
FROM
    temperature_readings
ORDER BY
    station_name, observation_date;

WITH temps_collapsed (station_name, max_temperature_group) AS (
    SELECT
        station_name,
        CASE
            WHEN max_temp >= 90 THEN 'Hot'
            WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
            WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
            WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
            WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
            WHEN max_temp < 20 THEN 'Inhumane'
            ELSE 'No Reading'
        END
    FROM
        temperature_readings
                                                              )
SELECT
    station_name,
    max_temperature_group,
    COUNT(*)
FROM
    temps_collapsed
GROUP BY
    station_name, max_temperature_group
ORDER BY
    station_name, COUNT(*) DESC;