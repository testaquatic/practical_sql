BEGIN TRANSACTION;


CREATE TABLE percentile_test(numbers INTEGER);


INSERT INTO percentile_test
VALUES(10),
      (20),
      (30),
      (40),
      (50),
      (60);


COMMIT;


SELECT percentile_cont(.5) WITHIN GROUP (
                                         ORDER BY numbers), percentile_disc(.5) WITHIN GROUP (
                                                                                              ORDER BY numbers)
FROM percentile_test;