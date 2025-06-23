BEGIN TRANSACTION;


CREATE TABLE us_counties_pop_est_2019 (state_fips TEXT, county_fips TEXT, region SMALLINT, state_name TEXT, county_name TEXT, area_land BIGINT, area_water BIGINT, internal_point_lat NUMERIC(10, 7),
                                                                                                                                                                                      internal_point_lon NUMERIC(10, 7),
                                                                                                                                                                                                         pop_est_2018 INTEGER, pop_est_2019 INTEGER, births_2019 INTEGER, deaths_2019 INTEGER, international_migr_2019 INTEGER, domestic_migr_2019 INTEGER, residual_2019 INTEGER, CONSTRAINT counties_2019_key PRIMARY KEY (state_fips,
                                                                                                                                                                                                                                                                                                                                                                                                                             county_fips));


SELECT *
FROM us_counties_pop_est_2019;


COMMIT;

-- psql
-- \copy us_counties_pop_est_2019 FROM './data/us_counties_pop_est_2019.csv' WITH (FORMAT CSV, HEADER);