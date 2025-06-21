BEGIN TRANSACTION;

CREATE TABLE number_data_types (
    numeric_column NUMERIC(20,5),
    real_column REAL,
    double_column DOUBLE PRECISION
);

INSERT INTO number_data_types
VALUES
    (.7, .7, .7),
    (2.13579, 2.13579, 2.13579),
    (2.1357987654, 2.1357987654, 2.1357987654);

COMMIT;

SELECT * FROM number_data_types;
