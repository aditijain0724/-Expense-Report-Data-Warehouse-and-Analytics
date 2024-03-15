USE expense;

USE expense;
CREATE OR REPLACE VIEW expense_dw_report AS
SELECT ssn,first_name,last_name, dept_name,
COUNT(trip_id) number_trips,
ROUND(sum(amount),2) total_spent
FROM
(SELECT ssn, first_name, last_name, dept_name, t.trip_id, 
reason_code, 
gross_amount+tax AS amount
FROM trips t
JOIN employees e
ON e.ssn=t.employee 
JOIN expenses x
ON t.trip_id=x.trip_id 
JOIN dept_codes d ON e.dept=d.dept_id) t 
GROUP BY ssn;

#new queries on this view 

#1 no. of trips for each reason in descending order
SELECT reason_description, count(*) total_trips
FROM expense_dw_report e
JOIN trips t
ON t.employee=e.ssn
JOIN reason_codes r
ON t.reason_code=r.reason_code
GROUP BY t.reason_code
ORDER BY total_trips DESC
limit 25;

#2 total amt spent by dept
SELECT dept_name,sum(total_spent) total
FROM expense_dw_report
GROUP BY dept_name
ORDER BY total DESC;

#3 total trips by dept
SELECT dept_name,sum(number_trips) s
FROM expense_dw_report
GROUP BY dept_name;

#4  reimbursements per dept
SELECT dept_name, ROUND(SUM(reimbursement_amount),2) reimbursement
FROM expense_dw_report exp
JOIN reimbursements reim
ON exp.ssn = reim.employee
GROUP BY dept_name
ORDER BY reimbursement DESC;


