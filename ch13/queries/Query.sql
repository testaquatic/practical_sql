SELECT
    county_name,
    state_name,
    pop_est_2019
FROM
    us_counties_pop_est_2019
WHERE
    pop_est_2019 >= (
        SELECT PERCENTILE_CONT(.9) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_pop_est_2019
                    )
ORDER BY
    pop_est_2019 DESC;

START TRANSACTION;

CREATE TABLE us_counties_2019_top10 AS
    SELECT *
    FROM
        us_counties_pop_est_2019;

DELETE
FROM
    us_counties_2019_top10
WHERE
    pop_est_2019 < (
        SELECT PERCENTILE_CONT(.9) WITHIN GROUP ( ORDER BY pop_est_2019 ) FROM us_counties_2019_top10
                   );

COMMIT;

SELECT
    COUNT(*)
FROM
    us_counties_2019_top10;

SELECT
    ROUND(calcs.average, 0)                AS average,
    calcs.median,
    ROUND(calcs.average - calcs.median, 0) AS median_average_diff
FROM
    (
        SELECT
            AVG(pop_est_2019)                                                   AS average,
            PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 )::NUMERIC AS median
        FROM
            us_counties_pop_est_2019
    ) AS calcs;

SELECT
    census.state_name                                                         AS st,
    census.pop_est_2018,
    est.establishment_count,
    ROUND((est.establishment_count / census.pop_est_2018::NUMERIC) * 1000, 1) AS estabs_per_thousand
FROM
    (
        SELECT st, SUM(establishments) AS establishment_count FROM cbp_naics_72_establishments GROUP BY st
    ) AS est
    JOIN (
        SELECT state_name, SUM(pop_est_2018) AS pop_est_2018 FROM us_counties_pop_est_2019 GROUP BY state_name
         ) AS census ON est.st = census.state_name
ORDER BY
    estabs_per_thousand DESC;

SELECT
    county_name,
    state_name,
    pop_est_2019,
    (
        SELECT PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY pop_est_2019) FROM us_counties_pop_est_2019
    ) AS us_median
FROM
    us_counties_pop_est_2019;

SELECT
    county_name,
    state_name       AS st,
    pop_est_2019,
    pop_est_2019 - (
        SELECT PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY pop_est_2019) FROM us_counties_pop_est_2019
                   ) AS diff_from_median
FROM
    us_counties_pop_est_2019
WHERE
    (pop_est_2019 - (
        SELECT PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY pop_est_2019) FROM us_counties_pop_est_2019
                    )) BETWEEN -1000 AND 1000;
