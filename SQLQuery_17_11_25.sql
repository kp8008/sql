CREATE TABLE EMP (
    EID INT PRIMARY KEY,
    EName VARCHAR(50),
    Department VARCHAR(50),
    Salary INT,
    JoiningDate DATE,
    City VARCHAR(50),
    Gender VARCHAR(10)
);

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


--1. Display the Highest, Lowest, Label the columns Maximum, Minimum respectively.
SELECT
	MAX(Salary) as Highest,
	MIN(Salary) as Lowest
FROM EMP 

--2. Display Total, and Average salary of all employees. Label the columns Total_Sal and Average_Sal, respectively. 
SELECT
	SUM(Salary) as Total,
	AVG(Salary) as Average
FROM EMP 

--3. Find total number of employees of EMPLOYEE table.
SELECT
	COUNT(EID) as Total_Employees 
FROM EMP 

--4. Find highest salary from Rajkot city. 
SELECT
	MAX(Salary) as Highest
FROM EMP 
WHERE City = 'Rajkot'

--5. Give maximum salary from IT department. 
SELECT
	MAX(Salary) as Max_Salary_IT 
FROM EMP 
WHERE Department = 'IT'

--6. Count employee whose joining date is after 8-Feb-91. 
SELECT
	COUNT(EID) as Employee_Count  
FROM EMP 
WHERE JoiningDate < '8-FEB-91'

--7. Display average salary of Admin department.
SELECT
	AVG(Salary) as Avg_Salary_Admin   
FROM EMP 
WHERE Department = 'Admin'

--8. Display total salary of HR department.
SELECT
	SUM(Salary) as Total_Salary_HR    
FROM EMP 
WHERE Department = 'HR'

--9. Count total number of cities of employee without duplication.
SELECT
	COUNT(DISTINCT City) as Unique_Cities     
FROM EMP 

--10. Count unique departments. 
SELECT
	COUNT(DISTINCT Department) as Unique_DepartmentS    
FROM EMP

--11. Give minimum salary of employee who belongs to Ahmedabad. 
SELECT
	MIN(Salary) as Min_Salary_Ahmedabad     
FROM EMP 
WHERE City = 'Ahmedabad'

--12. Find city wise highest salary. 
SELECT
	City,
	MAX(Salary) as Max_Salary     
FROM EMP 
GROUP BY City

--13. Find department wise lowest salary. 
SELECT
	Department,
	MIN(Salary) as MIN_Salary     
FROM EMP 
GROUP BY Department

--14. Display city with the total number of employees belonging to each city. Expected Output:
SELECT
	City,
	COUNT(EID) as Employee_Count      
FROM EMP 
GROUP BY City

--15. Give total salary of each department of EMP table. 
SELECT
	Department,
	SUM(Salary) as Total_Salary       
FROM EMP 
GROUP BY Department

--16. Give average salary of each department of EMP table without displaying the respective department name.
SELECT
	AVG(Salary) as Average_Salary        
FROM EMP 
GROUP BY Department

--17. Count the number of employees for each department in every city.
SELECT
	Department,
	City,
	COUNT(EID) as Employee_Count         
FROM EMP 
GROUP BY Department , City

--18. Calculate the total salary distributed to male and female employees. 
SELECT
	Gender,
	SUM(Salary) as Total_Salary        
FROM EMP 
GROUP BY Gender

--19. Give city wise maximum and minimum salary of female employees. 
SELECT
	City,
	MAX(Salary) as Highest,
	MIN(Salary) as Lowest
FROM EMP
WHERE Gender = 'female'
GROUP BY City

--20. Calculate department, city, and gender wise average salary.
SELECT
	Department,
	City,
	Gender,
	AVG(Salary) as Average_Salary 
FROM EMP
GROUP BY Department,City,Gender

--Part – B

--1. Count the number of employees living in Rajkot.
SELECT
	COUNT(EID) as Rajkot_Employees         
FROM EMP 
WHERE City = 'Rajkot'

--2. Display the difference between the highest and lowest salaries. Label the column DIFFERENCE. 
SELECT
	MAX(Salary) - MIN(Salary) AS DIFFERENCE
FROM EMP

--3. Display the total number of employees hired before 1st January, 1991. 
SELECT
	COUNT(EID) as Hired_Before_1991          
FROM EMP 
WHERE JoiningDate <= '1991-01-01'

--Part – C


--1. Count the number of employees living in Rajkot or Baroda.
SELECT
	COUNT(EID) as Employee_Count           
FROM EMP 
WHERE City IN ('Rajkot','Baroda')

--2. Display the total number of employees hired before 1st January, 1991 in IT department. Expected Output:
SELECT
	COUNT(EID) as Hired_Before_1991          
FROM EMP 
WHERE JoiningDate <= '1991-01-01' AND Department = 'IT'

--3. Find the Joining Date wise Total Salaries.
SELECT
	JoiningDate,
	SUM(Salary) as Total_Salary           
FROM EMP 
GROUP BY JoiningDate

--4. Find the Maximum salary department & city wise in which city name starts with ‘R’.
SELECT
	Department,
	City,
	MAX(Salary) as Max_Salary  
FROM EMP
WHERE City LIKE 'R%'
GROUP BY Department,City

--🛒 Queries on SALES_DATA Table

--Part – A

--1. Display Total Sales Amount by Region.
SELECT
	Region,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Region

