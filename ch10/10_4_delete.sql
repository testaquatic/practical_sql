BEGIN;

DELETE
FROM
    meat_poultry_egg_establishments
WHERE
    st IN ('AS', 'GU', 'MP', 'PR', 'VI');

COMMIT;

ALTER TABLE meat_poultry_egg_establishments
    DROP COLUMN zip_copy;

BEGIN;
DROP TABLE meat_poultry_egg_establishments_backup;
COMMIT;