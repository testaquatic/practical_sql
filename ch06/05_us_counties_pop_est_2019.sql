SELECT
    county_name AS county,
    state_name AS state,
    pop_est_2019 AS pop,
    births_2019 AS births,
    deaths_2019 AS deaths,
    international_migr_2019 AS int_mig,
    domestic_migr_2019 AS dom_mig,
    residual_2019 AS residual
FROM
    us_counties_pop_est_2019;
