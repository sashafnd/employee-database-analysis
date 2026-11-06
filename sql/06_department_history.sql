-- Number of departments per employee

SELECT
    emp_no,
    COUNT(DISTINCT dept_no)
FROM dept_emp
GROUP BY emp_no
ORDER BY COUNT(DISTINCT dept_no) DESC
LIMIT 20;

-- Count employees who worked in multiple departments

SELECT COUNT(*)
FROM (
    SELECT emp_no
    FROM dept_emp
    GROUP BY emp_no
    HAVING COUNT(DISTINCT dept_no) > 1
) AS multiple_departments;
