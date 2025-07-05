BEGIN;

ALTER TABLE meat_poultry_egg_establishments ADD COLUMN company_standard TEXT;

UPDATE meat_poultry_egg_establishments
SET company_standard = company;

COMMIT;