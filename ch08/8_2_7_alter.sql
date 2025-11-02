BEGIN;

ALTER TABLE not_null_example
    DROP CONSTRAINT student_id_key;
ALTER TABLE not_null_example
    ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);
ALTER TABLE not_null_example
    ALTER COLUMN first_name DROP NOT NULL;
ALTER TABLE not_null_example
    ALTER COLUMN first_name SET NOT NULL;

COMMIT;
