BEGIN;

CREATE TABLE not_null_example (
    student_id BIGINT GENERATED ALWAYS AS IDENTITY,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

COMMIT;