-- 함수 생성
CREATE OR REPLACE FUNCTION
    percent_change(new_value NUMERIC, old_value NUMERIC, decimal_places INTEGER DEFAULT 1)
    RETURNS NUMERIC AS
'SELECT round(((new_value - old_value) / old_value) * 100, decimal_places);'
    LANGUAGE sql
    IMMUTABLE
    RETURNS NULL ON NULL INPUT;

SELECT percent_change(110, 108, 2);

SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019                                            AS pop_2019,
       percent_change(c2019.pop_est_2019, c2010.estimates_base_2010) AS pct_chg_func,
       round((c2019.pop_est_2019 - c2010.estimates_base_2010)::NUMERIC / c2010.estimates_base_2010 * 100,
             1)                                                      AS pct_chg_formula
FROM county_statistics.us_counties_pop_est_2019 AS c2019
         JOIN county_statistics.us_counties_pop_est_2010 AS c2010
              ON c2019.state_fips = c2010.state_fips
                  AND c2019.county_fips = c2010.county_fips
ORDER BY pct_chg_func DESC
LIMIT 5;

-- 프로시저
ALTER TABLE playground.teachers
    ADD COLUMN personal_days integer;

SELECT first_name, last_name, hire_date, personal_days
FROM playground.teachers;

CREATE OR REPLACE PROCEDURE playground.update_personal_days()
AS
$$
BEGIN
    UPDATE playground.teachers
    SET personal_days = CASE
                            WHEN (now() - hire_date) >= '10 years'::interval
                                AND (now() - hire_date) < '15 years'::interval THEN 4
                            WHEN (now() - hire_date) >= '15 years'::interval
                                AND (now() - hire_date) < '20 years'::interval THEN 5
                            WHEN (now() - hire_date) >= '20 years'::interval AND (now() - hire_date) < '25 years'::interval
                                THEN 6
                            WHEN (now() - hire_date) >= '25 years'::interval THEN 7
                            ELSE 3
        END;
    RAISE NOTICE 'personal_days_updated!';
END;
$$
LANGUAGE plpgsql;

CALL playground.update_personal_days();