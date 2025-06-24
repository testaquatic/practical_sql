SELECT
    SUM(pop_est_2019) AS county_sum,
    ROUND(AVG(pop_est_2019), 0) AS county_average
FROM
    us_counties_pop_est_2019;