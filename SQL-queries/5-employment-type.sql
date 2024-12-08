-- Analyze the employment contract types offered
SELECT
  employment.element.type AS employment_type,
  COUNT(DISTINCT id) AS job_count
FROM `projectbigdata-442715.just_join_it.jobs_consolidated`,
UNNEST(employment_types.list) AS employment
WHERE
  LOWER(title) LIKE '%big data%'
  OR LOWER(title) LIKE '%data analyst%'
  OR LOWER(title) LIKE '%big data analyst%'
GROUP BY employment_type
ORDER BY job_count DESC;
