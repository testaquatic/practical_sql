-- CORR
SELECT corr(median_hh_income, pct_bachelors_higher)
FROM county_statistics.acs_2014_2018_stats;

SELECT median_hh_income, pct_bachelors_higher
FROM county_statistics.acs_2014_2018_stats;

SELECT round(corr(median_hh_income, pct_bachelors_higher)::NUMERIC, 2)  AS bachelors_income_r,
       round(corr(pct_travel_60_min, median_hh_income)::NUMERIC, 2)     AS income_travle_r,
       round(corr(pct_travel_60_min, pct_bachelors_higher)::NUMERIC, 2) AS bachelors_travle_r
FROM county_statistics.acs_2014_2018_stats;

-- 선형회귀
SELECT round(regr_slope(median_hh_income, pct_bachelors_higher)::NUMERIC, 2)     AS slope,
       round(regr_intercept(median_hh_income, pct_bachelors_higher)::NUMERIC, 2) AS y_intercept
FROM county_statistics.acs_2014_2018_stats;

-- r-제곱 확인
SELECT round(regr_r2(median_hh_income, pct_bachelors_higher)::NUMERIC, 3) AS r_squared
FROM county_statistics.acs_2014_2018_stats;