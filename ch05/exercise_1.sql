BEGIN TRANSACTION;

CREATE TEMPORARY TABLE movie_actor_temp (
    id INTEGER PRIMARY KEY,
    movie TEXT NOT NULL,
    actor TEXT NOT NULL
);

-- psql

\copy movie_actor_temp
FROM './data/movie_actor.txt'
WITH (FORMAT CSV, HEADER, DELIMITER ':');

--

SELECT * FROM movie_actor_temp;

COMMIT;

DROP TABLE movie_actor_temp;