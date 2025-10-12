BEGIN;


CREATE TABLE char_data_types (char_column CHAR(10),
                                          varchar_column VARCHAR(10),
                                                         text_column TEXT);


INSERT INTO char_data_types
VALUES ('abc', 'abc', 'abc'),
       ('defghi', 'defghi', 'defghi');


COMMIT;

-- psql
\copy char_data_types TO './data/typetest.txt' WITH (FORMAT CSV,
                                                            DELIMITER '|',
                                                                      HEADER);