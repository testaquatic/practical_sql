START TRANSACTION;

CREATE TABLE IF NOT EXISTS district_2020_enrollment (
    id         INTEGER,
    enrollment INTEGER
);

CREATE TABLE IF NOT EXISTS district_2020_grades (
    id     INTEGER,
    grades VARCHAR(10)
);

INSERT INTO district_2020_enrollment
VALUES (
    1, 360
), (
    2, 1001
), (
    5, 450
), (
    6, 927
);

INSERT INTO district_2020_grades
VALUES (
    1, 'K-3'
), (
    2, '9-12'
), (
    5, '6-8'
), (
    6, '9-12'
);

COMMIT;

SELECT
    d20.id,
    school_2020,
    enrollment,
    grades
FROM
    district_2020 d20
    JOIN district_2020_enrollment en ON d20.id = en.id
    JOIN district_2020_grades gr ON d20.id = gr.id
ORDER BY
    d20.id;

SELECT *
FROM
    district_2020
UNION
SELECT *
FROM
    district_2035
ORDER BY
    id;

SELECT
    '2020'      AS year,
    school_2020 AS school
FROM
    district_2020
UNION ALL
SELECT
    '2035'      AS year,
    school_2035 AS school
FROM
    district_2035
ORDER BY
    school, year;

SELECT *
FROM
    district_2020
INTERSECT
SELECT *
FROM
    district_2035
ORDER BY
    id;

SELECT *
FROM
    district_2020
EXCEPT
SELECT *
FROM
    district_2035
ORDER BY
    id;

