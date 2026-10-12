-- 데이터셋 생성
CREATE schema geo;
CREATE TABLE geo.farmers_markets
(
    fmid        BIGINT PRIMARY KEY,
    market_name TEXT NOT NULL,
    street      TEXT,
    city        TEXT,
    county      TEXT,
    state       TEXT NOT NULL,
    zip         TEXT,
    longitude   NUMERIC(10, 7),
    latitude    NUMERIC(10, 7),
    organic     TEXT NOT NULL
);

COPY geo.farmers_markets
    FROM 'farmers_markets.csv'
    WITH (FORMAT CSV , HEADER );

-- 8681
SELECT count(*)
FROM geo.farmers_markets;

-- geography 열 생성하고 채우기
ALTER TABLE geo.farmers_markets
    ADD COLUMN geog_point geography(POINT, 4326);

UPDATE geo.farmers_markets
SET geog_point = st_setsrid(st_makepoint(farmers_markets.longitude, farmers_markets.latitude)::geography, 4326);

CREATE INDEX market_pts_idx ON geo.farmers_markets USING gist (geog_point);

SELECT longitude, latitude, geog_point, st_asewkt(geog_point)
FROM geo.farmers_markets
WHERE longitude IS NOT NULL
LIMIT 5;

-- 범위 안
SELECT market_name, city, state, geog_point
FROM geo.farmers_markets
WHERE st_dwithin(geog_point, st_geogfromtext('POINT(-93.6204386 41.5853202)'), 10_000)
ORDER BY market_name;

-- 거리
SELECT st_distance(ST_GeogFromText('POINT(-73.9283685 40.8296466)'),
                   ST_GeogFromText('POINT(-73.8480153 40.7570917)')
       ) / 1000 AS mets_to_yanks;

SELECT market_name,
       city,
       round(
               (st_distance(geog_point, st_geogfromtext('POINT(-93.6204386 41.5853202)')) / 1000)::NUMERIC, 2
       ) AS km_from_dt
FROM geo.farmers_markets
WHERE st_dwithin(geog_point, st_geogfromtext('POINT(-93.6204386 41.5853202)'), 10_000)
ORDER BY km_from_dt;

SELECT market_name,
       city,
       state,
       round(st_distance(geog_point, st_geogfromtext('POINT(-68.2041607 44.3876414)'))::NUMERIC / 1000, 2) AS km_from_bh
FROM geo.farmers_markets
ORDER BY geog_point <-> st_geogfromtext('POINT(-68.2041607 44.3876414)')
LIMIT 3;

-- shp
SELECT st_astext(geom)
FROM county_statistics.us_counties_2019_shp
ORDER BY gid
LIMIT 1;

-- 면적 계산
SELECT name, statefp AS st, round((st_area(geom::geography) / 1_000_000)::NUMERIC, 2) as square_km
FROM county_statistics.us_counties_2019_shp
ORDER BY square_km DESC
LIMIT 5;

-- 좌표를 포함하는 카운티 찾기
SELECT sh.name, c.state_name
FROM county_statistics.us_counties_2019_shp sh
         JOIN county_statistics.us_counties_pop_est_2019 c
              ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE st_within(
              'SRID=4269;POINT(-118.3419063 34.0977076)'::geometry, geom
      );

-- 일정 범위 내의 인구
SELECT sum(c.pop_est_2019) AS pop_est_2019
FROM county_statistics.us_counties_2019_shp sh
         JOIN county_statistics.us_counties_pop_est_2019 c
              ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE st_dwithin(sh.geom::geography, st_geogfromtext('SRID=4269;POINT(-96.699656 40.811567)'), 80_000);


SELECT sh.name, c.state_name, c.pop_est_2019, st_transform(sh.geom, 4326) AS geom
FROM county_statistics.us_counties_2019_shp sh
         JOIN county_statistics.us_counties_pop_est_2019 c
              ON sh.statefp = c.state_fips AND sh.countyfp = c.county_fips
WHERE st_dwithin(sh.geom::geography, st_geogfromtext('SRID=4269;POINT(-96.699656 40.811567)'), 80_000);

