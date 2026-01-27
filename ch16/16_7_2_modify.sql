START TRANSACTION;

UPDATE films
SET
    film = film || '{
      "studio": "Pixar"
    }'::jsonb
WHERE
    film @> '{
      "title": "The Incredibles"
    }'::jsonb;

UPDATE films
SET
    film = film || JSONB_BUILD_OBJECT('studio', 'Pixar')
WHERE
    film @> '{
      "title": "The Incredibles"
    }'::jsonb;


COMMIT;

SELECT *
FROM
    films;

UPDATE films
SET
    film = JSONB_SET(film, '{genre}', film #> '{genre}' || '["World War II"]', TRUE)
WHERE
    film @> '{
      "title": "Cinema Paradiso"
    }'::jsonb;


UPDATE films
SET
    film = film - 'studio'
WHERE
    film @> '{
      "title": "The Incredibles"
    }'::jsonb;

UPDATE films
SET
    film = film #- '{genre, 2}'
WHERE
    film @> '{"title":"Cinema Paradiso"}';

SELECT
    id,
    film ->> 'title'                         AS title,
    JSONB_ARRAY_LENGTH(film -> 'characters') AS num_characters
FROM
    films
ORDER BY
    id;

SELECT
    id,
    JSONB_ARRAY_ELEMENTS(film -> 'genre')      AS genre_jsonb,
    JSONB_ARRAY_ELEMENTS_TEXT(film -> 'genre') AS genre_text
FROM
    films
ORDER BY
    id;

WITH characters (id, json) AS (
    SELECT id, JSONB_ARRAY_ELEMENTS(film -> 'characters')
    FROM films
                              )
SELECT
    id,
    json ->> 'name'  AS name,
    json ->> 'actor' AS actor
FROM
    characters
ORDER BY
    id;