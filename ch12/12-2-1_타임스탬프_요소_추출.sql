-- date_part()
SELECT date_part('year', now())          AS year,
       date_part('month', now())         AS month,
       date_part('day', now())           AS day,
       date_part('hour', now())          AS hour,
       date_part('minute', now())        AS minute,
       date_part('seconds', now())       AS seconds,
       date_part('timezone_hour', now()) AS tz,
       date_part('week', now())          AS week,
       date_part('quarter', now())       as quarter,
       date_part('epoch', now())         AS epoch;

-- sql 표준
select extract('year' FROM now());

-- 날짜 시간 값 만들기
SELECT make_date(2022, 2, 22);
SELECT make_time(18, 4, 30.3);
SELECT make_timestamptz(2022, 2, 22, 18, 4, 30.3, 'Europe/Lisbon');

-- 현재 날짜 및 시각
CREATE TABLE playground.current_time_example
(
    time_id               INTEGER GENERATED ALWAYS AS IDENTITY,
    current_timestamp_col TIMESTAMP WITH TIME ZONE,
    clock_timestamp_col   TIMESTAMP WITH TIME ZONE
);

INSERT INTO playground.current_time_example
    (current_timestamp_col, clock_timestamp_col)
    (SELECT current_timestamp, clock_timestamp() FROM generate_series(1, 1000));

SELECT *
FROM playground.current_time_example;