START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET
    company = 'AGRO Merchantss Oakland LLC'
WHERE
    company = 'AGRO Merchants Oakland, LLC';

SELECT
    company
FROM
    meat_poultry_egg_establishments
WHERE
    company LIKE 'AGRO%'
ORDER BY
    company;

ROLLBACK;

START TRANSACTION;

UPDATE meat_poultry_egg_establishments
SET
    company = 'AGRO Merchants Oakland LLC'
WHERE
    company = 'AGRO Merchants Oakland, LLC';

SELECT
    company
FROM
    meat_poultry_egg_establishments
WHERE
    company LIKE 'AGRO%'
ORDER BY
    company;

COMMIT;

START TRANSACTION;

CREATE TABLE meat_poultry_egg_establishments_backup AS
    SELECT *,
        '2023-02-14 00:00 EST'::TIMESTAMP WITH TIME ZONE AS reviewed_date
    FROM
        meat_poultry_egg_establishments;

ALTER TABLE meat_poultry_egg_establishments
    RENAME TO meat_poultry_egg_establishments_temp;
ALTER TABLE meat_poultry_egg_establishments_backup
    RENAME TO meat_poultry_egg_establishments;
ALTER TABLE meat_poultry_egg_establishments_temp
    RENAME TO meat_poultry_egg_establishments_backup;

COMMIT;