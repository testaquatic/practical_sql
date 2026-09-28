-- 명단
SELECT school, last_name, first_name
FROM school.teachers
ORDER BY school, last_name;

-- 조건
SELECT *
FROM school.teachers
WHERE first_name LIKE 'S%'
  AND salary >= 40_000;

SELECT *
FROM school.teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;