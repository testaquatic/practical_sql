BEGIN TRANSACTION;


CREATE TABLE natural_key_composite_example(student_id TEXT, school_day DATE, present BOOLEAN, CONSTRAINT student_key PRIMARY KEY(student_id,
                                                                                                                                 school_day));


INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES (775, '2022-01-22', 'Y');


INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES (775, '2022-01-23', 'Y');


COMMIT;

BEGIN TRANSACTION;


INSERT INTO natural_key_composite_example (student_id, school_day, present)
VALUES (775, '2022-01-23', 'N');


ROLLBACK;