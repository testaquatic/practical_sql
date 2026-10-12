-- 확장 사용
CREATE EXTENSION postgis;

SELECT postgis_full_version();

SELECT srtext
FROM spatial_ref_sys
WHERE srid = 4326