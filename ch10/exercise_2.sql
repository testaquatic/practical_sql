BEGIN;


UPDATE meat_poultry_egg_establishments
SET meat_processing = TRUE
WHERE activities ILIKE '%meat processing%';


UPDATE meat_poultry_egg_establishments
SET poultry_processing = TRUE
WHERE activities ILIKE '%poultry processing%';


SELECT meat_processing,
       poultry_processing,
       count(*)
FROM meat_poultry_egg_establishments
GROUP BY meat_processing,
         poultry_processing
ORDER BY count(*) DESC;


COMMIT;