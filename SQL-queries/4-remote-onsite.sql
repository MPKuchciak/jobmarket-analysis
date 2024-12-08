-- Show how many Big Data roles are remote vs. non-remote
SELECT
  remote,
  workplace_type,
  COUNT(*) AS job_count
FROM `projectbigdata-442715.just_join_it.jobs_consolidated`
WHERE
  LOWER(title) LIKE '%big data%'
  OR LOWER(title) LIKE '%data analyst%'
  OR LOWER(title) LIKE '%big data analyst%'
GROUP BY remote, workplace_type;

