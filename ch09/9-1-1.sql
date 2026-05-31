CREATE TABLE pls_fy2018_libraries (
    stabr     TEXT           NOT NULL,
    fscskey   TEXT
        CONSTRAINT fscskey_2018_pkey PRIMARY KEY,
    libid     TEXT           NOT NULL,
    libname   TEXT           NOT NULL,
    address   TEXT           NOT NULL,
    city      TEXT           NOT NULL,
    zip       TEXT           NOT NULL,
    county    TEXT           NOT NULL,
    phone     TEXT           NOT NULL,
    c_relatn  TEXT           NOT NULL,
    c_legbas  TEXT           NOT NULL,
    c_admin   TEXT           NOT NULL,
    c_fscs    TEXT           NOT NULL,
    geocode   TEXT           NOT NULL,
    lsabound  TEXT           NOT NULL,
    startdate TEXT           NOT NULL,
    enddate   TEXT           NOT NULL,
    popu_lsa  INTEGER        NOT NULL,
    popu_und  INTEGER        NOT NULL,
    centlib   INTEGER        NOT NULL,
    branlib   INTEGER        NOT NULL,
    bkmob     INTEGER        NOT NULL,
    totstaff  NUMERIC(8, 2)  NOT NULL,
    bkvol     INTEGER        NOT NULL,
    ebook     INTEGER        NOT NULL,
    audio_ph  INTEGER        NOT NULL,
    audio_dl  INTEGER        NOT NULL,
    video_ph  INTEGER        NOT NULL,
    video_dl  INTEGER        NOT NULL,
    ec_lo_ot  INTEGER        NOT NULL,
    subscrip  INTEGER        NOT NULL,
    hrs_open  INTEGER        NOT NULL,
    visits    INTEGER        NOT NULL,
    reference INTEGER        NOT NULL,
    regbor    INTEGER        NOT NULL,
    totcir    INTEGER        NOT NULL,
    kidcircl  INTEGER        NOT NULL,
    totpro    INTEGER        NOT NULL,
    gpterms   INTEGER        NOT NULL,
    pitusr    INTEGER        NOT NULL,
    wifisess  INTEGER        NOT NULL,
    obereg    TEXT           NOT NULL,
    statstru  TEXT           NOT NULL,
    statname  TEXT           NOT NULL,
    stataddr  TEXT           NOT NULL,
    longitude NUMERIC(10, 7) NOT NULL,
    latitude  NUMERIC(10, 7) NOT NULL
);

----------- psql
\copy pls_fy2018_libraries FROM './data/pls_fy2018_libraries.csv' WITH (FORMAT CSV, HEADER);
-----------

CREATE INDEX libname_2018_idx ON pls_fy2018_libraries (libname);

CREATE TABLE pls_fy2017_libraries (
    stabr     TEXT           NOT NULL,
    fscskey   TEXT
        CONSTRAINT fscskey_17_pkey PRIMARY KEY,
    libid     TEXT           NOT NULL,
    libname   TEXT           NOT NULL,
    address   TEXT           NOT NULL,
    city      TEXT           NOT NULL,
    zip       TEXT           NOT NULL,
    county    TEXT           NOT NULL,
    phone     TEXT           NOT NULL,
    c_relatn  TEXT           NOT NULL,
    c_legbas  TEXT           NOT NULL,
    c_admin   TEXT           NOT NULL,
    c_fscs    TEXT           NOT NULL,
    geocode   TEXT           NOT NULL,
    lsabound  TEXT           NOT NULL,
    startdate TEXT           NOT NULL,
    enddate   TEXT           NOT NULL,
    popu_lsa  INTEGER        NOT NULL,
    popu_und  INTEGER        NOT NULL,
    centlib   INTEGER        NOT NULL,
    branlib   INTEGER        NOT NULL,
    bkmob     INTEGER        NOT NULL,
    totstaff  NUMERIC(8, 2)  NOT NULL,
    bkvol     INTEGER        NOT NULL,
    ebook     INTEGER        NOT NULL,
    audio_ph  INTEGER        NOT NULL,
    audio_dl  INTEGER        NOT NULL,
    video_ph  INTEGER        NOT NULL,
    video_dl  INTEGER        NOT NULL,
    ec_lo_ot  INTEGER        NOT NULL,
    subscrip  INTEGER        NOT NULL,
    hrs_open  INTEGER        NOT NULL,
    visits    INTEGER        NOT NULL,
    reference INTEGER        NOT NULL,
    regbor    INTEGER        NOT NULL,
    totcir    INTEGER        NOT NULL,
    kidcircl  INTEGER        NOT NULL,
    totpro    INTEGER        NOT NULL,
    gpterms   INTEGER        NOT NULL,
    pitusr    INTEGER        NOT NULL,
    wifisess  INTEGER        NOT NULL,
    obereg    TEXT           NOT NULL,
    statstru  TEXT           NOT NULL,
    statname  TEXT           NOT NULL,
    stataddr  TEXT           NOT NULL,
    longitude NUMERIC(10, 7) NOT NULL,
    latitude  NUMERIC(10, 7) NOT NULL
);

