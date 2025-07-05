--psql
BEGIN;


CREATE TABLE state_regions(st TEXT CONSTRAINT st_key PRIMARY KEY,
                                                     region TEXT NOT NULL);

\copy state_regions
FROM './data/state_regions.csv' WITH (FORMAT CSV,
                                      HEADER);


COMMIT;