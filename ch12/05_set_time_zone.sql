BEGIN;

SET TIME ZONE 'US/Pacific';

CREATE TABLE time_zone_test(
  test_date TIMESTAMPTZ
);

INSERT INTO time_zone_test VALUES ('2023-01-01 4:00');

SELECT test_date
FROM time_zone_test;

SET TIME ZONE 'US/Eastern';

SELECT test_date
FROM time_zone_test;

SELECT test_date AT TIME ZONE 'Asia/Seoul'
FROM time_zone_test;

COMMIT;