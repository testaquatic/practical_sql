BEGIN TRANSACTION;

CREATE TABLE natural_key_example (
    license_id TEXT CONSTRAINT license_key PRIMARY KEY,
    first_name TEXT,
    last_name TEXT
);

DROP TABLE natural_key_example;

CREATE TABLE natural_key_example (
    license_id TEXT,
    first_name TEXT,
    last_name TEXT,
    CONSTRAINT license_key PRIMARY KEY (license_id)
);

COMMIT;