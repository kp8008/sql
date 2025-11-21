-- =========================================
-- 1. TABLE CREATION
-- =========================================
-- CATEGORY table
CREATE TABLE CATEGORI (
CategoryID INT IDENTITY(1,1) PRIMARY KEY,
CategoryName VARCHAR(100) NOT NULL UNIQUE
);
-- BRANCH table
CREATE TABLE BRANCH (
BranchID INT IDENTITY(1,1) PRIMARY KEY,
BranchName VARCHAR(100) NOT NULL,
City VARCHAR(100) NOT NULL
);
-- CUSTOMER table
CREATE TABLE CUSTOMERSS (
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
Name VARCHAR(150) NOT NULL,
Phone VARCHAR(15) NOT NULL UNIQUE,
City VARCHAR(100) NOT NULL
);
-- VEHICLE table
CREATE TABLE VEHICLE (
VehicleID INT IDENTITY(1,1) PRIMARY KEY,
CategoryID INT NOT NULL,
Model VARCHAR(150) NOT NULL,
DailyRate DECIMAL(10,2) NOT NULL,
Status VARCHAR(50) NOT NULL CHECK (Status IN ('Available', 'Rented','Maintenance')),
BranchID INT NOT NULL,
CONSTRAINT FK_Vehicle_Category
FOREIGN KEY (CategoryID) REFERENCES CATEGORI(CategoryID),
CONSTRAINT FK_Vehicle_Branch
FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID)
);
-- RENTAL table
CREATE TABLE RENTAL (
RentalID INT IDENTITY(1,1) PRIMARY KEY,
VehicleID INT NOT NULL,
CustomerID INT NOT NULL,
StartDate DATE NOT NULL,
EndDate DATE NOT NULL,
TotalAmount DECIMAL(10,2) NOT NULL CHECK (TotalAmount >= 0),
CONSTRAINT FK_Rental_Vehicle
FOREIGN KEY (VehicleID) REFERENCES VEHICLE(VehicleID),
CONSTRAINT FK_Rental_Customer
FOREIGN KEY (CustomerID) REFERENCES CUSTOMERSS(CustomerID)
);


--🗂 Queries – Part A

--1. Retrieve customers who rented more than 3 vehicles.
SELECT C.Name,COUNT(R.VehicleID) AS VehiclesRented
FROM CUSTOMERSS C JOIN RENTAL R
ON C.CustomerID = R.CustomerID
GROUP BY C.Name
HAVING COUNT(R.VehicleID) > 3

--2. Display vehicles rented in the last 30 days along with customer and branch details.
SELECT R.RentalID,V.VehicleID,V.Model,R.StartDate,R.EndDate,R.TotalAmount,C.*,B.*
FROM CUSTOMERSS C JOIN RENTAL R
ON C.CustomerID = R.CustomerID
JOIN VEHICLE V
ON V.VehicleID = R.VehicleID
JOIN BRANCH B
ON B.BranchID = V.BranchID
WHERE R.StartDate >=DATEADD(DAY, -30, GETDATE())
ORDER BY R.StartDate DESC

--3. List customers along with the number of rentals they have completed.
SELECT C.CustomerID,C.Name,COUNT(R.CustomerID)
FROM CUSTOMERSS C JOIN RENTAL R
ON C.CustomerID = R.CustomerID
GROUP BY C.CustomerID,C.Name

--4. Show total revenue generated for each vehicle category.
SELECT CA.CategoryID,CA.CategoryName,SUM(R.TotalAmount) AS TotalRevenue
FROM RENTAL AS R
JOIN VEHICLE AS V
ON R.VehicleID = V.VehicleID
JOIN CATEGORI AS CA
ON V.CategoryID = CA.CategoryID
GROUP BY CA.CategoryID, CA.CategoryName;


--5. Find vehicles that have never been rented.
SELECT V.VehicleID,V.Model,V.Status,B.BranchID
FROM VEHICLE V JOIN BRANCH B
ON V.BranchID = B.BranchID
WHERE V.VehicleID NOT IN (SELECT VehicleID FROM RENTAL)

--6. Display customer name and total amount they have spent on rentals.
SELECT C.Name,sum(R.TotalAmount) AS RENTALAMT
FROM CUSTOMERSS C JOIN RENTAL R
ON C.CustomerID = R.CustomerID
GROUP BY C.Name

