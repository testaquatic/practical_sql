WITH large_counties (county_name, state_name, pop_est_2019) AS
  (SELECT county_name,
          state_name,
          pop_est_2019
   FROM us_counties_pop_est_2019
   WHERE pop_est_2019 >= 100000 )
SELECT state_name,
       count(*)
FROM large_counties
GROUP BY state_name
ORDER BY count(*) DESC;