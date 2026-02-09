START TRANSACTION;

CREATE TABLE grades (
    student_id BIGINT,
    course_id  BIGINT,
    course     TEXT NOT NULL,
    grade      TEXT NOT NULL,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO grades
VALUES (
    1, 1, 'Biology', 'F'
), (
    1, 2, 'English 11B', 'D'
), (
    1, 3, 'World History 11B', 'C'
), (
    1, 4, 'Trig 2', 'B'
);

CREATE TABLE grades_history (
    student_id  BIGINT                   NOT NULL,
    course_id   BIGINT                   NOT NULL,
    change_time TIMESTAMP WITH TIME ZONE NOT NULL,
    course      TEXT                     NOT NULL,
    old_grade   TEXT                     NOT NULL,
    new_grade   TEXT                     NOT NULL,
    PRIMARY KEY (student_id, course_id, change_time)
);

COMMIT;

START TRANSACTION;

CREATE OR REPLACE FUNCTION record_if_grade_changed() RETURNS TRIGGER AS
$$
BEGIN
    IF new.grade <> old.grade THEN
        INSERT INTO grades_history (
            student_id,
            course_id,
            change_time,
            course,
            old_grade,
            new_grade
        )
        VALUES (
            old.student_id,
            old.course_id,
            NOW(),
            old.course,
            old.grade,
            new.grade
        );
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grades_update
    AFTER UPDATE
    ON grades
    FOR EACH ROW
EXECUTE PROCEDURE record_if_grade_changed();

COMMIT;

SELECT *
FROM
    grades_history;
SELECT *
FROM
    grades
ORDER BY
    student_id, course_id;

START TRANSACTION;

UPDATE grades
SET
    grade = 'C'
WHERE
    student_id = 1
    AND course_id = 1;

COMMIT;

SELECT
    student_id,
    change_time,
    course,
    old_grade,
    new_grade
FROM
    grades_history;

START TRANSACTION;

CREATE TABLE temperature_test (
    station_name     TEXT,
    observation_date DATE,
    max_temp         INTEGER,
    min_temp         INTEGER,
    max_temp_group   TEXT,
    PRIMARY KEY (station_name, observation_date)
);

CREATE OR REPLACE FUNCTION classify_max_temp() RETURNS TRIGGER AS
$$
BEGIN
    CASE
        WHEN new.max_temp >= 90 THEN new.max_temp_group := 'Hot';
        WHEN new.max_temp >= 70 AND new.max_temp < 90 THEN new.max_temp_group := 'Warm';
        WHEN new.max_temp >= 50 AND new.max_temp < 70 THEN new.max_temp_group := 'Pleasant';
        WHEN new.max_temp >= 33 AND new.max_temp < 50 THEN new.max_temp_group := 'Cold';
        WHEN new.max_temp >= 20 AND new.max_temp < 33 THEN new.max_temp_group := 'Frigid';
        WHEN new.max_temp < 20 THEN new.max_temp_group := 'Inhumane';
        ELSE new.max_temp_group := 'No Reading';
    END CASE;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER temperature_insert
    BEFORE INSERT
    ON temperature_test
    FOR EACH ROW
    EXECUTE PROCEDURE classify_max_temp();

COMMIT;

START TRANSACTION;

INSERT INTO temperature_test
VALUES  ('North Station', '1/19/2023', 10, -3),
    ('North Station', '3/20/2023', 28, 19),
    ('North Station', '5/2/2023', 65, 42),
    ('North Station', '8/9/2023', 93, 74),
    ('North Station', '12/14/2023', NULL, NULL);

SELECT * FROM temperature_test ORDER BY observation_date;

COMMIT;
