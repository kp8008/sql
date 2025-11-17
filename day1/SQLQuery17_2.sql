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


--Queries: Part – B

--1. Produce Output Like: <PersonName> earns <Salary> from <DepartmentName> department monthly. (In single column).
SELECT 
    P.PersonName + ' earns ' +CAST(P.Salary AS VARCHAR(20)) + ' from ' + D.DepartmentName + ' Department monthly.' 
        
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID

--2. Find city & department wise total, average & maximum salaries.
SELECT P.City,D.DepartmentName,MAX(P.Salary) AS Max_Salary,
AVG(P.Salary) as Avg_Salary, SUM(P.Salary) as Total_salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
GROUP BY P.City,D.DepartmentName
ORDER BY P.City ASC

--3. Find all persons who do not belong to any department.
SELECT P.*
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE P.DepartmentID IS NULL

--4. Find all departments whose total salary is exceeding 100000.
SELECT D.DepartmentName, SUM(P.Salary) as Total_salary
FROM DEPT AS D
INNER JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
GROUP BY D.DepartmentName
HAVING SUM(P.Salary) > 100000

--Queries: Part – C

--1. List all departments who have no person.
SELECT D.DepartmentName
FROM DEPT AS D
LEFT JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
WHERE P.PersonID IS NULL

--2. List out department names in which more than two persons are working. Expected Output:
SELECT D.DepartmentName,COUNT(P.PersonID)
FROM DEPT AS D
LEFT JOIN PERSON AS P
ON D.DepartmentID = P.DepartmentID
GROUP BY D.DepartmentName
HAVING COUNT(P.PersonID) > 2

--3. Give a 10% increment in the computer department employee’s salary. (Use Update). This is an UPDATE query. To verify your work, run a SELECT query on the PERSON table for the 'Computer' department before and after your UPDATE.
UPDATE P
SET P.Salary = P.Salary * 1.10
FROM PERSON AS P
JOIN DEPT AS D
    ON D.DepartmentID = P.DepartmentID
WHERE D.DepartmentName = 'Computer';

--SELECT P.*
--FROM DEPT AS D
--INNER JOIN PERSON AS P
--ON D.DepartmentID = P.DepartmentID
--WHERE D.DepartmentName = 'Computer';


--Advanced SQL Joins

--📚 Part 1: Book & Author Schema

--Create Author table
CREATE TABLE Author (
    AuthorID INT PRIMARY KEY,
    AuthorName VARCHAR(100) NOT NULL,
    Country VARCHAR(50) NULL
);

-- Create Publisher table
CREATE TABLE Publisher (
    PublisherID INT PRIMARY KEY,
    PublisherName VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(50) NOT NULL
);

-- Create Book table with Foreign Keys
CREATE TABLE Book (
    BookID INT PRIMARY KEY,
    Title VARCHAR(200) NOT NULL,
    AuthorID INT NOT NULL,
    PublisherID INT NOT NULL,
    Price DECIMAL(8, 2) NOT NULL,
    PublicationYear INT NOT NULL,
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID),
    FOREIGN KEY (PublisherID) REFERENCES Publisher(PublisherID)
);

-- Insert into Author
INSERT INTO Author (AuthorID, AuthorName, Country)
VALUES
(1, 'Chetan Bhagat', 'India'),
(2, 'Arundhati Roy', 'India'),
(3, 'Amish Tripathi', 'India'),
(4, 'Ruskin Bond', 'India'),
(5, 'Jhumpa Lahiri', 'India'),
(6, 'Paulo Coelho', 'Brazil'),
(7, 'Sudha Murty', 'India'),
(8, 'Vikram Seth', 'India'),
(9, 'Kiran Desai', 'India'); -- Author with no books

-- Insert into Publisher
INSERT INTO Publisher (PublisherID, PublisherName, City)
VALUES
(1, 'Rupa Publications', 'New Delhi'),
(2, 'Penguin India', 'Gurugram'),
(3, 'HarperCollins India', 'Noida'),
(4, 'Aleph Book Company', 'New Delhi'),
(5, 'Westland', 'Chennai');

