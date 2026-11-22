-- Calendar years since hire at a fixed date for everyone hired by that date.
-- The register supplies hire dates. This metric does not measure time actually employed.
SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, hire_date, '2001-01-01')), 2) AS mean_completed_years
FROM employees
WHERE hire_date <= '2001-01-01';

WITH elapsed AS (
    SELECT TIMESTAMPDIFF(YEAR, hire_date, '2001-01-01') AS completed_years
    FROM employees
    WHERE hire_date <= '2001-01-01'
),
bands AS (
    SELECT CASE WHEN completed_years < 5 THEN 1
                WHEN completed_years < 10 THEN 2
                ELSE 3 END AS band_id,
           completed_years
    FROM elapsed
)
SELECT CASE band_id WHEN 1 THEN 'Under 5 years'
                    WHEN 2 THEN '5 to under 10 years'
                    ELSE '10 years or more' END AS time_since_hire,
       COUNT(*) AS employees,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM bands
GROUP BY band_id
ORDER BY band_id;
