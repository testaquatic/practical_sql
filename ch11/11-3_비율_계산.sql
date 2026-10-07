-- 데이터셋 생성
CREATE TABLE county_statistics.cbp_naics_72_establishments
(
    state_fips       TEXT,
    county_fips      TEXT,
    county           TEXT     NOT NULL,
    st               TEXT     NOT NULL,
    naics_2017       TEXT     NOT NULL,
    naics_2017_label TEXT     NOT NULL,
    year             SMALLINT NOT NULL,
    establishments   INTEGER  NOT NULL,
    CONSTRAINT cbp_fips_key PRIMARY KEY (state_fips, county_fips)
);

COPY county_statistics.cbp_naics_72_establishments
    FROM 'cbp_naics_72_establishments.csv'
    WITH (FORMAT CSV , HEADER );

SELECT *
FROM county_statistics.cbp_naics_72_establishments
ORDER BY state_fips, county_fips
LIMIT 5;

-- 기업이 많이 집중된 카운티
SELECT cbp.county,
       cbp.st,
       cbp.establishments,
       pop.pop_est_2018,
       round(cbp.establishments::NUMERIC / pop.pop_est_2018 * 1000, 1) AS estabs_per_1000
FROM county_statistics.cbp_naics_72_establishments cbp
         JOIN county_statistics.us_counties_pop_est_2019 pop
              ON cbp.state_fips = pop.state_fips AND cbp.county_fips = pop.county_fips
WHERE pop.pop_est_2018 >= 50_000
ORDER BY cbp.establishments::NUMERIC / pop.pop_est_2018 DESC;

-- 데이터셋 생성
CREATE SCHEMA us_statistics;

CREATE TABLE us_statistics.us_exports
(
    year                  SMALLINT,
    month                 SMALLINT,
    citrus_export_value   BIGINT,
    soybeans_export_value BIGINT
);

COPY us_statistics.us_exports
    FROM 'us_exports.csv'
    WITH (FORMAT CSV, HEADER );

SELECT year, month, citrus_export_value
FROM us_statistics.us_exports
ORDER BY year, month;

-- 이동평균
SELECT year,
       month,
       citrus_export_value,
       round(avg(citrus_export_value) OVER (ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW ), 0)
           AS twelve_month_avg
FROM us_statistics.us_exports
ORDER BY year, month;

SELECT round(corr(median_hh_income, pct_masters_higher)::NUMERIC, 2) AS masters_income_r
FROM county_statistics.acs_2014_2018_stats;

SELECT year,
       month,
       soybeans_export_value,
       round(avg(soybeans_export_value) OVER (ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW ),
             0) AS twelve_month_avg
FROM us_statistics.us_exports
ORDER BY year, month;

SELECT rank() OVER (ORDER BY visits::NUMERIC / popu_lsa DESC) AS rank,
       libname,
       stabr,
       city,
       visits,
       popu_lsa,
       round(visits::NUMERIC / popu_lsa * 1000, 1)            AS visits_per_1000
FROM libraries.pls_fy2018_libraries
WHERE popu_lsa >= 250_000;


