SELECT * FROM district_2020
UNION
SELECT * FROM district_2035
ORDER BY id;

SELECT * FROM district_2020
UNION ALL
SELECT * FROM district_2035
ORDER BY id;

SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020
UNION ALL
SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school, year;

SELECT * FROM district_2020
INTERSECT
SELECT * FROM district_2035
ORDER BY id;

SELECT * FROM district_2020
EXCEPT
SELECT * FROM district_2035
ORDER BY id;