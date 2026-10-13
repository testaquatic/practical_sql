-- 데이터셋 생성
CREATE TABLE playground.earthquakes
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    earthquake jsonb NOT NULL
);

COPY playground.earthquakes (earthquake)
    FROM 'earthquakes.json';

CREATE INDEX idx_earthquakes ON playground.earthquakes USING gin (earthquake);

SELECT count(*)
FROM playground.earthquakes;

-- 지진 발생 시간
SELECT id, earthquake #>> '{properties, time}'
FROM playground.earthquakes
LIMIT 5;

SELECT id,
       earthquake #>> '{properties, time}'                                          AS time,
       to_timestamp((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000) AS time_formatted
FROM playground.earthquakes
LIMIT 5;

SELECT min(to_timestamp((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000)
       ) AT TIME ZONE 'UTC' AS min_timestamp,
       max(to_timestamp((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000)) AT TIME ZONE
       'UTC'                AS max_timestamp
FROM playground.earthquakes;


-- 진도와 빈도
SELECT earthquake #>> '{properties, place}'                                                            AS place,
       to_timestamp((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000) AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::NUMERIC                                                   AS magnitude
FROM playground.earthquakes
ORDER BY (earthquake #>> '{properties, mag}')::NUMERIC DESC NULLS LAST
LIMIT 5;

SELECT earthquake #>> '{properties,place}'                                                             AS place,
       to_timestamp((earthquake #>> '{properties, time}')::DOUBLE PRECISION / 1000) AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties, mag}')::NUMERIC                                                   AS magnitude,
       (earthquake #>> '{properties,felt}')::INTEGER                                                   as felt
FROM playground.earthquakes
ORDER BY (earthquake #>> '{properties,felt}')::INTEGER DESC NULLS LAST
LIMIT 5;

-- 공간 데이터
SELECT id,
       earthquake #>> '{geometry, coordinates}'    AS coordinates,
       earthquake #>> '{geometry, coordinates, 0}' AS longitude,
       earthquake #>> '{geometry, coordinates, 1}' AS latitude
FROM playground.earthquakes
ORDER BY id
LIMIT 5;

SELECT st_setsrid(st_makepoint((earthquake #>> '{geometry, coordinates, 0}')::NUMERIC,
                               (earthquake #>> '{geometry, coordinates, 1}')::NUMERIC),
                  4326)::geography AS earthquake_point
FROM playground.earthquakes
ORDER BY id;

ALTER TABLE playground.earthquakes
    ADD COLUMN earthquake_point geography(POINT, 4326);

UPDATE playground.earthquakes
SET earthquake_point = st_setsrid(st_makepoint((earthquake #>> '{geometry, coordinates, 0}')::NUMERIC,
                                               (earthquake #>> '{geometry, coordinates, 1}')::NUMERIC),
                                  4326)::geography;

CREATE INDEX quake_pt_idx ON playground.earthquakes USING gist (earthquake_point);

SELECT earthquake #>> '{properties,place}'                                                               AS place,
       to_timestamp((earthquake -> 'properties' ->> 'time')::DOUBLE PRECISION / 1000) AT TIME ZONE 'UTC' AS time,
       (earthquake #>> '{properties,mag}')::NUMERIC                                                      AS magnitude,
       earthquake_point
FROM playground.earthquakes
WHERE st_dwithin(earthquake_point, st_geogfromtext('POINT(-95.989505 36.155007)'), 80_000)
ORDER BY time;

SELECT to_json(row (emp_id, last_name)) AS json_rows
FROM playground.employees;


SELECT to_json(employees)
FROM (SELECT emp_id, last_name
      FROM playground.employees) AS employees;

SELECT json_agg(to_json(employees))
FROM (SELECT emp_id, last_name
      FROM playground.employees) AS employees;

-- 필드 추가
UPDATE playground.films
SET film = film || '{
  "studio": "Pixar"
}'::jsonb
WHERE film @> '{
  "title": "The Incredibles"
}'::jsonb;

UPDATE playground.films
SET film = film || jsonb_build_object('studio', 'Pixar')
WHERE film @> '{
  "title": "The Incredibles"
}'::jsonb;

SELECT *
FROM playground.films;

UPDATE playground.films
SET film = jsonb_set(film, '{genre}', film #> '{genre}' || '["World War II"]', true)
WHERE film @> '{
  "title": "Cinema Paradiso"
}'::jsonb;

UPDATE playground.films
SET film = film - 'studio'
WHERE film @> '{
  "title": "The Incredibles"
}'::jsonb;

UPDATE playground.films
SET film = film #- '{genre,2}'
WHERE film @> '{"title":"Cinema Paradiso"}';

-- json 처리 함수
SELECT id, film ->> 'title' AS title, jsonb_array_length(film -> 'characters') AS num_characters
FROM playground.films
ORDER BY id;

SELECT id,
       jsonb_array_elements(film -> 'genre')      AS genre_jsonb,
       jsonb_array_elements_text(film -> 'genre') AS genre_text
FROM playground.films
ORDER BY id;

SELECT id, jsonb_array_elements(film -> 'characters')
FROM playground.films
ORDER BY id;

WITH characters AS (SELECT id, jsonb_array_elements(film -> 'characters') AS json
                    FROM playground.films
                    ORDER BY id)
SELECT id, json ->> 'name' AS name, json ->> 'actor' AS actor
FROM characters
ORDER BY id;

SELECT id,
       earthquake -> 'properties' -> 'tsunami' AS                                 tsunami,
       earthquake_point                                                           point,
       to_timestamp((earthquake #> '{properties,time}')::DOUBLE PRECISION / 1000) time,
       earthquake -> 'properties' -> 'mag'     AS                                 mag
FROM playground.earthquakes
WHERE (earthquake -> 'properties' -> 'tsunami')::INTEGER = 1
ORDER BY id;

CREATE TABLE playground.earthquakes_from_json
(
    id               text PRIMARY KEY,
    title            text,
    type             text,
    quake_date       timestamptz,
    mag              numeric,
    place            text,
    earthquake_point geography(POINT, 4326),
    url              text
);

WITH earthquakes_data AS (SELECT earthquake ->> 'id'                             AS id,
                                 earthquake -> 'properties' ->> 'title'          AS title,
                                 earthquake -> 'properties' ->> 'type'           AS type,
                                 to_timestamp((earthquake -> 'properties' ->> 'time')::DOUBLE PRECISION / 1000) AT TIME ZONE
                                 'UTC'                                           AS quake_date,
                                 (earthquake -> 'properties' ->> 'mag')::NUMERIC AS mag,
                                 earthquake -> 'properties' ->> 'place'          AS place,
                                 st_setsrid(st_makepoint((earthquake -> 'geometry' -> 'coordinates' ->> 0)::NUMERIC,
                                                         (earthquake -> 'geometry' -> 'coordinates' ->> 1)::NUMERIC),
                                            4326)::geography                     AS earthquake_point,
                                 earthquake -> 'properties' ->> 'url'            AS url
                          FROM playground.earthquakes)
INSERT
INTO playground.earthquakes_from_json
SELECT *
FROM earthquakes_data;

CREATE INDEX ON playground.earthquakes (id);

-- 12899
SELECT count(*)
FROM playground.earthquakes_from_json;

SELECT *
    FROM playground.teachers;

SELECT * FROM playground.teachers_lab_access;

SELECT id, first_name AS fn, last_name AS ln, l.access_time
FROM playground.teachers t JOIN playground.teachers_lab_access l
ON t.id = l.teacher_id;

WITH lab_access AS (
    SELECT a.teacher_id AS id, jsonb_agg(json) AS lab_access
           FROM playground.teachers_lab_access a JOIN LATERAL (
               SELECT lab_name, access_time::text
               ) AS json ON true
           GROUP BY id
), teacher_lab AS (
    SELECT t.id, first_name::text AS fn, last_name::text AS ln, a.lab_access
        FROM playground.teachers t JOIN lab_access a ON t.id = a.id
) SELECT to_json(teacher_lab)
      FROM teacher_lab
WHERE id = 6;