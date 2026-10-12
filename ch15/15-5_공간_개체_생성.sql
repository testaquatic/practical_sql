-- geometry 개체 생성
SELECT ST_GeomFromText('POINT(-74.9233606 42.699992)', 4326);
SELECT ST_GeomFromText('LINESTRING(-74.9 42.7, -75.1 42.7)', 4326);
SELECT ST_GeomFromText('POLYGON((-74.9 42.7, -75.1 42.7,
                                 -75.1 42.6, -74.9 42.7))', 4326);
SELECT ST_GeomFromText('MULTIPOINT (-74.9 42.7, -75.1 42.7)', 4326);
SELECT ST_GeomFromText('MULTILINESTRING((-76.27 43.1, -76.06 43.08),
                                        (-76.2 43.3, -76.2 43.4,
                                         -76.4 43.1))', 4326);
SELECT ST_GeomFromText('MULTIPOLYGON((
                                     (-74.92 42.7, -75.06 42.71,
                                      -75.07 42.64, -74.92 42.7),
                                     (-75.0 42.66, -75.0 42.64,
                                      -74.98 42.64, -74.98 42.66,
                                      -75.0 42.66)))', 4326);

-- geography 개체 생성
SELECT ST_GeogFromText('SRID=4326;MULTIPOINT(-74.9 42.7, -75.1 42.7, -74.924 42.6)');

-- 점 생성
SELECT st_pointfromtext('POINT(-74.9233606 42.699992)', 4326);
SELECT st_makepoint(-74.9233606, 42.699992);
SELECT st_setsrid(st_makepoint(-74.9233606, 42.699992), 4326);

-- 선 생성
SELECT st_linefromtext('LINESTRING(-105.90 35.67,-105.91 35.67)', 4326);
SELECT st_makeline(ST_MakePoint(-74.9, 42.7), ST_MakePoint(-74.1, 42.4));

-- 다각형 생성
SELECT st_polygonfromtext('POLYGON((-74.9 42.7, -75.1 42.7,
                                    -75.1 42.6, -74.9 42.7))', 4326);

SELECT ST_MakePolygon(
           ST_GeomFromText('LINESTRING(-74.92 42.7, -75.06 42.71,
                                       -75.07 42.64, -74.92 42.7)', 4326));

SELECT ST_MPolyFromText('MULTIPOLYGON((
                                       (-74.92 42.7, -75.06 42.71,
                                        -75.07 42.64, -74.92 42.7),
                                       (-75.0 42.66, -75.0 42.64,
                                        -74.98 42.64, -74.98 42.66,
                                        -75.0 42.66)
                                      ))', 4326);