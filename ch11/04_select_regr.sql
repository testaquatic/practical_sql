SELECT round(regr_slope(median_hh_income, pct_bachelors_higher)::NUMERIC, 2) AS slope,
       round(regr_intercept(median_hh_income, pct_bachelors_higher)::NUMERIC, 2) AS y_intercept
FROM acs_2014_2018_stats;