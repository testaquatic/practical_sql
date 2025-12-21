START TRANSACTION;

CREATE TABLE president_speeches (
    president          TEXT NOT NULL,
    title              TEXT NOT NULL,
    speech_date        DATE NOT NULL,
    speech_text        TEXT NOT NULL,
    search_speech_text tsvector,
    CONSTRAINT speech_key PRIMARY KEY (president, speech_date)
);

COMMIT;


-- psql
START TRANSACTION;
\copy president_speeches (president, title, speech_date, speech_text) FROM 'data\president_speeches.csv' WITH (FORMAT CSV, DELIMITER '|', HEADER OFF, QUOTE '@');
SELECT *
FROM
    president_speeches;
COMMIT;
--

SELECT *
FROM
    president_speeches;


UPDATE president_speeches
SET
    search_speech_text = TO_TSVECTOR('english', speech_text);

START TRANSACTION;
CREATE INDEX search_idx ON president_speeches USING gin (search_speech_text);
COMMIT;

SELECT
    president,
    speech_date
FROM
    president_speeches
WHERE
    search_speech_text @@ TO_TSQUERY('english', 'Vietnam')
ORDER BY
    speech_date;

SELECT
    president,
    speech_date,
    TS_HEADLINE(speech_text, TO_TSQUERY('english', 'tax'),
                'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM
    president_speeches
WHERE
    search_speech_text @@ TO_TSQUERY('english', 'tax')
ORDER BY
    speech_date;

SELECT
    president,
    speech_date,
    TS_HEADLINE(speech_text, TO_TSQUERY('transportation & !roads'),
                'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM
    president_speeches
WHERE
    search_speech_text @@ TO_TSQUERY('english', 'transportation & !roads')
ORDER BY
    speech_date;

SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'military <-> defense'), 'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'military <-> defense')
ORDER BY speech_date;

SELECT president,
       speech_date,
       ts_rank(search_speech_text, to_tsquery('english', 'war & security & threat & enemy'), 2)::NUMERIC AS score
FROM president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;