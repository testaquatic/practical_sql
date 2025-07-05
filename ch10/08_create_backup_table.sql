BEGIN;


CREATE TABLE meat_poultry_egg_establishments_backup AS
SELECT *
FROM meat_poultry_egg_establishments;


COMMIT;