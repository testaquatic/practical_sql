-- psql
 \copy us_counties_pop_est_2019 TO './data/us_counties_export.txt' WITH (FORMAT CSV,
                                                                         HEADER,
                                                                         DELIMITER '|');

\copy us_counties_pop_est_2019 (county_name, internal_point_lat, internal_point_lon) TO './data/us_counties_latlon_export.txt' WITH (FORMAT CSV,
                                                                                                                                     HEADER,
                                                                                                                                     DELIMITER '|');

\copy
    (SELECT county_name,
            state_name
     FROM us_counties_pop_est_2019
     WHERE county_name ILIKE '%mill%' ) TO './data/us_counties_mill_export.txt' WITH (FORMAT CSV,
                                                                                      HEADER);