--2. Display Average Sales Amount by Product. Expected Output:
SELECT
	Product,
	AVG(Sales_Amount) as Avg_Sales   
FROM SALES_DATA
GROUP BY Product

--3. Display Maximum Sales Amount by Year. 
SELECT
	Year,
	MAX(Sales_Amount) as Max_Sales   
FROM SALES_DATA
GROUP BY Year

--4. Display Minimum Sales Amount by Region and Year. Expected Output:
SELECT
	Region,
	Year,
	MIN(Sales_Amount) as Min_Sales   
FROM SALES_DATA
GROUP BY Region        ,Year

--5. Count of Products Sold by Region. 
SELECT
	Region,
	COUNT(Product) as Product_Count    
FROM SALES_DATA
GROUP BY Region

--6. Display Sales Amount by Year and Product.
SELECT
	Product,
	Year,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Product        ,Year

--7. Display Regions with Total Sales Greater Than 5000.
SELECT
	Region,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Region
HAVING SUM(Sales_Amount) > 5000

--8. Display Products with Average Sales Less Than 10000. Expected Output:
SELECT
	Product,
	AVG(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Product
HAVING AVG(Sales_Amount) < 10000

--9. Display Years with Maximum Sales Exceeding 500.
SELECT
	Year,
	MAX(Sales_Amount) as Max_Sales   
FROM SALES_DATA
GROUP BY Year
HAVING MAX(Sales_Amount) > 500

--10. Display Regions with at Least 3 Distinct Products Sold. 
SELECT
	Region,
	COUNT(DISTINCT Product) as Total_Sales   
FROM SALES_DATA
GROUP BY Region
HAVING COUNT(DISTINCT Product) > 3

--11. Display Years with Minimum Sales Less Than 1000.
SELECT
	Year,
	MIN(Sales_Amount) as Min_Sales   
FROM SALES_DATA
GROUP BY Year
HAVING MIN(Sales_Amount) < 1000

--12. Display Total Sales Amount by Region for Year 2023, Sorted by Total Amount. Expected Output:
SELECT
	Region,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
WHERE Year = '2023'
GROUP BY Region
ORDER BY SUM(Sales_Amount) ASC

--13. Find the Region Where 'Mobile' Had the Lowest Total Sales Across All Years.
SELECT
	Top 1 Region,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
WHERE Product = 'Mobile'
GROUP BY Region
ORDER BY SUM(Sales_Amount) ASC


--14. Find the Product with the Highest Sales Across All Regions in 2023. 
SELECT
	Top 1 Product,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
WHERE Product = 'Watch'
GROUP BY Product
ORDER BY SUM(Sales_Amount) DESC

--15. Find Regions Where 'TV' Sales in 2023 Were Greater Than 1000. Expected Output:
SELECT
	Region,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
WHERE Year = '2023' and Product = 'TV'
GROUP BY Region
HAVING SUM(Sales_Amount) > 1000

--Part – B

--1. Display Count of Orders by Year and Region, Sorted by Year and Region.
SELECT
	Region,
	Year,
	COUNT(Product) as Total_Sales   
FROM SALES_DATA
GROUP BY Region , Year
ORDER BY Year , Region

--2. Display Regions with Maximum Sales Amount Exceeding 1000 in Any Year, Sorted by Region. Expected Output:
SELECT
	Region,
	MAX(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Region
HAVING MAX(Sales_Amount) > 1000
ORDER BY Region

--3. Display Years with Total Sales Amount Less Than 10000, Sorted by Year Descending. Expected Output:
SELECT
	Year,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Year
HAVING SUM(Sales_Amount) < 10000
ORDER BY Year

--4. Display Top 3 Regions by Total Sales Amount in Year 2024. Expected Output:
SELECT
	Top 3 Region,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
WHERE Year = '2024'
GROUP BY Region
ORDER BY SUM(Sales_Amount) ASC

--5. Find the Year with the Lowest Total Sales Across All Regions.
SELECT
	 TOP 1 Year,
	SUM(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Year
ORDER BY SUM(Sales_Amount) ASC

--Part – C

--1. Display Products with Average Sales Amount Between 1000 and 2000, Ordered by Product Name. 
SELECT
	Product,
	AVG(Sales_Amount) as Total_Sales   
FROM SALES_DATA
GROUP BY Product
HAVING AVG(Sales_Amount) >= 1000 AND AVG(Sales_Amount) <= 2000
ORDER BY Product

--2. Display Years with More Than 1 Orders from Each Region. 
SELECT
	Year   
FROM SALES_DATA
GROUP BY Year
HAVING COUNT(Product) >1

--3. Display Regions with Average Sales Amount Above 1500 in Year 2023 sort by amount in descending. Expected Output:
SELECT
	Region,
	AVG(Sales_Amount) as Total_Sales   
FROM SALES_DATA
WHERE Year = '2023'
GROUP BY Region
HAVING AVG(Sales_Amount) >1500 
ORDER BY AVG(Sales_Amount) DESC

--4. Find out region wise duplicate product. 
SELECT
	Region,
	Product,
	COUNT(*)
FROM SALES_DATA
GROUP BY Region,Product
HAVING COUNT(*)>1
ORDER BY Region,Product


--5. Find out year wise duplicate product. Expected Output:
SELECT
	Year,
	Product,
	COUNT(*)
FROM SALES_DATA
GROUP BY Year,Product
HAVING COUNT(*)>1
ORDER BY Year,Product

















