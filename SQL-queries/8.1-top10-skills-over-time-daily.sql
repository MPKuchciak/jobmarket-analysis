-- Top 10 Skills Over Time (Daily)
-- To track the popularity of these top 10 skills over time, generate daily active job counts for each
WITH top_skills AS (
  SELECT
    skill.element.name AS skill_name,
    COUNT(DISTINCT id) AS job_count
  FROM `projectbigdata-442715.just_join_it.jobs_consolidated`,
  UNNEST(skills.list) AS skill
  WHERE (LOWER(title) LIKE '%big data%'
    OR LOWER(title) LIKE '%data analyst%'
    OR LOWER(title) LIKE '%big data analyst%')
  GROUP BY skill_name
  ORDER BY job_count DESC
  LIMIT 10
),
skills_active AS (
  SELECT
    skill_element.element.name AS skill_name,
    id,
    GENERATE_DATE_ARRAY(CAST(start_date AS DATE), CAST(end_date AS DATE)) AS active_dates
  FROM `projectbigdata-442715.just_join_it.jobs_consolidated`,
  UNNEST(skills.list) AS skill_element
  WHERE (LOWER(title) LIKE '%big data%'
    OR LOWER(title) LIKE '%data analyst%'
    OR LOWER(title) LIKE '%big data analyst%')
)
SELECT
  active_date,
  skill_name,
  COUNT(DISTINCT id) AS job_count
FROM skills_active
JOIN top_skills USING (skill_name)
CROSS JOIN UNNEST(active_dates) AS active_date
GROUP BY active_date, skill_name
ORDER BY active_date, job_count DESC;
