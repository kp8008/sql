-- Create the EMP table
CREATE TABLE EMP (
    EID INT PRIMARY KEY,
    EName VARCHAR(50),
    Department VARCHAR(50),
    Salary INT,
    JoiningDate DATE,
    City VARCHAR(50),
    Gender VARCHAR(10)
);

-- Insert data into the EMP table
INSERT INTO EMP (EID, EName, Department, Salary, JoiningDate, City, Gender)
VALUES
(101, 'Rahul', 'Admin', 56000, '1990-01-01', 'Rajkot', 'Male'),
(102, 'Hardik', 'IT', 18000, '1990-09-25', 'Ahmedabad', 'Male'),
(103, 'Bhavin', 'HR', 25000, '1991-05-14', 'Baroda', 'Male'),
(104, 'Bhoomi', 'Admin', 39000, '1991-02-08', 'Rajkot', 'Female'),
(105, 'Rohit', 'IT', 17000, '1990-07-23', 'Jamnagar', 'Male'),
(106, 'Priya', 'IT', 9000, '1990-10-18', 'Ahmedabad', 'Female'),
(107, 'Bhoomi', 'HR', 34000, '1991-12-25', 'Rajkot', 'Female'),
(108, 'Manish', 'IT', 22000, '1990-04-20', 'Baroda', 'Male'),
(109, 'Kavita', 'Admin', 35000, '1992-03-12', 'Ahmedabad', 'Female'),
(110, 'Suresh', 'HR', 28000, '1991-11-05', 'Jamnagar', 'Male'),
(111, 'Pooja', 'IT', 19000, '1991-01-30', 'Rajkot', 'Female'),
(112, 'Amit', 'Admin', 42000, '1990-08-19', 'Baroda', 'Male'),
(113, 'Rekha', 'HR', 31000, '1992-07-02', 'Ahmedabad', 'Female'),
(114, 'Vijay', 'IT', 20000, '1990-06-11', 'Rajkot', 'Male'),
(115, 'Meera', 'Admin', 38000, '1991-10-09', 'Jamnagar', 'Female');

-- Create the SALES_DATA table
CREATE TABLE SALES_DATA (
    Region VARCHAR(50),
    Product VARCHAR(50),
    Sales_Amount INT,
    Year INT
);

-- Insert data into the SALES_DATA table
INSERT INTO SALES_DATA (Region, Product, Sales_Amount, Year)
VALUES
('North America', 'Watch', 1500, 2023),
('Europe', 'Mobile', 1200, 2023),
('Asia', 'Watch', 1800, 2023),
('North America', 'TV', 900, 2024),
('Europe', 'Watch', 2000, 2024),
('Asia', 'Mobile', 1000, 2024),
('North America', 'Mobile', 1600, 2023),
('Europe', 'TV', 1500, 2023),
('Asia', 'TV', 1100, 2024),
('North America', 'Watch', 1700, 2024),
('Asia', 'Watch', 2200, 2024),
('Europe', 'Mobile', 1400, 2024),
('North America', 'TV', 1300, 2023),
('Asia', 'TV', 1000, 2023),
('Europe', 'Watch', 1800, 2023),
('North America', 'Mobile', 1100, 2024),
('Asia', 'Laptop', 3000, 2023),
('Europe', 'Laptop', 3500, 2024),
('North America', 'Laptop', 2800, 2024),
('Asia', 'Mobile', 1300, 2023);


----------------------------------------------------------------------------------------
select * from EMP
select * from SALES_DATA

-------------------------------
---Part-A---EMP----
--1. Display the Highest, Lowest, Label the columns Maximum, Minimum respectively.
select MAX(salary) as maximun,
	   MIN(salary) as minimum
	from EMP

--2. Display Total, and Average salary of all employees. Label the columns Total_Sal and Average_Sal, respectively
select sum(salary) as total,
	   avg(salary) as avg
	   from emp

--3. Find total number of employees of EMPLOYEE table.
select count(*) as total_employee
from EMP

--4. Find highest salary from Rajkot city
select max(salary) as max_rajkot
from EMP
where city='rajkot'

--5. Give maximum salary from IT department.
select max(salary) as max_it
from EMP
where department='it'

--6. Count employee whose joining date is after 8-Feb-91
select count(eid) as emp_count
from emp
where joiningdate>'1991-02-08'

--7. Display average salary of Admin department
select avg(salary) as avg_admin
from emp
where department='admin'

--8. Display total salary of HR department.
select sum(salary) as total_hr
from emp
where department = 'hr'

--9. Count total number of cities of employee without duplication.
select count(distinct city) as total_cities
from emp

--10. Count unique departments
select count(distinct department) as department
from emp

--11. Give minimum salary of employee who belongs to Ahmedabad.
select min(salary) as max_ahm
from EMP
where city='ahmedabad'

