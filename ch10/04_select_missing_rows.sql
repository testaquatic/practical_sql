SELECT
    establishment_number,
    company,
    city,
    st,
    zip
FROM meat_poultry_egg_establishments
WHERE st IS NULL;