CREATE EXTENSION tablefunc;

-- psql

START TRANSACTION;

CREATE TABLE ice_cream_survey (
    response_id INTEGER PRIMARY KEY,
    office      TEXT,
    flavor      TEXT
);

\copy ice_cream_survey FROM 'data\ice_cream_survey.csv' WITH (FORMAT CSV, HEADER);

SELECT *
FROM
    ice_cream_survey
ORDER BY
    response_id
LIMIT 5;

COMMIT;

--

SELECT *
FROM
    crosstab('SELECT office, flavor, count(*)
     FROM ice_cream_survey
     GROUP BY office, flavor
     ORDER BY office', 'SELECT flavor
     FROM ice_cream_survey
     GROUP BY flavor
     ORDER BY flavor') AS (office TEXT, chocolate BIGINT, strawberry BIGINT, vanilla BIGINT);


