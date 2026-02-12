START TRANSACTION;
CREATE TABLE vacuum_test (
    integer_column INTEGER
);
COMMIT;

SELECT PG_SIZE_PRETTY(PG_TOTAL_RELATION_SIZE('vacuum_test'));

START TRANSACTION;

INSERT INTO vacuum_test
SELECT *
FROM
    GENERATE_SERIES(1, 500_000);

COMMIT;

SELECT PG_SIZE_PRETTY(PG_TOTAL_RELATION_SIZE('vacuum_test'));

START TRANSACTION;

UPDATE vacuum_test
SET
    integer_column = integer_column + 1;

COMMIT;

SELECT PG_SIZE_PRETTY(PG_TOTAL_RELATION_SIZE('vacuum_test'));

SELECT
    relname,
    last_vacuum,
    last_autovacuum,
    vacuum_count,
    autovacuum_count
FROM
    pg_stat_all_tables
WHERE
    relname = 'vacuum_test';

SELECT PG_SIZE_PRETTY(PG_TOTAL_RELATION_SIZE('vacuum_test'));

VACUUM vacuum_test;

SELECT
    relname,
    last_vacuum,
    last_autovacuum,
    vacuum_count,
    autovacuum_count
FROM
    pg_stat_all_tables
WHERE
    relname = 'vacuum_test';

VACUUM FULL vacuum_test;

SELECT PG_SIZE_PRETTY(PG_TOTAL_RELATION_SIZE('vacuum_test'));

SHOW CONFIG_FILE;