CREATE SCHEMA fsis;

CREATE TABLE fsis.meat_poultry_egg_establishments
(
    establishment_number TEXT
        CONSTRAINT est_number_key PRIMARY KEY,
    company              TEXT,
    street               TEXT,
    city                 TEXT,
    st                   TEXT,
    zip                  TEXT,
    phone                TEXT,
    grant_date           TEXT,
    activities           TEXT,
    dbas                 TEXT
);

COPY fsis.meat_poultry_egg_establishments
    FROM 'MPI_Directory_by_Establishment_Name.csv'
    WITH (FORMAT CSV , HEADER );

CREATE INDEX company_idx ON fsis.meat_poultry_egg_establishments (company);

SELECT count(*) FROM fsis.meat_poultry_egg_establishments;

