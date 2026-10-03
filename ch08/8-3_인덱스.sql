-- 데이터셋 생성
CREATE SCHEMA new_york;

CREATE TABLE new_york.new_york_addresses
(
    longitude     NUMERIC(9, 6),
    latitude      NUMERIC(9, 6),
    street_number TEXT,
    street        TEXT,
    unit          TEXT,
    postcode      TEXT,
    id            INTEGER
        CONSTRAINT new_york_key PRIMARY KEY
);

COPY new_york.new_york_addresses
    FROM 'city_of_new_york.csv'
    WITH (FORMAT CSV, HEADER );

SELECT *
FROM new_york.new_york_addresses;

-- 실행 게획 - 인덱스 없음
-- 16.4ms
EXPLAIN (ANALYZE)
SELECT *
FROM new_york.new_york_addresses
WHERE street = 'BROADWAY';

-- 16.1ms
EXPLAIN (ANALYZE )
SELECT *
FROM new_york.new_york_addresses
WHERE street = '52 STREET';

-- 15.8ms
EXPLAIN (ANALYZE )
SELECT *
FROM new_york.new_york_addresses
WHERE street = 'ZWICKY AVENUE';

-- 인덱스 생성
CREATE INDEX street_idx ON new_york.new_york_addresses (street);

-- 실행 계획 - 인덱스 생성 후
-- 1.4ms
EXPLAIN (ANALYZE)
SELECT *
FROM new_york.new_york_addresses
WHERE street = 'BROADWAY';

-- 0.54ms
EXPLAIN (ANALYZE )
SELECT *
FROM new_york.new_york_addresses
WHERE street = '52 STREET';

-- 0.038ms
EXPLAIN (ANALYZE )
SELECT *
FROM new_york.new_york_addresses
WHERE street = 'ZWICKY AVENUE';

CREATE TABLE playground.albums
(
    album_id     BIGINT GENERATED ALWAYS AS IDENTITY,
    catalog_code TEXT,
    title        TEXT,
    artist       TEXT,
    release_date DATE,
    genre        TEXT,
    description  TEXT
);

ALTER TABLE playground.albums ADD CONSTRAINT album_id_key PRIMARY KEY (album_id);

CREATE TABLE playground.songs
(
    song_id   BIGINT GENERATED ALWAYS AS IDENTITY,
    title     TEXT,
    composers TEXT,
    album_id  BIGINT REFERENCES playground.albums (album_id)
);

CREATE INDEX ON playground.songs (album_id);