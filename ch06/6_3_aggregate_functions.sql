SELECT sum(pop_est_2019) AS county_sum,
       round(avg(pop_est_2019), 0) AS county_average
FROM us_counties_pop_est_2019;

BEGIN;


CREATE TABLE percentile_test (numbers INTEGER);


INSERT INTO percentile_test (numbers)
VALUES (1),
       (2),
       (3),
       (4),
       (5),
       (6);


SELECT percentile_cont(.5) WITHIN GROUP (
                                         ORDER BY numbers), percentile_disc(.5) WITHIN GROUP (
                                                                                              ORDER BY numbers)
FROM percentile_test;


COMMIT;


SELECT SUM(pop_est_2019) AS county_sum,
       round(AVG(pop_est_2019), 0) AS county_average,
       percentile_cont(.5) WITHIN GROUP (
                                         ORDER BY pop_est_2019) AS county_median
FROM us_counties_pop_est_2019;


SELECT percentile_cont(array[.25, .5, .75]) WITHIN GROUP (
                                                          ORDER BY pop_est_2019) AS quartiles
FROM us_counties_pop_est_2019;


SELECT unnest(percentile_cont(array[.25, .5, .75]) WITHIN GROUP (
                                                                 ORDER BY pop_est_2019)) AS quartiles
FROM us_counties_pop_est_2019;

SELECT mode() WITHIN GROUP (
                         ORDER BY births_2019)
FROM us_counties_pop_est_2019;