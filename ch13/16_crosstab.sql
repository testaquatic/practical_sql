SELECT *
FROM crosstab(
  'SELECT office, flavor, count(*)
   FROM ice_cream_survey
   GROUP BY office, flavor
   ORDER BY office',
   'SELECT flavor
   FROM ice_cream_survey
   GROUP BY flavor
   ORDER BY flavor')
  AS (office TEXT, chocolate BIGINT, strawberry BIGINT, vanilla BIGINT);