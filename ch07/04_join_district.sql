SELECT *
FROM district_2020 JOIN district_2035
    ON district_2020.id = district_2035.id
ORDER BY district_2020.id;