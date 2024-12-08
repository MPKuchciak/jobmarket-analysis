-- limiting dataset to Poland and 2022-01-01 through 2023-09-25
CREATE OR REPLACE TABLE `projectbigdata-442715.just_join_it.just_join_it_2022_2023_filtered` AS
SELECT *
FROM `projectbigdata-442715.just_join_it.just_join_it_2022_2023`
WHERE DATE(date) BETWEEN '2022-01-01' AND '2023-09-25'
  AND country_code = 'PL';

