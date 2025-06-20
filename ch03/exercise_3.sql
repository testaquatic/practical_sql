SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE hire_date >= '2010-01-01'
ORDER BY salary DESC;