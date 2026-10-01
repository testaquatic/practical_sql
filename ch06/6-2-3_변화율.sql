-- 테이블 생성
CREATE TABLE playground.percent_change
(
    department TEXT,
    spend_2019 NUMERIC(10, 2),
    spend_2022 NUMERIC(10, 2)
);

-- 데이터 삽입
INSERT INTO playground.percent_change
VALUES ('Assessor', 178556, 179500),
       ('Building', 250000, 289000),
       ('Clerk', 451980, 650000),
       ('Library', 87777, 90001),
       ('Parks', 250000, 223000),
       ('Water', 199000, 195000);

-- 변화율 계산
SELECT department, spend_2019, spend_2022, round((spend_2022 - spend_2019) / spend_2019 * 100, 1) AS pct_change
FROM playground.percent_change;

-- 평균, 총합
SELECT sum(pop_est_2019)           AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average
FROM pop.us_counties_pop_est_2019;

-- 중앙값
CREATE TABLE playground.percentile_test
(
    numbers INTEGER
);

INSERT INTO playground.percentile_test (numbers)
VALUES (1),
       (2),
       (3),
       (4),
       (5),
       (6);

SELECT percentile_cont(.5) WITHIN GROUP ( ORDER BY numbers ), percentile_disc(.5) WITHIN GROUP ( ORDER BY numbers )
FROM playground.percentile_test;

-- 인구조사 데이터의 중앙값
SELECT sum(pop_est_2019)                                          AS county_sum,
       round(avg(pop_est_2019), 0)                                AS county_average,
       percentile_cont(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) AS county_median
FROM pop.us_counties_pop_est_2019;

-- 사분위
SELECT percentile_cont(ARRAY [.25, .5, .75]) WITHIN GROUP ( ORDER BY pop_est_2019 ) AS quartiles
FROM pop.us_counties_pop_est_2019;

-- unnest
SELECT unnest(percentile_cont(ARRAY [.25, .5, .75]) WITHIN GROUP ( ORDER BY pop_est_2019 ))
FROM pop.us_counties_pop_est_2019;

SELECT mode() WITHIN GROUP ( ORDER BY births_2019 )
FROM pop.us_counties_pop_est_2019;

SELECT 5 * 5 * 3.14;

SELECT county_name,
       births_2019                                     births,
       deaths_2019                                     deaths,
       round(deaths_2019::NUMERIC / births_2019, 3) AS births_deaths_ratio
FROM pop.us_counties_pop_est_2019
WHERE state_name = 'New York'
ORDER BY births_deaths_ratio DESC;

SELECT state_name,
       percentile_cont(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) pop_2019_median
FROM pop.us_counties_pop_est_2019
WHERE state_name in ('California', 'New York')
GROUP BY state_name;