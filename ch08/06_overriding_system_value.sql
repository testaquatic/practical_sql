BEGIN TRANSACTION;


INSERT INTO surrogate_key_example OVERRIDING SYSTEM VALUE
VALUES (4, 'Chicken Coop', '2021-09-03 10:33-07');


ALTER TABLE surrogate_key_example
ALTER COLUMN order_number RESTART WITH 5;


INSERT INTO surrogate_key_example (product_name, order_time)
VALUES ('Aloe Plant', '2020-03-15 10:09-07');


COMMIT;

SELECT * FROM surrogate_key_example;