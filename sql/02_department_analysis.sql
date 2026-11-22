-- Snapshot: the sample database marks open assignments with 9999-01-01.
SELECT d.dept_name AS department,
       COUNT(DISTINCT a.emp_no) AS headcount,
       ROUND(100.0 * COUNT(DISTINCT a.emp_no)
             / SUM(COUNT(DISTINCT a.emp_no)) OVER (), 2) AS share_pct
FROM dept_emp AS a
JOIN departments AS d ON d.dept_no = a.dept_no
WHERE a.to_date = '9999-01-01'
GROUP BY d.dept_no, d.dept_name
ORDER BY headcount DESC, department;
