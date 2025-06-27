-- psql
 BEGIN TRANSACTION;


CREATE TABLE new_york_addresses (longtitude NUMERIC(9, 6),
                                            latitude NUMERIC(9, 6),
                                                     street_number TEXT, street TEXT, unit TEXT, postcode TEXT, id INTEGER CONSTRAINT new_york_key PRIMARY KEY);

\copy new_york_addresses
FROM './data/city_of_new_york.csv' WITH (FORMAT CSV,
                                         HEADER);


SELECT *
FROM new_york_addresses;


COMMIT;