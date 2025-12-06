START TRANSACTION;

CREATE TABLE retirees (
    id         INT,
    first_name TEXT,
    last_name  TEXT
);

INSERT INTO retirees
VALUES (
    2, 'Janet', 'King'
), (
    4, 'Michael', 'Taylor'
);

SELECT *
FROM
    retirees;

COMMIT;

SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    emp_id IN (
        SELECT id
        FROM retirees
              )
ORDER BY
    emp_id;

SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    EXISTS (
        SELECT id
        FROM retirees
        WHERE id = employees.emp_id
           );

SELECT
    first_name,
    last_name
FROM
    employees
WHERE
    NOT EXISTS (
        SELECT id
        FROM retirees
        WHERE id = employees.emp_id
               );