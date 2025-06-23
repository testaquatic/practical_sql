-- psql

\copy (
    SELECT county_name, state_name
    FROM us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
)
TO './data/us_counties_mill_export.csv'
WITH (FORMAT CSV, HEADER);