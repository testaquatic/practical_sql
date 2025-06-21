BEGIN TRANSACTION;


CREATE TABLE char_data_types (char_column CHAR(10),
                                          varchar_column VARCHAR(10),
                                                         text_column TEXT);


INSERT INTO char_data_types
VALUES ('abc', 'abc', 'abc'),
       ('defghi', 'defghi', 'defghi');


COMMIT;

-- 도커 인스턴스를 사용하니 제대로 실행되지 않는다.
-- [인터넷 검색]( < https://www.google.com/search?q=psql+copy > )을 해보니 psql을 통해서 아래와 같은 방법으로 사용이 가능했다.
-- psql
-- ```
-- \copy char_data_types TO './typetest.txt' WITH (FORMAT CSV, HEADER,DELIMITER '|');
-- ```