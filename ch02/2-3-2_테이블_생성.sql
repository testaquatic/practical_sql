-- 편의를 위한 스키마 생성
CREATE SCHEMA school;

-- 테이블 생성
CREATE TABLE school.teachers
(
    id         BIGSERIAL,
    first_name VARCHAR(25),
    last_name  VARCHAR(50),
    school     VARCHAR(50)
);

-- 테이블 수정
ALTER TABLE school.teachers
    ADD COLUMN hire_date DATE;
ALTER TABLE school.teachers
    ADD COLUMN salary NUMERIC;

-- 데이터 삽입
INSERT INTO school.teachers (first_name, last_name, school, hire_date, salary)
VALUES ('Janet', 'Smith', 'F.D. Roosevelt HS', '2011-10-30', 36200),
       ('Lee', 'Reynolds', 'F.D. Roosevelt HS', '1993-05-22', 65000),
       ('Samuel', 'Cole', 'Myers Middle School', '2005-08-01', 43500),
       ('Samantha', 'Bush', 'Myers Middle School', '2011-10-30', 36200),
       ('Betty', 'Diaz', 'Myers Middle School', '2005-08-30', 43500),
       ('Kathleen', 'Roush', 'F.D. Roosevelt HS', '2010-10-22', 38500);

-- 테이블 조회
SELECT *
FROM school.teachers;