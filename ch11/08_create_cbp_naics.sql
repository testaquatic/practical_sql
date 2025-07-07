-- psql
 BEGIN;


CREATE TABLE cbp_naics_72_establishements (state_fips TEXT, county_fips TEXT, county TEXT NOT NULL,
                                                                                          st TEXT NOT NULL,
                                                                                                  naics_2017 TEXT NOT NULL,
                                                                                                                  naics_2017_label TEXT NOT NULL,
                                                                                                                                        year SMALLINT NOT NULL,
                                                                                                                                                      establishments INTEGER NOT NULL,
                                                                                                                                                                             CONSTRAINT cbp_fips_key PRIMARY KEY (state_fips,
                                                                                                                                                                                                                  county_fips));

\copy cbp_naics_72_establishements
FROM './data/cbp_naics_72_establishments.csv' WITH (HEADER,
                                                    FORMAT CSV);


SELECT *
FROM cbp_naics_72_establishements
ORDER BY state_fips,
         county_fips
LIMIT 5;


COMMIT;