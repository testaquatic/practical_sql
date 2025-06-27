BEGIN TRANSACTION;

CREATE TABLE check_constraint_exmaple(
    user_id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_role TEXT,
    salary NUMERIC(10, 2),
    CONSTRAINT user_id_key PRIMARY KEY (user_id),
    CONSTRAINT check_role_in_list CHECK (user_role IN('Admin', 'Staff')),
    CONSTRAINT check_salary_not_below_zero CHECK (salary >= 0)
);

COMMIT;