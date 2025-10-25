SELECT district_2020.id,
       district_2020.school_2020,
       district_2035.school_2035
FROM district_2020
LEFT JOIN district_2035 ON district_2020.id = district_2035.id
ORDER BY district_2020.id;