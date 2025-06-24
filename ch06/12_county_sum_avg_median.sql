SELECT
    SUM(pop_est_2019) AS county_sum,
    ROUND(avg(pop_est_2019), 0) AS county_average,
    PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY pop_est_2019) AS county_median
FROM
    us_counties_pop_est_2019;