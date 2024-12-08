-- checking names of variables
SELECT 
  column_name
FROM 
  `projectbigdata-442715.just_join_it.INFORMATION_SCHEMA.COLUMNS`
WHERE 
  table_name = 'just_join_it_2022_2023_filtered';
