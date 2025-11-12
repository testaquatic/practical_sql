BEGIN;
CREATE TABLE state_regions (
    st     TEXT
        CONSTRAINT st_key PRIMARY KEY,
    region TEXT NOT NULL
);
COMMIT;

-- psql
\copy state_regions FROM 'data\state_regions.csv' WITH (FORMAT CSV, HEADER);
--

BEGIN;

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN inspection_deadline TIMESTAMP WITH TIME ZONE;

UPDATE meat_poultry_egg_establishments establishment
SET
    inspection_deadline = '2022-12-01 00:00 EST'
WHERE
    EXISTS(
        SELECT
            state_regions.region
        FROM
            state_regions
        WHERE
            establishment.st = state_regions.st
            AND state_regions.region = 'New England'
          );

SELECT
    st,
    inspection_deadline
FROM
    meat_poultry_egg_establishments
GROUP BY
    st, inspection_deadline
ORDER BY
    st;

COMMIT;