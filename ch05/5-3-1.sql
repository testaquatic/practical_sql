BEGIN;


CREATE TABLE us_counties_pop_est_2019 (
    state_fips              TEXT,           -- State FIPS code
    county_fips             TEXT,           -- County FIPS code
    region                  SMALLINT,       -- Region
    state_name              TEXT,           -- State name
    county_name             TEXT,           -- County name
    area_land               BIGINT,         -- Area (Land) in square meters
    area_water              BIGINT,         -- Area (Water) in square meters
    internal_point_lat      NUMERIC(10, 7), -- Internal point (latitude)
    internal_point_lon      NUMERIC(10, 7), -- Internal point (longitude)
    pop_est_2018            INTEGER,        -- 2018-07-01 resident total population estimate
    pop_est_2019            INTEGER,        -- 2019-07-01 resident total population estimate
    births_2019             INTEGER,        -- Births from 2018-07-01 to 2019-06-30
    deaths_2019             INTEGER,        -- Deaths from 2018-07-01 to 2019-06-30
    international_migr_2019 INTEGER,        -- Net international migration from 2018-07-01 to 2019-06-30
    domestic_migr_2019      INTEGER,        -- Net domestic migration from 2018-07-01 to 2019-06-30
    residual_2019           INTEGER,        -- Residual for 2018-07-01 to 2019-06-30
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)
);

COMMIT;

SELECT *
FROM
    us_counties_pop_est_2019;

-------- psql start
START TRANSACTION;

\copy us_counties_pop_est_2019 FROM './ch05/data/us_counties_pop_est_2019.csv' WITH (FORMAT CSV, HEADER);

SELECT *
FROM
    us_counties_pop_est_2019
LIMIT 5;

COMMIT;
-------- psql end

SELECT *
FROM
    us_counties_pop_est_2019;

SELECT
    county_name,
    state_name,
    area_land
FROM
    us_counties_pop_est_2019
ORDER BY
    area_land DESC
LIMIT 3;

SELECT
    county_name,
    state_name,
    internal_point_lat,
    internal_point_lon
FROM
    us_counties_pop_est_2019
ORDER BY
    internal_point_lon DESC
LIMIT 5;

START TRANSACTION;

CREATE TABLE IF NOT EXISTS supervisor_salaries (
    id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town       TEXT,
    county     TEXT,
    supervisor TEXT,
    start_date DATE,
    salary     NUMERIC(10, 2),
    benefits   NUMERIC(10, 2)
);
SELECT *
FROM
    supervisor_salaries;

COMMIT;

-------- psql start
START TRANSACTION;
\copy supervisor_salaries (town, supervisor, salary) FROM './ch05/data/supervisor_salaries.csv' WITH (FORMAT CSV, HEADER) ;
SELECT *
FROM
    supervisor_salaries;
COMMIT;
-------- psql end

START TRANSACTION;
DELETE
FROM
    supervisor_salaries;
SELECT *
FROM
    supervisor_salaries;
COMMIT;

-------- psql start
START TRANSACTION;
\copy supervisor_salaries (town, supervisor, salary) FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV, HEADER) WHERE town = 'New Brillig';
SELECT *
FROM
    supervisor_salaries;
COMMIT;
-------- psql end

START TRANSACTION;
DELETE
FROM
    supervisor_salaries;
COMMIT;

-------- psql start
START TRANSACTION;
CREATE TEMPORARY TABLE supervisor_salaries_temp (
    LIKE supervisor_salaries INCLUDING ALL
);
\copy supervisor_salaries_temp (town, supervisor, salary) FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV, HEADER);
INSERT INTO supervisor_salaries (
    town, county, supervisor, salary
)
SELECT
    town,
    'Mills',
    supervisor,
    salary
FROM
    supervisor_salaries_temp;
DROP TABLE supervisor_salaries_temp;
COMMIT;
-------- psql end

SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;

-------- psql start
\copy us_counties_pop_est_2019 TO './data/us_counties_export.txt' WITH (FORMAT CSV, HEADER, DELIMITER '|');
\copy us_counties_pop_est_2019 (county_name, internal_point_lat, internal_point_lon) TO './data/us_counties_latlon_export.txt' WITH (FORMAT CSV, HEADER, DELIMITER '|');
\copy (SELECT county_name, state_name FROM us_counties_pop_est_2019 WHERE county_name ILIKE '%mill%') TO './data/us_counties_mill_export.csv' WITH (FORMAT CSV, HEADER);
-------- psql end