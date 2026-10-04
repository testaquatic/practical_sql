SELECT count(*)
FROM libraries.pls_fy2018_libraries;

SELECT count(*)
FROM libraries.pls_fy2017_libraries;

SELECT count(*)
FROM libraries.pls_fy2016_libraries;

-- NULL이 아닌 개수 세기
SELECT count(phone)
FROM libraries.pls_fy2018_libraries;

SELECT count(libname)
FROM libraries.pls_fy2018_libraries;

-- 중복 제외
SELECT count(DISTINCT libname)
FROM libraries.pls_fy2018_libraries;

-- 최대, 최소
SELECT max(visits), min(visits)
FROM libraries.pls_fy2018_libraries;

-- GROUP BY
SELECT stabr
FROM libraries.pls_fy2018_libraries
GROUP BY stabr
ORDER BY stabr;

-- 복합
SELECT city, stabr
FROM libraries.pls_fy2018_libraries
GROUP BY city, stabr
ORDER BY city, stabr;

-- 집계 합수
SELECT stabr, count(*)
FROM libraries.pls_fy2018_libraries
GROUP BY stabr
ORDER BY count(*) DESC;

-- 복합
SELECT stabr, stataddr, count(*)
FROM libraries.pls_fy2018_libraries
GROUP BY stabr, stataddr
ORDER BY stabr, stataddr;

SELECT sum(visits) AS visits_2018
FROM libraries.pls_fy2018_libraries
WHERE visits >= 0;

SELECT sum(visits) AS visits_2017
FROM libraries.pls_fy2017_libraries
WHERE visits >= 0;

SELECT sum(visits) AS visits_2016
FROM libraries.pls_fy2016_libraries
WHERE visits >= 0;

-- 방문자수 변화
SELECT sum(pls18.visits) AS vitits_2018,
       sum(pls17.visits) AS visits_2017,
       sum(pls16.visits) AS visits_2016
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17
              ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16
              ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0
  AND pls17.visits >= 0
  AND pls16.visits >= 0;

-- 와이파이
SELECT sum(pls18.wifisess) AS wifi_2018,
       sum(pls17.wifisess) AS wifi_2017,
       sum(pls16.wifisess) AS wifi_2016
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17
              ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16
              ON pls18.fscskey = pls16.fscskey
WHERE pls18.wifisess >= 0
  AND pls17.wifisess >= 0
  AND pls16.wifisess >= 0;

-- 주별 방문자수
SELECT pls18.stabr,
       sum(pls18.visits)                                                                    AS visits_2018,
       sum(pls17.visits)                                                                    AS visits_2017,
       sum(pls16.visits)                                                                    AS visits_2016,
       round((sum(pls18.visits)::NUMERIC - sum(pls17.visits)) / sum(pls17.visits) * 100, 1) AS chg_2018_17,
       round((sum(pls17.visits) - sum(pls16.visits)::NUMERIC) / sum(pls16.visits) * 100, 1) AS chg_2017_16
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0
  AND pls17.visits >= 0
  AND pls16.visits >= 0
GROUP BY pls18.stabr
ORDER BY chg_2018_17 DESC;

-- HAVING
SELECT pls18.stabr,
       sum(pls18.visits)                                                                    AS visits_2018,
       sum(pls17.visits)                                                                    AS visits_2017,
       sum(pls16.visits)                                                                    AS visits_2016,
       round((sum(pls18.visits)::NUMERIC - sum(pls17.visits)) / sum(pls17.visits) * 100, 1) AS chg_2018_17,
       round((sum(pls17.visits) - sum(pls16.visits)::NUMERIC) / sum(pls16.visits) * 100, 1) AS chg_2017_16
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.visits >= 0
  AND pls17.visits >= 0
  AND pls16.visits >= 0
GROUP BY pls18.stabr
HAVING sum(pls18.visits) > 50_000_000
ORDER BY chg_2018_17 DESC;

