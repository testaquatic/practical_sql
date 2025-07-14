SELECT segment,
       arrival - departure AS segment_duration,
       justify_interval(sum(arrival - departure) OVER (
                                                       ORDER BY trip_id)) AS cume_duration
FROM train_rides;