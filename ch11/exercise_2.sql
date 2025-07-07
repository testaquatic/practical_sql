\copy
    (SELECT year,
            month,
            soybeans_export_value,
            sum(soybeans_export_value) OVER(
                                            ORDER BY year, month ROWS BETWEEN 11 PRECEDING AND CURRENT ROW) AS sum_last_12_months
     FROM us_exports
     ORDER BY year,
              month) TO './data/beans.csv' WITH (FORMAT CSV,
                                                 HEADER);