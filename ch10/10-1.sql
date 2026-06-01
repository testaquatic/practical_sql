CREATE TABLE meat_poultry_egg_establishments (
    establishment_number TEXT
        CONSTRAINT est_number_key PRIMARY KEY,
    company              TEXT,
    street               TEXT,
    city                 TEXT,
    st                   TEXT,
    zip                  TEXT,
    phone                TEXT,
    grant_date           DATE,
    activities           TEXT,
    dbas                 TEXT
);

--------------------- psql
\copy meat_poultry_egg_establishments FROM './data/MPI_Directory_by_Establishment_Name.csv' WITH (FORMAT CSV, HEADER);
---------------------

CREATE INDEX company_idx ON meat_poultry_egg_establishments (company);

SELECT
    COUNT(*)
FROM
    meat_poultry_egg_establishments;

SELECT
    company,
    street,
    city,
    st,
    COUNT(*) AS address_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    company, street, city, st
HAVING
    COUNT(*) > 1
ORDER BY
    company, street, city, st;

SELECT
    st,
    COUNT(*) AS st_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    st
ORDER BY
    st;

SELECT
    establishment_number,
    company,
    city,
    st,
    zip
FROM
    meat_poultry_egg_establishments
WHERE
    st IS NULL;

SELECT
    company,
    COUNT(*) AS company_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    company
ORDER BY
    company;

SELECT
    LENGTH(zip),
    COUNT(*) AS length_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    LENGTH(zip)
ORDER BY
    LENGTH(zip);

SELECT
    st,
    COUNT(*) AS st_count
FROM
    meat_poultry_egg_establishments
WHERE
    LENGTH(zip) < 5
GROUP BY
    st
ORDER BY
    st;