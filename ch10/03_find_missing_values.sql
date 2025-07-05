SELECT
    st,
    count(*) AS st_count
FROM meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;