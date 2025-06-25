SELECT est19.state_name,
       est19.county_name,
       est19.pop_est_2019 AS pop19,
       est10.estimates_base_2010 AS pop10,
       est19.pop_est_2019 - est10.estimates_base_2010 AS raw_chg,
       ROUND((est19.pop_est_2019::NUMERIC - est10.estimates_base_2010) / est10.estimates_base_2010 * 100, 1) AS pct_chg
FROM us_counties_pop_est_2019 AS est19
JOIN us_counties_pop_est_2010 AS est10 ON est19.state_fips = est10.state_fips
AND est19.county_fips = est10.county_fips
ORDER BY pct_chg ASC;