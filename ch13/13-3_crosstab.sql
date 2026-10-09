-- 모듈 설치
CREATE EXTENSION tablefunc;

-- 데이터셋 추가
CREATE TABLE playground.ice_cream_survey
(
    response_id INTEGER PRIMARY KEY,
    office      TEXT,
    flavor      TEXT
);

COPY playground.ice_cream_survey
    FROM 'ice_cream_survey.csv'
    WITH (FORMAT CSV , HEADER );

SELECT *
FROM playground.ice_cream_survey
ORDER BY response_id
LIMIT 5;

-- crosstab
SELECT *
FROM crosstab(
             'SELECT office, flavor, count(*)
              FROM playground.ice_cream_survey
              GROUP BY office, flavor
              ORDER BY office',
             'SELECT flavor
              FROM playground.ice_cream_survey
              GROUP BY flavor
              ORDER BY flavor') AS (office TEXT, chocolate BIGINT, strawberry BIGINT, vanilla BIGINT);

-- 데이터셋 생성
CREATE TABLE us_statistics.temperature_readings
(
    station_name     TEXT,
    observation_date DATE,
    max_temp         INTEGER,
    min_temp         INTEGER,
    CONSTRAINT temp_key PRIMARY KEY (station_name, observation_date)
);

COPY us_statistics.temperature_readings
    FROM 'temperature_readings.csv'
    WITH (FORMAT CSV , HEADER );

SELECT station_name, date_part('month', observation_date), percentile_cont(.5) WITHIN GROUP ( ORDER BY max_temp )
FROM us_statistics.temperature_readings
GROUP BY station_name, date_part('month', observation_date)
ORDER BY station_name;

SELECT month
FROM generate_series(1, 12) month;

SELECT *
FROM crosstab(
             'SELECT station_name, date_part(''month'', observation_date), percentile_cont(.5) WITHIN GROUP ( ORDER BY max_temp )
             FROM us_statistics.temperature_readings
             GROUP BY station_name, date_part(''month'', observation_date)
             ORDER BY station_name',
             'SELECT month
             FROM generate_series(1, 12) month'
     ) AS (station TEXT, jan NUMERIC(3, 0), feb NUMERIC(3, 0), mar NUMERIC(3, 0), apr NUMERIC(3, 0),
           may NUMERIC(3, 0), jun NUMERIC(3, 0), jul NUMERIC(3, 0), aug NUMERIC(3, 0), sep NUMERIC(3, 0),
           oct NUMERIC(3, 0), nov NUMERIC(3, 0), dec NUMERIC(3, 0)
    );

-- CASE WHEN
SELECT max_temp,
       CASE
           WHEN max_temp >= 90 THEN 'Hot'
           WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
           WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
           WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
           WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
           WHEN max_temp < 20 THEN 'Inhumane'
           ELSE 'No reading'
           END AS temperature_group
FROM us_statistics.temperature_readings
ORDER BY station_name, observation_date;

WITH temps_collapsed(station_name, max_temperature_group) AS
         (SELECT station_name,
                 CASE
                     WHEN max_temp >= 90 THEN 'Hot'
                     WHEN max_temp >= 70 AND max_temp < 90 THEN 'Warm'
                     WHEN max_temp >= 50 AND max_temp < 70 THEN 'Pleasant'
                     WHEN max_temp >= 33 AND max_temp < 50 THEN 'Cold'
                     WHEN max_temp >= 20 AND max_temp < 33 THEN 'Frigid'
                     WHEN max_temp < 20 THEN 'Inhumane'
                     ELSE 'No reading'
                     END AS temperature_group
          FROM us_statistics.temperature_readings)
SELECT station_name, max_temperature_group, count(*)
FROM temps_collapsed
GROUP BY station_name, max_temperature_group
ORDER BY station_name, count(*) DESC;

WITH waikiki_temps AS (SELECT max_temp,
                              CASE
                                  WHEN max_temp >= 90 THEN '90 or more'
                                  WHEN max_temp >= 88 AND max_temp < 90 THEN '88-89'
                                  WHEN max_temp >= 86 AND max_temp < 88 THEN '86-87'
                                  WHEN max_temp >= 84 AND max_temp < 86 THEN '84-85'
                                  WHEN max_temp >= 82 AND max_temp < 84 THEN '82-83'
                                  WHEN max_temp >= 80 AND max_temp < 82 THEN '80-81'
                                  WHEN max_temp < 80 THEN '79 or less'
                                  ELSE 'No reading'
                                  END AS temp_group
                       FROM us_statistics.temperature_readings
                       WHERE station_name = 'WAIKIKI 717.2 HI US')
SELECT temp_group, count(*)
FROm waikiki_temps
GROUP BY temp_group
ORDER BY count(*) DESC;

SELECT flavor, office, count(*)
FROM playground.ice_cream_survey
GROUP BY flavor, office
ORDER BY flavor;

SELECT office
FROM playground.ice_cream_survey
GROUP BY office
ORDER BY office;

SELECT *
FROM crosstab('SELECT flavor, office, count(*)
              FROM playground.ice_cream_survey
              GROUP BY flavor, office
              ORDER BY flavor', 'SELECT office FROM playground.ice_cream_survey
GROUP BY office
ORDER BY office') AS (office TEXT, Downtown INTEGER, Midtown INTEGER, Uptown INTEGER);