CREATE TABLE pls_fy2016_libraries (
    stabr     TEXT           NOT NULL,
    fscskey   TEXT
        CONSTRAINT fscskey_16_pkey PRIMARY KEY,
    libid     TEXT           NOT NULL,
    libname   TEXT           NOT NULL,
    address   TEXT           NOT NULL,
    city      TEXT           NOT NULL,
    zip       TEXT           NOT NULL,
    county    TEXT           NOT NULL,
    phone     TEXT           NOT NULL,
    c_relatn  TEXT           NOT NULL,
    c_legbas  TEXT           NOT NULL,
    c_admin   TEXT           NOT NULL,
    c_fscs    TEXT           NOT NULL,
    geocode   TEXT           NOT NULL,
    lsabound  TEXT           NOT NULL,
    startdate TEXT           NOT NULL,
    enddate   TEXT           NOT NULL,
    popu_lsa  INTEGER        NOT NULL,
    popu_und  INTEGER        NOT NULL,
    centlib   INTEGER        NOT NULL,
    branlib   INTEGER        NOT NULL,
    bkmob     INTEGER        NOT NULL,
    totstaff  NUMERIC(8, 2)  NOT NULL,
    bkvol     INTEGER        NOT NULL,
    ebook     INTEGER        NOT NULL,
    audio_ph  INTEGER        NOT NULL,
    audio_dl  INTEGER        NOT NULL,
    video_ph  INTEGER        NOT NULL,
    video_dl  INTEGER        NOT NULL,
    ec_lo_ot  INTEGER        NOT NULL,
    subscrip  INTEGER        NOT NULL,
    hrs_open  INTEGER        NOT NULL,
    visits    INTEGER        NOT NULL,
    reference INTEGER        NOT NULL,
    regbor    INTEGER        NOT NULL,
    totcir    INTEGER        NOT NULL,
    kidcircl  INTEGER        NOT NULL,
    totpro    INTEGER        NOT NULL,
    gpterms   INTEGER        NOT NULL,
    pitusr    INTEGER        NOT NULL,
    wifisess  INTEGER        NOT NULL,
    obereg    TEXT           NOT NULL,
    statstru  TEXT           NOT NULL,
    statname  TEXT           NOT NULL,
    stataddr  TEXT           NOT NULL,
    longitude NUMERIC(10, 7) NOT NULL,
    latitude  NUMERIC(10, 7) NOT NULL
);

---------------- psql
\copy pls_fy2017_libraries FROM './data/pls_fy2017_libraries.csv' WITH (FORMAT CSV, HEADER);

\copy pls_fy2016_libraries FROM './data/pls_fy2016_libraries.csv' WITH (FORMAT CSV, HEADER);
----------------

CREATE INDEX libname_2017_idx ON pls_fy2017_libraries (libname);
CREATE INDEX libname_2016_idx ON pls_fy2016_libraries (libname);

SELECT
    COUNT(*)
FROM
    pls_fy2018_libraries;

SELECT
    COUNT(*)
FROM
    pls_fy2017_libraries;

SELECT
    COUNT(*)
FROM
    pls_fy2016_libraries;

SELECT
    COUNT(phone)
FROM
    pls_fy2018_libraries;

SELECT
    COUNT(libname)
FROM
    pls_fy2018_libraries;

SELECT
    COUNT(DISTINCT libname)
FROM
    pls_fy2018_libraries;

SELECT
    MAX(visits),
    MIN(visits)
FROM
    pls_fy2018_libraries;

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
    pls_fy2018_libraries pls18
    JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
WHERE
    pls18.visits >= 0
    AND pls17.visits >= 0
    AND pls16.visits >= 0;

SELECT
    pls18.stabr,
    SUM(pls18.visits)                                                                    AS visits_2018,
    SUM(pls17.visits)                                                                    AS visits_2017,
    SUM(pls16.visits)                                                                    AS visits_2016,
    ROUND((SUM(pls18.visits::NUMERIC) - SUM(pls17.visits)) / SUM(pls17.visits) * 100, 1) AS chg_2018_17,
    ROUND((SUM(pls17.visits::NUMERIC) - SUM(pls16.visits)) / SUM(pls16.visits) * 100, 1) AS chg_2017_16
FROM
    pls_fy2018_libraries pls18
    JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
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
    ROUND((SUM(pls18.visits::NUMERIC) - SUM(pls17.visits)) / SUM(pls17.visits) * 100, 1) AS chg_2018_17,
    ROUND((SUM(pls17.visits::NUMERIC) - SUM(pls16.visits)) / SUM(pls16.visits) * 100, 1) AS chg_2017_16
FROM
    pls_fy2018_libraries pls18
    JOIN pls_fy2017_libraries pls17 ON pls18.fscskey = pls17.fscskey
    JOIN pls_fy2016_libraries pls16 ON pls18.fscskey = pls16.fscskey
GROUP BY
    pls18.stabr
HAVING
    SUM(pls18.visits) > 50_000_000
ORDER BY
    chg_2018_17 DESC;