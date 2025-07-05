-- psql
 BEGIN;


CREATE TABLE meat_poultry_egg_establishments (establishment_number TEXT CONSTRAINT est_nmber_key PRIMARY KEY,
                                                                                                 company TEXT, street TEXT, city TEXT, st TEXT, zip TEXT, phone TEXT, grant_date DATE, activities TEXT, dbas TEXT);

\copy meat_poultry_egg_establishments
FROM './data/MPI_Directory_by_Establishment_Name.csv' WITH (FORMAT CSV,
                                                            HEADER);


CREATE INDEX company_idx ON meat_poultry_egg_establishments (company);


SELECT count(*)
FROM meat_poultry_egg_establishments;


COMMIT;