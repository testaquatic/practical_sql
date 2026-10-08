-- 시간대 설정 학인
SHOW timezone;
SELECT current_setting('timezone');

-- 모든 설정 확인
SHOW ALL;

SELECT make_timestamptz(2022, 2, 22, 18, 4, 30.3, current_setting('timezone'));

-- 시간대 조회
SELECT *
FROM pg_timezone_abbrevs
ORDER BY abbrev;

SELECT *
FROM pg_timezone_names
ORDER BY name;

SELECT *
FROM pg_timezone_names
WHERE name LIKE 'Europe%'
ORDER BY name;

SELECT *
FROM pg_timezone_names
WHERE name LIKE 'America%'
ORDER BY name;

-- 시간대 설정
SET TIME ZONE 'America/Los_Angeles';

CREATE TABLE playground.time_zone_test
(
    test_date TIMESTAMP WITH TIME ZONE
);

INSERT INTO playground.time_zone_test
VALUES ('2023-01-01 4:00');

SELECT test_date
FROM playground.time_zone_test;

SET TIME ZONE 'America/New_York';

SELECT test_date
FROM playground.time_zone_test;

SET TIME ZONE 'Asia/Seoul';

SELECT test_date
FROM playground.time_zone_test;
