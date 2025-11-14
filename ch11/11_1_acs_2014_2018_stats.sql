START TRANSACTION;

CREATE TABLE acs_2014_2018_stats (
    geoid                TEXT
        CONSTRAINT geoid_key PRIMARY KEY,
    county               TEXT NOT NULL,
    st                   TEXT NOT NULL,
    pct_travel_60_min    NUMERIC(5, 2),
    pct_bachelors_higher NUMERIC(5, 2),
    pct_masters_higher   NUMERIC(5, 2),
    med_hh_inc           INTEGER,
    CHECK ( pct_masters_higher <= pct_bachelors_higher )
);

COMMIT;

--psql
\copy acs_2014_2018_stats FROM 'data\acs_2014_2018_stats.csv' WITH (FORMAT CSV, HEADER);
--

SELECT *
FROM
    acs_2014_2018_stats;