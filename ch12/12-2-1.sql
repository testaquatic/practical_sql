SELECT
    DATE_PART('year', '2022-12-01 18:37:12 EST'::timestamptz)          AS year,
    DATE_PART('month', '2022-12-01 18:37:12 EST'::timestamptz)         AS month,
    DATE_PART('day', '2022-12-01 18:37:12 EST'::timestamptz)           AS day,
    DATE_PART('hour', '2022-12-01 18:37:12 EST'::timestamptz)          AS hour,
    DATE_PART('minute', '2022-12-01 18:37:12 EST'::timestamptz)        AS minute,
    DATE_PART('seconds', '2022-12-01 18:37:12 EST'::timestamptz)       AS seconds,
    DATE_PART('timezone_hour', '2022-12-01 18:37:12 EST'::timestamptz) AS tz,
    DATE_PART('week', '2022-12-01 18:37:12 EST'::timestamptz)          AS week,
    DATE_PART('quarter', '2022-12-01 18:37:12 EST'::timestamptz)       AS quarter,
    DATE_PART('epoch', '2022-12-01 18:37:12 EST'::timestamptz)         AS epoch;

SELECT MAKE_DATE(2022, 2, 22);
SELECT MAKE_TIME(18, 4, 30.2);
SELECT MAKE_TIMESTAMPTZ(2022, 2, 22, 18, 4, 30.2, 'Europe/Lisbon');

CREATE TABLE current_time_example (
    time_id               INTEGER GENERATED ALWAYS AS IDENTITY,
    current_timestamp_col timestamptz,
    clock_timestamp_col   timestamptz
);

INSERT INTO current_time_example (
    current_timestamp_col, clock_timestamp_col
) (
    SELECT CURRENT_TIMESTAMP, CLOCK_TIMESTAMP() FROM GENERATE_SERIES(1, 10000)
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
