SELECT stabr,
       count(*)
FROM pls_fy2018_libraries
GROUP BY stabr
ORDER BY count(*) DESC;