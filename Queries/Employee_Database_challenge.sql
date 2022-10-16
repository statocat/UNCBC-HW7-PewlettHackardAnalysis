-- DELVIERABLE 6.1: Number of Retiring Employees by Title
--6.1.1 to 6.1.7 retirement_titles table creation
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees AS e
LEFT JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--6.1.8 to 6.1.15 current retirement titles table creation
SELECT DISTINCT ON(rt.emp_no) rt.emp_no, rt.first_name, rt.last_name, rt.title 
INTO unique_titles
FROM retirement_titles AS rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

-- 6.1.16 to 6.1.21 retiring titles by count table creation
SELECT COUNT(ut.emp_no), ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.emp_no) DESC;

--Deliverable 6.2: Mentorship Program Eligible Employees
-- Noticed (same as Klaus) the results in title column 
-- were not consistent run-to-run in using de.to_date = '9999-01-01'.
-- It seems the from_date and to_dates in dept_emp table do not capture promotions, 
-- only hire date, termination date and cross-departmental moves. 
-- Whereas titles table seems to capture more information about all titles held during an employee's tenure.
-- Thus, a 1-1 relationship does not necessarily exist between (emp_no de.to_date = '9999-01-1') and ti.title
-- for all employees in table, yielding the inconsistent results in title colummn.
-- Based on this observation, chose to use ti.to_date = '9999-01-01' in addition to de.to_date = '9999-01-01'.
-- This resulted in consistently in getting the most current (senior) title.
SELECT DISTINCT ON (e.emp_no)
	e.emp_no, 
	e.first_name, 
	e.last_name, 
	e.birth_date, 
	de.from_date, 
	de.to_date, 
	ti.title
INTO mentorship_eligibility
FROM employees AS e
LEFT JOIN dept_emp AS de 
ON (e.emp_no = de.emp_no)
LEFT JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
	AND (ti.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;