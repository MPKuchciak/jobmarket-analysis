-- Average Duration by Experience Level - how long the offer laster on average
SELECT
  experience_level,
  AVG(DATE_DIFF(CAST(end_date AS DATE), CAST(start_date AS DATE), DAY)) AS avg_duration_days,
  AVG(DATE_DIFF(CAST(latest_published_at AS TIMESTAMP), CAST(earliest_published_at AS TIMESTAMP), DAY)) AS avg_published_days
FROM `projectbigdata-442715.just_join_it.jobs_consolidated`
WHERE LOWER(title) LIKE '%big data%'
  OR LOWER(title) LIKE '%data analyst%'
  OR LOWER(title) LIKE '%big data analyst%'
GROUP BY experience_level
ORDER BY avg_duration_days DESC;
