WITH us_median AS (
  SELECT percentile_cont(.5) WITHIN GROUP (ORDER BY pop_est_2019) AS us_median_pop
  FROM us_counties_pop_est_2019
)
SELECT county_name, state_name AS st, pop_est_2019, us_median_pop, pop_est_2019 - us_median_pop AS diff_from_median
FROM us_counties_pop_est_2019
CROSS JOIN us_median
WHERE (pop_est_2019 - us_median_pop) BETWEEN -1000 AND 1000;