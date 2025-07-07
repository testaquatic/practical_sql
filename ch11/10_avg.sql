-- psql
BEGIN;


CREATE TABLE us_exports (year SMALLINT, month SMALLINT, citrus_export_value BIGINT, soybeans_export_value BIGINT);

\copy us_exports
FROM './data/us_exports.csv' WITH (FORMAT CSV,
                                   HEADER);


SELECT *
FROM us_exports
ORDER BY year,
         month;


COMMIT;


SELECT year,
       month,
       citrus_export_value
FROM us_exports
ORDER BY year,
         month;


SELECT year,
       month,
       citrus_export_value,
       round(avg(citrus_export_value) OVER(
                                           ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW), 0)
FROM us_exports
ORDER BY year,
         month;

