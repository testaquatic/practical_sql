-- 시간을 문자열로
SELECT timestamp_column, CAST(timestamp_column AS varchar(10))
FROM playground.date_time_types;

-- 숫자 변환
SELECT numeric_column,
       CAST(numeric_column AS INTEGER),
       CAST(numeric_column AS TEXT)
FROM playground.number_data_types;

-- 오류!
SELECT CAST(char_column AS INTEGER)
FROM playground.char_data_types;

-- 이중콜론
SELECT timestamp_column, CAST(timestamp_column AS VARCHAR(10))
FROM playground.date_time_types;
SELECT timestamp_column, timestamp_column::VARCHAR(10)
FROM playground.date_time_types;