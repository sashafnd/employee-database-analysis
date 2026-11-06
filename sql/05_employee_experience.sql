-- Average employee experience

    SELECT
    ROUND(AVG(DATEDIFF(CURRENT_DATE(), hire_date) / 365), 2) as avgexp_pracivnykiv
FROM employees;

-- Employees by experience categories
SELECT
    CASE
        WHEN DATEDIFF(DATE('2001-01-01'), hire_date) / 365 < 5
            THEN 'Less than 5 years'
        WHEN DATEDIFF(DATE('2001-01-01'), hire_date) / 365 < 10
            THEN '5-10 years'
        ELSE 'More than 10 years'
    END as analize,
    COUNT(*)
FROM employees
GROUP BY
    CASE
        WHEN DATEDIFF(DATE('2001-01-01'), hire_date) / 365 < 5
            THEN 'Less than 5 years'
        WHEN DATEDIFF(DATE('2001-01-01'), hire_date) / 365 < 10
            THEN '5-10 years'
        ELSE 'More than 10 years'
    END;



