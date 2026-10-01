-- 테이블 조회
SELECT county_name             AS county,
       state_name              AS state,
       pop_est_2019            AS pop,
       births_2019             AS births,
       deaths_2019             AS deaths,
       international_migr_2019 AS int_migr,
       domestic_migr_2019      AS dom_migr,
       residual_2019           AS residual
FROM pop.us_counties_pop_est_2019;

-- 두 열의 차
SELECT county_name               AS county,
       state_name                AS state,
       births_2019               AS births,
       deaths_2019               AS deaths,
       births_2019 - deaths_2019 AS natural_increase
FROM pop.us_counties_pop_est_2019
ORDER BY state_name, county_name;

-- 데이터셋 검사
SELECT county_name                    AS county,
       state_name                     AS state,
       pop_est_2019                   AS pop,
       pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 +
       residual_2019                  AS components_total,
       pop_est_2019 - (pop_est_2018 + births_2019 - deaths_2019 + international_migr_2019 + domestic_migr_2019 +
                       residual_2019) AS difference
FROM pop.us_counties_pop_est_2019
ORDER BY difference DESC;

-- 백분율 구하기
SELECT county_name                                          AS county,
       state_name                                           AS state,
       area_water::NUMERIC / (area_land + area_water) * 100 AS pct_water
FROM pop.us_counties_pop_est_2019
ORDER BY pct_water DESC;