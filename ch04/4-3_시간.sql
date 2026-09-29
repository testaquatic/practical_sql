CREATE TABLE playground.date_time_types
(
    timestamp_column TIMESTAMP WITH TIME ZONE,
    interval_column  INTERVAL
);

INSERT INTO playground.date_time_types
VALUES ('2022-12-31 01:00 EST', '2 days'),
       ('2022-12-31 01:00 -8', '1 month'),
       ('2022-12-31 01:00 Australia/Melbourne', '1 century');

SELECT *
FROM playground.date_time_types;

SELECT timestamp_column, interval_column, timestamp_column - interval_column AS new_date
FROM playground.date_time_types;