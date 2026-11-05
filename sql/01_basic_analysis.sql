-- =========================================
-- EMPLOYEE DATABASE ANALYSIS
-- 01. BASIC ANALYSIS
-- =========================================


-- 1. Total number of employees

SELECT COUNT(*)
FROM employees;


-- 2. Display the first 10 employees

SELECT *
FROM employees
LIMIT 10;


-- 3. Number of employees by gender

SELECT gender, COUNT(*)
FROM employees
GROUP BY gender;


-- 4. Earliest and latest hiring dates

SELECT
    MIN(hire_date),
    MAX(hire_date)
FROM employees;


-- 5. Number of employees hired by year

SELECT YEAR(hire_date), COUNT(*)
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY YEAR(hire_date);
