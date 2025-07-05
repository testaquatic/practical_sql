BEGIN;
ALTER TABLE meat_poultry_egg_establishments ADD COLUMN st_copy TEXT;


UPDATE meat_poultry_egg_establishments
SET st_copy = st;

COMMIT;