CREATE TABLE acs_2014_2018_stats (
    geoid                TEXT
        CONSTRAINT geoid_key PRIMARY KEY,
    county               TEXT NOT NULL,
    st                   TEXT NOT NULL,
    pct_travel_60_min    NUMERIC(5, 2),
    pct_bachelors_higher NUMERIC(5, 2),
    pct_masters_higher   NUMERIC(5, 2),
    median_hh_income     INTEGER,
    CHECK ( pct_masters_higher <= pct_bachelors_higher )
);

---------------------psql
\copy acs_2014_2018_stats FROM './data/acs_2014_2018_stats.csv' WITH (FORMAT CSV, HEADER);
---------------------

SELECT *
FROM
    acs_2014_2018_stats;

SELECT
    CORR(median_hh_income, pct_bachelors_higher)
FROM
    acs_2014_2018_stats;

SELECT
    ROUND(CORR(acs_2014_2018_stats.median_hh_income, acs_2014_2018_stats.pct_bachelors_higher)::NUMERIC,
          2)                                                                                                 AS bachelors_income_r,
    ROUND(CORR(acs_2014_2018_stats.pct_travel_60_min, acs_2014_2018_stats.median_hh_income)::NUMERIC,
          2)                                                                                                 AS income_travle_r,
    ROUND(CORR(acs_2014_2018_stats.pct_travel_60_min, acs_2014_2018_stats.pct_bachelors_higher)::NUMERIC,
          2)                                                                                                 AS bachelors_travle_r
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

CREATE TABLE widget_companies (
    id            INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    company       TEXT    NOT NULL,
    widget_output INTEGER NOT NULL
);

INSERT INTO widget_companies (
    company, widget_output
)
VALUES (
    'Dom Widgets', 125000
), (
    'Ariadne Widget Masters', 143000
), (
    'Saito Widget Co.', 201000
), (
    'Mal Inc.', 133000
), (
    'Dream Widget Inc.', 196000
), (
    'Miles Amalgamated', 620000
), (
    'Arthur Industries', 244000
), (
    'Fischer Worldwide', 201000
);

SELECT
    company,
    widget_output,
    RANK() OVER (ORDER BY widget_output DESC),
    DENSE_RANK() OVER (ORDER BY widget_output DESC)
FROM
    widget_companies
ORDER BY
    widget_output DESC;

CREATE TABLE store_sales (
    store      TEXT   NOT NULL,
    category   TEXT   NOT NULL,
    unit_sales BIGINT NOT NULL,
    CONSTRAINT store_category_key PRIMARY KEY (store, category)
);

INSERT INTO store_sales (
    store, category, unit_sales
)
VALUES (
    'Broders', 'Cereal', 1104
), (
    'Wallace', 'Ice Cream', 1863
), (
    'Broders', 'Ice Cream', 2517
), (
    'Cramers', 'Ice Cream', 2112
), (
    'Broders', 'Beer', 641
), (
    'Cramers', 'Cereal', 1003
), (
    'Cramers', 'Beer', 640
), (
    'Wallace', 'Cereal', 980
), (
    'Wallace', 'Beer', 988
);

SELECT
    category,
    store,
    unit_sales,
    RANK() OVER (PARTITION BY category ORDER BY unit_sales DESC)
FROM
    store_sales
ORDER BY
    category, RANK() OVER (PARTITION BY category ORDER BY unit_sales DESC);