CREATE SCHEMA playground;

CREATE TABLE playground.char_data_types
(
    char_column    CHAR(10),
    varchar_column VARCHAR(10),
    text_column    TEXT
);

INSERT INTO playground.char_data_types
VALUES ('abc', 'abc', 'abc'),
       ('defghi', 'defghi', 'defghi');

-- psql
-- \copy playground.char_data_types TO 'typetest.txt'
-- WITH (FORMAT CSV, HEADER, DELIMITER '|');
