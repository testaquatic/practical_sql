-- psql

\copy us_counties_pop_est_2019
    (county_name, internal_point_lat, internal_point_lon)
TO './data/us_counties_latlon_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');

