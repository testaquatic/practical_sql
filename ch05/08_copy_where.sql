-- psql
BEGIN TRANSACTION;
\copy supervisor_salaries (town, supervisor, salary)
FROM './data/supervisor_salaries.csv'
WITH (FORMAT CSV, HEADER)
WHERE town = 'New Brillig';
COMMIT;