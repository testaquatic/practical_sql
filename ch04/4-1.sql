CREATE TABLE char_data_types (
    char_column    CHAR(10),
    varchar_column VARCHAR(10),
    text_column    TEXT
);

INSERT INTO char_data_types
VALUES (
    'abc', 'abc', 'abc'
), (
    'defghi', 'defghi', 'defghi'
);

---- psql
\copy char_data_types TO './data/typetest.txt' WITH (FORMAT CSV, HEADER, DELIMITER '|');
----

CREATE TABLE number_data_types (
    numeric_column NUMERIC(20, 5),
    real_column    REAL,
    double_column  DOUBLE PRECISION
);

INSERT INTO number_data_types
VALUES (
    .7, .7, .7
), (
    2.13579, 2.13579, 2.13579
), (
    2.1357987654, 2.1357987654, 2.1357987654
);

SELECT *
FROM
    number_data_types;

SELECT
    numeric_column * 10_000_000 AS fixed,
    real_column * 10_000_000    AS floating
FROM
    number_data_types
WHERE
    numeric_column = .7;

CREATE TABLE date_time_types (
    timestamp_column TIMESTAMP WITH TIME ZONE,
    interval_column  INTERVAL
);

INSERT INTO date_time_types
VALUES (
    '2022-12-31 01:00 EST', '2 days'
), (
    '2022-12-31 01:00 -8', '1 month'
), (
    '2022-12-31 01:00 Australia/Melbourne', '1 century'
), (
    NOW(), '1 week'
);

SELECT *
FROM
    date_time_types;

SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date
FROM
    date_time_types;

SELECT
    timestamp_column,
    CAST(timestamp_column AS VARCHAR(10))
FROM
    date_time_types;

SELECT
    numeric_column,
    CAST(numeric_column AS INTEGER),
    CAST(numeric_column AS TEXT)
FROM
    number_data_types;

SELECT
    CAST(char_column AS INTEGER)
FROM
    char_data_types;

SELECT
    timestamp_column,
    CAST(timestamp_column AS VARCHAR(10))
FROM
    date_time_types;
SELECT
    timestamp_column::VARCHAR(10)
FROM
    date_time_types;
