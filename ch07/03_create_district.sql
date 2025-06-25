BEGIN TRANSACTION;


CREATE TABLE district_2020 (id INTEGER CONSTRAINT id_key_2020 PRIMARY KEY,
                                                              school_2020 TEXT);


CREATE TABLE district_2035 (id INTEGER CONSTRAINT id_key_2035 PRIMARY KEY,
                                                              school_2035 TEXT);


INSERT INTO district_2020
VALUES (1, 'Oak Street School'),
       (2, 'Roosevelt High School'),
       (5, 'Dover Middle School'),
       (6, 'Webutuck High School');


INSERT INTO district_2035
VALUES (1, 'Oak Street School'),
       (2, 'Roosevelt High School'),
       (3, 'Morrison Elementary'),
       (4, 'Chase Magnet Academy'),
       (6, 'Webutuck High School');


COMMIT;


ROLLBACK;