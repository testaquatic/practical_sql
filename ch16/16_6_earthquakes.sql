-- psql
START TRANSACTION;

CREATE TABLE earthquakes (
    id         INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    earthquake jsonb NOT NULL
);

\copy earthquakes (earthquake) FROM 'data\earthquakes.json';

CREATE INDEX idx_earthquakes ON earthquakes USING gin (earthquake);

SELECT
    COUNT(*)
FROM
    earthquakes;

COMMIT;
--

SELECT
    id,
    earthquake #>> '{properties, time}' AS time
FROM
    earthquakes
ORDER BY
    id
LIMIT 5;

SELECT
    id,
    earthquake #>> '{properties, time}'                                          AS time,
    TO_TIMESTAMP((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000) AS time_formatted
FROM
    earthquakes
ORDER BY
    id
LIMIT 5;

SELECT
    MIN(TO_TIMESTAMP((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000)) AT TIME ZONE
    'UTC'                                                                                                AS min_timestamp,
    MAX(TO_TIMESTAMP((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000)) AT TIME ZONE
    'UTC'                                                                                                AS max_timestamp
FROM
    earthquakes;

SELECT
    earthquake #>> '{properties, place}'                                                            AS place,
    TO_TIMESTAMP((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000) AT TIME ZONE 'UTC' AS time,
    (earthquake #>> '{properties, mag}')::NUMERIC                                                   AS magnitude
FROM
    earthquakes
ORDER BY
    (earthquake #>> '{properties, mag}')::NUMERIC DESC NULLS LAST
LIMIT 5;

SELECT
    earthquake #>> '{properties, place}'                                                            AS place,
    TO_TIMESTAMP((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000) AT TIME ZONE 'UTC' AS time,
    (earthquake #>> '{properties, mag}')::NUMERIC                                                   AS magnitude,
    (earthquake #>> '{properties, felt}')::INT                                                      AS felt
FROM
    earthquakes
ORDER BY
    (earthquake #>> '{properties, felt}')::INT DESC NULLS LAST
LIMIT 5;

SELECT
    id,
    earthquake #>> '{geometry, coordinates}'    AS coordinates,
    earthquake #>> '{geometry, coordinates, 0}' AS longitude,
    earthquake #>> '{geometry, coordinates, 1}' AS latitude
FROM
    earthquakes
ORDER BY
    id
LIMIT 5;

SELECT
    st_setsrid(st_makepoint((earthquake #>> '{geometry, coordinates, 0}')::NUMERIC,
                            (earthquake #>> '{geometry, coordinates, 1}')::NUMERIC),
               4326)::geography AS earthquake_point
FROM
    earthquakes
ORDER BY
    id;

START TRANSACTION;

ALTER TABLE earthquakes
    ADD COLUMN earthquake_point geography(POINT, 4326);

UPDATE earthquakes
SET
    earthquake_point = st_setsrid(st_makepoint((earthquake #>> '{geometry, coordinates, 0}')::NUMERIC,
                                               (earthquake #>> '{geometry, coordinates, 1}')::NUMERIC), 4326)::geography
;

CREATE INDEX quake_pt_idx ON earthquakes USING gist (earthquake_point);

COMMIT;

SELECT
    earthquake #>> '{properties, place}'                                                              AS place,
    TO_TIMESTAMP((earthquake -> 'properties' ->> 'time')::DOUBLE PRECISION / 1000) AT TIME ZONE 'UTC' AS time,
    (earthquake #>> '{properties, mag}'):: NUMERIC                                                    AS magnitude,
    earthquake_point
FROM
    earthquakes
WHERE
    st_dwithin(earthquake_point, st_geogfromtext('POINT(-95.989505 36.155007)'), 80_000)
ORDER BY
    time;
