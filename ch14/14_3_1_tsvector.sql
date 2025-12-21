SELECT to_tsvector('english', 'I am walking across the sitting room to sit with you');

SELECT cfgname FROM pg_ts_config;

SELECT to_tsquery('english', 'walking & sitting');

SELECT to_tsvector('english', 'I am walking across the sitting room') @@ to_tsquery('english', 'walking & sitting');

SELECT to_tsvector('english', 'I am walking across the sitting room') @@ to_tsquery('english', 'walking & running');