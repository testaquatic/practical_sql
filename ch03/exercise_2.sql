SELECT first_name, last_name, school, hire_date, salary
FROM teachers
WHERE first_name LIKE 'S%'
    AND salary >= 40000;