SELECT pls18.obereg,
       sum(pls18.visits) AS visits_2018,
       sum(pls17.visits) AS visits_2017,
       sum(pls16.visits) AS visits_2016,
       round((sum(pls18.visits::NUMERIC) - sum(pls17.visits))/ sum(pls17.visits) * 100, 1) AS chg_2018_17,
       round((sum(pls17.visits::NUMERIC) - sum(pls16.visits))/ sum(pls16.visits) * 100, 1) AS chg_2017_16
FROM pls_fy2018_libraries AS pls18
JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0
    AND pls17.visits >= 0
    AND pls16.visits >= 0
GROUP BY pls18.obereg
ORDER BY pls18.obereg;

-- 이곳의 자료를 참고로 했다.
-- https://www.icpsr.umich.edu/web/NADAC/studies/37119/datasets/0001/variables/OBEREG?archive=NADAC
 BEGIN;


CREATE TABLE obe_region_code (obereg TEXT CONSTRAINT obereg_key PRIMARY KEY,
                                                                region TEXT);


INSERT INTO obe_region_code
VALUES ('01', 'New England'),
       ('02', 'Mid East'),
       ('03', 'Great Lakes'),
       ('04', 'Plains'),
       ('05', 'Southeast'),
       ('06', 'Southwest'),
       ('07', 'Rocky Mountains'),
       ('08', 'Far West'),
       ('09', 'Outlying Areas');


SELECT *
FROM obe_region_code;


COMMIT;


SELECT obe.obereg,
       obe.region,
       sum(pls18.visits) AS visits_2018,
       sum(pls17.visits) AS visits_2017,
       sum(pls16.visits) AS visits_2016,
       round((sum(pls18.visits::NUMERIC) - sum(pls17.visits))/ sum(pls17.visits) * 100, 1) AS chg_2018_17,
       round((sum(pls17.visits::NUMERIC) - sum(pls16.visits))/ sum(pls16.visits) * 100, 1) AS chg_2017_16
FROM pls_fy2018_libraries AS pls18
JOIN pls_fy2017_libraries AS pls17 ON pls18.fscskey = pls17.fscskey
JOIN pls_fy2016_libraries AS pls16 ON pls18.fscskey = pls16.fscskey
JOIN obe_region_code AS obe ON pls18.obereg = obe.obereg
WHERE pls18.visits >= 0
    AND pls17.visits >= 0
    AND pls16.visits >= 0
GROUP BY obe.obereg
ORDER BY obe.obereg;