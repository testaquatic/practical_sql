SELECT timestamp_column, CAST(timestamp_column AS VARCHAR(10))
FROM date_time_types;

SELECT numeric_column,
	CAST(numeric_column AS INTEGER),
	CAST(numeric_column AS TEXT)
FROM number_data_types;