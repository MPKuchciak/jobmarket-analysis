# jobmarket-analysis  
Just Join IT market analysis using GCP, project for studies



## Authors 

<span style="color: red;">*Maciej Kuchciak*</span>

<span style="color: red;">*Michał Woźniak*</span>



## Place for GitHub Pages link:

[PLACEHOLDER]



## Structure of Project
```
jobmarket-analysis/
├── README.md      # Main documentation and project 1-pager !!!
├── .gitattributes     # Repository management (line endings, etc.)
├── .gitignore         # Ignoring unnecessary files
├── docs/              # Files for GitHub Pages or additional configuration like .yml
├── SQL-queries/       # SQL scripts for data cleaning and analysis
├── Data-from-queries/ # Storing exported query results
└── setup/             # Jupyter notebooks (e.g., justjoinit.ipynb) & bq_commands.txt
```



## Quick Explanation
The primary goal of the project is to identify which courses should be launched for Big Data Analysts next year and to justify these recommendations with data, so that hypothetical client will buy our services for continuous period. 

Throughout the process, we addressed key challenges:  
- Handling nested JSON variables (skills, multilocation) with `UNNEST` operations.  
- Deciding between on-the-fly UNNEST (flexible, no extra storage) vs. pre-flattening the data (faster but more complex setup).  
- Filtering data by country (`PL` for Poland) and by job titles relevant to Big Data Analysts (we considered %big data%,  %data analyst% and %big data analyst%, but in the future in may be wise to analyze what other titles may be included in big data analysts jobs or consider also different variables such as skills when filtering main database).  
- We filtered dataset to data in range of 2022-01-01 to 2023-09 (2021 was cut off from raw dataset)
- Managing performance vs. complexity trade-offs to ensure queries remain efficient; for example with window functions



