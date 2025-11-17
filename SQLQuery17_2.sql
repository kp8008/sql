-- Create the DEPT table first, as PERSON depends on it
CREATE TABLE DEPT (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    DepartmentCode VARCHAR(50) NOT NULL UNIQUE,
    Location VARCHAR(50) NOT NULL
);

-- Create the PERSON table with a Foreign Key
CREATE TABLE PERSON (
    PersonID INT PRIMARY KEY,
    PersonName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    Salary DECIMAL(8, 2) NOT NULL,
    JoiningDate DATE NOT NULL,
    City VARCHAR(100) NOT NULL,
    FOREIGN KEY (DepartmentID) REFERENCES DEPT(DepartmentID)
);

-- Insert data into the DEPT table
INSERT INTO DEPT (DepartmentID, DepartmentName, DepartmentCode, Location)
VALUES
(1, 'Admin', 'Adm', 'A-Block'),
(2, 'Computer', 'CE', 'C-Block'),
(3, 'Civil', 'CI', 'G-Block'),
(4, 'Electrical', 'EE', 'E-Block'),
(5, 'Mechanical', 'ME', 'B-Block'),
(6, 'Marketing', 'Mkt', 'F-Block'),
(7, 'Accounts', 'Acc', 'A-Block');

-- Insert data into the PERSON table
INSERT INTO PERSON (PersonID, PersonName, DepartmentID, Salary, JoiningDate, City)
VALUES
(101, 'Rahul Tripathi', 2, 56000.00, '2000-01-01', 'Rajkot'),
(102, 'Hardik Pandya', 3, 18000.00, '2001-09-25', 'Ahmedabad'),
(103, 'Bhavin Kanani', 4, 25000.00, '2000-05-14', 'Baroda'),
(104, 'Bhoomi Vaishnav', 1, 39000.00, '2005-02-08', 'Rajkot'),
(105, 'Rohit Topiya', 2, 17000.00, '2001-07-23', 'Jamnagar'),
(106, 'Priya Menpara', NULL, 9000.00, '2000-10-18', 'Ahmedabad'),
(107, 'Neha Sharma', 2, 34000.00, '2002-12-25', 'Rajkot'),
(108, 'Nayan Goswami', 3, 25000.00, '2001-07-01', 'Rajkot'),
(109, 'Mehul Bhundiya', 4, 13500.00, '2005-01-09', 'Baroda'),
(110, 'Mohit Maru', 5, 14000.00, '2000-05-25', 'Jamnagar'),
(111, 'Alok Nath', 2, 36000.00, '2003-03-15', 'Ahmedabad'),
(112, 'Seema Jain', 3, 28000.00, '2002-06-18', 'Baroda'),
(113, 'Karan Singh', 1, 41000.00, '2004-11-30', 'Rajkot'),
(114, 'Riya Gupta', 5, 16000.00, '2001-02-12', 'Ahmedabad'),
(115, 'Suresh Patel', 7, 32000.00, '2003-08-20', 'Jamnagar'),
(116, 'Meena Kumari', 7, 30000.00, '2004-01-01', 'Rajkot'),
(117, 'Vikram Batra', NULL, 11000.00, '2005-04-05', 'Baroda');


--🗂️ Queries: Part – A

--1. Combine information from Person and Department table using cross join or Cartesian product. 
SELECT P.PersonName, D.DepartmentName
FROM DEPT AS D
CROSS JOIN PERSON AS P

--2. Find all persons with their department name. 
SELECT P.PersonName, D.DepartmentName
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID

--3. Find all persons with their department name & code. Expected Output (Partial):
SELECT P.PersonName, D.DepartmentName,D.DepartmentCode
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID

--4. Find all persons with their department code and location. 
SELECT P.PersonName,D.DepartmentCode,D.Location
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID

--5. Find the detail of the person who belongs to Mechanical department. 
SELECT P.*
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE D.DepartmentName = 'Mechanical'

--6. Final person’s name, department code and salary who lives in Ahmedabad city.
SELECT P.PersonName,D.DepartmentCode,P.Salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE P.City = 'Ahmedabad'

--7. Find the person's name whose department is in C-Block. Expected Output:
SELECT P.PersonName
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE D.Location = 'C-Block'

--8. Retrieve person name, salary & department name who belongs to Jamnagar city. Expected Output:
SELECT P.PersonName,D.DepartmentName,P.Salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE P.City = 'Jamnagar'

--9. Retrieve person’s detail who joined the Civil department after 1-Aug-2001. Expected Output:
SELECT P.*
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE D.DepartmentName = 'Civil' AND P.JoiningDate > '1-Aug-2001'

--10. Display all the person's name with the department whose joining date difference with the current date is more than 365 days. 
SELECT P.PersonName,D.DepartmentName
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE DATEDIFF(day,p.JoiningDate,getdate()) > 365
 
 --11. Find department wise person counts. Expected Output:
 SELECT D.DepartmentName,COUNT(P.PersonID)
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
GROUP BY D.DepartmentName

--12. Give department wise maximum & minimum salary with department name. Expected Output:
SELECT D.DepartmentName,MAX(P.Salary) AS Max_Salary,MIN(P.Salary) AS Min_Salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
GROUP BY D.DepartmentName

--13. Find city wise total, average, maximum and minimum salary. Expected Output:
SELECT P.City,MAX(P.Salary) AS Max_Salary,MIN(P.Salary) AS Min_Salary,
AVG(P.Salary) as Avg_Salary, SUM(P.Salary) as Total_salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
GROUP BY P.City

--14. Find the average salary of a person who belongs to Ahmedabad city. Expected Output:
SELECT 
AVG(P.Salary) as Avg_Salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE P.City = 'Ahmedabad'

--15. Produce Output Like: <PersonName> lives in <City> and works in <DepartmentName> Department. (In single column).
SELECT 
    P.PersonName + ' lives in ' + P.City + ' and works in ' + D.DepartmentName + ' Department.' 
        
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
