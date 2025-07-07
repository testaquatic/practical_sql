SELECT cbp.county,
       cbp.st,
       cbp.establishments,
       round((cbp.establishments::NUMERIC / pop.pop_est_2018) * 1000, 1) AS estabs_per_1000
FROM cbp_naics_72_establishments cbp
JOIN us_counties_pop_est_2019 pop ON cbp.state_fips = pop.state_fips
AND cbp.county_fips = pop.county_fips
WHERE pop.pop_est_2018 >= 50000
ORDER BY cbp.establishments::NUMERIC / pop.pop_est_2018 DESC;