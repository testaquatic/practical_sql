SELECT
    county_name
FROM
    us_counties_pop_est_2019
WHERE
    county_name ~* '(lade|lare)'
ORDER BY
    county_name;

SELECT
    county_name
FROM
    us_counties_pop_est_2019
WHERE
    county_name ~* 'ash'
    AND county_name !~ 'Wash'
ORDER BY
    county_name;

-- psql

START TRANSACTION;

CREATE TABLE crime_reports (
    crime_id      INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    case_number   TEXT,
    date_1        timestamptz,
    date_2        timestamptz,
    street        TEXT,
    city          TEXT,
    crime_type    TEXT,
    description   TEXT,
    original_text TEXT NOT NULL
);

\copy crime_reports (original_text) FROM 'data\crime_reports.csv' WITH (FORMAT CSV, HEADER OFF, QUOTE '"');

COMMIT;
--

SELECT
    original_text
FROM
    crime_reports;

SELECT
    crime_id,
    REGEXP_MATCH(original_text, '\d{1,2}/\d{1,2}/\d{2}')
FROM
    crime_reports
ORDER BY
    crime_id;

SELECT
    crime_id,
    REGEXP_MATCHES(original_text, '\d{1,2}/\d{1,2}/\d{2}', 'g')
FROM
    crime_reports
ORDER BY
    crime_id;

SELECT
    crime_id,
    REGEXP_MATCH(original_text, '-(\d{1,2}/\d{1,2}/\d{2})')
FROM
    crime_reports
ORDER BY
    crime_id;