SELECT
    CORR(med_hh_inc, pct_bachelors_higher) AS bachelors_income_r
FROM
    acs_2014_2018_stats;

START TRANSACTION;

ALTER TABLE acs_2014_2018_stats
    RENAME COLUMN med_hh_inc TO median_hh_income;

COMMIT;

SELECT
    ROUND(CORR(median_hh_income, pct_bachelors_higher)::NUMERIC, 2)  AS bachelors_income_r,
    ROUND(CORR(pct_travel_60_min, median_hh_income)::NUMERIC, 2)     AS income_travle_r,
    ROUND(CORR(pct_travel_60_min, pct_bachelors_higher)::NUMERIC, 2) AS bachelors_travle_r
FROM
    acs_2014_2018_stats;


SELECT
    ROUND(REGR_SLOPE(median_hh_income, pct_bachelors_higher)::NUMERIC, 2)     AS slope,
    ROUND(REGR_INTERCEPT(median_hh_income, pct_bachelors_higher)::NUMERIC, 2) AS y_intercept
FROM
    acs_2014_2018_stats;

SELECT
    ROUND(REGR_R2(median_hh_income, pct_bachelors_higher)::NUMERIC, 3) AS r_squared
FROM
    acs_2014_2018_stats;