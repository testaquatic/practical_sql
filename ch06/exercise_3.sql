SELECT state_name AS state,
       PERCENTILE_CONT(.5) WITHIN GROUP (
                                         ORDER BY pop_est_2019) AS median
FROM us_counties_pop_est_2019
WHERE state_name = 'California'
    OR state_name = 'New York'
GROUP BY state_name
ORDER BY median DESC;