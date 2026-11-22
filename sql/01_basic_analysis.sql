-- Hiring and workforce composition across the complete employee register.
SELECT COUNT(*) AS employee_count,
       MIN(hire_date) AS first_hire,
       MAX(hire_date) AS last_hire
FROM employees;

SELECT gender,
       COUNT(*) AS employees,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS share_pct
FROM employees
GROUP BY gender
ORDER BY employees DESC;

SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS hires
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;
