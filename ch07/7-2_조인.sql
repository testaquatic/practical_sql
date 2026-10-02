-- 데이터 생성
CREATE TABLE playground.departments
(
    dept_id INTEGER,
    dept    TEXT,
    city    TEXT,
    CONSTRAINT dept_key PRIMARY KEY (dept_id),
    CONSTRAINT dept_city_unique UNIQUE (dept, city)
);

CREATE TABLE playground.employees
(
    emp_id     INTEGER,
    first_name TEXT,
    last_name  TEXT,
    salary     NUMERIC(10, 2),
    dep_id     INTEGER REFERENCES playground.departments (dept_id),
    CONSTRAINT emp_key PRIMARY KEY (emp_id)
);

INSERT INTO playground.departments
VALUES (1, 'Tax', 'Atlanta'),
       (2, 'IT', 'Boston');

INSERT INTO playground.employees
VALUES (1, 'Julia', 'Reyes', 115300, 1),
       (2, 'Janet', 'King', 98000, 1),
       (3, 'Arthur', 'Pappas', 72700, 2),
       (4, 'Michael', 'Taylor', 89500, 2);

-- JOIN
SELECT *
FROM playground.employees
         JOIN playground.departments
              ON employees.dep_id = departments.dept_id
ORDER BY employees.dep_id;

-- 데이터 생성
CREATE TABLE playground.district_2020
(
    id          INTEGER
        CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 TEXT
);

CREATE TABLE playground.district_2035
(
    id          INTEGER
        CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 TEXT
);

INSERT INTO playground.district_2020
VALUES (1, 'Oak Street School'),
       (2, 'Roosevelt High School')
        ,
       (5, 'Dover Middle School')
        ,
       (6, 'Webutuck High School');

INSERT INTO playground.district_2035
VALUES (1, 'Oak Street School'),
       (2, 'Roosevelt High School'),
       (3, 'Morrison Elementary'),
       (4, 'Chase Magnet Academy'),
       (6, 'Webutuck High School');

-- JOIN
SELECT *
FROM playground.district_2020
         JOIN playground.district_2035
              ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- USING
SELECT *
FROM playground.district_2020
         JOIN playground.district_2035
              USING (id)
ORDER BY district_2020.id;

-- LEFT JOIN
SELECT *
FROM playground.district_2020
         LEFT JOIN playground.district_2035
                   ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- RIGHT JOIN
SELECT *
FROM playground.district_2020
         RIGHT JOIN playground.district_2035
                    ON district_2020.id = district_2035.id
ORDER BY district_2035.id;

-- FULL OUTER JOIN
SELECT *
FROM playground.district_2020
         FULL OUTER JOIN playground.district_2035
                         ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- CROSS JOIn
SELECT *
FROM playground.district_2020 d20
         CROSS JOIN playground.district_2035 d35
ORDER BY d20.id, d35.id;

-- NULL
SELECT *
FROM playground.district_2020
         LEFT JOIN playground.district_2035
                   ON district_2020.id = district_2035.id
WHERE district_2035.id IS NULL;

-- 오류, 모호한 id
SELECT id
FROM playground.district_2020
         LEFT JOIN playground.district_2035
                   ON district_2020.id = district_2035.id;

-- 수정
SELECT district_2020.id, district_2020.school_2020, district_2035.school_2035
FROM playground.district_2020
         LEFT JOIN playground.district_2035
                   ON district_2020.id = district_2035.id
ORDER BY district_2020.id;

-- 테이블 생성
CREATE TABLE playground.district_2020_enrollment
(
    id         INTEGER,
    enrollment INTEGER
);

CREATE TABLE playground.district_2020_grades
(
    id     INTEGER,
    grades VARCHAR(10)
);

INSERT INTO playground.district_2020_enrollment
VALUES (1, 360),
       (2, 1001),
       (5, 450),
       (6, 927);

INSERT INTO playground.district_2020_grades
VALUES (1, 'K-3'),
       (2, '9-12'),
       (5, '6-8'),
       (6, '9-12');

-- 여러 테이블 조인
SELECT d20.id, d20.school_2020, en.enrollment, gr.grades
FROM playground.district_2020 d20
         JOIN playground.district_2020_enrollment en ON d20.id = en.id
         JOIN playground.district_2020_grades gr ON d20.id = gr.id
ORDER BY d20.id;

-- UNION
SELECT *
FROM playground.district_2020
UNION
SELECT *
FROM playground.district_2035
ORDER BY id;

SELECT *
FROM playground.district_2020
UNION ALL
SELECT *
FROM playground.district_2035
ORDER BY id;

SELECT '2020'      AS year,
       school_2020 AS school
FROM playground.district_2020
UNION ALL
SELECT '2035' AS year,
       school_2035
FROM playground.district_2035
ORDER BY school, year;

-- INTERSECT, EXCEPT
SELECT *
FROM playground.district_2020
INTERSECT
SELECT *
FROM playground.district_2035
ORDER BY id;

SELECT *
FROM playground.district_2020
EXCEPT
SELECT *
FROM playground.district_2035
ORDER BY id;

-- 2010년 인구 데이터
CREATE TABLE pop.us_counties_pop_est_2010
(
    state_fips          TEXT,
    county_fips         TEXT,
    region              SMALLINT,
    state_name          TEXT,
    county_name         TEXT,
    estimates_base_2010 INTEGER,
    CONSTRAINT counties_2010_key PRIMARY KEY (state_fips, county_fips)
);

COPY pop.us_counties_pop_est_2010
    FROM 'us_counties_pop_est_2010.csv'
    WITH (FORMAT CSV, HEADER );

-- 2010년 대비 2019년의 인구 변화율
SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019                                                                                    pop_2019,
       c2010.estimates_base_2010                                                                             pop2010,
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS                                                     raw_change,
       round((c2019.pop_est_2019::NUMERIC - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100, 1) pct_change
FROM pop.us_counties_pop_est_2019 AS c2019
         JOIN pop.us_counties_pop_est_2010 c2010
              on c2019.state_fips = c2010.state_fips AND c2019.county_fips = c2010.county_fips
ORDER BY pct_change DESC;

-- 인구 감소율
SELECT c19.county_name,
       c19.state_name,
       c19.pop_est_2019,
       c10.estimates_base_2010,
       c19.pop_est_2019 - c10.estimates_base_2010                                                      AS raw_change,
       round((c19.pop_est_2019::NUMERIC - c10.estimates_base_2010) / c10.estimates_base_2010 * 100, 1) AS pct_change
FROM pop.us_counties_pop_est_2019 AS c19
         JOIN pop.us_counties_pop_est_2010 AS c10
              ON c19.state_fips = c10.state_fips AND c19.county_fips = c10.county_fips
ORDER BY pct_change;

SELECT '2019' AS year, state_fips, county_fips, region, state_name, county_name, pop_est_2019 AS pop
FROM pop.us_counties_pop_est_2019
UNION
SELECT '2010' AS year, state_fips, county_fips, region, state_name, county_name, estimates_base_2010 AS pop
FROM pop.us_counties_pop_est_2010
ORDER BY state_fips, county_fips, year;

SELECT percentile_cont(0.5)
       WITHIN GROUP ( ORDER BY (p19.pop_est_2019::NUMERIC - p10.estimates_base_2010) / p10.estimates_base_2010 * 100 )
FROM pop.us_counties_pop_est_2019 AS p19
         JOIN pop.us_counties_pop_est_2010 AS p10
              ON p19.state_fips = p10.state_fips AND p19.county_fips = p10.county_fips;
