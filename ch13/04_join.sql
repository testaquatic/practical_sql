SELECT census.state_name AS st,
       census.pop_est_2018,
       est.establishment_count,
       round((est.establishment_count / census.pop_est_2018::numeric) * 1000, 1) AS estaps_per_thousand
FROM
  (SELECT st,
          sum(establishments) AS establishment_count
   FROM cbp_naics_72_establishments
   GROUP BY st) AS est
JOIN
  (SELECT state_name,
          sum(pop_est_2018) AS pop_est_2018
   FROM us_counties_pop_est_2019
   GROUP BY state_name) AS census ON est.st = census.state_name
ORDER BY estaps_per_thousand DESC;