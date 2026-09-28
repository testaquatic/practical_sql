-- 테이블 조회
SELECT *
FROM school.teachers;

-- 테이블 조회2
TABLE school.teachers;

-- 하위 집합 쿼리
SELECT last_name, first_name, salary
FROM school.teachers;

-- 정렬
SELECT first_name,
       last_name,
       salary
FROM school.teachers
ORDER BY salary DESC;

-- 정렬, 열 번호
SELECT first_name,
       last_name,
       salary
FROM school.teachers
ORDER BY 3 DESC;

-- 복합 정렬
SELECT last_name, school, hire_date
FROM school.teachers
ORDER BY school ASC, hire_date DESC;

-- DISTINCT
SELECT DISTINCT school
FROM school.teachers
ORDER BY school;

-- DISTINCT 복합
SELECT DISTINCT school, salary
FROM school.teachers
ORDER BY school, salary;

-- WHERE
SELECT last_name, school, hire_date
FROM school.teachers
WHERE school = 'Myers Middle School';

-- = 연산자
SELECT first_name, last_name, school
FROM school.teachers
WHERE first_name = 'Janet';

-- <> 연산자
SELECT DISTINCT school
FROM school.teachers
WHERE school <> 'F.D. Roosevelt HS';

-- < 연산자
SELECT first_name, last_name, hire_date
FROM school.teachers
WHERE hire_date < '2000-01-01';

-- >= 연산자
SELECT first_name, last_name, salary
FROM school.teachers
WHERE salary >= 43500;

-- BETWEEN 연산자
SELECT first_name, last_name, salary
FROM school.teachers
WHERE salary BETWEEN 40_000 AND 65_000;

-- 명시적
SELECT first_name,
       last_name,
       school,
       salary
FROM school.teachers
WHERE salary >= 40_000
  AND salary <= 65_000;

-- LIKE
SELECT first_name
FROM school.teachers
WHERE first_name LIKE 'sam%';

-- ILIKE
SELECT first_name
FROM school.teachers
WHERE first_name ILIKE 'sam%';

-- AND
SELECT *
FROM school.teachers
WHERE school = 'Myers Middle School'
  AND salary < 40000;

-- OR
SELECT *
FROM school.teachers
WHERE last_name = 'Cole'
   OR last_name = 'Bush';

-- AND OR
SELECT *
FROM school.teachers
WHERE school = 'F.D. Roosevelt HS'
  AND (salary < 38_000 OR salary > 40_000);

-- 복합
SELECT first_name, last_name, school, hire_date, salary
FROM school.teachers
WHERE school LIKE '%Roos%'
ORDER BY hire_date DESC;