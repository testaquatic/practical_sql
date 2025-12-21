SELECT
    REGEXP_MATCH(original_text, '(?:C0|SO)[0-9]+')                            AS case_number,
    REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')                    AS date_1,
    REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):')                   AS crime_type,
    REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city
FROM
    crime_reports
ORDER BY
    crime_id;

SELECT
    crime_id,
    (REGEXP_MATCH(original_text, '(?:C0|SO)[0-9]+'))[1]

FROM
    crime_reports
ORDER BY
    crime_id;

SELECT
    crime_id,
    ((REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1] || ' ' ||
     (REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})'))[1] || ' US/Eastern')::timestamptz AS date_1
FROM
    crime_reports;

START TRANSACTION;

UPDATE crime_reports
SET
    date_1 = ((REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}'))[1] || ' ' ||
              (REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})'))[1] || ' US/Eastern')::timestamptz
RETURNING crime_id, date_1, original_text;

COMMIT;

SELECT
    crime_id,
    REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')                    AS date1,
    REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})')                           AS time1,
    REGEXP_MATCH(original_text, '-(\d{1,2}/\d{1,2}/\d{2})')                   AS date2,
    REGEXP_MATCH(original_text, '\/\d{2}\n\d{4}-(\d{4})')                     AS time2,
    REGEXP_MATCH(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))')    AS street,
    REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
    REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):')                   AS crime_type,
    REGEXP_MATCH(original_text, ':\s(.+)(?:C0|SO)')                           AS description,
    REGEXP_MATCH(original_text, '(?:C0|SO)[0-9]+')                            AS case_number
FROM
    crime_reports;

START TRANSACTION;
WITH regexp_extract AS (
    SELECT
        crime_id,
        REGEXP_MATCH(original_text, '\d{1,2}\/\d{1,2}\/\d{2}')                    AS date1,
        REGEXP_MATCH(original_text, '\/\d{2}\n(\d{4})')                           AS time1,
        REGEXP_MATCH(original_text, '-(\d{1,2}/\d{1,2}/\d{2})')                   AS date2,
        REGEXP_MATCH(original_text, '\/\d{2}\n\d{4}-(\d{4})')                     AS time2,
        REGEXP_MATCH(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))')    AS street,
        REGEXP_MATCH(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city,
        REGEXP_MATCH(original_text, '\n(?:\w+ \w+|\w+)\n(.*):')                   AS crime_type,
        REGEXP_MATCH(original_text, ':\s(.+)(?:C0|SO)')                           AS description,
        REGEXP_MATCH(original_text, '(?:C0|SO)[0-9]+')                            AS case_number
    FROM
        crime_reports
                       )
UPDATE crime_reports
SET
    date_1      = (regexp_extract.date1[1] || ' ' || regexp_extract.time1[1] || ' US/Eastern')::timestamptz,
    date_2      = CASE
                      WHEN (regexp_extract.date2 IS NULL) AND (regexp_extract.time2 IS NOT NULL) THEN (
                          regexp_extract.date1[1] || ' ' || regexp_extract.time2[1] || ' US/Eastern')::timestamptz
                      WHEN (regexp_extract.date2 IS NOT NULL) AND (regexp_extract.time2 IS NOT NULL) THEN (
                          regexp_extract.date2[1] || ' ' || regexp_extract.time2[1] || ' US/Eastern')::timestamptz
                  END,
    street      = regexp_extract.street[1],
    city        = regexp_extract.city[1],
    crime_type  = regexp_extract.crime_type[1],
    description = regexp_extract.description[1],
    case_number = regexp_extract.case_number[1]
FROM
    regexp_extract
WHERE
    crime_reports.crime_id = regexp_extract.crime_id;

SELECT *
FROM
    crime_reports;
COMMIT;

ROLLBACK;