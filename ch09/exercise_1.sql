SELECT pls18.stabr,
       sum(pls18.totstaff) AS totstaff_18,
       sum(pls17.totstaff) AS totstaff_17,
       sum(pls16.totstaff) AS totstaff_16,
       round((sum(pls18.totstaff::NUMERIC) - sum(pls17.totstaff))/ sum(pls17.totstaff) * 100, 1) AS chg_2018_17,
       round((sum(pls17.totstaff::NUMERIC) - sum(pls16.totstaff))/ sum(pls16.totstaff) * 100, 1) AS chg_2017_16
FROM pls_fy2018_libraries AS pls18
JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0
    AND pls18.totstaff >= 0
    AND pls17.totstaff >= 0
    AND pls16.totstaff >= 0
GROUP BY pls18.stabr
ORDER BY chg_2018_17 DESC;


SELECT pls18.stabr,
       sum(pls18.totstaff) AS totstaff_18,
       sum(pls17.totstaff) AS totstaff_17,
       sum(pls16.totstaff) AS totstaff_16,
       sum(pls18.visits) AS visits_18,
       round((sum(pls18.totstaff::NUMERIC) - sum(pls17.totstaff))/ sum(pls17.totstaff) * 100, 1) AS chg_2018_17,
       round((sum(pls17.totstaff::NUMERIC) - sum(pls16.totstaff))/ sum(pls16.totstaff) * 100, 1) AS chg_2017_16
FROM pls_fy2018_libraries AS pls18
JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.totstaff >= 0
    AND pls17.totstaff >= 0
    AND pls16.totstaff >= 0
    AND pls18.visits >= 0
GROUP BY pls18.stabr
HAVING sum(pls18.visits) > 50000000
ORDER BY chg_2018_17 DESC;