-- 중첩
SELECT char_length(trim('  Pat   '));

-- 정규 표현식
SELECT substring('The game starts at 7 p.m. on May 2, 2024' from '\d{4}');

SELECT county_name
FROM county_statistics.us_counties_pop_est_2019
WHERE county_name ~* '(lade|lare)'
ORDER BY county_name;

SELECT county_name
FROM county_statistics.us_counties_pop_est_2019
WHERE county_name ~* 'ash'
  AND county_name !~ 'Wash'
ORDER BY county_name;

SELECT regexp_replace('05/12/2024', '\d{4}', '2023');

SELECT regexp_split_to_table('Four,score,and,seven,years,ago', ',');

SELECT regexp_split_to_array('Phil Mike Tony Steve', '\s');

SELECT array_length(regexp_split_to_array('Phil Mike Tony Steve', '\s'), 1);