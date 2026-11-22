-- Count each historical department once per employee, regardless of assignment length.
WITH history AS (
    SELECT emp_no, COUNT(DISTINCT dept_no) AS departments_held
    FROM dept_emp
    GROUP BY emp_no
)
SELECT COUNT(*) AS employees_with_assignments,
       SUM(CASE WHEN departments_held > 1 THEN 1 ELSE 0 END) AS employees_in_multiple_departments,
       ROUND(100.0 * SUM(CASE WHEN departments_held > 1 THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS mobility_pct
FROM history;

-- Inspect a reproducible sample of employees with multiple departments.
SELECT emp_no, COUNT(DISTINCT dept_no) AS departments_held
FROM dept_emp
GROUP BY emp_no
HAVING COUNT(DISTINCT dept_no) > 1
ORDER BY departments_held DESC, emp_no
LIMIT 20;
