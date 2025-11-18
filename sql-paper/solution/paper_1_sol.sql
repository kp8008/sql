--📜 Paper 1: Table & Data Generation Scripts

--1. Table Generation Script (DDL)

-- Create Department Table
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL
);

-- Create Employee Table
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    City VARCHAR(50),
    Mobile VARCHAR(20),
    JoiningDate DATE,
    Salary DECIMAL(10, 2),
    DeptID INT FOREIGN KEY REFERENCES Department(DeptID)
);

--2. Sample Data Insertion (DML)

-- Insert Sample Departments
INSERT INTO Department (DeptID, DeptName) VALUES
(1, 'Computer'),
(2, 'Civil'),
(3, 'Mechanical'),
(4, 'HR'),
(5, 'Finance');

-- Insert Sample Employees
INSERT INTO Employee (EmpID, Name, Email, City, Mobile, JoiningDate, Salary, DeptID) VALUES
-- Q1: Changa
(101, 'Sandeep', 'sandeep@test.com', 'Mumbai', '1112223334', '2021-05-15', 50000.00, 1),
(102, 'Rajesh Kumar', 'rajesh@test.com', 'Changa', '2223334445', '2022-03-10', 55000.00, 1),

-- Q2: Joined after 01 Jun 2022, Computer or Civil
(103, 'Priya Sharma', 'priya@test.com', 'Pune', '3334445556', '2022-06-05', 60000.00, 1),
(104, 'Amit Singh', 'amit@test.com', 'Delhi', '4445556667', '2022-07-20', 62000.00, 2),

-- Q3: No mobile or email
(105, 'Sneha Patel', 'sneha@test.com', 'Pune', NULL, '2021-08-01', 58000.00, 1),
(106, 'Vikram Rathod', NULL, 'Mumbai', '6667778889', '2022-01-12', 53000.00, 2),

-- Q4/Q5: Top salaries
(107, 'Anjali Mehta', 'anjali@test.com', 'Delhi', '7778889990', '2020-02-18', 90000.00, 1),
(108, 'Manish Jain', 'manish@test.com', 'Changa', '8889990001', '2021-11-05', 85000.00, 2),
(109, 'Kavita Iyer', 'kavita@test.com', 'Pune', '9990001112', '2022-04-30', 88000.00, 1),

-- Q5: Top 3 dept wise
(110, 'Rahul Dave', 'rahul@test.com', 'Mumbai', '1231231234', '2021-09-22', 82000.00, 2),
(111, 'Meera Krishnan', 'meera@test.com', 'Delhi', '2342342345', '2022-08-14', 86000.00, 1),

-- Q9: Dept with > 9 (Computer will have 10)
(112, 'Varun Gill', 'varun@test.com', 'Pune', '3453453456', '2023-01-01', 50000.00, 1),
(113, 'Deepak Shah', 'deepak@test.com', 'Changa', '4564564567', '2023-02-11', 48000.00, 1),
(114, 'Nisha Verma', 'nisha@test.com', 'Mumbai', '5675675678', '2023-03-15', 47000.00, 1),
(115, 'Suresh Reddy', 'suresh@test.com', 'Delhi', '6786786789', '2023-04-20', 46000.00, 1),

-- Q10: Mechanical
(116, 'Rina Desai', 'rina@test.com', 'Pune', '7897897890', '2022-05-10', 60000.00, 3),
(117, 'Gaurav Kumar', 'gaurav@test.com', 'Mumbai', '8908908901', '2022-06-12', 65000.00, 3),

-- Q12: HR > 45k
(118, 'Pooja Singh', 'pooja@test.com', 'Delhi', '9019019012', '2021-07-07', 48000.00, 4),
(119, 'Alok Nath', 'alok@test.com', 'Pune', '0120120123', '2022-09-30', 40000.00, 4),

-- Q13: Same name
(120, 'Amit Singh', 'amit2@test.com', 'Pune', '1122112211', '2023-05-01', 51000.00, 5),
(121, 'Priya Sharma', 'priya2@test.com', 'Mumbai', '2233223322', '2023-06-10', 70000.00, 5);


