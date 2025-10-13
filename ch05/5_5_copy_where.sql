BEGIN;


DELETE
FROM supervisor_salaries;


COMMIT;

-- psql
\copy supervisor_salaries (town, supervisor, salary)
FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV,
                                            HEADER)
WHERE town = 'New Brillig';

SELECT * FROM supervisor_salaries;