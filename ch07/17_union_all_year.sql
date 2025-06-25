SELECT '2020' AS year,
       school_2020 AS school
FROM district_2020
UNION ALL
SELECT '2035' AS year,
       school_2035
FROM district_2035
ORDER BY school,
         year;