## Steps to Get Started 
1. Dataset Download:  
   Download the Kaggle dataset from [JustJoinIT Job Offers Data 2021-10 to 2023-09](https://www.kaggle.com/datasets/jszafranqb/justjoinit-job-offers-data-2021-10-2023-09?resource=download-directory). This dataset contains valuable job offer information spanning multiple years.

2. Prepare the Data - contained in setup folder:  
   Use the `justjoinit.ipynb` Jupyter notebook to review the dataset schema and convert the data from JSON to Parquet. This step improves query performance. In later steps, consider two alternative approaches:
   - Keep data nested and UNNEST in queries when needed (flexible but potentially costly per query).
   - Pre-flatten data if queries are frequent and the complexity justifies it.

3. Upload Data to GCP:  
   Utilize `bq_commands.txt` and Google Cloud CLI / Google Cloud SDK (desktop) to upload data (example of handling data below as bq_commands.txt may not work correctly as in our case) to GCP and create tables in BigQuery. 
   
   First we loaded single day of month to get scheme autodetected (also newer periods contain variable related to ukraine while the older ones did not)
   For example (names are something that needs to be changed):
   
   ```bash
   # Single file load example:
   bq load --source_format=PARQUET \
     --autodetect \
     projectbigdata-442715:just_join_it.just_join_it_2022_2023 \
     gs://jeden-123456/just_join_it/pq_data_output/2023-09/2023-09-01.parquet

   # Multiple files loop example:
   while IFS= read -r file; do
     bq load --source_format=PARQUET \
       projectbigdata-442715:just_join_it.just_join_it_2022_2023 "$file"
   done < file_list.txt
    ``` 

4. Data Cleaning:
    Key decisions included:
    - Performing data cleaning steps using SQL queries (stored in the SQL-queries folder). For example, we are focusing on Poland (country_code='PL') and Big Data Analyst roles, and applying flexible UNNEST operations as needed.
    - Filtering period of data to 2022-01-01 to 2023-09 excluding whole 2021
    - Experimenting with window functions (e.g., ROW_NUMBER()) to deduplicate records.
    - On-the-fly UNNEST for queries that may not be used that often; as this is exemplary project we won't do them second time so we went with unnest within queries.



## Example Queries and Functions Used

Below are explanations of various SQL functions and exemplary query that we used (all used queries are inside SQL-queries folder).

Example of query 3 - usage of unnesting to flatten skills and matching job title using `LIKE` to select roles only related to Big Data

```
SELECT
  skill.element.name AS skill_name,
  COUNT(DISTINCT id) AS job_count
FROM `projectbigdata-442715.just_join_it.jobs_consolidated`,
  UNNEST(skills.list) AS skill
WHERE LOWER(title) LIKE '%big data%' 
  OR LOWER(title) LIKE '%data analyst%' 
  OR LOWER(title) LIKE '%big data analyst%'
GROUP BY skill_name
ORDER BY job_count DESC
LIMIT 10;
```

**Some function / methods we used:**

*CREATE OR REPLACE TABLE:*
Overwrites an existing (or creates table) table with a new version. This is handy for experimentation but can be costly. Normally, we would not do it and prefer a more controlled approach, even with just creation of table (instead CREATE OR REPLACE), but for testing purposes and some experimentation we decided on that approach.

*ANY_VALUE():*
During table creation, ANY_VALUE() picks a single value from a group of rows without specifying which one in particular. This is often used when You know the field is identical or stable across rows, which we assumed it is (briefly checked, but I guess it would be appropriate to check it more thoroughly).

*Grouping by a Field (e.g. GROUP BY id):*
Collapses multiple rows related to the same `id`(exemplary column) into one combined result row, allowing You to aggregate values (like using MIN, MAX, ANY_VALUE) and represent a single jobs entire active span as a single record.

*MIN/MAX for earliest/latest times:*
Using MIN(published_at/date) or MAX(published_at/date) helps find the earliest or latest occurrences of a job postings attributes, defining the jobs active time range.

*DISTINCT:*
Ensures that when counting (e.g., COUNT(DISTINCT id)), each unique id is only counted once. 

*WHERE with LIKE:*
Filters rows based on matches. For example, LOWER(title) LIKE '%big data%' finds all titles that include `big data` somewhere in them.

*UNNEST:*
Expands a nested array (like skills.list) into multiple rows. Without UNNEST, each row might contain multiple skills stored in an array. After UNNEST, each skill is on its own row, making it easier to count or filter them.

*CAST(... AS DATE/TIMESTAMP):*
Converts values to a proper date or timestamp type. This is crucial when using date/time functions (DATE_DIFF, GENERATE_DATE_ARRAY), ensuring the function receives the correct data type and avoids errors.

*DATE_DIFF:*
Calculates the difference between two dates or timestamps (e.g., in days). 

*GENERATE_DATE_ARRAY:*
Creates an array of dates from a start date to an end date. For a job active from January 1 to January 3, GENERATE_DATE_ARRAY returns [2023-01-01, 2023-01-02, 2023-01-03]. Makes enumeration easier.

*CROSS JOIN:*
When you CROSS JOIN UNNEST(active_dates), you join each job row with each date in the active_dates array, producing a row per active day. A CROSS JOIN without conditions pairs every row from the left table with every row from the right, which is exactly what UNNEST returns.

*DATE_TRUNC:*
Truncates a date or timestamp to a specified granularity (e.g., MONTH). If you have daily data, DATE_TRUNC(day, MONTH) aggregates it at the monthly level. For example, DATE_TRUNC('2023-04-15', MONTH) = 2023-04-01, grouping all April dates under April.

*LAG() (Window Function):*
A window function that looks at a previous row value in a result set without changing grouping. For instance, LAG(job_count) OVER (ORDER BY month) fetches the job_count from the previous month, allowing month-over-month comparisons.

*SAFE_DIVIDE():*
A safer division function. If the denominator is zero, SAFE_DIVIDE returns NULL instead of causing an error. Suitable for calculating percentages where the previous value might be zero (like growth rates).

*CASE:*
A conditional expression allowing you to categorize or rename fields. For example, converting various SQL-related skill names (`MySQL`, `T-SQL`, `PL/SQL`) into a single category `SQL`.

*SUM(x) OVER (PARTITION BY y):*
A window function that sums values (x) for each partition defined by y. For example, SUM(job_count) OVER (PARTITION BY active_date) calculates the total jobs active on that date (across all `skills` if used in Our context). It is useful when you need totals or running sums without writing another GROUP BY query.



## Visualize the Results:
We have used Python and EXCEL for visualizations

Visualization helps communicate findings to stakeholders or in our project to connect with company, showing top skills, how they evolve over time, and how job durations vary by experience level (examples of our queries). 
These insights support strategic decisions on which courses to offer and will or may help us in getting Us hypothetically considered as partners (for employer).



## Note for Project 
This analysis is a starting point. 
Further refinement, such as exploring more job titles related to Big Data or analyzing different regions, can be conducted if a real employer hires us long-term. For now, we've showcased part of methodology, selecting Poland as only market and focusing on a set of Big Data-related titles. The UNNEST strategy was chosen for simplicity and flexibility, but can be adapted if performance needs change.



## Additional Queries and Insights (something to work on in the future)
For example:
- considering unnesting before making queries, 
- considering SQL related skills so for example MySQLi or PL SQL into SQL statistics, analyze data - - considering engineers too (or maybe excluding them)
- considering different things like id or certain skills and look what other titles may be associated with big data jobs.
- google related jobs, all things that may come into google; gcp, google analytics (although there may be different kind of jobs related to google analytics that may not involve big data itself or some skills like SQL)

### Additional Information
 We managed to correct with these considerations one of the queries and it is in the folder `Data-from-queries` (csv file with output) as *11-monthly_exemplary_query.csv* and *12-category.csv* and in the `SQL-queries` folder (.sql file with query itself) as *11-monthly_exemplary_query.sql* and *12-category.sql*
