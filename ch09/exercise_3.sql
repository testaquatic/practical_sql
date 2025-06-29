SELECT pls_18.stabr,
       pls_18.fscskey AS fscskey_18,
       pls_17.fscskey AS fscskey_17,
       pls_16.fscskey AS fscskey_16
FROM pls_fy2018_libraries AS pls_18
FULL OUTER JOIN pls_fy2017_libraries AS pls_17 ON pls_17.fscskey = pls_18.fscskey
FULL OUTER JOIN pls_fy2016_libraries AS pls_16 ON pls_16.fscskey = pls_18.fscskey
WHERE pls_18.fscskey IS NULL
    OR pls_17.fscskey IS NULL
    OR pls_16.fscskey IS NULL;