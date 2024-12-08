# jobmarket-analysis  
Just Join IT market analysis using GCP, project for studies



## Authors and Folder Structure The repository structure:

**Maciej Kuchciak**

**Michał Woźniak**


## Place for GitHub Pages link:

[PLACEHOLDER]

## Quick Explanation
The primary goal of the project is to identify which courses should be launched for Big Data Analysts next year and to justify these recommendations with data, so that hypothetical client will buy our services for continuos period. 

Throughout the process, we addressed key challenges:  
- Handling nested JSON variables (skills, multilocation) with `UNNEST` operations.  
- Deciding between on-the-fly UNNEST (flexible, no extra storage) vs. pre-flattening the data (faster but more complex setup).  
- Filtering data by country (`PL` for Poland) and by job titles relevant to Big Data Analysts (we considered %big data%,  %data analyst% and %big data analyst%, but in the future in may be wise to analyze what other titles may be included in big data analysts jobs or consider also different variables such as skills when filtering main database).  
- We filtered dataset to data in range of 2022-01-01 to 2023-09 (2021 was cut off from raw dataset)
- Managing performance vs. complexity trade-offs to ensure queries remain efficient; for example with windows functions.



## Steps to Get Started 
1. Dataset Download:  
   Download the Kaggle dataset from [JustJoinIT Job Offers Data 2021-10 to 2023-09](https://www.kaggle.com/datasets/jszafranqb/justjoinit-job-offers-data-2021-10-2023-09?resource=download-directory). This dataset contains valuable job offer information spanning multiple years.

2. Prepare the Data - contained in setup folder:  
   Use the `justjoinit.ipynb` Jupyter notebook to review the dataset schema and convert the data from JSON to Parquet. This step improves query performance. If performance issues arise due to nested structures, consider alternative approaches:
   - Keep data nested and UNNEST in queries when needed (flexible but potentially costly per query).
   - Pre-flatten data if queries are frequent and the complexity justifies it.

3. Upload Data to GCP:  
   Utilize `bq_commands.txt` and Google Cloud CLI / Google Cloud SDK (desktop) to upload data (example of handliing data below as bq_commands.txt may not work correctly as in our case) to GCP and create tables in BigQuery. 
   
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



## Example Queries and Techniques

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

## Visualize the Results:
We have used Python and EXCEL for visualizations

Visualization helps communicate findings to stakeholders or in our project to connect with company, showing top skills, how they evolve over time, and how job durations vary by experience level (examples of our queries). 
These insights support strategic decisions on which courses to offer and will or may help us in getting Us hypothetically considered as partners (for employer).



## Structure of project
```
jobmarket-analysis/
├── README.md          # Main documentation and 
├── .gitattributes     # Repository management (line endings, etc.)
├── .gitignore         # Ignoring unnecessary files
├── docs/              # Files for GitHub Pages or additional configuration like .yml
├── SQL-queries/       # SQL scripts for data cleaning and analysis
├── Data-from-queries/ # Storing exported query results
└── setup/             # Jupyter notebooks (e.g., justjoinit.ipynb) & bq_commands.txt
```



## Note for Project 
This analysis is a starting point. 
Further refinement, such as exploring more job titles related to Big Data or analyzing different regions, can be conducted if a real employer hires us long-term. For now, we've showcased part of methodology, selecting Poland as only market and focusing on a set of Big Data-related titles. The UNNEST strategy was chosen for simplicity and flexibility, but can be adapted if performance needs change.



## Additional Queries and Insights (something to work on in the future)
For example:
- considering unnesting before making queries, 
- considering SQL related skills so for example MySQLi or PL SQL into SQL statistics, analyze data - - considering engineers too (or maybe excluding them)
- considering different things like id or certain skills and look what other titles may be associated with big data jobs.
- google related jobs, all things that may come into google; gcp, google analytics (although there may be different kind of jobs related to google analytics that may not involve big data itself or some skills like SQL)

### Additional information
 We managed to correct with these considerations one of the queries and it is in the folder `Data-from-queries` (csv file with output) as *11_monthly_exemplary_query.csv* and in the `SQL-queries` folder (.sql file with query itself) as *11_monthly_exemplary_query.sql*