START TRANSACTION;

CREATE TABLE farmers_markets (
    fmid        BIGINT PRIMARY KEY,
    market_name TEXT NOT NULL,
    street      TEXT,
    city        TEXT,
    county      TEXT,
    st          TEXT NOT NULL,
    zip         TEXT,
    longitude   NUMERIC(10, 7),
    latitude    NUMERIC(10, 7),
    organic     TEXT NOT NULL
);

\copy farmers_markets FROM 'data\farmers_markets.csv' WITH (FORMAT CSV, HEADER);

SELECT
    COUNT(*)
FROM
    farmers_markets;

COMMIT;

START TRANSACTION;

ALTER TABLE farmers_markets
    ADD COLUMN geog_point geography(POINT, 4326);

UPDATE farmers_markets
SET
    geog_point = st_setsrid(st_makepoint(longitude, latitude)::geography, 4326);

CREATE INDEX market_pts_idx ON farmers_markets USING gist (geog_point);

SELECT
    longitude,
    latitude,
    geog_point,
    st_astext(geog_point)
FROM
    farmers_markets
WHERE
    longitude IS NOT NULL
LIMIT 5;

COMMIT;

SELECT
    market_name,
    city,
    st,
    geog_point
FROM
    farmers_markets
WHERE
    st_dwithin(geog_point, st_geomfromtext('POINT(-93.6204386 41.5853202)'), 10000)
ORDER BY
    market_name;

SELECT
    st_distance(st_geogfromtext('POINT(-73.9283685 40.8296466)'), st_geogfromtext('POINT(-73.8480153 40.7570917)')) /
    1000 AS mets_to_yanks;

SELECT
    market_name,
    city,
    ROUND((st_distance(geog_point, st_geogfromtext('POINT(-93.6204386 41.5853202)')::geography) / 1000)::NUMERIC,
          2) AS km_from_dt
FROM
    farmers_markets
WHERE
    st_dwithin(geog_point, st_geogfromtext('POINT(-93.6204386 41.5853202)'), 10000)
ORDER BY
    km_from_dt;