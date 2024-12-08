-- Identify which cities have the most postings. additional thing to just see what cities are most popular within big data related jobs
SELECT
  city,
  COUNT(*) AS job_count
FROM `projectbigdata-442715.just_join_it.jobs_consolidated`
WHERE
  LOWER(title) LIKE '%big data%'
  OR LOWER(title) LIKE '%data analyst%'
  OR LOWER(title) LIKE '%big data analyst%'
GROUP BY city
ORDER BY job_count DESC
LIMIT 10;
