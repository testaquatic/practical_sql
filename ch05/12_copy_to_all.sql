-- psql

\copy us_counties_pop_est_2019
TO './data/us_counties_export.txt'
WITH (FORMAT CSV, HEADER, DELIMITER '|');