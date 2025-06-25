-- 오류가 발생한다.

SELECT id
FROM district_2020
LEFT JOIN district_2035 ON district_2020.id = district_2035.id;