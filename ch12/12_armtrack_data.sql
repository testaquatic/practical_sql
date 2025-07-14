BEGIN;


CREATE TABLE train_rides (trip_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
                                                                      segment TEXT NOT NULL,
                                                                                   departure TIMESTAMPTZ NOT NULL,
                                                                                                         arrival TIMESTAMPTZ NOT NULL);


INSERT INTO train_rides (segment, departure, arrival)
VALUES ('Chicago to New York', '2020-11-13 21:30 CST', '2020-11-14 18:23 EST'),
       ('New York to New Orleans', '2020-11-15 14:15 EST', '2020-11-16 19:32 CST'),
       ('New Orleans to Los Angeles', '2020-11-17 13:45 CST', '2020-11-18 9:00 PST'),
       ('Los Angeles to San Francisco', '2020-11-19 10:10 PST', '2020-11-19 21:24 PST'),
       ('San Francisco to Denver', '2020-11-20 9:10 PST', '2020-11-21 18:38 MST'),
       ('Denver to Chicago', '2020-11-22 19:10 MST', '2020-11-23 14:50 CST');


SET TIME ZONE 'US/Central';


SELECT *
FROM train_rides;


COMMIT;