SELECT county_name,
       state_fips,
       county_fips,
       pop_est_2019
FROM county_statistics.us_counties_pop_est_2019
WHERE state_name = 'Nevada';

CREATE OR REPLACE VIEW county_statistics.nevada_counties_pop_2019 AS
SELECT county_name,
       state_fips,
       county_fips,
       pop_est_2019
FROM county_statistics.us_counties_pop_est_2019
WHERE state_name = 'Nevada';

SELECT *
FROM county_statistics.nevada_counties_pop_2019
ORDER BY county_fips
LIMIT 5;

SELECT c2019.county_name,
       c2019.state_name,
       c2019.state_fips,
       c2019.county_fips,
       c2019.pop_est_2019        AS pop_2019,
       c2010.estimates_base_2010 AS pop_2010,
       round(
               (c2019.pop_est_2019 - c2010.estimates_base_2010)::NUMERIC / c2010.estimates_base_2010 * 100, 1
       )                         AS pct_change_2019_2010
FROM county_statistics.us_counties_pop_est_2019 c2019
         JOIN county_statistics.us_counties_pop_est_2010 c2010
              ON c2019.state_fips = c2010.state_fips AND c2019.county_fips = c2010.county_fips;

CREATE OR REPLACE VIEW county_statistics.county_pop_change_2019_2010 AS
SELECT c2019.county_name,
       c2019.state_name,
       c2019.state_fips,
       c2019.county_fips,
       c2019.pop_est_2019        AS pop_2019,
       c2010.estimates_base_2010 AS pop_2010,
       round(
               (c2019.pop_est_2019 - c2010.estimates_base_2010)::NUMERIC / c2010.estimates_base_2010 * 100, 1
       )                         AS pct_change_2019_2010
FROM county_statistics.us_counties_pop_est_2019 c2019
         JOIN county_statistics.us_counties_pop_est_2010 c2010
              ON c2019.state_fips = c2010.state_fips AND c2019.county_fips = c2010.county_fips;

SELECT county_name,
       state_name,
       pop_2019,
       pct_change_2019_2010
FROM county_statistics.county_pop_change_2019_2010
WHERE state_name = 'Nevada'
ORDER BY county_fips
LIMIT 5;

DROP VIEW county_statistics.nevada_counties_pop_2019;

CREATE MATERIALIZED VIEW county_statistics.nevada_counties_pop_2019 AS
SELECT county_name,
       state_fips,
       county_fips,
       pop_est_2019
FROM county_statistics.us_counties_pop_est_2019
WHERE state_name = 'Nevada';

REFRESH MATERIALIZED VIEW county_statistics.nevada_counties_pop_2019;

SELECT *
FROM playground.employees
ORDER BY emp_id;

CREATE OR REPLACE VIEW playground.employee_tax_dept WITH (security_barrier) AS
SELECT emp_id, first_name, last_name, dep_id
FROM playground.employees
WHERE dep_id = 1
WITH LOCAL CHECK OPTION;

SELECT *
FROM playground.employee_tax_dept
ORDER BY emp_id;

INSERT INTO playground.employee_tax_dept (emp_id, first_name, last_name, dep_id)
VALUES (5, 'Suzanne', 'Legere', 1);

-- 실패
INSERT INTO playground.employee_tax_dept (emp_id, first_name, last_name, dep_id)
VALUES (6, 'Jamil', 'White', 2);

SELECT *
FROM playground.employee_tax_dept
ORDER BY emp_id;

SELECT *
FROM playground.employees
ORDER BY emp_id;

UPDATE playground.employee_tax_dept
SET last_name = 'Le Gere'
WHERE emp_id = 5;

SELECT * FROM playground.employee_tax_dept ORDER BY emp_id;

DELETE FROM playground.employee_tax_dept
WHERE emp_id = 5;