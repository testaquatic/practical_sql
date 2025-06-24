SELECT UNNEST(PERCENTILE_CONT(ARRAY[.25, .5, .75]) WITHIN GROUP (
                                                                 ORDER BY pop_est_2019)) AS quartiles
FROM us_counties_pop_est_2019;