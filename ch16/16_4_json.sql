-- psql
START TRANSACTION;

CREATE TABLE films (
    id   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    film jsonb NOT NULL
);

\copy films (film) FROM 'data\films.json';

CREATE INDEX idx_film ON films USING gin (film);

COMMIT;
--

SELECT *
FROM
    films;

SELECT
    id,
    film -> 'title' AS title
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film ->> 'title' AS title
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film -> 'genre' AS genre
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film -> 'genre' -> 0 AS genres
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film -> 'genre' -> -1 AS genres
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film -> 'genre' -> 2 AS genres
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film -> 'genre' ->> 0 AS genres
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film #> '{rating, MPAA}' AS mpaa_rating
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film -> 'rating' -> 'MPAA' AS mpaa_rating
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film #> '{characters, 0, name}' AS name
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film #>> '{characters, 0, name}' AS name
FROM
    films
ORDER BY
    id;

SELECT
    id,
    film ->> 'title' AS title,
    film @> '{
      "title": "The Incredibles"
    }'::jsonb        AS is_incredible
FROM
    films
ORDER BY
    id;

SELECT
    film ->> 'title' AS title,
    film ->> 'year'  AS year
FROM
    films
WHERE
    film @> '{
      "title": "The Incredibles"
    }'::jsonb;

SELECT
    film ->> 'title' AS title,
    film ->> 'year'  AS year
FROM
    films
WHERE
    '{
      "title": "The Incredibles"
    }'::jsonb <@ film;

SELECT
    film ->> 'title' AS title
FROM
    films
WHERE
    film ? 'rating';

SELECT
    film ->> 'title'  AS title,
    film ->> 'rating' AS rating,
    film ->> 'genre'  AS genre
FROM
    films
WHERE
    film ?| '{"rating", "genre"}';

SELECT
    film ->> 'title'  AS title,
    film ->> 'rating' AS rating,
    film ->> 'genre'  AS genre
FROM
    films
WHERE
    film ?& ARRAY ['rating', 'genre'];