SELECT first_name,
       last_name
FROM employees
WHERE EXISTS
    (SELECT id
     FROM retirees
     WHERE id = employees.emp_id );

SELECT employees.first_name, employees.last_name
FROM employees
JOIN retirees
  ON emp_id = retirees.id;