CREATE OR REPLACE FUNCTION percent_change(
    new_value NUMERIC, old_value NUMERIC, decimal_places INT DEFAULT 1
) RETURNS NUMERIC AS
'SELECT ROUND(((new_value - old_value) / old_value) * 100, decimal_places);' LANGUAGE sql
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;

SELECT percent_change(110, 108, 2);

SELECT
    c2019.county_name,
    c2019.state_name,
    c2019.pop_est_2019                                                                                    AS pop_2019,
    percent_change(c2019.pop_est_2019, c2010.estimates_base_2010)                                         AS pct_chg_func,
    ROUND((c2019.pop_est_2019::NUMERIC - c2010.estimates_base_2010) / c2010.estimates_base_2010 * 100,
          1)                                                                                              AS pct_change_formula
FROM
    us_counties_pop_est_2019 AS c2019
    JOIN us_counties_pop_est_2010 AS c2010
         ON c2019.state_fips = c2010.state_fips AND c2019.county_fips = c2010.county_fips
ORDER BY
    pct_chg_func DESC
LIMIT 5;

START TRANSACTION;

ALTER TABLE teachers
    ADD COLUMN personal_days INTEGER;

SELECT
    first_name,
    last_name,
    hire_date,
    personal_days
FROM
    teachers;

COMMIT;

CREATE OR REPLACE PROCEDURE update_personal_days() AS
$$
BEGIN
    UPDATE teachers
    SET
        personal_days = CASE
                            WHEN (NOW() - hire_date) >= '10 years'::INTERVAL AND (NOW() - hire_date) < '15 years'::INTERVAL
                                THEN 4
                            WHEN (NOW() - hire_date) >= '15 years'::INTERVAL AND (now() - hire_date) < '20 years'::INTERVAL
                                THEN 5
                            WHEN (NOW() - hire_date) >= '20 years'::INTERVAL AND (now() - hire_date) < '25 years'::INTERVAL
                                THEN 6
                            WHEN (NOW() - hire_date) >= '25 years'::INTERVAL THEN  7
                            ELSE 3
                        END;
    RAISE NOTICE 'personal_days updated!';
END;
$$ LANGUAGE plpgsql;

CALL update_personal_days();
