-- Monthly growth query - for top 10 skills (whole period) - We added a RANK() window function
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
),
daily_counts AS (
  SELECT
    skill_name,
    active_date,
    COUNT(DISTINCT id) AS job_count
  FROM skills_active
  JOIN top_skills USING (skill_name)
  CROSS JOIN UNNEST(active_dates) AS active_date
  GROUP BY skill_name, active_date
),
monthly_counts AS (
  SELECT
    skill_name,
    DATE_TRUNC(active_date, MONTH) AS month,
    AVG(job_count) AS avg_jobs_month
  FROM daily_counts
  GROUP BY skill_name, month
)
SELECT
  skill_name,
  month,
  avg_jobs_month,
  LAG(avg_jobs_month) OVER (PARTITION BY skill_name ORDER BY month) AS avg_prev_month_jobs,
  (avg_jobs_month - LAG(avg_jobs_month) OVER (PARTITION BY skill_name ORDER BY month)) AS abs_change_in_avg_jobs,
  SAFE_DIVIDE(avg_jobs_month - LAG(avg_jobs_month) OVER (PARTITION BY skill_name ORDER BY month), 
              LAG(avg_jobs_month) OVER (PARTITION BY skill_name ORDER BY month)) AS month_over_month_growth,
  RANK() OVER (PARTITION BY month ORDER BY avg_jobs_month DESC) AS skill_rank
FROM monthly_counts
ORDER BY month, skill_rank;
