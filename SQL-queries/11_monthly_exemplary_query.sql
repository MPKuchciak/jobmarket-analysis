-- All Skills Over Time (Daily) - with inclusion of some of our post project considerations and insights to climb onto in the next project or in the future of this project
-- To track the popularity of all skills over time, generate daily active job counts for each
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
  -- LIMIT 10
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
),
skills_monthly AS (
SELECT
  FORMAT_DATE('%Y-%m', active_date) AS active_date,
  
  CASE
    WHEN LOWER(skill_name) LIKE '%sql%' THEN IF(LOWER(skill_name) LIKE '%nosql%', 'NoSQL', 'SQL')
    WHEN LOWER(skill_name) LIKE '%python%' THEN 'Python'
    WHEN LOWER(skill_name) LIKE '%power%' THEN IF(LOWER(skill_name) LIKE '%bi%', 'PowerBI', skill_name)
    WHEN LOWER(skill_name) LIKE '%spark%' THEN 'Spark'
    WHEN LOWER(skill_name) LIKE '%etl%' THEN 'ETL'
    WHEN LOWER(skill_name) LIKE '%excel%' THEN 'Excel'
    WHEN LOWER(skill_name) LIKE '%google%' THEN 'GCP'
    WHEN LOWER(skill_name) LIKE '%gcp%' THEN 'GCP'
    WHEN LOWER(skill_name) LIKE '%bigquery%' THEN 'GCP'
    WHEN LOWER(skill_name) LIKE '%warehouse%' THEN 'DWH'
    WHEN LOWER(skill_name) LIKE '%dwh%' THEN 'DWH'
    ELSE skills_active.skill_name
  END AS 
  skill_name,
  COUNT(DISTINCT id) AS job_count
FROM skills_active
JOIN top_skills USING (skill_name)
CROSS JOIN UNNEST(active_dates) AS active_date
GROUP BY 
active_date, 
skill_name
HAVING
LOWER(skill_name) NOT LIKE '%data%'
AND LOWER(skill_name) NOT LIKE '%business%'
AND LOWER(skill_name) NOT LIKE '%english%'
AND LOWER(skill_name) NOT LIKE '%polish%'
AND LOWER(skill_name) NOT LIKE '%analy%'
AND LOWER(skill_name) NOT LIKE '%bazy%'
)
SELECT 
active_date,
skill_name,
job_count,
SUM(job_count) OVER(PARTITION BY active_date) AS month_total
FROM skills_monthly
ORDER BY active_date, job_count DESC