SELECT *
FROM employees
JOIN departments ON employees.dept_id = departments.dept_id
ORDER BY employees.dept_id;