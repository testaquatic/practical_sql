BEGIN TRANSACTION;


INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'Gem', 'Godfrey');


COMMIT;

BEGIN TRANSACTION;


INSERT INTO natural_key_example (license_id, first_name, last_name)
VALUES ('T229901', 'John', 'Mitchell');


ROLLBACK;