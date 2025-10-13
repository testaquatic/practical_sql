BEGIN;


CREATE TABLE supervisor_salaries (id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                                                          town TEXT, county TEXT, supervisor TEXT, start_date DATE, salary NUMERIC(10, 2),
                                                                                                                                           benefits NUMERIC(10, 2));


COMMIT;

-- psql
\copy supervisor_salaries (town, supervisor, salary)
FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV,
                                            HEADER);


SELECT *
FROM supervisor_salaries
ORDER BY id
LIMIT 2;

