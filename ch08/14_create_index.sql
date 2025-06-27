BEGIN TRANSACTION;
CREATE INDEX street_idx ON new_york_addresses (street);
COMMIT;