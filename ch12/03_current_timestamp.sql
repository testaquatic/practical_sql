BEGIN;


CREATE TABLE current_time_example(time_id INTEGER GENERATED ALWAYS AS IDENTITY,
                                                            current_timestamp_col TIMESTAMPTZ,
                                                            clock_timestamp_col TIMESTAMPTZ);


INSERT INTO current_time_example(current_timestamp_col, clock_timestamp_col)
  (SELECT current_timestamp,
          clock_timestamp()
   FROM generate_series(1, 1000));


SELECT *
FROM current_time_example;


COMMIT;