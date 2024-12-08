-- creation of deduplicated column based on data from published at and data
CREATE OR REPLACE TABLE `projectbigdata-442715.just_join_it.jobs_consolidated` AS
SELECT
  id,
  ANY_VALUE(title) AS title,
  ANY_VALUE(street) AS street,
  ANY_VALUE(city) AS city,
  ANY_VALUE(country_code) AS country_code,
  ANY_VALUE(address_text) AS address_text,
  ANY_VALUE(marker_icon) AS marker_icon,
  ANY_VALUE(workplace_type) AS workplace_type,
  ANY_VALUE(company_name) AS company_name,
  ANY_VALUE(company_url) AS company_url,
  ANY_VALUE(company_size) AS company_size,
  ANY_VALUE(experience_level) AS experience_level,
  ANY_VALUE(latitude) AS latitude,
  ANY_VALUE(longitude) AS longitude,
  
  -- Handling published_at times
  MIN(published_at) AS earliest_published_at,
  MAX(published_at) AS latest_published_at,

  ANY_VALUE(remote_interview) AS remote_interview,
  ANY_VALUE(open_to_hire_ukrainians) AS open_to_hire_ukrainians,
  ANY_VALUE(display_offer) AS display_offer,

  -- For employment_types and skills (currently JSON), pick ANY_VALUE.
  -- they seem consistent, ANY_VALUE is likely fine.
  ANY_VALUE(employment_types) AS employment_types,
  ANY_VALUE(company_logo_url) AS company_logo_url,
  ANY_VALUE(skills) AS skills,
  ANY_VALUE(remote) AS remote,

  ANY_VALUE(multilocation) AS multilocation,
  ANY_VALUE(way_of_apply) AS way_of_apply,

  -- Handling date timespan
  MIN(date) AS start_date,
  MAX(date) AS end_date

FROM `projectbigdata-442715.just_join_it.just_join_it_2022_2023_filtered`
GROUP BY id;
