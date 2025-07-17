WITH counties (st, pop_est_2018) AS
  (SELECT state_name,
          sum(pop_est_2018)
   FROM us_counties_pop_est_2019
   GROUP BY state_name),
     establishments (st, establishment_count) AS
  (SELECT st,
          sum(establishments) AS establishment_count
   FROM cbp_naics_72_establishments
   GROUP BY st)
SELECT counties.st,
       pop_est_2018,
       establishment_count,
       round((establishments.establishment_count / counties.pop_est_2018::NUMERIC(10, 1)) * 1000, 1) AS estaps_per_thousand
FROM counties
JOIN establishments ON counties.st = establishments.st
ORDER BY estaps_per_thousand DESC;