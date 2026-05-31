CREATE TABLE new_york_addresses (
    longitude     NUMERIC(9, 6),
    latitude      NUMERIC(9, 6),
    street_number TEXT,
    street        TEXT,
    unit          TEXT,
    postcode      TEXT,
    id            INTEGER
        CONSTRAINT new_york_key PRIMARY KEY
);

------------------- psql
\copy new_york_addresses FROM './data/city_of_new_york.csv' WITH (FORMAT CSV, HEADER);
-------------------

SELECT *
FROM
    new_york_addresses;

----- 15ms~
EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = 'BROADWAY';
---- 15ms~
EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = '52 STREET';

--- 14ms~
EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = 'ZWICKY AVENUE';

CREATE INDEX street_idx ON new_york_addresses (street);

----- 1.4ms~
EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = 'BROADWAY';
---- 0.51ms~
EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = '52 STREET';

--- 0.034ms~
EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = 'ZWICKY AVENUE';