SELECT pls18.stabr,
       sum(pls18.totstaff)                                                                 AS staff_2018,
       sum(pls17.totstaff)                                                                 AS staff_2017,
       sum(pls16.totstaff)                                                                 AS staff_2016,
       round(sum(pls18.totstaff - pls17.totstaff)::NUMERIC / sum(pls17.totstaff) * 100, 1) AS chg_2018_17,
       round(sum(pls17.totstaff - pls16.totstaff)::NUMERIC / sum(pls16.totstaff) * 100, 1) AS chg_2017_16
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17
              ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16
              ON pls18.fscskey = pls16.fscskey
WHERE pls18.totstaff >= 0
  AND pls17.totstaff >= 0
  AND pls16.totstaff >= 0
GROUP BY pls18.stabr
ORDER BY chg_2018_17 DESC;


SELECT pls18.stabr,
       sum(pls18.visits)                                                                   AS visits_2018,
       sum(pls18.totstaff)                                                                 AS staff_2018,
       sum(pls17.totstaff)                                                                 AS staff_2017,
       sum(pls16.totstaff)                                                                 AS staff_2016,
       round(sum(pls18.totstaff - pls17.totstaff)::NUMERIC / sum(pls17.totstaff) * 100, 1) AS chg_2018_17,
       round(sum(pls17.totstaff - pls16.totstaff)::NUMERIC / sum(pls16.totstaff) * 100, 1) AS chg_2017_16
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17
              ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16
              ON pls18.fscskey = pls16.fscskey
WHERE pls18.totstaff >= 0
  AND pls17.totstaff >= 0
  AND pls16.totstaff >= 0
  AND pls18.visits >= 0
GROUP BY pls18.stabr
HAVING sum(pls18.visits) >= 50_000_000
ORDER BY chg_2018_17 DESC;


CREATE TABLE pop.obereg_codes
(
    obereg text
        CONSTRAINT obereg_key PRIMARY KEY,
    region text
);

INSERT INTO pop.obereg_codes
VALUES ('01', 'New England (CT ME MA NH RI VT)'),
       ('02', 'Mid East (DE DC MD NJ NY PA)'),
       ('03', 'Great Lakes (IL IN MI OH WI)'),
       ('04', 'Plains (IA KS MN MO NE ND SD)'),
       ('05', 'Southeast (AL AR FL GA KY LA MS NC SC TN VA WV)'),
       ('06', 'Soutwest (AZ NM OK TX)'),
       ('07', 'Rocky Mountains (CO ID MT UT WY)'),
       ('08', 'Far West (AK CA HI NV OR WA)'),
       ('09', 'Outlying Areas (AS GU MP PR VI)');

SELECT obereg_codes.obereg,
       obereg_codes.region,
       sum(pls18.visits)                                                             visits_2018,
       sum(pls17.visits)                                                             visits_2017,
       sum(pls16.visits)                                                             visits_2016,
       round(sum(pls18.visits - pls17.visits)::NUMERIC / sum(pls17.visits) * 100, 1) chg_2018_17,
       round(sum(pls17.visits - pls16.visits)::NUMERIC / sum(pls16.visits) * 100, 1) chg_2017_16
FROM libraries.pls_fy2018_libraries pls18
         JOIN libraries.pls_fy2017_libraries pls17
              ON pls18.fscskey = pls17.fscskey
         JOIN libraries.pls_fy2016_libraries pls16
              ON pls18.fscskey = pls16.fscskey
         JOIN pop.obereg_codes
              ON pls18.obereg = pop.obereg_codes.obereg
WHERE pls18.visits >= 0
  AND pls17.visits >= 0
  AND pls16.visits >= 0
GROUP BY obereg_codes.obereg
ORDER BY obereg_codes.obereg;


SELECT pls18.fscskey, pls17.fscskey, pls16.fscskey
FROM libraries.pls_fy2018_libraries pls18
         FULL JOIN libraries.pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
         FULL JOIN libraries.pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE pls18.fscskey IS NULL || pls17.fscskey IS NULL || pls16.fscskey IS NULL;