-- 어휘소
SELECT to_tsvector('english', 'I am walking across the sitting room to sit with you.');

SELECT pg_ts_config.cfgname
FROM pg_ts_config;

SELECT to_tsquery('english', 'walking & sitting');

SELECT to_tsvector('english', 'I am walking across the sitting room to sit with you.') @@
       to_tsquery('english', 'walking & running');

-- 데이터셋 생성
CREATE TABLE text.president_speeches
(
    president          TEXT NOT NULL,
    title              TEXT NOT NULL,
    speech_date        DATE NOT NULL,
    speech_text        TEXT NOT NULL,
    search_speech_text tsvector,
    CONSTRAINT speech_key PRIMARY KEY (president, speech_date)
);

COPY text.president_speeches (president, title, speech_date, speech_text)
    FROM 'president_speeches.csv'
    WITH (FORMAT CSV , DELIMITER '|', HEADER OFF , QUOTE '@');

SELECT *
FROM text.president_speeches;

UPDATE text.president_speeches
SET search_speech_text = to_tsvector('english', president_speeches.speech_text);

CREATE INDEX search_idx ON text.president_speeches USING gin (search_speech_text);

-- 텍스트 검색
SELECT president, speech_date
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'Vietnam')
ORDER BY speech_date;

SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'tax'),
                   'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'tax')
ORDER BY speech_date;

SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'transportation & !roads'),
                   'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'transportation & !roads')
ORDER BY speech_date;

SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'military <-> defense'),
                   'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'military <-> defense')
ORDER BY speech_date;



SELECT president,
       speech_date,
       ts_headline(speech_text, to_tsquery('english', 'military <2> defense'),
                   'StartSel = <, StopSel = >, MinWords = 5, MaxWords = 7, MaxFragments = 1')
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'military <2> defense')
ORDER BY speech_date;

SELECT president,
       speech_date,
       ts_rank(search_speech_text, to_tsquery('english', 'war & security & threat & enemy')) AS score
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;

SELECT president,
       speech_date,
       ts_rank(search_speech_text, to_tsquery('english', 'war & security & threat & enemy'), 2)::NUMERIC as score
FROM text.president_speeches
WHERE search_speech_text @@ to_tsquery('english', 'war & security & threat & enemy')
ORDER BY score DESC
LIMIT 5;