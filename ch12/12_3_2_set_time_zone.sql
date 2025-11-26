SET TIME ZONE 'US/Pacific';

CREATE TABLE time_zone_test (
    test_date timestamptz
);

INSERT INTO time_zone_test
VALUES (
    '2023-01-01 4:00'
);

SELECT
    test_date
FROM
    time_zone_test;

SET TIME ZONE 'US/Eastern';

SELECT
    test_date
FROM
    time_zone_test;

SELECT
    test_date AT TIME ZONE 'Asia/Seoul'
FROM
    time_zone_test;

SELECT '1929-09-30'::DATE - '1929-09-27'::DATE;

SELECT '1929-09-30'::DATE + '5 day'::INTERVAL;