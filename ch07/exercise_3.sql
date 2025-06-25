SELECT percentile_cont(.5) WITHIN GROUP (
                                         ORDER BY (e2019.pop_est_2019 - e2010.estimates_base_2010)::NUMERIC / e2010.estimates_base_2010 * 100) AS median_pct_chg
FROM us_counties_pop_est_2019 AS e2019
JOIN us_counties_pop_est_2010 AS e2010 ON e2010.state_fips = e2019.state_fips
AND e2010.county_fips = e2019.county_fips;