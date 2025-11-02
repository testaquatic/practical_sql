BEGIN;
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
COMMIT;

-- psql
BEGIN;
COPY new_york_addresses FROM './data/city_of_new_york.csv' WITH (FORMAT CSV , HEADER );
COMMIT;
--

SELECT *
FROM
    new_york_addresses;

EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = 'BROADWAY';

EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = '51 STREET';

EXPLAIN ANALYSE
    SELECT *
    FROM
        new_york_addresses
    WHERE
        street = 'ZWICKY AVENUE';

BEGIN;

CREATE INDEX street_idx ON new_york_addresses (street);

COMMIT;