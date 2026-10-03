-- 기본 키 : 열 제약조건
CREATE TABLE playground.natural_key_example
(
    license_id TEXT
        CONSTRAINT license_key PRIMARY KEY,
    first_name TEXT,
    last_name  TEXT
);

DROP TABLE playground.natural_key_example;

-- 기본 키 : 테이블 제약조건
CREATE TABLE playground.natural_key_example
(
    license_id TEXT,
    first_name TEXT,
    last_name  TEXT,
    CONSTRAINT license_key PRIMARY KEY (license_id)
);

-- 기본키 위반
INSERT INTO playground.natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Gem', 'Godfrey');
-- 오류
INSERT INTO playground.natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'John', 'Mitchell');

-- 복합 기본키
CREATE TABLE playground.natural_key_composite_example
(
    student_id TEXT,
    school_day DATE,
    present    BOOLEAN,
    CONSTRAINT student_key PRIMARY KEY (student_id, school_day)
);

INSERT INTO playground.natural_key_composite_example (student_id, school_day, present)
VALUES (775, '2022-01-22', 'Y');
-- OK
INSERT INTO playground.natural_key_composite_example (student_id, school_day, present)
VALUES (775, '2022-01-23', 'Y');
-- 기본키 위반!
INSERT INTO playground.natural_key_composite_example (student_id, school_day, present)
VALUES (775, '2022-01-23', 'N');

-- 인조키
CREATE TABLE playground.surrogate_key_example
(
    order_number BIGINT GENERATED ALWAYS AS IDENTITY,
    product_name TEXT,
    order_time   TIMESTAMPTZ,
    CONSTRAINT order_number_key PRIMARY KEY (order_time)
);

INSERT INTO playground.surrogate_key_example (product_name, order_time)
VALUES ('Beachball Polish', '2020-03-15 09:21-07'),
       ('Wrinkle De-Atomizer', '2017-05-22 14:00-07'),
       ('Flux Capacitor', '1985-10-26 01:18:00-07');

SELECT *
FROM playground.surrogate_key_example;

-- 수동 삽입
INSERT INTO playground.surrogate_key_example
    OVERRIDING SYSTEM VALUE
VALUES (4, 'Chicken Coop', '2021-09-03 10:33-07');

ALTER TABLE playground.surrogate_key_example
    ALTER COLUMN order_number RESTART WITH 5;

INSERT INTO playground.surrogate_key_example (product_name, order_time)
VALUES ('Aloe Plant', '2020-03-15 10:09-07');

SELECT *
FROM playground.surrogate_key_example;

-- 외래키
CREATE TABLE playground.licenses
(
    license_id TEXT,
    first_name TEXT,
    last_name  TEXT,
    CONSTRAINT licenses_key PRIMARY KEY (license_id)
);

CREATE TABLE playground.registrations
(
    registration_id   TEXT,
    registration_date TIMESTAMPTZ,
    license_id        TEXT REFERENCES playground.licenses (license_id),
    CONSTRAINT registration_key PRIMARY KEY (registration_id, license_id)
);

INSERT INTO playground.licenses (license_id, first_name, last_name)
VALUES ('T229901', 'Steve', 'Rothery');

-- OK
INSERT INTO playground.registrations (registration_id, registration_date, license_id)
VALUES ('A203391', '2022-03-17', 'T229901');
-- 오류 : 외래키 제약 위반
INSERT INTO playground.registrations (registration_id, registration_date, license_id)
VALUES ('A75772', '2022-03-17', 'T000001');

CREATE TABLE playground.check_constraint_example
(
    user_id   BIGINT GENERATED ALWAYS AS IDENTITY,
    user_role TEXT,
    salary    NUMERIC(10, 2),
    CONSTRAINT user_id_key PRIMARY KEY (user_id),
    CONSTRAINT check_role_in_list CHECK ( user_role IN ('Admin', 'Staff')),
    CONSTRAINT check_salary_not_below_zero CHECK ( salary >= 0 )
);

-- UNIQUE
CREATE TABLE playground.unique_constraint_example
(
    contact_id BIGINT GENERATED ALWAYS AS IDENTITY,
    first_name TEXT,
    last_name  TEXT,
    email      TEXT,
    CONSTRAINT contact_id_key PRIMARY KEY (contact_id),
    CONSTRAINT email_unique UNIQUE (email)
);

INSERT INTO playground.unique_constraint_example (first_name, last_name, email)
VALUES ('Samantha', 'Lee', 'slee@example.org');

INSERT INTO playground.unique_constraint_example (first_name, last_name, email)
VALUES ('Betty', 'Diaz', 'bdiaz@example.org');

-- 오류 : 이메일 중복
INSERT INTO playground.unique_constraint_example (first_name, last_name, email)
VALUES ('Sasha', 'Lee', 'slee@example.org');

-- NOT NULL
CREATE TABLE playground.not_null_example
(
    student_id BIGINT GENERATED ALWAYS AS IDENTITY,
    first_name TEXT NOT NULL,
    last_name  TEXT NOT NULL,
    CONSTRAINT student_id_key PRIMARY KEY (student_id)
);

-- 제약조건 수정
ALTER TABLE playground.not_null_example DROP constraint student_id_key;
ALTER TABLE playground.not_null_example ADD CONSTRAINT student_id_key PRIMARY KEY (student_id);
ALTER TABLE playground.not_null_example ALTER COLUMN first_name DROP NOT NULL ;
ALTER TABLE playground.not_null_example ALTER COLUMN first_name SET NOT NULL ;