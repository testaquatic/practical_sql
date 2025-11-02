BEGIN;


CREATE TABLE unique_constraint_example (
    contact_id BIGINT GENERATED ALWAYS AS IDENTITY,
    first_name TEXT,
    last_name  TEXT,
    email      TEXT,
    CONSTRAINT contact_id_key PRIMARY KEY (contact_id),
    CONSTRAINT email_unique UNIQUE (email)
);

INSERT INTO unique_constraint_example (
    first_name, last_name, email
)
VALUES (
    'Samantha', 'Lee', 'slee@example.com'
);

INSERT INTO unique_constraint_example (
    first_name, last_name, email
)
VALUES (
    'Betty', 'Diaz', 'bdiaz@example.com'
);

COMMIT;

BEGIN;
INSERT INTO unique_constraint_example (
    first_name, last_name, email
)
VALUES (
    'Sasha', 'Lee', 'slee@example.com'
);
ROLLBACK;