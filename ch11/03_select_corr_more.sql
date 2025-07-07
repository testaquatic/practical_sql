SELECT round(corr(median_hh_income, pct_bachelors_higher)::NUMERIC, 2) AS bachelors_income_r,
       round(corr(pct_travel_60_min, median_hh_income)::NUMERIC, 2) AS income_travel_r,
       round(corr(pct_travel_60_min, pct_bachelors_higher)::NUMERIC, 2) AS bachelors_travel_r
FROM acs_2014_2018_stats;