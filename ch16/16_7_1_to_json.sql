SELECT
    TO_JSON(employees) AS json_rows
FROM
    employees;

SELECT
    TO_JSON(ROW (emp_id, last_name)) AS json_rows
FROM
    employees;

SELECT
    TO_JSON(employees) AS json_row
FROM
    (
        SELECT emp_id, last_name AS ln
        FROM employees
    ) AS employees;

SELECT
    JSON_AGG(TO_JSON(employees)) AS json
FROM
    (
        SELECT emp_id, last_name AS ln
        FROM employees
    ) AS employees;