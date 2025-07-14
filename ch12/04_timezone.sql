SHOW timezone;


SELECT current_setting('timezone');

SHOW ALL;


SELECT make_timestamptz(2022, 2, 22, 18, 4, 30.3, current_setting('timezone'));

SELECT * FROM pg_timezone_abbrevs ORDER BY abbrev;
SELECT * FROM pg_timezone_names ORDER BY name;


SELECT * FROM pg_timezone_names WHERE name LIKE 'Europe%' ORDER BY name;