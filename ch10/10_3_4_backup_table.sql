BEGIN;

CREATE TABLE meat_poultry_egg_establishments_backup AS
    SELECT *
    FROM
        meat_poultry_egg_establishments;

COMMIT;

SELECT
    (
        SELECT COUNT(*)
        FROM meat_poultry_egg_establishments
    ) AS original,
    (
        SELECT COUNT(*)
        FROM meat_poultry_egg_establishments_backup
    ) AS backup;

BEGIN;

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN st_copy TEXT;
UPDATE meat_poultry_egg_establishments
SET
    st_copy = st;

COMMIT;

ROLLBACK;

SELECT
    st,
    st_copy
FROM
    meat_poultry_egg_establishments
WHERE
    st IS DISTINCT FROM st_copy
ORDER BY
    st;

SELECT
    st,
    st_copy
FROM
    meat_poultry_egg_establishments
WHERE
    st <> st_copy
ORDER BY
    st;

BEGIN;

UPDATE meat_poultry_egg_establishments
SET
    st = 'MN'
WHERE
    establishment_number = 'V18677A';

UPDATE meat_poultry_egg_establishments
SET
    st = 'AL'
WHERE
    establishment_number = 'M45319+P45319';

UPDATE meat_poultry_egg_establishments
SET
    st = 'WI'
WHERE
    establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

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

COMMIT;

BEGIN;

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

COMMIT;

BEGIN;

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN company_standard TEXT;

UPDATE meat_poultry_egg_establishments
SET
    company_standard = company;

UPDATE meat_poultry_egg_establishments
SET
    company_standard = 'Armour-Eckrich Meats'
WHERE
    company LIKE 'Armour%'
RETURNING company, company_standard;

COMMIT;

BEGIN;

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
    st,
    COUNT(*) AS st_count
FROM
    meat_poultry_egg_establishments
WHERE
    LENGTH(zip) < 5
GROUP BY
    st
ORDER BY
    st ASC;

COMMIT;