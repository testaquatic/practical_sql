-- psql
BEGIN;


CREATE TABLE IF NOT EXISTS ice_cream_survey (response_id INT PRIMARY KEY,
                                                             office TEXT, flavor TEXT);

\copy ice_cream_survey
FROM './data/ice_cream_survey.csv' WITH (FORMAT CSV,
                                         HEADER);


COMMIT;