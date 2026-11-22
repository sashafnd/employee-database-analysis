-- Each observation is a salary record. An employee can contribute several records.
SELECT MIN(salary) AS minimum_salary,
       MAX(salary) AS maximum_salary,
       ROUND(AVG(salary), 2) AS mean_salary
FROM salaries;

-- Use the year the record took effect. Change is measured against the prior year's mean.
WITH annual AS (
    SELECT YEAR(from_date) AS effective_year,
           COUNT(*) AS salary_records,
           AVG(salary) AS mean_salary
    FROM salaries
    GROUP BY YEAR(from_date)
),
comparison AS (
    SELECT annual.*,
           LAG(mean_salary) OVER (ORDER BY effective_year) AS prior_year_mean
    FROM annual
)
SELECT effective_year, salary_records, ROUND(mean_salary, 2) AS mean_salary,
       ROUND(100.0 * (mean_salary - prior_year_mean)
             / NULLIF(prior_year_mean, 0), 2) AS change_pct
FROM comparison
ORDER BY effective_year;
