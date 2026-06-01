CREATE TABLE state_regions (
    st     TEXT
        CONSTRAINT st_key PRIMARY KEY,
    region TEXT NOT NULL
);

------------------------------psql
\copy state_regions FROM './data/state_regions.csv' WITH (FORMAT CSV, HEADER);
------------------------------

ALTER TABLE meat_poultry_egg_establishments
    ADD COLUMN inspection_deadline TIMESTAMP WITH TIME ZONE;

UPDATE meat_poultry_egg_establishments establishments
SET
    inspection_deadline = '2022-12-01 00:00 EST'
WHERE
    EXISTS(
        SELECT
            state_regions.region
        FROM
            state_regions
        WHERE
            establishments.st = state_regions.st
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

DELETE
FROM
    meat_poultry_egg_establishments
WHERE
    st IN ('AS', 'GU', 'MP', 'PR', 'VI');

ALTER TABLE meat_poultry_egg_establishments
    DROP COLUMN zip_copy;

DROP TABLE meat_poultry_egg_establishments_backup;
