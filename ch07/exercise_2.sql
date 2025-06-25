SELECT '2010' AS year,
       state_fips,
       county_fips,
       state_name,
       county_name,
       estimates_base_2010
FROM us_counties_pop_est_2010
UNION ALL
SELECT '2019',
       state_fips,
       county_fips,
       state_name,
       county_name,
       pop_est_2019
FROM us_counties_pop_est_2019
ORDER BY state_name,
         county_name;