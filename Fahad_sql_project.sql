/*Create a database named employee*/
create database employee; 
use employee;
/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table
, and make a list of employees and details of their department*/
Select EMP_ID,concat(first_name,LAST_NAME) AS Employee_Name, GENDER, DEPT from emp_record_table;
/*Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is*/
/*less than two*/
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, dept, EMP_RATING from emp_record_table where EMP_RATING<2; 
/*greater than four */
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, dept, EMP_RATING from emp_record_table where EMP_RATING>4; 
/*between two and four*/
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, dept, EMP_RATING from emp_record_table where EMP_RATING between 2 and 4; 
/*Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees
 in the Finance department from the employee table and then give the resultant column alias as NAME*/
 select concat( first_name, last_name) AS Name,Dept from emp_record_table where dept= 'finance'; 
/*Write a query to list only those employees who have someone reporting to them. 
Also, show the number of reporters (including the President).*/
select e1.emp_id AS manager_id, e1.first_name As manager_name, count(e2.emp_id)AS reporting_count from emp_record_table e1
JOIN emp_record_table e2
ON e1.EMP_ID = e2.MANAGER_ID
group by e1.EMP_ID, e1.FIRST_NAME, e1.LAST_NAME;
/*Write a query to list down all the employees from the healthcare and finance departments using union
. Take data from the employee record table*/
select Emp_id,concat(first_name, last_name) Name, DEPT from emp_record_table where dept = 'finance' 
union
select Emp_id,concat(first_name, last_name) Name, DEPT from emp_record_table  where dept = 'healthcare';
/*Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT,
 and EMP_RATING grouped by dept. 
 Also include the respective employee rating along with the max emp rating for the department*/
 -- using over function
select emp_id, first_name,last_name,role, emp_rating,dept, max(emp_rating) over (partition by dept) As Max_rating
from emp_record_table order by dept,emp_rating desc;
-- using subquery
 select first.emp_id, first.dept, sec.MAX from emp_record_table As first
 inner join ( select dept,max(emp_rating) AS max from emp_record_table group by dept)
 As sec
 on first.dept=sec.dept;
-- Write a query to calculate the minimum and the maximum salary of the employees in each role
Select Role, min(salary) Min_salary, max(salary) Max_Salary from emp_record_table group by role;

-- Write a query to assign ranks to each employee based on their experience.;
  select emp_id, first_name, last_name,role, dept, exp ,rank() over(order by exp desc) 'Rank' from  emp_record_table;
-- Write a query to create a view that displays employees in various countries whose salary is more than six thousand
create view Emp6000 as select * from emp_record_table where salary>6000;
select * from emp6000;
-- Write a nested query to find employees with experience of more than ten years 
select emp_id,first_name, last_name, exp from (select first_name, last_name, emp_id,exp from emp_record_table where exp>10 ) As test
-- Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years
Delimiter //
create procedure allemployeeexpgreater5()
Begin
Select* from emp_record_table where exp>5;
end //
call allemployeeexpgreater5();
/*Write a query using stored functions in the project table to check
 whether the job profile assigned to each employee in the data science team matches the organization’s set 
 standard.
The standard being:
For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
For an employee with the experience of 12 to 16 years assign 'MANAGER'.*/
select * from data_science_team;
DELIMITER //

CREATE FUNCTION get_job_profile(exp INT) 
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE job_profile VARCHAR(50);
    
    IF exp <= 2 THEN
        SET job_profile = 'JUNIOR DATA SCIENTIST';
    ELSEIF exp > 2 AND exp <= 5 THEN
        SET job_profile = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF exp > 5 AND exp <= 10 THEN
        SET job_profile = 'SENIOR DATA SCIENTIST';
    ELSEIF exp > 10 AND exp <= 12 THEN
        SET job_profile = 'LEAD DATA SCIENTIST';
    ELSEIF exp > 12 AND exp <= 16 THEN
        SET job_profile = 'MANAGER';
    ELSE
        SET job_profile = 'UNKNOWN';
    END IF;
    
    RETURN job_profile;
END //

DELIMITER ;
SELECT emp_id, first_name, last_name, role, exp,
       get_job_profile(exp) AS expected_role,
       CASE
           WHEN role = get_job_profile(exp) THEN 'MATCH'
           ELSE 'MISMATCH'
       END AS role_check
FROM data_science_team;
-- Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
CREATE INDEX idx_first_name ON emp_record_table (first_name(50));
SELECT * FROM emp_record_table WHERE first_name = 'eric';
-- Write a query to calculate the bonus for all the employees, 
-- based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
SELECT 
    EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (SALARY * 0.05 * EMP_RATING) AS BONUS
FROM 
    emp_record_table;
-- Write a query to calculate the average salary distribution based on the continent and country. 

select country, continent, avg(Salary) over ( partition by country) AVG_Salary_Distr_Country,
avg(Salary) over ( partition by Continent) AVG_Salary_Distr_Continent from emp_record_table;