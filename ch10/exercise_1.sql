BEGIN;


ALTER TABLE meat_poultry_egg_establishments ADD COLUMN meat_processing BOOLEAN;


ALTER TABLE meat_poultry_egg_establishments ADD COLUMN poultry_processing BOOLEAN;


SELECT meat_processing,
       poultry_processing,
       count(*)
FROM meat_poultry_egg_establishments
GROUP BY meat_processing,
         poultry_processing
ORDER BY count(*) DESC ;


COMMIT;