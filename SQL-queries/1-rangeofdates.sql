-- detecting range of dates in uploaded dataset for 0.x sql queries
SELECT
  MIN(DATE(date)) AS earliest_date,
  MAX(DATE(date)) AS latest_date
FROM `projectbigdata-442715.just_join_it.just_join_it_2022_2023`;
