CREATE TABLE current_time_example (
    time_id               INTEGER GENERATED ALWAYS AS IDENTITY,
    current_timestamp_col timestamptz,
    clock_timestamp_col   timestamptz
);

INSERT INTO current_time_example (
    current_timestamp_col, clock_timestamp_col
) (
    SELECT CURRENT_TIMESTAMP, CLOCK_TIMESTAMP() FROM GENERATE_SERIES(1, 1000)
  );

SELECT *
FROM
    current_time_example;

SHOW TIMEZONE;

SELECT CURRENT_SETTING('timezone');

SELECT MAKE_TIMESTAMPTZ(2022, 2, 22, 18, 4, 30.3, CURRENT_SETTING('timezone'));

SELECT *
FROM
    pg_timezone_abbrevs
ORDER BY
    abbrev;

SELECT *
FROM
    pg_timezone_names
ORDER BY
    name;

SELECT *
FROM
    pg_timezone_names
WHERE
    name LIKE 'Europe%'
ORDER BY
    name;

