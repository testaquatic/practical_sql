SELECT
    company,
    street,
    city,
    st,
    COUNT(*) AS address_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    company, street, city, st
HAVING
    COUNT(*) > 1
ORDER BY
    company, street, city, st;

SELECT
    st,
    COUNT(*) AS st_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    st
ORDER BY
    st;

SELECT
    establishment_number,
    company,
    city,
    st,
    zip
FROM
    meat_poultry_egg_establishments
WHERE
    st IS NULL;

SELECT
    company,
    COUNT(*) AS company_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    company
ORDER BY
    company ASC;

SELECT
    LENGTH(zip),
    COUNT(*) AS length_count
FROM
    meat_poultry_egg_establishments
GROUP BY
    LENGTH(zip)
ORDER BY
    LENGTH(zip) ASC;

SELECT
    st,
    COUNT(*) AS st_count
FROM
    meat_poultry_egg_establishments
WHERE
    LENGTH(zip) < 5
GROUP BY
    st
ORDER BY
    st ASC;