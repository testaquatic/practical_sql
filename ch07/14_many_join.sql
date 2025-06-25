BEGIN TRANSACTION;


CREATE TABLE district_2020_enrollment (id INTEGER, enrollment INTEGER);


CREATE TABLE district_2020_grades(id INTEGER, grades VARCHAR(10));


INSERT INTO district_2020_enrollment
VALUES (1, 360),
       (2, 1001),
       (5, 450),
       (6, 927);


INSERT INTO district_2020_grades
VALUES (1, 'K-3'),
       (2, '9-12'),
       (5, '6-8'),
       (6, '9-12');


COMMIT;


SELECT d20.id,
       d20.school_2020,
       en.enrollment,
       gr.grades
FROM district_2020 AS d20
JOIN district_2020_enrollment AS en ON d20.id = en.id
JOIN district_2020_grades AS gr ON d20.id = gr.id
ORDER BY d20.id;