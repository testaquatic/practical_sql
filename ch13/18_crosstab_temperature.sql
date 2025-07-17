SELECT *
FROM crosstab('SELECT
    station_name,
    date_part(''month'', observation_date),
    percentile_cont(.5)
      WITHIN GROUP (ORDER BY max_temp)
   FROM temperature_readings
   GROUP BY station_name,
            date_part(''month'', observation_date)
   ORDER BY station_name', 'SELECT month FROM generate_series(1,12) month') AS (station TEXT, jan NUMERIC(3, 0),
                                                                                                  feb NUMERIC(3, 0),
                                                                                                      mar NUMERIC(3, 0),
                                                                                                          apr NUMERIC(3, 0),
                                                                                                              may NUMERIC(3, 0),
                                                                                                                  jun NUMERIC(3, 0),
                                                                                                                      jul NUMERIC(3, 0),
                                                                                                                          aug NUMERIC(3, 0),
                                                                                                                              sep NUMERIC(3, 0),
                                                                                                                                  oct NUMERIC(3, 0),
                                                                                                                                      nov NUMERIC(3, 0), dec NUMERIC(3, 0));