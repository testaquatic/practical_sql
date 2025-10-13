--psql
 BEGIN;


DELETE
FROM supervisor_salaries;


CREATE
TEMPORARY TABLE supervisor_salaries_temp (LIKE supervisor_salaries INCLUDING ALL);

\copy supervisor_salaries_temp (town, supervisor, salary)
FROM './data/supervisor_salaries.csv' WITH (FORMAT CSV,
                                            HEADER);


INSERT INTO supervisor_salaries (town, county, supervisor, salary)
SELECT town,
       'Mills',
       supervisor,
       salary
FROM supervisor_salaries_temp;


DROP TABLE supervisor_salaries_temp;


COMMIT;

SELECT * FROM supervisor_salaries ORDER BY id LIMIT 2;