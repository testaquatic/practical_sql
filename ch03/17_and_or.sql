SELECT *
FROM teachers
WHERE school = 'Myers Middle School'
    AND salary < 40000;

SELECT *
FROM teachers
WHERE last_name = 'Cole'
    OR last_name = 'Bush';

SELECT *
FROM teachers
WHERE school = 'F.D. Roosevelt HS'
    AND (salary < 38000 OR salary > 40000);