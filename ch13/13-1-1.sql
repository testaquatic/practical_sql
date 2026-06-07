SELECT
    county_name,
    state_name,
    pop_est_2019
FROM
    us_counties_pop_est_2019
WHERE
    pop_est_2019 >= (
        SELECT PERCENTILE_CONT(0.9) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_pop_est_2019
                    )
ORDER BY
    pop_est_2019 DESC;

CREATE TABLE us_counties_2019_top10 AS
    SELECT *
    FROM
        us_counties_pop_est_2019;

DELETE
FROM
    us_counties_2019_top10
WHERE
    pop_est_2019 < (
        SELECT PERCENTILE_CONT(.9) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_2019_top10
                   );

SELECT
    COUNT(*)
FROM
    us_counties_2019_top10;

SELECT
    ROUND(calcs.average, 0)                AS average,
    calcs.median,
    ROUND(calcs.average - calcs.median, 0) AS median_average_diff
FROM
    (
        SELECT
            AVG(pop_est_2019)                                                   AS average,
            PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 )::NUMERIC AS median
        FROM
            us_counties_pop_est_2019
    ) AS calcs;

SELECT
    census.state_name                                                         AS st,
    census.pop_est_2018                                                       AS pop,
    est.establishment_count,
    ROUND((est.establishment_count / census.pop_est_2018::NUMERIC) * 1000, 1) AS estabs_per_thousand
FROM
    (
        SELECT st, SUM(establishments) AS establishment_count FROM cbp_naics_72_establishments GROUP BY st
    ) AS est
    JOIN (
        SELECT state_name, SUM(pop_est_2018) AS pop_est_2018 FROM us_counties_pop_est_2019 GROUP BY state_name
         ) AS census ON est.st = census.state_name
ORDER BY
    estabs_per_thousand DESC;

SELECT
    county_name,
    state_name AS st,
    pop_est_2019,
    (
        SELECT PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_pop_est_2019
    )          AS us_median
FROM
    us_counties_pop_est_2019;

SELECT
    county_name,
    state_name       AS st,
    pop_est_2019,
    pop_est_2019 - (
        SELECT PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_pop_est_2019
                   ) AS diff_from_median
FROM
    us_counties_pop_est_2019
WHERE
    (pop_est_2019 - (
        SELECT PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_pop_est_2019
                    )) BETWEEN -1000 AND 1000;

CREATE TABLE retirees (
    id         INT,
    first_name TEXT,
    last_name  TEXT
);

INSERT INTO retirees
VALUES (
    2, 'Janet', 'King'
), (
    4, 'Michael', 'Taylor'
);

SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    emp_id IN (
        SELECT id
        FROM retirees
              )
ORDER BY
    emp_id;


SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    EXISTS(
        SELECT id
        FROM retirees
        WHERE id = employees.emp_id
          );

SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    NOT EXISTS(
        SELECT id
        FROM retirees
        WHERE id = employees.emp_id
              );

SELECT
    county_name,
    state_name,
    pop_est_2018,
    pop_est_2019,
    raw_chg,
    ROUND(pct_chg * 100, 2) AS pct_chg
FROM
    us_counties_pop_est_2019,
    LATERAL (SELECT pop_est_2019 - pop_est_2018 AS raw_chg) rc,
    LATERAL (SELECT raw_chg / pop_est_2018::NUMERIC AS pct_chg) pc
ORDER BY
    pct_chg DESC;


ALTER TABLE teachers
    ADD CONSTRAINT id_key PRIMARY KEY (id);

CREATE TABLE teachers_lab_access (
    access_id   BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    access_time TIMESTAMP WITH TIME ZONE,
    lab_name    TEXT,
    teacher_id  BIGINT REFERENCES teachers (id)
);

INSERT INTO teachers_lab_access (
    access_time, lab_name, teacher_id
)
VALUES (
    '2022-11-30 08:59:00-05', 'Science A', 2
), (
    '2022-12-01 08:58:00-05', 'Chemistry B', 2
), (
    '2022-12-21 09:01:00-05', 'Chemistry A', 2
), (
    '2022-12-02 11:01:00-05', 'Science B', 6
), (
    '2022-12-07 10:02:00-05', 'Science A', 6
), (
    '2022-12-17 16:00:00-05', 'Science B', 6
);


SELECT
    teachers.first_name,
    teachers.last_name,
    a.access_time,
    a.lab_name
FROM
    teachers
    LEFT JOIN LATERAL (SELECT *
                       FROM teachers_lab_access
                       WHERE teacher_id = teachers.id
                       ORDER BY access_time DESC
                       LIMIT 2) a ON TRUE
ORDER BY
    teachers.id;

WITH large_counties (county_name, state_name, pop_est_2019) AS (
    SELECT county_name, state_name, pop_est_2019 FROM us_counties_pop_est_2019 WHERE pop_est_2019 >= 100_000
                                                               )
SELECT
    state_name,
    COUNT(*)
FROM
    large_counties
GROUP BY
    state_name
ORDER BY
    COUNT(*) DESC;

WITH counties (st, pop_est_2018) AS (
    SELECT state_name, SUM(pop_est_2018) FROM us_counties_pop_est_2019 GROUP BY state_name
                                    ), establishments (st, establishment_count) AS (
    SELECT st, SUM(establishments) FROM cbp_naics_72_establishments GROUP BY st
                                                                                   )
SELECT
    counties.st,
    counties.pop_est_2018,
    establishments.establishment_count,
    ROUND((establishments.establishment_count / counties.pop_est_2018::NUMERIC(10, 1)) * 1000, 1) AS estabs_per_thousand
FROM
    counties
    JOIN establishments ON counties.st = establishments.st
ORDER BY
    estabs_per_thousand DESC;

WITH us_median AS (
    SELECT PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) AS us_median_pop FROM us_counties_pop_est_2019
                  )
SELECT
    county_name,
    state_name                   AS st,
    pop_est_2019,
    us_median_pop,
    pop_est_2019 - us_median_pop AS diff_from_median
FROM
    us_counties_pop_est_2019
    CROSS JOIN us_median
WHERE
    (pop_est_2019 - us_median_pop) BETWEEN -1000 AND 1000;
