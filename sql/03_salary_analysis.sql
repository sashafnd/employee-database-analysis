```sql
-- Average current salary by department

SELECT departments.dept_name, ROUND(AVG(salaries.salary), 2)
FROM departments
JOIN dept_emp
    ON departments.dept_no = dept_emp.dept_no
JOIN salaries
    ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date > CURRENT_DATE()
    AND salaries.to_date > CURRENT_DATE()
GROUP BY departments.dept_name
ORDER BY AVG(salaries.salary) DESC;
```
