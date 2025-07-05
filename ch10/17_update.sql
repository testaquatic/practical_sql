BEGIN;


UPDATE meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN('CT',
            'MA',
            'ME',
            'NH',
            'NJ',
            'RI',
            'VT')
    AND length(zip) = 4;


COMMIT;