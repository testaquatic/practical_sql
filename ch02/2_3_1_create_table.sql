BEGIN;


CREATE TABLE teachers (id BIGSERIAL,
                          first_name VARCHAR(25),
                                     last_name VARCHAR(50),
                                               school VARCHAR(50),
                                                      hire_date DATE, salary NUMERIC);


COMMIT;