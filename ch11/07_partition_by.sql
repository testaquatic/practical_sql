BEGIN;


CREATE TABLE store_sales(store TEXT NOT NULL,
                                    category TEXT NOT NULL,
                                                  unit_sales INTEGER NOT NULL,
                                                                     CONSTRAINT store_category_key PRIMARY KEY (store,
                                                                                                                category));


INSERT INTO store_sales (store, category, unit_sales)
VALUES ('Broders', 'Cereal', 1104),
       ('Wallace', 'Ice Cream', 1863),
       ('Broders', 'Ice Cream', 2517),
       ('Cramers', 'Ice Cream', 2112),
       ('Broders', 'Beer', 641),
       ('Cramers', 'Cereal', 1003),
       ('Cramers', 'Beer', 640),
       ('Wallace', 'Cereal', 980),
       ('Wallace', 'Beer', 988);


SELECT category,
       store,
       unit_sales,
       rank() OVER (PARTITION BY category
                    ORDER BY unit_sales DESC)
FROM store_sales;


COMMIT;