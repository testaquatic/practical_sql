CREATE TABLE grades
(
    student_id bigint,
    course_id  bigint,
    course     text NOT NULL,
    grade      text NOT NULL,
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO grades
VALUES (1, 1, 'Biology 2', 'F'),
       (1, 2, 'English 11B', 'D'),
       (1, 3, 'World History 11B', 'C'),
       (1, 4, 'Trig 2', 'B');

CREATE TABLE grades_history
(
    student_id  bigint      NOT NULL,
    course_id   bigint      NOT NULL,
    change_time timestamptz NOT NULL,
    course      text        NOT NULL,
    old_grade   text        NOT NULL,
    new_grade   text        NOT NULL,
    PRIMARY KEY (student_id, course_id, change_time)
);

-- 트리거 함수
CREATE OR REPLACE FUNCTION record_if_grade_changed()
    RETURNS TRIGGER AS
$$
BEGIN
    IF new.grade <> old.grade THEN
        INSERT INTO grades_history (student_id, course_id, change_time, course, old_grade, new_grade)
        VALUES (old.student_id, old.course_id, now(), old.course, old.grade, new.grade);
    end if;
    RETURN NULL;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER grades_update
    AFTER UPDATE
    ON grades
    FOR EACH ROW
EXECUTE PROCEDURE record_if_grade_changed();

SELECT *
FROM grades
ORDER BY student_id, course_id;

UPDATE grades
SET grade = 'C'
WHERE student_id = 1
  AND course_id = 1;

SELECT student_id, change_time, course, old_grade, new_grade
FROM grades_history;

CREATE TABLE temperature_test
(
    station_name     TEXT,
    observation_date DATE,
    max_temp         INTEGER,
    min_temp         INTEGER,
    max_temp_group   text,
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
        ELSE new.max_temp_group := 'No reading';
        END CASE;
    RETURN new;
end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER temperature_insert
    BEFORE INSERT
    ON temperature_test
    FOR EACH ROW
EXECUTE PROCEDURE classify_max_temp();

INSERT INTO temperature_test
VALUES ('North Station', '1/19/2023', 10, -3),
       ('North Station', '3/20/2023', 28, 19),
       ('North Station', '5/2/2023', 65, 42),
       ('North Station', '8/9/2023', 93, 74),
       ('North Station', '12/14/2023', NULL, NULL);

SELECT *
FROM temperature_test;

SET TIME ZONE 'America/Los_Angeles';

CREATE VIEW new_york.new_york_taxi_count_by_time AS
SELECT date_part('hour', tpep_pickup_datetime) AS trip_hour,
       count(*)
FROM new_york.nyc_yellow_taxi_trips
GROUP BY trip_hour
ORDER BY trip_hour;

SELECT *
FROM new_york.new_york_taxi_count_by_time;

DROP FUNCTION rates_per_thousand(new_value NUMERIC, old_value NUMERIC, decimal_places INTEGER);

CREATE OR REPLACE FUNCTION rates_per_thousand(new_value NUMERIC, old_value NUMERIC, decimal_places INTEGER DEFAULT 1)
    RETURNS NUMERIC AS
$$
BEGIN
    RETURN round(new_value / old_value * 1000, decimal_places);
end;
$$ LANGUAGE plpgsql
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;

SELECT rates_per_thousand(10, null, 2);


CREATE OR REPLACE FUNCTION county_statistics.update_inspection_deadline() RETURNS TRIGGER AS
$$
BEGIN
    new.inspection_deadline := now() + '6 month'::INTERVAL;
    RETURN new;
end;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER update_inspection_deadline
    BEFORE INSERT
    ON county_statistics.meat_poultry_egg_establishments
    FOR EACH ROW
EXECUTE PROCEDURE county_statistics.update_inspection_deadline();

INSERT INTO county_statistics.meat_poultry_egg_establishments(establishment_number, company)
VALUES ('test', 'test');

SELECT *
FROM county_statistics.meat_poultry_egg_establishments
WHERE company = 'test';