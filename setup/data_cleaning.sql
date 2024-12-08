CREATE TABLE `sql-by-creaitive-studio.just_join_it.just_join_it_2022_2023_exploded` AS
WITH deduped AS (
  SELECT *
  FROM
    (
    SELECT
      a.*,
      ROW_NUMBER() OVER (PARTITION BY id, published_at ORDER BY date DESC) AS rn
    FROM
      `sql-by-creaitive-studio.just_join_it.just_join_it_2022_2023` a
    ORDER BY
      id,
      published_at desc
    )
  WHERE
    rn = 1
  ),
  exploded AS (
  SELECT
    *,
    skill_element.element.level AS skill_level,
    skill_element.element.name AS skill_name
  FROM
    deduped,
    UNNEST(skills.list) AS skill_element
  )

SELECT *
FROM
  exploded
;