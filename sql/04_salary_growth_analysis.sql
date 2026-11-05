
-- General salary statistics

SELECT
    MIN(salary),
    MAX(salary),
    ROUND(AVG(salary), 2)
FROM salaries;



-- Average salary by year

SELECT
    YEAR(from_date),
    ROUND(AVG(salary), 2)
FROM salaries
GROUP BY YEAR(from_date)
ORDER BY YEAR(from_date);
