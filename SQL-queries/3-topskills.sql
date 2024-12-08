-- Couting skills in jobs related to big data on previously arranged table on given period that was 2022 01 01 to 2023 09 
SELECT
  skill.element.name AS skill_name,
  COUNT(DISTINCT id) AS job_count
FROM `projectbigdata-442715.just_join_it.jobs_consolidated`,
UNNEST(skills.list) AS skill
WHERE 
  LOWER(title) LIKE '%big data%' 
  OR LOWER(title) LIKE '%data analyst%' 
  OR LOWER(title) LIKE '%big data analyst%'
GROUP BY skill_name
ORDER BY job_count DESC
LIMIT 10;
