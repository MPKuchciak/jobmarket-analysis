WITH
  skill_list AS (
  SELECT
    CASE
      WHEN LOWER(skill.element.name) LIKE '%spark%' THEN 'Spark'
      WHEN (LOWER(skill.element.name) LIKE '%sql%'
      OR LOWER(skill.element.name) LIKE 'relational%'
      OR LOWER(skill.element.name) LIKE '%ssis%')
    AND LOWER(skill.element.name) NOT LIKE '%python%'
    AND LOWER(skill.element.name)!='nosql' THEN 'SQL'
      WHEN LOWER(skill.element.name) LIKE '%power%' AND LOWER(skill.element.name) LIKE '%bi%' THEN 'PowerBI'
      WHEN (LOWER(skill.element.name) LIKE '%power%'
      AND LOWER(skill.element.name) NOT LIKE '%bi%')
    OR LOWER(skill.element.name) LIKE '%excel%'
    OR LOWER(skill.element.name) LIKE '%vba%'
    OR LOWER(skill.element.name) LIKE '%sheets%' THEN 'Excel'
      WHEN LOWER(skill.element.name) IN ('aws', 'amazon web services', 'amazon aws') THEN 'AWS'
      WHEN LOWER(skill.element.name) LIKE '%sap%' THEN 'SAP'
      WHEN LOWER(skill.element.name) LIKE '%etl%' THEN 'ETL'
      WHEN LOWER(skill.element.name) LIKE '%composer%'
    OR LOWER(skill.element.name) LIKE '%data studio%'
    OR LOWER(skill.element.name) LIKE '%google%'
    OR LOWER(skill.element.name) LIKE '%bigquery%'
    OR LOWER(skill.element.name) LIKE '%gtm%' THEN 'GCP'
      WHEN LOWER(skill.element.name) LIKE '%hadoop%' OR LOWER(skill.element.name) LIKE '%haddop%' OR LOWER(skill.element.name) LIKE '%hdfs%' THEN 'Hadoop'
      WHEN LOWER(skill.element.name) LIKE '%shell%' THEN 'PowerShell'
      WHEN (LOWER(skill.element.name) LIKE '%bi%' OR LOWER(skill.element.name) LIKE '%business%') AND LOWER(skill.element.name) NOT LIKE '%query%' AND LOWER(skill.element.name) NOT LIKE '%power%' THEN 'BI'
      WHEN skill.element.name IN ('Outlook',
      'ms teams',
      'MS Office',
      'Outlook' 'SharePoint',
      'OneDrive',
      'Power Apps',
      'Power Automate',
      'Teams',
      'Teams Communication',
      'MS Access') THEN 'MS Office'
      WHEN LOWER(skill.element.name) LIKE '%azure%' THEN 'Azure'
      WHEN LOWER(skill.element.name) LIKE '%qlik%' THEN 'Qlik'
      WHEN LOWER(skill.element.name) LIKE '%linux%' THEN 'Linux'
      WHEN skill.element.name IN ('DWH',
      'Data Warehouse') THEN 'DWH'
      WHEN LOWER(skill.element.name) IN ('data modeling', 'machine learning', 'data science') OR LOWER(skill.element.name) LIKE '%a/b%' OR LOWER(skill.element.name) LIKE '%stat%' THEN 'Statistical methods'
      WHEN LOWER(skill.element.name) LIKE '%agile%'
    OR LOWER(skill.element.name) LIKE '%atlassian%'
    OR LOWER(skill.element.name) LIKE '%jira%' THEN 'Jira'
      ELSE skill.element.name
  END
    AS skill_name,
    COUNT(DISTINCT id) AS job_count
  FROM
    `projectbigdata-442715.just_join_it.jobs_consolidated`,
    UNNEST(skills.list) AS skill
  WHERE
    (LOWER(title) LIKE '%big data%'
      OR LOWER(title) LIKE '%data analyst%'
      OR LOWER(title) LIKE '%big data analyst%')
  GROUP BY
    1
  HAVING
    LOWER(skill_name) NOT LIKE '%english%'
    AND LOWER(skill_name) NOT LIKE '%polish%'
    AND LOWER(skill_name) NOT LIKE '%analy%'
    AND LOWER(skill_name) NOT LIKE '%niemiecki%'
    AND LOWER(skill_name) NOT LIKE '%german%'
    AND LOWER(skill_name) NOT LIKE '%dev%'
    AND skill_name NOT IN ('Big Data',
      'Data',
      'Team Player',
      'Proactivity',
      'Problem Solving',
      'Communication Skills',
      'Team Leadership',
      'Project Management',
      'Master data',
      'Programming',
      'Communication Skills',
      'Team Management',
      'Strategic advisory',
      'Risk Management',
      'Critical thinking',
      'People Management',
      'Digital',
      'Analiza',
      'SOP',
      'Trading voice',
      'Python OR SQL',
      'Apache',
      'BigData',
      'strategic advisory',
      'Java/Scala',
      'SaaS',
      'Oracle',
      'Schema Design',
      'Bazy Danych',
      'Reporting',
      'E-commerce',
      'Databases',
      'Enterprise',
      'data flow',
      'analiza',
      'data mining',
      'Data Visualization',
      'Cloud',
      'master data',
      'Cloud Native',
      'Data Lake',
      'Data Integration',
      'Data Engineering',
      'Pandas',
      'Open source',
      'BI')
    AND job_count>40
  ORDER BY
    2 ),
  skills_active AS (
  SELECT
    CASE
      WHEN LOWER(skill_element.element.name) LIKE '%spark%' THEN 'Spark'
      WHEN (LOWER(skill_element.element.name) LIKE '%sql%'
      OR LOWER(skill_element.element.name) LIKE 'relational%'
      OR LOWER(skill_element.element.name) LIKE '%ssis%')
    AND LOWER(skill_element.element.name) NOT LIKE '%python%'
    AND LOWER(skill_element.element.name)!='nosql' THEN 'SQL'
      WHEN LOWER(skill_element.element.name) LIKE '%power%' AND LOWER(skill_element.element.name) LIKE '%bi%' THEN 'PowerBI'
      WHEN (LOWER(skill_element.element.name) LIKE '%power%'
      AND LOWER(skill_element.element.name) NOT LIKE '%bi%')
    OR LOWER(skill_element.element.name) LIKE '%excel%'
    OR LOWER(skill_element.element.name) LIKE '%vba%'
    OR LOWER(skill_element.element.name) LIKE '%sheets%' THEN 'Excel'
      WHEN LOWER(skill_element.element.name) IN ('aws', 'amazon web services', 'amazon aws') THEN 'AWS'
      WHEN LOWER(skill_element.element.name) LIKE '%sap%' THEN 'SAP'
      WHEN LOWER(skill_element.element.name) LIKE '%etl%' THEN 'ETL'
      WHEN LOWER(skill_element.element.name) LIKE '%composer%'
    OR LOWER(skill_element.element.name) LIKE '%data studio%'
    OR LOWER(skill_element.element.name) LIKE '%google%'
    OR LOWER(skill_element.element.name) LIKE '%bigquery%'
    OR LOWER(skill_element.element.name) LIKE '%gtm%' THEN 'GCP'
      WHEN LOWER(skill_element.element.name) LIKE '%hadoop%' OR LOWER(skill_element.element.name) LIKE '%haddop%' OR LOWER(skill_element.element.name) LIKE '%hdfs%' THEN 'Hadoop'
      WHEN LOWER(skill_element.element.name) LIKE '%shell%' THEN 'PowerShell'
      WHEN (LOWER(skill_element.element.name) LIKE '%bi%' OR LOWER(skill_element.element.name) LIKE '%business%') AND LOWER(skill_element.element.name) NOT LIKE '%query%' AND LOWER(skill_element.element.name) NOT LIKE '%power%' THEN 'BI'
      WHEN skill_element.element.name IN ('Outlook',
      'ms teams',
      'MS Office',
      'Outlook' 'SharePoint',
      'OneDrive',
      'Power Apps',
      'Power Automate',
      'Teams',
      'Teams Communication',
      'MS Access') THEN 'MS Office'
      WHEN LOWER(skill_element.element.name) LIKE '%azure%' THEN 'Azure'
      WHEN LOWER(skill_element.element.name) LIKE '%qlik%' THEN 'Qlik'
      WHEN LOWER(skill_element.element.name) LIKE '%linux%' THEN 'Linux'
      WHEN skill_element.element.name IN ('DWH',
      'Data Warehouse') THEN 'DWH'
      WHEN LOWER(skill_element.element.name) IN ('data modeling', 'machine learning', 'data science') OR LOWER(skill_element.element.name) LIKE '%a/b%' OR LOWER(skill_element.element.name) LIKE '%stat%' THEN 'Statistical methods'
      WHEN LOWER(skill_element.element.name) LIKE '%agile%'
    OR LOWER(skill_element.element.name) LIKE '%atlassian%'
    OR LOWER(skill_element.element.name) LIKE '%jira%' THEN 'Jira'
      ELSE skill_element.element.name
  END
    AS skill_name,
    id,
    GENERATE_DATE_ARRAY(CAST(start_date AS DATE), CAST(end_date AS DATE)) AS active_dates
  FROM `projectbigdata-442715.just_join_it.jobs_consolidated`,
  UNNEST(skills.list) AS skill_element
  WHERE (LOWER(title) LIKE '%big data%'
    OR LOWER(title) LIKE '%data analyst%'
    OR LOWER(title) LIKE '%big data analyst%')
),
skills_cat AS (
SELECT
  FORMAT_DATE('%Y-%m',active_date) AS active_date,
  skill_name,
  IF
  (skill_name IN ('SQL',
      'NoSQL',
      'Hadoop',
      'Spark'), 1,0) AS database_solution,
  CASE
    WHEN skill_name='Hadoop' THEN 1
    WHEN skill_name='Spark' THEN 1
    WHEN skill_name='NoSQL' THEN 1
    ELSE 0
END
  AS nosql_solution,
  CASE
    WHEN skill_name='ETL' THEN 1
    WHEN skill_name='Data architecture' THEN 1
    WHEN skill_name='DWH' THEN 1
    ELSE 0
END
  AS databse_theory,
IF
  (skill_name IN ('GCP',
      'Azure',
      'AWS'), 1,0) AS cloud_solution,
IF
  (skill_name IN ('Python',
      'R',
      'Scala',
      'Java'),1,0) AS scripting_language,
IF
  (skill_name IN ('PowerBI',
      'Excel',
      'Tableau',
      'Qlik'),1,0) AS business_intelligence,
  COUNT(DISTINCT id) AS job_count
FROM skills_active
JOIN skill_list USING (skill_name)
CROSS JOIN UNNEST(active_dates) AS active_date
GROUP BY 
active_date,
skill_name
order by active_date,job_count DESC)
select * from skills_cat