-- Insert into Book
INSERT INTO Book (BookID, Title, AuthorID, PublisherID, Price, PublicationYear)
VALUES
(101, 'Five Point Someone', 1, 1, 250.00, 2004),
(102, 'The God of Small Things', 2, 2, 350.00, 1997),
(103, 'Immortals of Meluha', 3, 3, 300.00, 2010),
(104, 'The Blue Umbrella', 4, 1, 180.00, 1980),
(105, 'The Lowland', 5, 2, 400.00, 2013),
(106, 'Revolution 2020', 1, 1, 275.00, 2011),
(107, 'Sita: Warrior of Mithila', 3, 3, 320.00, 2017),
(108, 'The Room on the Roof', 4, 4, 200.00, 1956),
(109, 'A Suitable Boy', 8, 2, 600.00, 1993),
(110, 'Scion of Ikshvaku', 3, 5, 350.00, 2015),
(111, 'Wise and Otherwise', 7, 2, 210.00, 2002),
(112, '2 States', 1, 1, 260.00, 2009);

--Part – A: Book Queries

--1. List all books with their authors. Expected Output (Partial):
SELECT A.AuthorName,B.Title
FROM Author as A
INNER JOIN Book AS B
ON A.AuthorID = B.AuthorID

--2. List all books with their publishers. Expected Output (Partial):
SELECT B.Title,P.PublisherName
FROM Publisher as P
INNER JOIN Book AS B
ON P.PublisherID = B.PublisherID

--3. List all books with their authors and publishers. Expected Output (Partial):
SELECT B.Title,A.AuthorName,P.PublisherName
FROM Author as A
INNER JOIN Book AS B
ON A.AuthorID = B.AuthorID
JOIN Publisher AS P
ON P.PublisherID = B.PublisherID

--4. List all books published after 2010 with their authors and publisher and price. Expected Output:
SELECT B.Title,A.AuthorName,P.PublisherName,B.Price
FROM Author as A
INNER JOIN Book AS B
ON A.AuthorID = B.AuthorID
JOIN Publisher AS P
ON P.PublisherID = B.PublisherID
WHERE B.PublicationYear > 2010

--5. List all authors and the number of books they have written. 
SELECT A.AuthorName,COUNT(B.BookID) AS NumberOfBooks
FROM Author as A
INNER JOIN Book AS B
ON A.AuthorID = B.AuthorID
GROUP BY A.AuthorName

--6. List all publishers and the total price of books they have published. Expected Output:
SELECT P.PublisherName,SUM(B.Price)
FROM Publisher as P
INNER JOIN Book AS B
ON P.PublisherID = B.PublisherID
GROUP BY PublisherName


--7. List authors who have not written any books. 
SELECT  A.AuthorName
FROM Author A
LEFT JOIN Book B
    ON A.AuthorID = B.AuthorID
WHERE B.BookID IS NULL;

--8. Display total number of Books and Average Price of every Author.
SELECT A.AuthorName,COUNT(B.BookID) AS NumberOfBooks,AVG(B.Price) AS Average_Salary
FROM Author as A
INNER JOIN Book AS B
ON A.AuthorID = B.AuthorID
GROUP BY A.AuthorName

--9. lists each publisher along with the total number of books they have published, sorted from highest to lowest.
SELECT P.PublisherName,COUNT(B.BookID) AS NumberOfBooks
FROM Publisher as P
INNER JOIN Book AS B
ON P.PublisherID= B.PublisherID
GROUP BY P.PublisherName

--10. Display number of books published each year. Expected Output:
SELECT PublicationYear,COUNT(BookID) AS NumberOfBooks
FROM Book
GROUP BY PublicationYear


--Part – B: Book Queries

--1. List the publishers whose total book prices exceed 500, ordered by the total price. Expected Output:
SELECT P.PublisherName,SUM(B.Price) AS Total_Price
FROM Publisher as P
INNER JOIN Book AS B
ON P.PublisherID= B.PublisherID
GROUP BY P.PublisherName
HAVING SUM(B.Price) > 500

