-- creation of table for checking uniquess of records over time and selecting one of the jobs related to big data
CREATE OR REPLACE TABLE `projectbigdata-442715.just_join_it.just_join_it_2022_2023_single_id_test` AS
SELECT *
FROM `projectbigdata-442715.just_join_it.just_join_it_2022_2023_filtered`
WHERE id IN (
  SELECT id
  FROM `projectbigdata-442715.just_join_it.just_join_it_2022_2023_filtered`
  WHERE 
    LOWER(title) LIKE '%big data%' 
    OR LOWER(title) LIKE '%data analyst%' 
    OR LOWER(title) LIKE '%big data analyst%'
  LIMIT 10
);

