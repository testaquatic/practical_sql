-- 데이터 셋 생성
CREATE TABLE playground.films
(
    id   integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    film jsonb NOT NULL
);

COPY playground.films (film)
    FROM 'films.json';

CREATE INDEX idx_film ON playground.films USING gin (film);

SELECT *
FROM playground.films;

-- 키 값 추출
SELECT id, film -> 'title' AS title
FROM playground.films
ORDER BY id;

SELECT id, film ->> 'title' AS title
FROM playground.films
ORDER BY id;

SELECT id, film -> 'genre' AS genre
FROM playground.films
ORDER BY id;

-- 배열
SELECT id, film -> 'genre' -> 0 AS genres
FROM playground.films
ORDER BY id;

SELECT id, film -> 'genre' -> -1 AS genres
FROM playground.films
ORDER BY id;

SELECT id, film -> 'genre' -> 2 AS genres
FROM playground.films
ORDER BY id;

SELECT id, film -> 'genre' ->> 0 AS genres
FROM playground.films
ORDER BY id;

-- 경로
SELECT id, film #> '{rating, MPAA}' AS mpaa_rating
FROM playground.films
ORDER BY id;

SELECT id, film #> '{characters, 0, name}' AS name
FROM playground.films
ORDER BY id;

SELECT id, film #>> '{characters, 0, name}' AS name
FROM playground.films
ORDER BY id;

-- 포함
SELECT id,
       film ->> 'title' AS title,
       film @> '{
         "title": "The Incredibles"
       }'::jsonb        AS is_incredible
FROM playground.films
ORDER BY id;

SELECT id,
       film ->> 'title' AS title,
       film @> '{
         "title": "The Incredibles"
       }'::jsonb        AS is_incredible
FROM playground.films
ORDER BY id;

SELECT film ->> 'title' AS title,
       film ->> 'year'  AS year
FROM playground.films
WHERE film @> '{
  "title": "The Incredibles"
}'::jsonb;

SELECT film ->> 'title' AS title,
       film ->> 'year'  AS year
FROM playground.films
WHERE '{
  "title": "The Incredibles"
}'::jsonb <@ film;

-- 존재여부
SELECT film ->> 'title' AS title
FROM playground.films
WHERE film ? 'rating';

SELECT film ->> 'title' AS title,
       film ->> 'rating' AS rating,
       film ->> 'genre' AS genre
FROM playground.films
WHERE film ?| '{rating, genre}';

SELECT film ->> 'title' AS title,
       film ->> 'rating' AS rating,
       film ->> 'genre' AS genre
FROM playground.films
WHERE film ?& '{rating, genre}';


