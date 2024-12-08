# jobmarket-analysis 
 Just Join IT market analysis using GCP, project for studies

## Quick Explanation
The primary goal is to identify which courses should be launched for Big Data Analysts next year and to justify these recommendations with data. Throughout this process, we encountered challenges such as handling large nested datasets, deciding between UNNEST-ing dynamically or pre-flattening tables, and managing performance vs. complexity trade-offs.

## Steps to Get Started
1. Dataset Download:  
   Download the Kaggle dataset from [JustJoinIT Job Offers Data 2021-10 to 2023-09](https://www.kaggle.com/datasets/jszafranqb/justjoinit-job-offers-data-2021-10-2023-09?resource=download-directory). This dataset contains valuable job offer information spanning multiple years.

2. Prepare the Data - contained in setup folder:  
   Use the `justjoinit.ipynb` Jupyter notebook to review the dataset schema and convert the data from JSON to Parquet. This step improves query performance. If performance issues arise due to nested structures, consider alternative approaches:
   - Keep data nested and UNNEST in queries when needed (flexible but potentially costly per query).
   - Pre-flatten data if queries are frequent and the complexity justifies it.

3. Upload Data to GCP:  
   Utilize `bq_commands.txt` and Google Cloud CLI to upload data to GCP and create tables in BigQuery. 
   
   For example:
   
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
Perform data cleaning via data_cleaning.sql. For instance, filtering only Polish (country_code = 'PL') jobs and focusing on Big Data Analyst roles could be included there, but we decided on doing so later on within SQL-queries folder within separate queries. We also maintained flexible UNNEST strategies to handle arrays (skills, multilocation) and considered either:

On-the-fly UNNEST for occasional queries; as this is examplary project we won't do them second time.
Pre-flattening for repeated queries on large datasets.
Balancing performance and complexity was key. By doing so, we ensured reliable data for analysis and avoided unnecessary overhead.

## Visualize the Results:
Use Python and EXCEL for visualizations

Visualization helps communicate findings to stakeholders, showing top skills, how they evolve over time, and how job durations vary by experience level. These insights support strategic decisions on which courses to offer and will or may help us in getting us hypothetically considered as partners (for employer)

## Conclusion 
Following these steps enables effective analysis of job offer data, guiding data-driven decisions about course offerings. We analyzed trends over time, looked at growing or declining skill demands, and identified top in-demand skills. For a pitch presentation scenario, these results justify why certain skills are worth investing in for future training programs.

## Note for Project 
This analysis is a starting point. 
Further refinement, such as exploring more job titles related to Big Data or analyzing different regions, can be conducted if a real employer hires us long-term. For now, we've showcased a data-driven methodology, selecting Poland as a representative market and focusing on a set of Big Data-related titles. The UNNEST strategy was chosen for simplicity and flexibility, but can be adapted if performance needs change.

## Authors and Folder Structure The repository structure:
Maciej Kuchciak
Michał Woźniak

## Structure of project
```
jobmarket-analysis/ 
├── README.md # Main documentation 
├── .gitattributes # Repository management (line endings, etc.) 
├── .gitignore # Ignoring unnecessary files 
├── docs/ # Files for GITPAGES
├── SQL-queries/ # SQL scripts for data cleaning and analysis 
├── Data-from-queries/ # Storing exported query results 
└── setup/ # Jupyter notebooks (e.g., justjoinit.ipynb) and command lists (bq_commands.txt)
```

## Additional Queries and Insights 
For example, consider unnesting before making queries, consider SQL related skills so for example MySQLi or PL SQL into SQL statistics, analyze data engineers too, analyze what words may be in title, but also consider different things like id or certain skills and look what other titles may be associated with big data jobs.