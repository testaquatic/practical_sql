BEGIN;

CREATE TABLE date_time_types (timestamp_column timestamp with time zone,
                                               interval_column interval);

INSERT INTO date_time_types
VALUES ('2022-12-31 01:00 EST','2 days'),
       ('2022-12-31 01:00 -8','1 month'),
       ('2022-12-31 01:00 Australia/Melbourne','1 century'),
       (now(),'1 week');

SELECT *
FROM date_time_types;

COMMIT;

SELECT
    timestamp_column,
    interval_column,
    timestamp_column - interval_column AS new_date
FROM date_time_types;