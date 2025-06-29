SELECT
    sum(pls18.visits) AS visits_2018,
    sum(pls17.visits) AS visits_2017,
    sum(pls16.visits) AS visits_2016
FROM pls_fy2018_libraries AS pls18
JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0 AND pls17.visits >= 0 AND pls16.visits >= 0;