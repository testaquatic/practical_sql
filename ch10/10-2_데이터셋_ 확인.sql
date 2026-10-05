-- 같은 주소를 가진 회사
SELECT company, street, city, st, count(*) AS address_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY company, street, city, st
HAVING count(*) > 1
ORDER BY company, street, city, st;

-- 결측값 확인
SELECT st, count(*) AS st_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

SELECT establishment_number,
       company,
       city,
       st,
       zip
FROM fsis.meat_poultry_egg_establishments
WHERE st IS NULL;

-- 회사 이름 리스트
SELECT company, count(*) AS company_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY company
ORDER BY company ASC;

-- 우편번호 형식 오류 찾기
SELECT length(zip), count(*) AS length_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip);

-- 우편번호가 5자리보다 짧게 입력된 주 찾기
SELECT st,
       count(*) AS st_count
FROM fsis.meat_poultry_egg_establishments
WHERE length(zip) < 5
GROUP BY st
ORDER BY st ASC;