--2. List most expensive book for each author, sort it with the highest price. Expected Output:
SELECT A.AuthorName,B.Title,SUM(B.Price) AS Total_Salary
FROM Author as A
INNER JOIN Book AS B
ON A.AuthorID = B.AuthorID
GROUP BY A.AuthorName,B.Title
ORDER BY SUM(B.Price) DESC

--Part – C: Employee & Location Schema

CREATE TABLE Dept_info (
    Did INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL
);

CREATE TABLE Country (
    Cid INT PRIMARY KEY,
    Cname VARCHAR(50) NOT NULL
);

CREATE TABLE State (
    Sid INT PRIMARY KEY,
    Sname VARCHAR(50) NOT NULL,
    Cid INT NOT NULL,
    FOREIGN KEY (Cid) REFERENCES Country(Cid)
);

CREATE TABLE District (
    Did INT PRIMARY KEY,
    Dname VARCHAR(50) NOT NULL,
    Sid INT NOT NULL,
    FOREIGN KEY (Sid) REFERENCES State(Sid)
);

CREATE TABLE City_info (
    Cid INT PRIMARY KEY,
    Cname VARCHAR(50) NOT NULL,
    Did INT NOT NULL,
    FOREIGN KEY (Did) REFERENCES District(Did)
);

CREATE TABLE Emp_info (
    Eid INT PRIMARY KEY,
    Ename VARCHAR(50) NOT NULL,
    Did INT NOT NULL,
    Cid INT NOT NULL,
    Salary DECIMAL(10,2) NOT NULL CHECK (Salary > 0),
    Experience INT CHECK (Experience >= 0),
    FOREIGN KEY (Did) REFERENCES Dept_info(Did),
    FOREIGN KEY (Cid) REFERENCES City_info(Cid)
);

INSERT INTO Dept_info VALUES
(1, 'IT'),
(2, 'HR'),
(3, 'Sales'),
(4, 'Finance'),
(5, 'Marketing');

INSERT INTO Country VALUES
(1, 'India'),
(2, 'USA'),
(3, 'UK'),
(4, 'Canada'),
(5, 'Australia');

INSERT INTO State VALUES
(1, 'Gujarat', 1),
(2, 'Maharashtra', 1),
(3, 'California', 2),
(4, 'Texas', 2),
(5, 'Ontario', 4);

INSERT INTO District VALUES
(101, 'Rajkot', 1),
(102, 'Ahmedabad', 1),
(103, 'Mumbai', 2),
(104, 'Los Angeles', 3),
(105, 'Austin', 4);

INSERT INTO City_info VALUES
(1001, 'Rajkot', 101),
(1002, 'Sanand', 102),
(1003, 'Bandra', 103),
(1004, 'Santa Monica', 104),
(1005, 'East Austin', 105);

INSERT INTO Emp_info VALUES
(1, 'Anil Sharma', 1, 1001, 80000, 5),
(2, 'Priya Singh', 2, 1003, 65000, 3),
(3, 'Rajesh Kumar', 3, 1002, 70000, 4),
(4, 'Meena Patel', 1, 1001, 82000, 6),
(5, 'Suresh Desai', 4, 1004, 95000, 8);

--ERROR CHEKING

INSERT INTO Emp_info VALUES
(6, 'Rohan Error', 1, 9999, 50000, 2);

--REPORT QUERY
SELECT 
    E.Ename AS EmpName,
    DI.Dname AS DeptName,
    E.Salary,
    E.Experience,
    CI.Cname AS CityName,
    D.Dname AS DistrictName,
    S.Sname AS StateName,
    C.Cname AS CountryName
FROM Emp_info E
JOIN Dept_info DI ON E.Did = DI.Did
JOIN City_info CI ON E.Cid = CI.Cid
JOIN District D ON CI.Did = D.Did
JOIN State S ON D.Sid = S.Sid
JOIN Country C ON S.Cid = C.Cid;
