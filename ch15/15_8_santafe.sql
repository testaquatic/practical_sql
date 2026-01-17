SELECT
    COUNT(*)
FROM
    santafe_linearwater_2019;

SELECT
    COUNT(*)
FROM
    santafe_roads_2019;

SELECT
    st_geometrytype(geom)
FROM
    santafe_linearwater_2019
LIMIT 1;

SELECT
    st_geometrytype(geom)
FROM
    santafe_roads_2019
LIMIT 1;

SELECT
    water.fullname AS waterway,
    roads.rttyp,
    roads.fullname AS road
FROM
    santafe_linearwater_2019 AS water
    JOIN santafe_roads_2019 AS roads ON st_intersects(water.geom, roads.geom)
WHERE
    water.fullname = 'Santa Fe Riv'
    AND roads.fullname IS NOT NULL
ORDER BY
    roads.fullname;

SELECT
    water.fullname AS waterway,
    roads.rttyp,
    roads.fullname AS road,
    st_astext(st_intersection(water.geom, roads.geom))
FROM
    santafe_linearwater_2019 water
    JOIN santafe_roads_2019 roads ON st_intersects(water.geom, roads.geom)
WHERE
    water.fullname = 'Santa Fe Riv'
    AND roads.fullname IS NOT NULL
ORDER BY
    roads.fullname;