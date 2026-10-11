-- 데이터셋 생성
CREATE SCHEMA text;

CREATE TABLE text.crime_reports
(
    crime_id      INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    case_number   TEXT,
    date_1        timestamptz,
    date_2        timestamptz,
    street        TEXT,
    city          TEXT,
    crime_type    TEXT,
    description   TEXT,
    original_text TEXT NOT NULL
);

COPY text.crime_reports (original_text)
    FROM 'crime_reports.csv'
    WITH (FORMAT CSV , HEADER OFF , QUOTE '"');

SELECT original_text
FROM text.crime_reports;

-- 날짜 패턴 매칭
SELECT crime_id, regexp_match(original_text, '\d{1,2}/\d{1,2}/\d{2}')
FROM text.crime_reports
ORDER BY crime_id;

SELECT crime_id, regexp_matches(original_text, '-(\d{1,2}/\d{1,2}/\d{2})', 'g')
FROM text.crime_reports
ORDER BY crime_id;

SELECT regexp_match(original_text, '(?:C0|SO)[0-9]+')                            AS case_number,
       regexp_match(original_text, '\d{1,2}/\d{1,2}/\d{2}')                      AS date_1,
       regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):')                   AS crime_type,
       regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n') AS city
FROM text.crime_reports;

SELECT crime_id, (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1] AS case_number
FROM text.crime_reports
ORDER BY crime_id;

SET TIME ZONE 'America/New_York';

-- 업데이트
UPDATE text.crime_reports
SET date_1 = (
    (regexp_match(original_text, '\d{1,2}/\d{1,2}/\d{2}'))[1] || ' ' ||
    (regexp_match(crime_reports.original_text, '/\d{2}\n(\d{4})'))[1] || ' America/New_York'
    )::timestamptz
RETURNING crime_reports.crime_id, crime_reports.date_1, crime_reports.original_text;

SELECT *
FROM text.crime_reports
ORDER BY crime_id;

-- 전체 업데이트
WITH crime_matches AS (SELECT crime_id,
                              (regexp_match(original_text, '\d{1,2}/\d{1,2}/\d{2}'))[1]                      AS date_start,
                              (regexp_match(original_text, '-(\d{1,2}/\d{1,2}/\d{2})'))[1]                   AS date_end,
                              (regexp_match(original_text, '/\d{2}\n(\d{4})'))[1]                            AS time_start,
                              (regexp_match(original_text, '/\d{2}\n\d{4}-(\d{4})'))[1]                      AS time_end,
                              (regexp_match(original_text, 'hrs.\n(\d+ .+(?:Sq.|Plz.|Dr.|Ter.|Rd.))'))[1]    AS street,
                              (regexp_match(original_text, '(?:Sq.|Plz.|Dr.|Ter.|Rd.)\n(\w+ \w+|\w+)\n'))[1] AS city,
                              (regexp_match(original_text, '\n(?:\w+ \w+|\w+)\n(.*):'))[1]                   AS crime_type,
                              (regexp_match(original_text, ':\s(.+)(?:C0|SO)'))[1]                           AS description,
                              (regexp_match(original_text, '(?:C0|SO)[0-9]+'))[1]                            AS case_number
                       FROM text.crime_reports),
     crime_date AS (SELECT crime_id,
                           (crime_matches.date_start || ' ' || crime_matches.time_start ||
                            ' America/New_York')::timestamptz AS date_start,
                           CASE
                               WHEN crime_matches.date_end IS NULL AND crime_matches.time_end IS NOT NULL
                                   THEN (crime_matches.date_start || ' ' || crime_matches.time_end ||
                                         ' America/New_York')::timestamptz
                               WHEN crime_matches.date_end IS NOT NULL AND crime_matches.time_end IS NOT NULL
                                   THEN (crime_matches.date_end || ' ' || crime_matches.time_end ||
                                         ' America/New_York')::timestamptz
                               END                            AS date_end
                    FROM crime_matches)
UPDATE text.crime_reports
SET date_1      = crime_date.date_start,
    date_2      = crime_date.date_end,
    street      = crime_matches.street,
    city        = crime_matches.city,
    crime_type  = crime_matches.crime_type,
    description = crime_matches.description,
    case_number = crime_matches.case_number
FROM crime_matches
         JOIN crime_date ON crime_matches.crime_id = crime_date.crime_id
WHERE crime_matches.crime_id = crime_reports.crime_id;

SELECT date_1, street, city, crime_type
FROM text.crime_reports
ORDER BY crime_id;