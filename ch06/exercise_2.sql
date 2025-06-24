SELECT state_name AS state,
       county_name AS county,
       births_2019 AS briths,
       deaths_2019 AS deaths,
       ROUND(deaths_2019::NUMERIC / births_2019, 2) AS ratio
FROM us_counties_pop_est_2019
WHERE births_2019 != 0
ORDER BY ratio DESC
LIMIT 20;