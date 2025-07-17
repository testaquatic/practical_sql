SELECT
  first_name, last_name
FROM employees
WHERE emp_id IN (
  SELECT id
  FROM retirees
) ORDER BY emp_id;