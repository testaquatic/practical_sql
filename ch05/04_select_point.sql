SELECT
    county_name, state_name, internal_point_lat, internal_point_lon
FROM
    us_counties_pop_est_2019
ORDER BY
    internal_point_lon DESC
LIMIT 5;

