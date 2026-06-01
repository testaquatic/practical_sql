CREATE TABLE meat_poultry_egg_establishments_backup AS
    SELECT *
    FROM
        meat_poultry_egg_establishments;

SELECT
    (
        SELECT COUNT(*)
        FROM meat_poultry_egg_establishments AS original
    ),
    (
        SELECT COUNT(*)
        FROM meat_poultry_egg_establishments_backup AS backup
    );

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN st_copy TEXT;

UPDATE meat_poultry_egg_establishments
SET
    st_copy = st;

SELECT
    st,
    st_copy
FROM
    meat_poultry_egg_establishments
WHERE
    st IS DISTINCT FROM st_copy
ORDER BY
    st;

SELECT 'a' <> NULL;

UPDATE meat_poultry_egg_establishments
SET
    st = 'MN'
WHERE
    establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET
    st = 'AL'
WHERE
    establishment_number = 'M45319+P45319'

UPDATE meat_poultry_egg_establishments
SET
    st = 'WI'
WHERE
    establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

SELECT
    establishment_number,
    st
FROM
    meat_poultry_egg_establishments
WHERE
    st IS NULL;

UPDATE meat_poultry_egg_establishments
SET
    st = st_copy;

UPDATE meat_poultry_egg_establishments original
SET
    st = backup.st
FROM
    meat_poultry_egg_establishments_backup backup
WHERE
    original.establishment_number = backup.establishment_number;

UPDATE meat_poultry_egg_establishments
SET
    st = 'MN'
WHERE
    establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET
    st = 'AL'
WHERE
    establishment_number = 'M45319+P45319'

UPDATE meat_poultry_egg_establishments
SET
    st = 'WI'
WHERE
    establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN company_standard TEXT;
UPDATE meat_poultry_egg_establishments
SET
    company_standard = company;

SELECT
    company
FROM
    meat_poultry_egg_establishments
WHERE
    company LIKE 'Armour%';

UPDATE meat_poultry_egg_establishments
SET
    company_standard = 'Armour-Eckrich Meats'
WHERE
    company LIKE 'Armour%'
RETURNING company, company_standard;

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN zip_copy TEXT;
UPDATE meat_poultry_egg_establishments
SET
    zip_copy = zip;

UPDATE meat_poultry_egg_establishments
SET
    zip = '00' || zip
WHERE
    st IN ('PR', 'VI')
    AND LENGTH(zip) = 3;

UPDATE meat_poultry_egg_establishments
SET
    zip = '0' || zip
WHERE
    st IN ('CT', 'MA', 'ME', 'NH', 'NJ', 'RI', 'VT')
    AND LENGTH(zip) = 4;

SELECT
    LENGTH(zip),
    COUNT(*)
FROM
    meat_poultry_egg_establishments
GROUP BY
    LENGTH(zip)
ORDER BY
    LENGTH(zip);