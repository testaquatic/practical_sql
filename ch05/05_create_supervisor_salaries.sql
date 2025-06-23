BEGIN TRANSACTION;


CREATE TABLE supervisor_salaries(id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                                                         town TEXT, county TEXT, supervisor TEXT, start_date DATE, salary NUMERIC(10, 2),
                                                                                                                                          benefits NUMERIC(10, 2));


COMMIT;

