CREATE TABLE nyc_yellow_taxi_trips (
    trip_id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    vendor_id             TEXT            NOT NULL,
    tpep_pickup_datetime  timestamptz     NOT NULL,
    tpep_dropoff_datetime timestamptz     NOT NULL,
    passenger_count       INTEGER         NOT NULL,
    trip_distance         NUMERIC(8, 2)   NOT NULL,
    pickup_longitude      NUMERIC(18, 15) NOT NULL,
    pickup_latitude       NUMERIC(18, 15) NOT NULL,
    rate_code_id          TEXT            NOT NULL,
    store_and_fwd_flag    TEXT            NOT NULL,
    dropoff_longitude     NUMERIC(18, 15) NOT NULL,
    dropoff_latitude      NUMERIC(18, 15) NOT NULL,
    payment_type          TEXT            NOT NULL,
    fare_amount           NUMERIC(9, 2)   NOT NULL,
    extra                 NUMERIC(9, 2)   NOT NULL,
    mta_tax               NUMERIC(5, 2)   NOT NULL,
    tip_amount            NUMERIC(9, 2)   NOT NULL,
    tolls_amount          NUMERIC(9, 2)   NOT NULL,
    improvement_surcharge NUMERIC(9, 2)   NOT NULL,
    total_amount          NUMERIC(9, 2)   NOT NULL
);

---------------------psql
\copy nyc_yellow_taxi_trips (vendor_id,
                            tpep_pickup_datetime,
                            tpep_dropoff_datetime,
                            passenger_count,
                            trip_distance,
                            pickup_longitude,
                            pickup_latitude,
                            rate_code_id,
                            store_and_fwd_flag,
                            dropoff_longitude,
                            dropoff_latitude,
                            payment_type,
                            fare_amount,
                            extra,
                            mta_tax,
                            tip_amount,
                            tolls_amount,
                            improvement_surcharge,
                            total_amount
    ) FROM './data/nyc_yellow_taxi_trips.csv' WITH (FORMAT CSV, HEADER);
---------------------

CREATE INDEX tpep_pickup_idx ON nyc_yellow_taxi_trips (tpep_pickup_datetime);

SELECT
    COUNT(*)
FROM
    nyc_yellow_taxi_trips;

SELECT
    (DATE_PART('hour', nyc_yellow_taxi_trips.tpep_pickup_datetime)::INTEGER + 20) % 24 AS trip_hour,
    COUNT(*)
FROM
    nyc_yellow_taxi_trips
GROUP BY
    trip_hour
ORDER BY
    trip_hour;

SELECT
    (DATE_PART('hour', tpep_pickup_datetime)::INTEGER + 20) % 24                                       AS trip_hour,
            PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY tpep_dropoff_datetime - tpep_pickup_datetime ) AS median_trip
FROM
    nyc_yellow_taxi_trips
GROUP BY
    trip_hour
ORDER BY
    trip_hour;

CREATE TABLE train_rides (
    trip_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    segment   TEXT        NOT NULL,
    departure timestamptz NOT NULL,
    arrival   timestamptz NOT NULL
);

INSERT INTO train_rides (
    segment, departure, arrival
)
VALUES (
    'Chicago to New York', '2020-11-13 21:30 CST', '2020-11-14 18:23 EST'
), (
    'New York to New Orleans', '2020-11-15 14:15 EST', '2020-11-16 19:32 CST'
), (
    'New Orleans to Los Angeles', '2020-11-17 13:45 CST', '2020-11-18 9:00 PST'
), (
    'Los Angeles to San Francisco', '2020-11-19 10:10 PST', '2020-11-19 21:24 PST'
), (
    'San Francisco to Denver', '2020-11-20 9:10 PST', '2020-11-21 18:38 MST'
), (
    'Denver to Chicago', '2020-11-22 19:10 MST', '2020-11-23 14:50 CST'
);

SELECT *
FROM
    train_rides;

SELECT
    train_rides.segment,
    TO_CHAR(train_rides.departure, 'YYYY-MM-DD HH12:MI a.m. TZ') AS departure,
    train_rides.arrival - train_rides.departure                  AS segment_time
FROM
    train_rides;

SELECT
    segment,
    arrival - departure                              AS segment_duration,
    SUM(arrival - departure) OVER (ORDER BY trip_id) AS cume_duration
FROM
    train_rides;

SELECT
    segment,
    arrival - departure                                                AS segment_duration,
    JUSTIFY_INTERVAL(SUM(arrival - departure) OVER (ORDER BY trip_id)) AS cume_duration
FROM
    train_rides;