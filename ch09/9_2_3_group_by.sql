SELECT
    stabr
FROM
    pls_fy2018_libraries
GROUP BY
    stabr
ORDER BY
    stabr;

SELECT
    city,
    stabr
FROM
    pls_fy2018_libraries
GROUP BY
    city, stabr
ORDER BY
    city, stabr;

SELECT
    stabr,
    COUNT(*)
FROM
    pls_fy2018_libraries
GROUP BY
    stabr
ORDER BY
    COUNT(*) DESC;

SELECT
    stabr,
    stataddr,
    COUNT(*)
FROM
    pls_fy2018_libraries
GROUP BY
    stabr, stataddr
ORDER BY
    stabr, stataddr;

SELECT
    SUM(visits) AS visits_2018
FROM
    pls_fy2018_libraries
WHERE
    visits >= 0;

SELECT
    SUM(visits) AS visits_2017
FROM
    pls_fy2017_libraries
WHERE
    visits >= 0;

SELECT
    SUM(visits) AS visits_2016
FROM
    pls_fy2016_libraries
WHERE
    visits >= 0;

SELECT
    SUM(pls18.visits) AS visits_2018,
    SUM(pls17.visits) AS visits_2017,
    SUM(pls16.visits) AS visits_2016
FROM
    pls_fy2018_libraries AS pls18
    JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
    pls18.visits >= 0
    AND pls17.visits >= 0
    AND pls16.visits >= 0;

SELECT
    SUM(pls18.wifisess) AS wifi_2018,
    SUM(pls17.wifisess) AS wifi_2017,
    SUM(pls16.wifisess) AS wifi_2016
FROM
    pls_fy2018_libraries AS pls18
    JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
    pls18.wifisess >= 0
    AND pls17.wifisess >= 0
    AND pls16.wifisess >= 0;

SELECT
    pls18.stabr,
    SUM(pls18.visits)                                                                    AS visits_2018,
    SUM(pls17.visits)                                                                    AS visits_2017,
    SUM(pls16.visits)                                                                    AS visits_2016,
    ROUND((SUM(pls18.visits::NUMERIC) - SUM(pls17.visits)) / SUM(pls17.visits) * 100, 1) AS chg_2018_17,
    ROUND((SUM(pls17.visits::NUMERIC) - SUM(pls16.visits)) / SUM(pls16.visits) * 100, 1) AS chg_2017_16
FROM
    pls_fy2018_libraries AS pls18
    JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
    pls18.visits >= 0
    AND pls17.visits >= 0
    AND pls16.visits >= 0
GROUP BY
    pls18.stabr
ORDER BY
    chg_2018_17 DESC;

SELECT
    pls18.stabr,
    SUM(pls18.visits)                                                                    AS visits_2018,
    SUM(pls17.visits)                                                                    AS visits_2017,
    SUM(pls16.visits)                                                                    AS visits_2016,
    ROUND((SUM(pls18.visits::NUMERIC) - SUM(pls17.visits)) / SUM(pls17.visits) * 100, 1) AS pct_change_2018_17,
    ROUND((SUM(pls17.visits::NUMERIC) - SUM(pls16.visits)) / SUM(pls16.visits) * 100, 1) AS pct_change_2017_16
FROM
    pls_fy2018_libraries AS pls18
    JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE
    pls18.visits >= 0
    AND pls17.visits >= 0
    AND pls16.visits >= 0
GROUP BY
    pls18.stabr
HAVING
    SUM(pls18.visits) > 50_000_000
ORDER BY
    pct_change_2018_17 DESC;