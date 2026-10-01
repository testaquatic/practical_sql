-- 기본
SELECT 2 + 2;
SELECT 9 - 1;
SELECT 3 * 4;
SELECT 11 / 6;
SELECT 11 % 6;

-- numeric 반환
SELECT 11.0 / 6;
SELECT CAST(11 AS NUMERIC(3, 1)) / 6;

-- 지수
SELECT 3 ^ 4;
SELECT |/10;
SELECT sqrt(10);
SELECT ||/10;
SELECT factorial(4);
-- SELECT 4!;

-- 연산의 순서
SELECT 7 + 8 * 9;
SELECT (7 + 8) * 9;
SELECT 3 ^ 3 - 1;
SELECT 3 ^ (3 - 1);