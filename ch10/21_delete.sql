BEGIN;


DELETE
FROM meat_poultry_egg_establishments
WHERE st IN('AS',
            'GU',
            'MP',
            'PR',
            'VI');


COMMIT;