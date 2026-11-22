# Workforce and pay findings

## Department size and pay

Development and Production account for **114,690 of 240,124** open department assignments (47.76%). Sales has 37,701 employees and the highest mean salary. Finance is the smallest department by headcount and ranks third by mean salary.

| Department | Employees | Share of headcount | Mean salary, source units |
| --- | ---: | ---: | ---: |
| Development | 61,386 | 25.56% | 67,657.92 |
| Production | 53,304 | 22.20% | 67,843.30 |
| Sales | 37,701 | 15.70% | 88,852.97 |
| Customer Service | 17,569 | 7.32% | 67,285.23 |
| Research | 15,441 | 6.43% | 67,913.37 |
| Marketing | 14,842 | 6.18% | 80,058.85 |
| Quality Management | 14,546 | 6.06% | 65,441.99 |
| Human Resources | 12,898 | 5.37% | 63,921.90 |
| Finance | 12,437 | 5.18% | 78,559.94 |

The number of employees with open salary records matches the headcount in every row. Applying the open-record condition to both tables gives each employee one salary observation in this comparison. The 24,931.07 difference between Sales and Human Resources describes department averages. These queries do not control for job title or experience. [Headcount query](../02_department_analysis.sql) · [Pay query](../03_salary_analysis.sql)

## Hiring and recorded workforce composition

The register contains **300,024** employees, with hire dates from January 1, 1985 to January 28, 2000. Hiring peaked in 1986 at **36,150**, compared with 35,316 in 1985. The 13 hires in 2000 cover only the opening weeks of the year. The sample's gender field contains 179,973 records coded M (59.99%) and 120,051 coded F (40.01%). These counts use the entire employee register. [Hiring and composition query](../01_basic_analysis.sql)

## Effective salary records over time

Across **2,844,047** salary records, the minimum is 38,623, the maximum is 158,220 and the mean is 63,810.74. The annual mean rose from **53,182.36** for records starting in 1985 to **72,683.94** for records starting in 2002. That is a 36.7% increase across the two groups of records. The result describes the mix of rates taking effect in each year. Measuring individual raises would require following the same employee across consecutive salary records. [Salary history query](../04_salary_growth_analysis.sql)

## Time since hire on January 1, 2001

The average was **10.42 completed calendar years** across the employee register. A person hired on January 1, 1991 has exactly ten completed years on the reference date and belongs in the final band.

| Completed years since hire | Employees | Share |
| --- | ---: | ---: |
| Under 5 | 21,891 | 7.30% |
| 5 to under 10 | 87,663 | 29.22% |
| 10 or more | 190,470 | 63.48% |

The three bands sum to 300,024. The calculation uses hire dates only, so years after leaving the company are included. [Time-since-hire query](../05_employee_experience.sql)

## Department mobility

**31,579 of 300,024 employees (10.53%)** appear in more than one distinct department over their assignment history. Each person contributes once to the numerator regardless of the number of assignments. [Department history query](../06_department_history.sql)

## Reconciliation

The figures were independently recalculated from four tables in the [public sample revision](https://github.com/datacharmer/test_db/tree/e324b56193ca506ab7cc1ab143a9153d8c4535d7). All nine headcounts, all 18 annual mean salaries and both gender counts match the [original course workbook](data_visualizations.xlsx). The time-since-hire bands use completed calendar years and replace the earlier approximation based on days divided by 365.

[Back to the SQL project](../)
