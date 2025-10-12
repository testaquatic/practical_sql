SELECT timestamp_column,
       CAST(timestamp_column AS varchar(10))
FROM date_time_types;

SELECT timestamp_column::VARCHAR(10)
FROM date_time_types;



SELECT numeric_column,
       CAST(numeric_column AS integer),
       CAST(numeric_column AS TEXT)
FROM number_data_types;


SELECT CAST(char_column AS integer) FROM char_data_types;