--12. Find city wise highest salary.
select city,max(salary) as max_salary
from emp
group by city
order by max_salary desc

--13. Find department wise lowest salary.
select department,min(salary) as min_salary
from emp
group by department

--14. Display city with the total number of employees belonging to each city.
select city,count(eid) as emp_city_wise
from emp
group by city

--15. Give total salary of each department of EMP table.
select department,sum(salary) as emp_salary_department
from emp
group by department

--16. Give average salary of each department of EMP table without displaying the respective department name
select avg(salary) as emp_salary_avg
from emp
group by department

--17. Count the number of employees for each department in every city
select department,city,count(eid) as emp_count
from emp
group by department,city

--18 Calculate the total salary distributed to male and female employees
select gender,sum(salary) as totalsalary
from emp
group by gender

--19.Give city wise maximum and minimum salary of female employees
select city, max(salary) as max_salary,
				   min(salary) as min_salary	
from emp
where gender='female'
group by city

--20 Calculate department, city, and gender wise average salary
select department,city,gender, avg(salary) as avg_salary
from emp
group by department,city,gender

---PART-B-----
--1. Count the number of employees living in Rajkot. 
select count(eid) as rajkot_employee
from emp
where city='rajkot'

--2. Display the difference between the highest and lowest salaries. Label the column DIFFERENCE.
select max(salary)-min(salary) as difference
from emp

--3. Display the total number of employees hired before 1st January, 1991.
select count(eid) as hired_before_1991
from emp
where joiningdate < '1991-01-01'

--PART-C---
--1. Count the number of employees living in Rajkot or Baroda.
select count(eid) as rajkot_baroda_employee
from emp
where city='rajkot' or city='baroda'

--2. Display the total number of employees hired before 1st January, 1991 in IT department.
select count(eid) as hired_before_1991
from emp
where joiningdate < '1991-01-01' and department='it'

--3. Find the Joining Date wise Total Salaries.
select joiningdate,sum(salary) as total_salary
from emp
group by joiningdate

--4. Find the Maximum salary department & city wise in which city name starts with ‘R’
select department,city, max(salary) as MAx_salary
from emp
where city like'R%'
group by department,city

--=================================================================
--Queries on SALES_DATA Table
--Part-A--

--1. Display Total Sales Amount by Region
select region,sum(sales_amount) as total_sales
from sales_data
group by region

--2. Display Average Sales Amount by Product
select product,avg(sales_amount) as avg_sales
from sales_data
group by product

--3. Display Maximum Sales Amount by Year. 
select year,max(sales_amount) as max_sales
from sales_data
group by year

--4. Display Minimum Sales Amount by Region and Year.
select year,region,min(sales_amount) as min_sales
from sales_data
group by year,region

--5. Count of Products Sold by Region
select region,count(product) as product_count
from sales_data
group by region

--6. Display Sales Amount by Year and Product.
select year,product,sum(sales_amount) as total_sales
from sales_data
group by year,product

--7. Display Regions with Total Sales Greater Than 5000.
select region,sum(sales_amount) as total_sales
from sales_data
group by region
having sum(sales_amount)>5000

--8. Display Products with Average Sales Less Than 10000
select product,avg(sales_amount) as avg_sales
from sales_data
group by product
having avg(sales_amount)<10000

--9. Display Years with Maximum Sales Exceeding 500
select year,max(sales_amount) as max_sales
from sales_data
group by year
having max(sales_amount)>500

--10. Display Regions with at Least 3 Distinct Products Sold.
select region,count(distinct product) as distinct_product
from sales_data
group by region

--11. Display Years with Minimum Sales Less Than 1000. 

--12. Display Total Sales Amount by Region for Year 2023, Sorted by Total Amount

--13. Find the Region Where 'Mobile' Had the Lowest Total Sales Across All Years

--14. Find the Product with the Highest Sales Across All Regions in 2023. 

--15. Find Regions Where 'TV' Sales in 2023 Were Greater Than 1000.


------PART-B----
--1. Display Count of Orders by Year and Region, Sorted by Year and Region.

--2. Display Regions with Maximum Sales Amount Exceeding 1000 in Any Year, Sorted by Region. 

--3.Display Years with Total Sales Amount Less Than 10000, Sorted by Year Descending.

--4 Display Top 3 Regions by Total Sales Amount in Year 2024.

--5 Find the Year with the Lowest Total Sales Across All Regions


---Part-c--

--1. Display Products with Average Sales Amount Between 1000 and 2000, Ordered by Product Name

--2 Display Years with More Than 1 Orders from Each Region

--3 Display Regions with Average Sales Amount Above 1500 in Year 2023 sort by amount in descending.

--4 Find out region wise duplicate product. 

--5  Find out year wise duplicate product. 