BEGIN TRANSACTION;

CREATE TABLE licenses (
    license_id TEXT,
    first_name TEXT,
    last_name TEXT,
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

CREATE TABLE registrations(
    registration_id TEXT,
    registration_date TIMESTAMP WITH TIME ZONE,
    license_id TEXT REFERENCES licenses(license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Steve', 'Rothery');

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '2022-03-17', 'T229901');

COMMIT;

BEGIN TRANSACTION;

INSERT INTO registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '2022-03-17', 'T000001');

ROLLBACK;