--7. List vehicles rented by customers from the same city as the branch they rented from.
SELECT R.RentalID,V.VehicleID,V.Model,C.CustomerID,C.Name,C.City,B.City
FROM CUSTOMERSS C JOIN RENTAL R
ON C.CustomerID = R.CustomerID
JOIN VEHICLE V
ON V.VehicleID = R.VehicleID
JOIN BRANCH B
ON V.BranchID = B.BranchID
WHERE C.City = B.City

--8. Retrieve all rentals where the associated vehicle is currently marked as Available.
SELECT R.RentalID,R.VehicleID,V.Model,R.CustomerID,R.StartDate,R.EndDate,R.TotalAmount
FROM RENTAL AS R JOIN VEHICLE AS V
   ON R.VehicleID = V.VehicleID
WHERE V.Status = 'Available'

--9. Show the top 5 vehicles that generated the highest total rental revenue.
SELECT TOP 5 V.VehicleID,V.Model,SUM(R.TotalAmount) AS TotalRevenue
FROM RENTAL AS R JOIN VEHICLE AS V
ON R.VehicleID = V.VehicleID
GROUP BY V.VehicleID, V.Model
ORDER BY TotalRevenue DESC;

--10. List all categories where the average rental duration is greater than 5 days.
SELECT CA.CategoryID,CA.CategoryName,AVG(DATEDIFF(DAY, R.StartDate, R.EndDate) + 1) AS AvgDurationDays
FROM RENTAL R JOIN VEHICLE V
ON R.VehicleID = V.VehicleID
JOIN CATEGORI CA 
ON V.CategoryID = CA.CategoryID
GROUP BY CA.CategoryID, CA.CategoryName
HAVING AVG(DATEDIFF(DAY, R.StartDate, R.EndDate) + 1) > 5


--part - b

SELECT C.CustomerID, C.Name
FROM CUSTOMERSS C
JOIN RENTAL R ON C.CustomerID = R.CustomerID
JOIN VEHICLE V ON R.VehicleID = V.VehicleID
JOIN CATEGORI CA ON V.CategoryID = CA.CategoryID
GROUP BY C.CustomerID, C.Name
HAVING COUNT(DISTINCT CA.CategoryID) = (SELECT COUNT(*) FROM CATEGORI);

SELECT CustomerID
FROM RENTAL R 
JOIN VEHICLE V ON R.VehicleID = V.VehicleID
GROUP BY CustomerID
HAVING COUNT(DISTINCT V.CategoryID) >= 3
--or 
SELECT DISTINCT V.VehicleID, V.Model
FROM RENTAL R
JOIN VEHICLE V ON R.VehicleID = V.VehicleID
WHERE R.CustomerID IN (
    SELECT CustomerID
    FROM RENTAL R2
    JOIN VEHICLE V2 ON R2.VehicleID = V2.VehicleID
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT V2.CategoryID) >= 3
);

DECLARE @CityName VARCHAR(50) = 'Mumbai';

SELECT C.CustomerID,
       C.Name,
       SUM(R.TotalAmount) AS TotalCustomerRevenue
FROM CUSTOMERSS C
JOIN RENTAL R ON C.CustomerID = R.CustomerID
GROUP BY C.CustomerID, C.Name
HAVING SUM(R.TotalAmount) >
(
    SELECT SUM(R2.TotalAmount)
    FROM CUSTOMERSS C2
    JOIN RENTAL R2 ON C2.CustomerID = R2.CustomerID
    WHERE C2.City = @CityName
);


SELECT DISTINCT C.CustomerID, C.Name
FROM CUSTOMERSS C
JOIN RENTAL R1 ON C.CustomerID = R1.CustomerID
JOIN RENTAL R2 ON C.CustomerID = R2.CustomerID
WHERE R2.StartDate = DATEADD(DAY, 1, R1.EndDate);


WITH X AS (
    SELECT CA.CategoryID,
           CA.CategoryName,
           V.VehicleID,
           V.Model,
           SUM(R.TotalAmount) AS TotalRevenue
    FROM RENTAL R
    JOIN VEHICLE V ON R.VehicleID = V.VehicleID
    JOIN CATEGORI CA ON V.CategoryID = CA.CategoryID
    GROUP BY CA.CategoryID, CA.CategoryName, V.VehicleID, V.Model
)
SELECT *
FROM X
WHERE TotalRevenue = (
    SELECT MAX(TotalRevenue)
    FROM X X2
    WHERE X2.CategoryID = X.CategoryID
);
