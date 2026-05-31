START TRANSACTION;

CREATE TABLE IF NOT EXISTS district_2020 (
    id          INTEGER
        CONSTRAINT id_key_2020 PRIMARY KEY,
    school_2020 TEXT
);

CREATE TABLE IF NOT EXISTS district_2035 (
    id          INTEGER
        CONSTRAINT id_key_2035 PRIMARY KEY,
    school_2035 TEXT
);

INSERT INTO district_2020
VALUES (
    1, 'Oak Street School'
), (
    2, 'Roosevelt High School'
), (
    5, 'Dover Middle School'
), (
    6, 'Webutuck High School'
);

INSERT INTO district_2035
VALUES (
    1, 'Oak Street School'
), (
    2, 'Roosevelt High School'
), (
    3, 'Morrison Elementary'
), (
    4, 'Chase Magnet Academy'
), (
    6, 'Webutuck High School'
);

COMMIT;

SELECT *
FROM
    district_2020
    JOIN district_2035 ON district_2020.id = district_2035.id
ORDER BY
    district_2020.id;

SELECT *
FROM
    district_2020
    JOIN district_2035 USING (id)
ORDER BY
    district_2020.id;

SELECT *
FROM
    district_2020
    LEFT JOIN district_2035 ON district_2020.id = district_2035.id
ORDER BY
    district_2020.id;

SELECT *
FROM
    district_2020
    RIGHT JOIN district_2035 ON district_2020.id = district_2035.id
ORDER BY
    district_2035.id;

SELECT *
FROM
    district_2020
    FULL OUTER JOIN district_2035 ON district_2020.id = district_2035.id
ORDER BY
    district_2020.id;

SELECT *
FROM
    district_2020
    CROSS JOIN district_2035
ORDER BY
    district_2020.id, district_2035.id;

SELECT *
FROM
    district_2020
    LEFT JOIN district_2035 ON district_2020.id = district_2035.id
WHERE
    district_2035.id IS NULL;

SELECT
    district_2035.id
FROM
    district_2020
    LEFT JOIN district_2035 ON district_2020.id = district_2035.id;

SELECT
    district_2020.id,
    district_2020.school_2020,
    district_2035.school_2035
FROM
    district_2020
    LEFT JOIN district_2035 ON district_2020.id = district_2035.id
ORDER BY
    district_2020.id;

SELECT
    d20.id,
    d20.school_2020,
    school_2035
FROM
    district_2020 AS d20
    LEFT JOIN district_2035 AS d35 ON d20.id = d35.id
ORDER BY
    id;
