START TRANSACTION;

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

COMMIT;

-- psql
\copy cbp_naics_72_establishments FROM 'data\cbp_naics_72_establishments.csv' WITH (FORMAT CSV, HEADER);
--

SELECT *
FROM
    cbp_naics_72_establishments
ORDER BY
    state_fips, county_fips
LIMIT 5;

SELECT
    cbp.county,
    cbp.st,
    cbp.establishments,
    pop.pop_est_2018,
    ROUND((cbp.establishments::NUMERIC / pop_est_2018) * 1000, 1) AS estabs_per_1000
FROM
    cbp_naics_72_establishments cbp
    JOIN us_counties_pop_est_2019 pop ON cbp.state_fips = pop.state_fips AND cbp.county_fips = pop.county_fips
WHERE
    pop_est_2018 >= 50000
ORDER BY
    cbp.establishments::NUMERIC / pop_est_2018 DESC;