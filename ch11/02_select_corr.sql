SELECT corr(med_hh_income, pct_bachelors_higher) AS bachelors_income_r
FROM acs_2014_2018_stats;

BEGIN;


ALTER TABLE acs_2014_2018_stats RENAME COLUMN med_hh_income TO median_hh_income;


SELECT *
FROM acs_2014_2018_stats
LIMIT 10;


COMMIT;