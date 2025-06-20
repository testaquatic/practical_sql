BEGIN TRANSACTION;


SELECT first_name,
       last_name,
       salary
FROM teachers
ORDER BY salary DESC;

;


COMMIT;