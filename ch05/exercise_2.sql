SELECT 
    county_name, state_name, births_2019 
FROM 
    public.us_counties_pop_est_2019
ORDER BY 
    births_2019 DESC
LIMIT 20;

