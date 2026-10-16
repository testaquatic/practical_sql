CREATE TABLE vaccum_test
(
    integer_column INTEGER
);

SELECT pg_size_pretty(
               pg_total_relation_size('vaccum_test')
       );

INSERT INTO vaccum_test
SELECT *
FROM generate_series(1, 500_000);

UPDATE vaccum_test
SET integer_column = integer_column + 1;

SELECT relname, last_vacuum, last_autovacuum, vacuum_count, autovacuum_count
FROM pg_stat_all_tables
WHERE relname = 'vaccum_test';

VACUUM vaccum_test;

VACUUM FULL vaccum_test;

SHOW config_file;