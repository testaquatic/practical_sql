-- psql start
BEGIN TRANSACTION;


CREATE TABLE us_counties_pop_est_2010 (state_fips TEXT, county_fips TEXT, region SMALLINT, state_name TEXT, county_name TEXT, estimates_base_2010 INTEGER, CONSTRAINT counties_2010_key PRIMARY KEY (state_fips,
                                                                                                                                                                                                     county_fips));

\copy us_counties_pop_est_2010
FROM './data/us_counties_pop_est_2010.csv' WITH (FORMAT CSV,
                                                 HEADER);


COMMIT;

-- psql end

SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,
       c2010.estimates_base_2010 AS pop_2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,
       ROUND((c2019.pop_est_2019::NUMERIC - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100, 1) AS pct_change
FROM us_counties_pop_est_2019 AS c2019
JOIN us_counties_pop_est_2010 AS c2010 ON c2019.state_fips = c2010.state_fips
AND c2019.county_fips = c2010.county_fips
ORDER BY pct_change DESC;