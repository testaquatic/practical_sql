BEGIN TRANSACTION;

INSERT INTO surrogate_key_example
VALUES (4, 'insert name', now());

ROLLBACK;