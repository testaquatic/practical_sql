CREATE TABLE cbp_naics_72_establishments (
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

-----------------------psql
\copy cbp_naics_72_establishments FROM './data/cbp_naics_72_establishments.csv' WITH (FORMAT CSV, HEADER);
-----------------------

SELECT *
FROM
    cbp_naics_72_establishments
ORDER BY
    state_fips, county_fips
LIMIT 5;

SELECT
    county,
    st,
    establishments,
    pop_est_2018,
    ROUND((establishments::NUMERIC / pop_est_2018) * 1000, 1) AS estabs_per_1000
FROM
    cbp_naics_72_establishments AS cbp
    JOIN us_counties_pop_est_2019 AS pop ON cbp.state_fips = pop.state_fips AND cbp.county_fips = pop.county_fips
WHERE
    pop_est_2018 >= 50_000
ORDER BY
    estabs_per_1000 DESC;

CREATE TABLE us_exports (
    year                  SMALLINT,
    month                 SMALLINT,
    citrus_export_value   BIGINT,
    soybeans_export_value BIGINT
);

-----------------------------------psql
\copy us_exports FROM './data/us_exports.csv' WITH (FORMAT CSV, HEADER);
-----------------------------------

SELECT
    year,
    month,
    citrus_export_value
FROM
    us_exports
ORDER BY
    year, month;

SELECT
    year,
    month,
    citrus_export_value,
    ROUND(AVG(citrus_export_value) OVER (ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW),
          0) AS twelve_month_avg
FROM
    us_exports
ORDER BY
    year, month;
