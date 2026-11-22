-- Match an open assignment with the same employee's open salary record.
SELECT d.dept_name AS department,
       COUNT(*) AS employees_with_salary,
       ROUND(AVG(s.salary), 2) AS mean_salary
FROM dept_emp AS a
JOIN departments AS d ON d.dept_no = a.dept_no
JOIN salaries AS s ON s.emp_no = a.emp_no
WHERE a.to_date = '9999-01-01'
  AND s.to_date = '9999-01-01'
GROUP BY d.dept_no, d.dept_name
ORDER BY mean_salary DESC, department;
