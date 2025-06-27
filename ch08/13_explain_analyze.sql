EXPLAIN ANAlYZE
SELECT *
FROM new_york_addresses
WHERE street = 'BROADWAY';

-- Execution Time: 14.064 ms
-- Execution Time: 1.630 ms
 EXPLAIN ANALYZE
SELECT *
FROM new_york_addresses
WHERE street = '52 STREET';

-- Execution Time: 14.742 ms
-- Execution Time: 0.557 ms
 EXPLAIN ANALYZE
SELECT *
FROM new_york_addresses
WHERE street = 'ZWICKY AVENUE';

-- Execution Time: 14.172 ms
-- Execution Time: 0.036 ms