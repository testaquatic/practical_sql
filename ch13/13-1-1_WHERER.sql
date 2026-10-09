-- 서브쿼리 필터링
SELECT county_name,
       state_name,
       pop_est_2019
FROM county_statistics.us_counties_pop_est_2019
WHERE pop_est_2019 >= (SELECT percentile_cont(.9) WITHIN GROUP ( ORDER BY pop_est_2019 )
                       FROM county_statistics.us_counties_pop_est_2019)
ORDER BY pop_est_2019 DESC;

CREATE TABLE county_statistics.us_counties_2019_top10 AS
SELECT *
FROM county_statistics.us_counties_pop_est_2019;

DELETE
FROM county_statistics.us_counties_2019_top10
WHERE pop_est_2019 < (SELECT percentile_cont(.9) WITHIN GROUP ( ORDER BY pop_est_2019 )
                      FROM county_statistics.us_counties_2019_top10);

-- 315
SELECT count(*)
FROM county_statistics.us_counties_2019_top10;

-- 파생 테이블
SELECT round(calcs.average, 0)                AS average,
       calcs.median,
       round(calcs.average - calcs.median, 0) AS median_average_diff
FROM (SELECT avg(pop_est_2019) AS average, percentile_cont(.5) WITHIN GROUP ( ORDER BY pop_est_2019 )::NUMERIC AS median
      FROM county_statistics.us_counties_pop_est_2019) AS calcs;

-- 파생 테이블 조인
SELECT census.state_name                                                   AS st,
       census.pop_est_2018,
       est.establish_count,
       round(est.establish_count / census.pop_est_2018::NUMERIC * 1000, 1) AS estabs_per_thousand
FROM (SELECT st, sum(establishments) AS establish_count
      FROM county_statistics.cbp_naics_72_establishments
      GROUP BY st) AS est
         JOIN (SELECT state_name, sum(pop_est_2018) AS pop_est_2018
               FROM county_statistics.us_counties_pop_est_2019
               GROUP BY state_name) AS census
              ON est.st = census.state_name
ORDER BY estabs_per_thousand DESC;

-- 열 생성
SELECT county_name,
       state_name                                                       AS st,
       pop_est_2019,
       pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP ( ORDER BY pop_est_2019 )
                       FROM county_statistics.us_counties_pop_est_2019) AS diff_from_median
FROM county_statistics.us_counties_pop_est_2019
WHERE pop_est_2019 - (SELECT percentile_cont(.5) WITHIN GROUP ( ORDER BY pop_est_2019 )
                      FROM county_statistics.us_counties_pop_est_2019)
          BETWEEN -1000 AND 1000;


-- 데이터 생성
CREATE TABLE playground.retirees
(
    id         INT,
    first_name TEXT,
    last_name  TEXT
);

-- IN
INSERT INTO playground.retirees
VALUES (2, 'Janet', 'King'),
       (4, 'Michael', 'Taylor');

SELECT first_name, last_name
FROM playground.employees
WHERE emp_id IN (SELECT id FROM playground.retirees)
ORDER BY emp_id;

-- exists
SELECT first_name, last_name
FROM playground.employees
WHERE EXISTS (SELECT id
              FROM playground.retirees
              WHERE id = employees.emp_id);

SELECT first_name, last_name
FROM playground.employees
WHERE NOT EXISTS(SELECT
                 FROM playground.retirees
                 WHERE id = employees.emp_id);

-- LATERAL
SELECT county_name, state_name, pop_est_2018, pop_est_2019, raw_chg, round(pct_chg * 100, 2) AS pct_chg
FROM county_statistics.us_counties_pop_est_2019,
     LATERAL (SELECT pop_est_2019 - pop_est_2018 AS raw_chg) rc,
     LATERAL (SELECT rc.raw_chg / pop_est_2018::NUMERIC AS pct_chg) pc
ORDER BY pct_chg DESC;

-- 데이터셋 생성
ALTER TABLE playground.teachers
    ADD CONSTRAINT id_key PRIMARY KEY (id);

CREATE TABLE playground.teachers_lab_access
(
    access_id   BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    access_time timestamptz,
    lab_name    TEXT,
    teacher_id  BIGINT REFERENCES playground.teachers (id)
);

INSERT INTO playground.teachers_lab_access (access_time, lab_name, teacher_id)
VALUES ('2022-11-30 08:59:00-05', 'Science A', 2),
       ('2022-12-01 08:58:00-05', 'Chemistry B', 2),
       ('2022-12-21 09:01:00-05', 'Chemistry A', 2),
       ('2022-12-02 11:01:00-05', 'Science B', 6),
       ('2022-12-07 10:02:00-05', 'Science A', 6),
       ('2022-12-17 16:00:00-05', 'Science B', 6);

-- LATERAL
SELECT t.first_name, t.last_name, a.access_time, a.lab_name
FROM playground.teachers t
         LEFT JOIN LATERAL ( SELECT *
                             FROM playground.teachers_lab_access
                             WHERE teacher_id = t.id
                             ORDER BY access_time DESC
                             LIMIT 2) a
                   ON true
ORDER BY t.id;

-- WITH
WITH large_counties (county_name, state_name, pop_est_2019)
         AS (SELECT county_name, state_name, pop_est_2019
             FROM county_statistics.us_counties_pop_est_2019
             WHERE pop_est_2019 >= 100_000)
SELECT state_name, count(*)
FROM large_counties
GROUP BY state_name
ORDER BY count(*) DESC;

WITH counties(st, pop_est_2018) AS
         (SELECT state_name, sum(pop_est_2018) FROM county_statistics.us_counties_pop_est_2019 GROUP BY state_name),
     establishments(st, establishment_count) AS
         (SELECT st, sum(establishments) AS establishment_count
          FROM county_statistics.cbp_naics_72_establishments
          GROUP BY st)
SELECT counties.st,
       pop_est_2018,
       establishment_count,
       round((establishments.establishment_count / counties.pop_est_2018::NUMERIC(10, 1) * 1000), 1)
           AS estabs_per_thousand
FROM counties
         JOIN establishments
              ON counties.st = establishments.st
ORDER BY estabs_per_thousand DESC;

WITH us_median AS
         (SELECT percentile_cont(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) AS us_median_pop
          FROM county_statistics.us_counties_pop_est_2019)
SELECT county_name, state_name AS st, pop_est_2019, us_median_pop, pop_est_2019 - us_median_pop AS diff_from_median
FROM county_statistics.us_counties_pop_est_2019
         CROSS JOIN us_median
WHERE (pop_est_2019 - us_median_pop) BETWEEN -1000 AND 1000;
