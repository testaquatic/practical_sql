BEGIN TRANSACTION;

CREATE TABLE surrogate_key_example(
    order_number BIGINT GENERATED ALWAYS AS IDENTITY,
    product_name TEXT,
    order_time TIMESTAMP WITH TIME ZONE,
    CONSTRAINT order_number_key PRIMARY KEY (order_number)
);

INSERT INTO surrogate_key_example (product_name, order_time)
VALUES
    ('Beachball Polish', '2020-03-15 09:21-07'),
       ('Wrinkle De-Atomizer', '2017-05-22 14:00-07'),
       ('Flux Capacitor', '1985-10-26 01:18:00-07');

SELECT * FROM surrogate_key_example;


COMMIT;