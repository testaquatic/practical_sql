BEGIN TRANSACTION;


CREATE TABLE percent_change(department TEXT, spend_2019 NUMERIC(10, 2),
                                                        spend_2022 NUMERIC(10, 2));


INSERT INTO percent_change
VALUES ('Assessor', 178556, 179500),
       ('Building', 250000, 289000),
       ('Clerk', 451980, 650000),
       ('Library', 87777, 90001),
       ('Parks', 250000, 223000),
       ('Water', 199000, 195000);


COMMIT;


SELECT department,
       spend_2019,
       spend_2022,
       ROUND((spend_2022 - spend_2019) / spend_2019 * 100, 1) as pct_change
FROM percent_change;