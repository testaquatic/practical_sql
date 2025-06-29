SELECT sum(visits) AS visits_2018
FROM pls_fy2018_libraries
WHERE visits >= 0;


SELECT sum(visits) AS visits_2017
FROM pls_fy2017_libraries
WHERE visits >= 0;


SELECT sum(visits) AS visits_2016
FROM pls_fy2016_libraries
WHERE visits >= 0;
