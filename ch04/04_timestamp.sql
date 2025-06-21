BEGIN TRANSACTION;

CREATE TABLE date_time_types (
    timestamp_column TIMESTAMP WITH TIME ZONE,
    interval_column INTERVAL
);

INSERT INTO date_time_types
VALUES
    ('2022-12-31 01:00 EST', '2 days'),
    ('2022-12-31 01:00 -8', '1 month'),
    ('2022-12-31 01:00 Australia/Melbourne', '1 century');

COMMIT;

SELECT * FROM date_time_types;