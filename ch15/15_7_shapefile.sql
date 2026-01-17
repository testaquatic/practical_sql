SELECT
    st_astext(geom)
FROM
    us_counties_2019_shp
ORDER BY
    gid
LIMIT 1;

SELECT
    name,
    statefp                                                 AS st,
    ROUND((st_area(geom::geography) / 1000000)::NUMERIC, 2) AS square_km
FROM
    us_counties_2019_shp
ORDER BY
    square_km DESC
LIMIT 5;

SELECT
    sh.name,
    c.state_name
FROM
    us_counties_2019_shp sh
    JOIN us_counties_pop_est_2019 c ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE
    st_within('SRID=4269;POINT(-118.3419063 34.0977076)'::geometry, geom);

SELECT
    SUM(c.pop_est_2019) AS pop_est_2019
FROM
    us_counties_2019_shp sh
    JOIN us_counties_pop_est_2019 c ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE
    st_dwithin(sh.geom::geography, st_geogfromtext('SRID=4269;POINT(-96.699656 40.811567)'), 80000);

SELECT
    sh.name,
    c.state_name,
    st_transform(sh.geom, 4326) AS geom
FROM
    us_counties_2019_shp sh
    JOIN us_counties_pop_est_2019 c ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE
    st_dwithin(sh.geom::geography, st_geogfromtext('SRID=4269;POINT(-96.699656 40.811567)'), 80000);