--🚀 Paper 1: SQL Queries

--Question 1: List all Employees which belongs to Changa.
SELECT * FROM Employee
WHERE City = 'Changa'

--Question 2: List all Employees who joined after 01 Jun, 2022 and belongs to either Computer or Civil.
SELECT D.DeptName,E.Name,E.JoiningDate
FROM Department AS D 
INNER JOIN Employee AS E
ON D.DeptID = E.DeptID
WHERE D.DeptName IN ('Computer','Civil') AND E.JoiningDate > '2022-06-01'

--Question 3: List all Employees with department name who don't have either mobile or email.
SELECT E.Name,E.Email,E.Mobile, D.DeptName
FROM Department AS D 
INNER JOIN Employee AS E
ON D.DeptID = E.DeptID
WHERE E.Email IS NULL OR E.Mobile IS NULL

--Question 4: List top 5 employees as per salaries.
SELECT TOP 5 * FROM Employee
ORDER BY Salary DESC

--Question 5: List top 3 employees department wise as per salaries.
WITH ROWDEPT AS (
    SELECT 
        E.Name,
        E.Salary,
        D.DeptName,
        ROW_NUMBER() OVER (
            PARTITION BY D.DeptName
            ORDER BY E.Salary DESC
        ) AS RN
    FROM Department AS D
    INNER JOIN Employee AS E
        ON D.DeptID = E.DeptID
)

SELECT 
    DeptName,
    Name,RN
    Salary
FROM ROWDEPT
WHERE RN <= 3;

--Question 6: List City with Employee Count.
SELECT  City,COUNT(EmpID)
FROM Employee
GROUP BY City

--Question 7: List City Wise Maximum, Minimum & Average Salaries & Give Proper Name As MaxSal, MinSal & AvgSal.
SELECT  City,MAX(Salary) AS MaxSal,MIN(Salary) AS MinSal,AVG(Salary) AS AvgSal
FROM Employee
GROUP BY City

--Question 8: List Department wise City wise Employee Count.
SELECT  D.DeptName,E.City,COUNT(E.EmpID)
FROM Employee as E INNER JOIN Department AS D
ON E.DeptID = D.DeptID
GROUP BY D.DeptName,E.City

--Question 9: List Departments with more than 9 employees.
SELECT  D.DeptName,COUNT(E.EmpID)
FROM Employee as E INNER JOIN Department AS D
ON E.DeptID = D.DeptID
GROUP BY D.DeptName
HAVING COUNT(E.EmpID) > 9

--Question 10: Give 10% increment in salary to all employees who belongs to Mechanical Department.
update E
SET E.Salary = E.Salary + E.Salary * 10
FROM Employee as E INNER JOIN Department AS D
ON E.DeptID = D.DeptID
WHERE D.DeptName = 'Mechanical'

--Question 11: Update City of Sandeep from Mumbai to Pune having 101 as Employee ID.
UPDATE Employee
SET City = 'Pune'
WHERE EmpID = 101 AND Name = 'Sandeep'

--Question 12: Delete all the employees who belongs to HR Department & Salary is more than 45,000.
DELETE E
FROM Employee as E INNER JOIN Department AS D
ON E.DeptID = D.DeptID
WHERE D.DeptName = 'HR' AND E.Salary > 45000

--Question 13: List Employees with same name with occurrence of name.
SELECT Name,COUNT(*) AS OccurrenceCount
FROM Employee
GROUP BY Name
HAVING COUNT(*)>1

--Question 14: List Department wise Average Salary.
SELECT  D.DeptName,AVG(E.Salary)
FROM Employee as E INNER JOIN Department AS D
ON E.DeptID = D.DeptID
GROUP BY D.DeptName

--Question 15: List City wise highest paid employee.
SELECT top 4 Name,City,Salary
FROM Employee E
WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employee
    WHERE City = E.City
);