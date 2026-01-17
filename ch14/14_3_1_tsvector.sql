SELECT TO_TSVECTOR('english', 'I am walking across the sitting room to sit with you');

SELECT
    cfgname
FROM
    pg_ts_config;

SELECT TO_TSQUERY('english', 'walking & sitting');

SELECT TO_TSVECTOR('english', 'I am walking across the sitting room') @@ TO_TSQUERY('english', 'walking & sitting');

SELECT TO_TSVECTOR('english', 'I am walking across the sitting room') @@ TO_TSQUERY('english', 'walking & running');