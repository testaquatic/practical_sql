-- psql
-- BEGIN TRANSACTION;
-- \copy supervisor_salaries FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV, HEADER);
-- ROLLBACK;
-- BEGIN TRANSACTION;
-- \copy supervisor_salaries (town, supervisor, salary) FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV, HEADER);
-- COMMIT;

SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;