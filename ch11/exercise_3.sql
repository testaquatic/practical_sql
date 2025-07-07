SELECT rank() OVER (
                    ORDER BY popu_lsa DESC),
       stabr,
       county,
       city,
       libname,
       popu_lsa,
       visits
FROM pls_fy2018_libraries lib18
WHERE visits >= 250000
ORDER BY popu_lsa DESC;