SELECT *
FROM geo.santafe_roads_2019;
SELECT *
FROM geo.santafe_linearwater_2019;

SELECT st_geometrytype(geom)
FROM geo.santafe_roads_2019
LIMIT 1;

SELECT st_geometrytype(geom)
FROM geo.santafe_linearwater_2019
LIMIT 1;

-- 산타페 강을 지나는 도로 찾기
SELECT water.fullname As waterway, roads.rttyp, roads.fullname AS road
FROM geo.santafe_linearwater_2019 water
         JOIN geo.santafe_roads_2019 roads ON st_intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv'
  AND roads.fullname IS NOT NULL
ORDER BY roads.fullname;

-- 교차 지접 찾기
SELECT water.fullname AS waterway,
       roads.rttyp,
       roads.fullname AS road,
       st_astext(st_intersection(water.geom, roads.geom))
FROM geo.santafe_linearwater_2019 water
         JOIN geo.santafe_roads_2019 roads
              ON st_intersects(water.geom, roads.geom)
WHERE water.fullname = 'Santa Fe Riv'
  AND roads.fullname IS NOT NULL
ORDER BY roads.fullname;

SELECT pop.state_name, sum(round(st_area(shp.geom::geography)::NUMERIC / 1_000_000, 2)) square_km
FROM county_statistics.us_counties_2019_shp shp
         JOIN county_statistics.us_counties_pop_est_2019 as pop
              ON shp.statefp = pop.state_fips AND shp.countyfp = pop.county_fips
GROUP BY pop.state_name
ORDER BY sum(round(st_area(shp.geom::geography)::NUMERIC / 1_000_000, 2)) DESC;

SELECT st_area(geom::geography)
FROM county_statistics.us_counties_2019_shp
WHERE name = 'Yukon-Koyukuk';

SELECT pop.state_name, round(sum(st_area(shp.geom::geography))::NUMERIC / 1_000_000, 2) square_km
FROM county_statistics.us_counties_2019_shp shp
         JOIN county_statistics.us_counties_pop_est_2019 as pop
              ON shp.statefp = pop.state_fips AND shp.countyfp = pop.county_fips
GROUP BY pop.state_name
HAVING sum(st_area(shp.geom::geography)) >
       (SELECT st_area(geom::geography)
        FROM county_statistics.us_counties_2019_shp
        WHERE name = 'Yukon-Koyukuk')
ORDER BY sum(st_area(shp.geom::geography)) DESC;

SELECT round(st_distance(o.geog_point, c.geog_point)::NUMERIC / 1000, 2) distance
FROM (SELECT geog_point::geography
      FROM geo.farmers_markets
      WHERE market_name = 'The Oakleaf Greenmarket') AS o
         JOIN (SELECT geog_point::geography
               FROM geo.farmers_markets
               WHERE market_name = 'Columbia Farmers Market') AS c ON true;

SELECT count(*)
FROM geo.farmers_markets
WHERE county IS NULL;

SELECT county
FROM geo.farmers_markets;


SELECT p.name, m.state, m.market_name
FROM geo.farmers_markets m
         JOIN county_statistics.us_counties_2019_shp p
              ON st_intersects(m.geog_point, st_setsrid(p.geom::geography, 4326))
WHERE m.county IS NULL
ORDER BY m.state, p.name;


SELECT (SELECT shp.countyfp
        FROM new_york.nyc_yellow_taxi_trips t
        WHERE st_intersects(st_setsrid(st_makepoint(t.pickup_longitude, t.pickup_latitude), 4326),
                            st_setsrid(shp.geom, 4326)))
FROM county_statistics.us_counties_2019_shp shp;

SELECT shp.statefp, shp.name, count(*)
FROM new_york.nyc_yellow_taxi_trips t
         JOIN county_statistics.us_counties_2019_shp shp
              ON st_within(
                      st_setsrid(st_makepoint(t.dropoff_longitude, t.dropoff_latitude), 4269)::geometry, shp.geom)
GROUP BY shp.statefp, shp.name
ORDER BY count(*) DESC;