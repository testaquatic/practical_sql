-- 타입의 정의
CREATE TABLE playground.number_data_types
(
    numeric_column NUMERIC(20, 5),
    real_column    REAL,
    double_column  DOUBLE PRECISION
);

-- 데이터 삽입
INSERT INTO playground.number_data_types
VALUES (.7, .7, .7),
       (2.13579, 2.13579, 2.13579),
       (2.1357987654, 2.1357987654, 2.1357987654);

-- 유효숫자 확인
SELECT *
FROM playground.number_data_types;

-- 부동 소숫점의 오차
SELECT numeric_column * 10_000_000 AS fixed,
       real_column * 10_000_000    AS floating
FROM playground.number_data_types
WHERE numeric_column = .7;