SELECT *
FROM crosstab(
  'SELECT flavor, office, count(*)
   FROM ice_cream_survey
   GROUP BY flavor, office
   ORDER BY flavor',
   'SELECT office
   FROM ice_cream_survey
   GROUP BY office
   ORDER BY office')
  AS (flavor TEXT, Downtown BIGINT, Midtown BIGINT, Uptown BIGINT);