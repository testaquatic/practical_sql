-- 테이블 백업
CREATE TABLE fsis.meat_poultry_egg_establishments_backup AS
SELECT *
FROM fsis.meat_poultry_egg_establishments;

SELECT (SELECT count(*) FROM fsis.meat_poultry_egg_establishments) AS original,
       (SELECT count(*) FROM fsis.meat_poultry_egg_establishments) AS backup;

-- 열 복사
ALTER TABLE fsis.meat_poultry_egg_establishments
    ADD COLUMN st_copy TEXT;
UPDATE fsis.meat_poultry_egg_establishments
SET st_copy = st;

SELECT st, st_copy
FROM fsis.meat_poultry_egg_establishments
WHERE st IS DISTINCT FROM st_copy
ORDER BY st;

SELECT 'a' <> NULL;

-- 결측값
SELECT st, count(*) AS st_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

-- 누락된 행 업데이트
UPDATE fsis.meat_poultry_egg_establishments
SET st = 'MN'
WHERE establishment_number = 'V18677A';

UPDATE fsis.meat_poultry_egg_establishments
SET st = 'AL'
WHERE establishment_number = 'M45319+P45319';

UPDATE fsis.meat_poultry_egg_establishments
SET st = 'WI'
WHERE establishment_number = 'M263A+P263A+V263A'
RETURNING establishment_number, company, city, st, zip;

-- 결측값 재확인
SELECT st, count(*) AS st_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY st
ORDER BY st;

-- 원래 값 복원하기
UPDATE fsis.meat_poultry_egg_establishments
SET st = st_copy;

UPDATE fsis.meat_poultry_egg_establishments original
SET st = backup.st
FROM fsis.meat_poultry_egg_establishments_backup backup
WHERE original.establishment_number = backup.establishment_number;

-- 일관성이 없는 값
SELECT company, count(*) AS company_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY company
ORDER BY company;

-- 수정
ALTER TABLE fsis.meat_poultry_egg_establishments
    ADD COLUMN company_standard TEXT;
UPDATE fsis.meat_poultry_egg_establishments
SET company_standard = company;

UPDATE fsis.meat_poultry_egg_establishments
SET company_standard = 'Armour-Eckrich Meats'
WHERE company LIKE 'Armour%'
RETURNING company, company_standard;

-- 우편번호 형식 오류 찾기
SELECT length(zip), count(*) AS length_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip);

-- 우편번호 복구
ALTER TABLE fsis.meat_poultry_egg_establishments
    ADD COLUMN zip_copy TEXT;

UPDATE fsis.meat_poultry_egg_establishments
SET zip_copy = zip;

UPDATE fsis.meat_poultry_egg_establishments
SET zip = '00' || zip
WHERE st IN ('PR', 'VI')
  AND length(zip) = 3;

UPDATE fsis.meat_poultry_egg_establishments
SET zip = '0' || zip
WHERE st IN ('CT', 'MA', 'ME', 'NH', 'NJ', 'RI', 'VT')
  AND length(zip) = 4;

SELECT length(zip), count(*) AS length_count
FROM fsis.meat_poultry_egg_establishments
GROUP BY length(zip)
ORDER BY length(zip);

-- 지역정보 테이블 생성
CREATE SCHEMA states;
CREATE TABLE states.obereg_codes
(
    LIKE pop.obereg_codes INCLUDING ALL
);
INSERT INTO states.obereg_codes (SELECT * FROM pop.obereg_codes);
SELECT *
FROM states.obereg_codes so
         FULL JOIN pop.obereg_codes po on so.obereg = po.obereg;

DROP TABLE pop.obereg_codes;

CREATE TABLE states.state_regions
(
    st     TEXT
        CONSTRAINT st_key PRIMARY KEY,
    region TEXT NOT NULL
);

COPY states.state_regions
    FROM 'state_regions.csv'
    WITH (FORMAT CSV , HEADER );

-- 여러 테이블에서 값 업데이트
ALTER TABLE fsis.meat_poultry_egg_establishments
    ADD COLUMN inspection_deadline TIMESTAMP WITH TIME ZONE;

UPDATE fsis.meat_poultry_egg_establishments establishments
SET inspection_deadline = '2022-12-01 00:00 EST'
WHERE EXISTS (SELECT state_regions.region
              FROM states.state_regions
              WHERE establishments.st = state_regions.st
                AND state_regions.region = 'New England');

SELECT st, inspection_deadline
FROM fsis.meat_poultry_egg_establishments
GROUP BY st, inspection_deadline
ORDER BY st;

-- DELETE
DELETE
FROM fsis.meat_poultry_egg_establishments
WHERE st IN ('AS', 'GU', 'MP', 'PR', 'VI');

ALTER TABLE fsis.meat_poultry_egg_establishments
    DROP COLUMN zip_copy;

DROP TABLE fsis.meat_poultry_egg_establishments_backup;

-- 트랜잭션
START TRANSACTION;

UPDATE fsis.meat_poultry_egg_establishments
SET company = 'AGRO Merchantss Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

SELECT company
FROM fsis.meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

ROLLBACK;

SELECT company
FROM fsis.meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

START TRANSACTION;

UPDATE fsis.meat_poultry_egg_establishments
SET company = 'AGRO Merchants Oakland LLC'
WHERE company = 'AGRO Merchants Oakland, LLC';

SELECT company
FROM fsis.meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

COMMIT;

SELECT company
FROM fsis.meat_poultry_egg_establishments
WHERE company LIKE 'AGRO%'
ORDER BY company;

-- 테이블 백업
CREATE TABLE fsis.meat_poultry_egg_establishments_backup AS
SELECT *, '2023-02-14 00:00 EST'::TIMESTAMP WITH TIME ZONE AS reviewed_date
FROM fsis.meat_poultry_egg_establishments;

ALTER TABLE fsis.meat_poultry_egg_establishments
    RENAME TO meat_poultry_egg_establishment_temp;
ALTER TABLE fsis.meat_poultry_egg_establishments_backup
    RENAME TO meat_poultry_egg_establishments;
ALTER TABLE fsis.meat_poultry_egg_establishment_temp
    RENAME TO meat_poultry_egg_establishments_backup;

ALTER TABLE fsis.meat_poultry_egg_establishments
    ADD COLUMN meat_processing BOOLEAN;
ALTER TABLE fsis.meat_poultry_egg_establishments
    ADD COLUMN poultry_processing BOOLEAN;

UPDATE fsis.meat_poultry_egg_establishments
SET meat_processing = TRUE
WHERE activities LIKE '%Meat Processing%';

SELECT activities, meat_processing
FROM fsis.meat_poultry_egg_establishments
WHERE activities LIKE '%Meat Processing%'
GROUP BY activities, meat_processing;

UPDATE fsis.meat_poultry_egg_establishments
SET poultry_processing = TRUE
WHERE activities LIKE '%Poultry Processing%';

SELECT count(*)
FROM fsis.meat_poultry_egg_establishments
WHERE meat_processing
  AND poultry_processing;