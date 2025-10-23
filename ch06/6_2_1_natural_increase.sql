SELECT county_name AS county,
       state_name AS state,
       births_2019 AS births,
       deaths_2019 AS deaths,
       births_2019 - deaths_2019 AS natural_increase
FROM us_counties_pop_est_2019
ORDER BY state_name,
         county_name;


SELECT county_name AS county,
       state_name AS state,
       pop_est_2019 AS pop,
       pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 + residual_2019 AS components_total,
       pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 + residual_2019) AS difference
FROM us_counties_pop_est_2019
ORDER BY difference DESC;


SELECT county_name AS county,
       state_name AS state,
       area_water::NUMERIC / (area_land + area_water) AS pct_water
FROM us_counties_pop_est_2019
ORDER BY pct_water DESC;