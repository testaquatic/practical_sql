CREATE SCHEMA county_statistics;

CREATE TABLE county_statistics.meat_poultry_egg_establishments
(
    LIKE fsis.meat_poultry_egg_establishments INCLUDING ALL
);

INSERT INTO county_statistics.meat_poultry_egg_establishments
SELECT *
FROM fsis.meat_poultry_egg_establishments;

DROP TABLE fsis.meat_poultry_egg_establishments;
DROP TABLE fsis.meat_poultry_egg_establishments_backup;
DROP SCHEMA fsis;

CREATE TABLE county_statistics.us_counties_pop_est_2019
(
    LIKE pop.us_counties_pop_est_2019 INCLUDING ALL
);

INSERT INTO county_statistics.us_counties_pop_est_2019
SELECT *
FROM pop.us_counties_pop_est_2019;

DROP TABLE pop.us_counties_pop_est_2019;

CREATE TABLE county_statistics.us_counties_pop_est_2010
(LIKE pop.us_counties_pop_est_2010 INCLUDING ALL );

INSERT INTO county_statistics.us_counties_pop_est_2010
SELECT *
FROM pop.us_counties_pop_est_2010;

DROP TABLE pop.us_counties_pop_est_2010;

CREATE TABLE playground.supervisor_salaries
(
    LIKE pop.supervisor_salaries INCLUDING ALL
);

INSERT INTO playground.supervisor_salaries(town, county, supervisor, start_date, salary, benefits)
SELECT town, county, supervisor, start_date, salary, benefits
FROM pop.supervisor_salaries;

SELECT * FROM playground.supervisor_salaries;
SELECT * FROM pop.supervisor_salaries;

DROP TABLE pop.supervisor_salaries;
DROP SCHEMA pop;


CREATE TABLE county_statistics.acs_2014_2018_stats
(
    geoid                TEXT
        CONSTRAINT geoid_key PRIMARY KEY,
    county               TEXT NOT NULL,
    st                   TEXT NOT NULL,
    pct_travel_60_min    NUMERIC(5, 2),
    pct_bachelors_higher NUMERIC(5, 2),
    pct_masters_higher   NUMERIC(5, 2),
    median_hh_income     INTEGER,
    CHECK ( pct_masters_higher <= pct_bachelors_higher )
);

COPY county_statistics.acs_2014_2018_stats
    FROM 'acs_2014_2018_stats.csv'
    WITH (FORMAT CSV , HEADER );

SELECT *
FROM county_statistics.acs_2014_2018_stats;