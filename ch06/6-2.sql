SELECT
    county_name             AS county,
    state_name              AS state,
    pop_est_2019            AS pop,
    births_2019             AS births,
    deaths_2019             AS deaths,
    international_migr_2019 AS int_migr,
    domestic_migr_2019      AS dom_migr,
    residual_2019           AS residual
FROM
    us_counties_pop_est_2019;

SELECT
    county_name               AS county,
    state_name                AS state,
    births_2019               AS births,
    deaths_2019               AS deaths,
    births_2019 - deaths_2019 AS natural_increase
FROM
    us_counties_pop_est_2019
ORDER BY
    state_name, county_name;

SELECT
    county_name                                                                                               AS county,
    state_name                                                                                                AS state,
    pop_est_2019                                                                                              AS pop,
    pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 +
    residual_2019                                                                                             AS components_total,
    pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 +
                    residual_2019)                                                                            AS difference
FROM
    us_counties_pop_est_2019
ORDER BY
    difference DESC;

SELECT
    county_name                                          AS county,
    state_name                                           AS state,
    area_water::NUMERIC / (area_water + area_land) * 100 AS pct_water
FROM
    us_counties_pop_est_2019
ORDER BY
    pct_water DESC;

START TRANSACTION;

CREATE TABLE IF NOT EXISTS percent_change (
    department TEXT,
    spend_2019 NUMERIC(10, 2),
    spend_2022 NUMERIC(10, 2)
);

INSERT INTO percent_change
VALUES (
    'Assessor', 178556, 179500
), (
    'Building', 250000, 289000
), (
    'Clerk', 451980, 650000
), (
    'Library', 87777, 90001
), (
    'Parks', 250000, 223000
), (
    'Water', 199000, 195000
);

SELECT
    department,
    spend_2019,
    spend_2022,
    ROUND((spend_2022 - spend_2019) / spend_2019 * 100, 1) AS pct_change
FROM
    percent_change;

COMMIT;

SELECT
    SUM(pop_est_2019)           AS county_sum,
    ROUND(AVG(pop_est_2019), 0) AS county_average
FROM
    us_counties_pop_est_2019;

START TRANSACTION;

CREATE TABLE IF NOT EXISTS percentile_test (
    numbers INT
);

INSERT INTO percentile_test (
    numbers
)
VALUES (
    1
), (
    2
), (
    3
), (
    4
), (
    5
), (
    6
);

SELECT
    PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY numbers ),
    PERCENTILE_DISC(.5) WITHIN GROUP ( ORDER BY numbers )
FROM
    percentile_test;

COMMIT;

SELECT
    SUM(pop_est_2019)                                          AS county_sum,
    ROUND(AVG(pop_est_2019), 0)                                AS county_average,
    PERCENTILE_CONT(.5) WITHIN GROUP ( ORDER BY pop_est_2019 ) AS county_median
FROM
    us_counties_pop_est_2019;

SELECT
    UNNEST(PERCENTILE_CONT(ARRAY [.25,.5,.75]) WITHIN GROUP ( ORDER BY pop_est_2019 )) AS quartiles
FROM
    us_counties_pop_est_2019;

SELECT
    MODE() WITHIN GROUP ( ORDER BY births_2019 )
FROM
    us_counties_pop_est_2019;