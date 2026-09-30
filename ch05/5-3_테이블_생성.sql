-- 스키마 생성
CREATE SCHEMA pop;

-- 테이블 생성
CREATE TABLE pop.us_counties_pop_est_2019
(
    state_fips              TEXT,
    county_fips             TEXT,
    region                  SMALLINT,
    state_name              TEXT,
    county_name             TEXT,
    area_land               BIGINT,
    area_water              BIGINT,
    internal_point_lat      NUMERIC(10, 7),
    internal_point_lon      NUMERIC(10, 7),
    pop_est_2018            INTEGER,
    pop_est_2019            INTEGER,
    births_2019             INTEGER,
    deaths_2019             INTEGER,
    international_migr_2019 INTEGER,
    domestic_migr_2019      INTEGER,
    residual_2019           INTEGER,
    CONSTRAINT counties_2019_key PRIMARY KEY (state_fips, county_fips)
);

-- 테이블 조회
SELECT *
FROM pop.us_counties_pop_est_2019;

-- 데이터 불러오기
COPY pop.us_counties_pop_est_2019
    FROM
    'us_counties_pop_est_2019.csv'
    WITH (FORMAT CSV , HEADER );

-- 모든 열 조회
SELECT *
FROM pop.us_counties_pop_est_2019;

-- 면적 조회
SELECT county_name, state_name, area_land
FROM pop.us_counties_pop_est_2019
ORDER BY area_land DESC
LIMIT 3;

-- 위치 조회
SELECT county_name, state_name, internal_point_lat, internal_point_lon
FROM pop.us_counties_pop_est_2019
ORDER BY internal_point_lon DESC
LIMIT 5;

-- 테이블 생성
CREATE TABLE IF NOT EXISTS pop.supervisor_salaries
(
    id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    town       TEXT,
    county     TEXT,
    supervisor TEXT,
    start_date DATE,
    salary     NUMERIC(10, 2),
    benefits   NUMERIC(10, 2)
);

-- 오류
COPY pop.supervisor_salaries
    FROM 'supervisor_salaries.csv'
    WITH (FORMAT CSV , HEADER );

-- 수정
COPY pop.supervisor_salaries (town, supervisor, salary)
    FROM 'supervisor_salaries.csv'
    WITH (FORMAT CSV , HEADER );

-- 확인
SELECT *
FROM pop.supervisor_salaries
ORDER BY id
LIMIT 2;

-- 테이블 비우기
DELETE
FROM pop.supervisor_salaries;

-- where를 사용한 COPY
COPY pop.supervisor_salaries (town, supervisor, salary)
    FROM 'supervisor_salaries.csv'
    WITH (FORMAT CSV , HEADER ) WHERE town = 'New Brillig';

-- 조회
SELECT *
FROM pop.supervisor_salaries;

-- 테이블 비우기
DELETE
FROM pop.supervisor_salaries;

-- 임시 테이블 생성
CREATE TEMPORARY TABLE supervisor_salaries_temp
(
    LIKE pop.supervisor_salaries INCLUDING ALL
);

-- 임시 테이블에 저장
COPY supervisor_salaries_temp (town, supervisor, salary)
    FROM 'supervisor_salaries.csv'
    WITH (FORMAT CSV , HEADER );

-- 급여 테이블 채우기
INSERT INTO pop.supervisor_salaries (town, county, supervisor, salary)
SELECT town, 'Mills', supervisor, salary
FROM supervisor_salaries_temp;

-- 테이블 드랍
DROP TABLE supervisor_salaries_temp;

-- 조회
SELECT *
FROM pop.supervisor_salaries
ORDER BY id
LIMIT 2;

-- 내보내기
COPY pop.us_counties_pop_est_2019
    TO 'us_counties_export.txt'
    WITH (FORMAT CSV, HEADER, DELIMITER '|');

-- 특정 열만 내보내기
COPY pop.us_counties_pop_est_2019
    (county_name, internal_point_lat, internal_point_lon)
    TO 'us_counties_latlon_export.txt'
    WITH (FORMAT CSV , HEADER , DELIMITER '|');

-- 쿼리 결과 내보내기
COPY (
    SELECT county_name, state_name
    FROM pop.us_counties_pop_est_2019
    WHERE county_name ILIKE '%mill%'
    )
    TO 'us_counties_mill_export.csv'
    WITH (FORMAT CSV , HEADER );
