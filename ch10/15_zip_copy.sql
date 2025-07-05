BEGIN;

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN zip_copy TEXT;
UPDATE meat_poultry_egg_establishments
SET zip_copy = zip;

COMMIT;