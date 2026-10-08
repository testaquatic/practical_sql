-- 계산
SELECT '1929-09-30'::DATE - '1929-09-27'::DATE;

SELECT '1929-09-30'::DATE + '5 years'::INTERVAL;

-- 데이터셋 생성
CREATE TABLE new_york.nyc_yellow_taxi_trips
(
    trip_id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_id             TEXT                     NOT NULL,
    tpep_pickup_datetime  TIMESTAMP WITH TIME ZONE NOT NULL,
    tpep_dropoff_datetime TIMESTAMP WITH TIME ZONE NOT NULL,
    passenger_count       INTEGER                  NOT NULL,
    trip_distance         NUMERIC(8, 2)            NOT NULL,
    pickup_longitude      NUMERIC(18, 15)          NOT NULL,
    pickup_latitude       NUMERIC(18, 15)          NOT NULL,
    rate_code_id          TEXT                     NOT NULL,
    store_and_fwd_flag    TEXT                     NOT NULL,
    dropoff_longitude     NUMERIC(18, 15)          NOT NULL,
    dropoff_latitude      NUMERIC(18, 15)          NOT NULL,
    payment_type          TEXT                     NOT NULL,
    fare_amount           NUMERIC(9, 2)            NOT NULL,
    extra                 NUMERIC(9, 2)            NOT NULL,
    mta_tax               NUMERIC(5, 2)            NOT NULL,
    tip_amount            NUMERIC(9, 2)            NOT NULL,
    tolls_amount          NUMERIC(9, 2)            NOT NULL,
    improvement_surcharge NUMERIC(9, 2)            NOT NULL,
    total_amount          NUMERIC(9, 2)            NOT NULL
);

COPY new_york.nyc_yellow_taxi_trips (
                                     vendor_id, tpep_pickup_datetime, tpep_dropoff_datetime, passenger_count,
                                     trip_distance, pickup_longitude, pickup_latitude, rate_code_id, store_and_fwd_flag,
                                     dropoff_longitude, dropoff_latitude, payment_type, fare_amount, extra, mta_tax,
                                     tip_amount, tolls_amount, improvement_surcharge, total_amount
    )
    FROM 'nyc_yellow_taxi_trips.csv'
    WITH (FORMAT CSV , HEADER );

CREATE INDEX tpep_pickup_idx
    ON new_york.nyc_yellow_taxi_trips (tpep_pickup_datetime);

SELECT count(*)
FROM new_york.nyc_yellow_taxi_trips;

-- 시간대 설정
SET TIME ZONE 'America/New_York';

-- 바쁜 시간대 찾기
SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
       count(*)
FROM new_york.nyc_yellow_taxi_trips
GROUP BY trip_hour
ORDER BY trip_hour;

-- 데이터 내보내기
COPY (
    SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour, count(*)
    FROM new_york.nyc_yellow_taxi_trips
    GROUP BY trip_hour
    ORDER BY trip_hour
    ) TO 'hourly_pickups.csv'
    WITH (FORMAT CSV , HEADER );

-- 시간별 평균 이동시간
SELECT date_part('hour', tpep_pickup_datetime)                                                    AS trip_hour,
       percentile_cont(.5) WITHIN GROUP ( ORDER BY tpep_dropoff_datetime - tpep_pickup_datetime ) AS median_trip
FROM new_york.nyc_yellow_taxi_trips
GROUP BY trip_hour
ORDER BY trip_hour;

-- 데이터셋 생성
CREATE TABLE playground.train_rides
(
    trip_id   BIGINT GENERATED ALWAYS AS IDENTITY,
    segment   TEXT                     NOT NULL,
    departure TIMESTAMP WITH TIME ZONE NOT NULL,
    arrival   TIMESTAMP WITH TIME ZONE NOT NULL
);

INSERT INTO playground.train_rides (segment, departure, arrival)
VALUES ('Chicago to New York', '2020-11-13 21:30 CST', '2020-11-14 18:23 EST'),
       ('New York to New Orleans', '2020-11-15 14:15 EST', '2020-11-16 19:32 CST'),
       ('New Orleans to Los Angeles', '2020-11-17 13:45 CST', '2020-11-18 9:00 PST'),
       ('Los Angeles to San Francisco', '2020-11-19 10:10 PST', '2020-11-19 21:24 PST'),
       ('San Francisco to Denver', '2020-11-20 9:10 PST', '2020-11-21 18:38 MST'),
       ('Denver to Chicago', '2020-11-22 19:10 MST', '2020-11-23 14:50 CST');

SET TIME ZONE 'America/Chicago';

SELECT *
FROM playground.train_rides;

-- 이동시간 확인
SELECT segment,
       to_char(departure, 'YYYY-MM-DD HH12:MI a.m TZ') AS departure,
       arrival - departure                             AS segment_time
FROM playground.train_rides;

-- 이동시간 누계
SELECT segment,
       arrival - departure                              AS segment_duration,
       sum(arrival - departure) OVER (ORDER BY trip_id) AS cume_duration
FROM playground.train_rides;

SELECT segment,
       arrival - departure                                                AS segment_duration,
       justify_interval(sum(arrival - departure) OVER (ORDER BY trip_id)) AS cume_duration
FROM playground.train_rides;

SELECT tpep_dropoff_datetime - tpep_pickup_datetime trip_time
FROM new_york.nyc_yellow_taxi_trips
ORDER BY trip_time ASC;

SELECT new_york_time.ny AT TIME ZONE 'America/New_York'    As new_york,
       new_york_time.ny AT TIME ZONE 'Europe/London'       as london,
       new_york_time.ny AT TIME ZONE 'Africa/Johannesburg' AS johannesburg,
       new_york_time.ny AT TIME ZONE 'Europe/Moscow'       AS moscow,
       new_york_time.ny AT TIME ZONE 'Australia/Melbourne' AS melbourne
FROM (SELECT '2100-01-01 00:00 America/New_York'::timestamptz as ny) AS new_york_time;

SELECT round(corr(total_amount, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime))::NUMERIC, 2) r,
       round(regr_r2(total_amount, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime)::NUMERIC)::NUMERIC,
             2)                                                                                                r2
FROM new_york.nyc_yellow_taxi_trips;

SELECT round(corr(trip_distance, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime))::NUMERIC, 2) r,
       round(regr_r2(trip_distance, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime)::NUMERIC)::NUMERIC,
             2)                                                                                                 r2
FROM new_york.nyc_yellow_taxi_trips;

SELECT round(corr(total_amount, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime))::NUMERIC, 2) r,
       round(regr_r2(total_amount, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime)::NUMERIC)::NUMERIC,
             2)                                                                                                r2
FROM new_york.nyc_yellow_taxi_trips
WHERE tpep_dropoff_datetime - tpep_pickup_datetime <= '3 hours'::INTERVAL;

SELECT round(corr(trip_distance, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime))::NUMERIC, 2) r,
       round(regr_r2(trip_distance, date_part('epoch', tpep_dropoff_datetime - tpep_pickup_datetime)::NUMERIC)::NUMERIC,
             2)                                                                                                 r2
FROM new_york.nyc_yellow_taxi_trips
WHERE tpep_dropoff_datetime - tpep_pickup_datetime <= '3 hours'::INTERVAL;