```sql
-- Number of current employees in each department

SELECT departments.dept_name, COUNT(*)
FROM employees
JOIN dept_emp
    ON employees.emp_no = dept_emp.emp_no
JOIN departments
    ON dept_emp.dept_no = departments.dept_no
WHERE dept_emp.to_date > CURRENT_DATE()
GROUP BY departments.dept_name
ORDER BY COUNT(*) DESC;
```
