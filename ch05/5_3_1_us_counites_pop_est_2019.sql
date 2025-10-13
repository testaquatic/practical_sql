BEGIN;


CREATE TABLE us_counties_pop_est_2019 (state_fips TEXT, -- 표준 연방 코드
 county_fips TEXT, -- 표준 연방 코드
 region SMALLINT, -- 카운티의 위치 => 1: 북동부, 2: 중서부, 3: 남부, 4: 서부
 state_name TEXT, -- 주 이름
 county_name TEXT, -- 카운티 이름
 area_land BIGINT, -- 토지 넓이
 area_water BIGINT, -- 물의 넓이
 internal_point_lat NUMERIC(10, 7), -- 내점의 위도
 internal_point_lon NUMERIC(10, 7), -- 경도
 pop_est_2018 INTEGER, -- 2018년 7월 1일 기준 인구 추정치
 pop_est_2019 INTEGER, -- 2019년 7월 1일 기준 인구 추정치
 births_2019 INTEGER, -- 2018년 7월 1일부터 2019년 6월 30일 사이 출생자 수
 deaths_2019 INTEGER, -- 사망자수
 international_migr_2019 INTEGER, -- 국제 이주자 수
 domestic_migr_2019 INTEGER, -- 국내 이주자수 수
 residual_2019 INTEGER, -- 일관성을 위해 추정치를 조정하는데 사용되는 숫자
 CONSTRAINT counties_2019_key PRIMARY KEY (state_fips,
                                           county_fips));


SELECT *
FROM us_counties_pop_est_2019;


COMMIT;