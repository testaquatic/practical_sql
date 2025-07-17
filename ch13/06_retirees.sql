BEGIN;


CREATE TABLE retirees (id INT, first_name TEXT, last_name TEXT);


INSERT INTO retirees
VALUES (2, 'Janet', 'King'),
       (4, 'Michael', 'Taylor');


SELECT *
FROM retirees;


COMMIT;