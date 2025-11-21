--📜 Paper 4: Table & Data Generation Scripts

-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    JoinDate DATE NOT NULL,
    TotalOrders INT DEFAULT 0
);

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    LastRestockDate DATE
);

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

--Question 1: Find top 5 customers by total order amount.
SELECT TOP 5 C.FirstName,SUM(O.TotalAmount) AS TotalSpent
FROM Customers C JOIN Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName

--Question 2: List products with no orders in the last 90 days.
SELECT ProductName
FROM Products 
WHERE ProductID NOT IN (
	SELECT ProductID FROM Orders
	WHERE OrderDate >= DATEADD(DAY,-90,GETDATE())
)

--Question 3: Calculate monthly sales for the last 6 months.
SELECT FORMAT(OrderDate ,'yyyy-MM') as SalesMonth,sum(TotalAmount) as TotalSales
from Orders
WHERE OrderDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY FORMAT(OrderDate ,'yyyy-MM')
ORDER BY SalesMonth

--Question 4: Find customers who ordered the same product more than once. (repeat buyers)
SELECT C. FirstName,P.ProductName,COUNT(O.CustomerID) AS OrderCount
FROM Customers C JOIN Orders O
ON C.CustomerID = O.CustomerID
JOIN Products P
ON P.ProductID = O.ProductID
GROUP BY C.FirstName,P.ProductName
HAVING COUNT(O.CustomerID) > 1

--Question 5: Identify products never ordered in the last 3 months.
SELECT ProductName
FROM Products 
WHERE ProductID NOT IN (
	SELECT ProductID FROM Orders
	WHERE OrderDate >= DATEADD(DAY,-90,GETDATE())
)

--Question 6: List products with low stock (less than 10 units) and high demand (more than 20 units ordered).
SELECT P.ProductName,P.StockQuantity, SUM(O.Quantity) AS TotalOrdered
FROM Products P JOIN Orders O
ON P.ProductID = O.ProductID
GROUP BY P.ProductName,P.StockQuantity
HAVING SUM(O.Quantity) > 20 AND
	P.StockQuantity < 10

--Question 7: List customers who ordered in every month of the current year.
SELECT C.FirstName
FROM Customers C JOIN Orders O
ON C.CustomerID = O.CustomerID
WHERE YEAR(O.OrderDate) = YEAR(GETDATE())
GROUP BY C.FirstName,C.CustomerID
HAVING COUNT(DISTINCT MONTH(O.OrderDate)) = 11

--Question 8: Find customers who has placed maximum number of orders.
SELECT C.FirstName, COUNT(O.OrderID) AS NumberOfOrders
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName
HAVING COUNT(O.OrderID) = (
    SELECT TOP 1 COUNT(Orders.OrderID)
    FROM Orders
    GROUP BY CustomerID
    ORDER BY COUNT(Orders.OrderID) DESC
);

--Question 9: List customers whose order was either 'Cancelled' or 'Pending'.
SELECT C.FirstName,O.OrderStatus
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderStatus IN('Cancelled','Pending')

--Question 10: Find customers with unusual ordering patterns (gaps > 60 days followed by large orders).
SELECT C.FirstName AS CustomerName,O1.OrderDate AS PrevOrderDate,O2.OrderDate AS NextOrderDate,
DATEDIFF(DAY, O1.OrderDate, O2.OrderDate) AS GapInDays,O2.TotalAmount AS LargeOrderAmount
FROM Customers C JOIN Orders O1
ON C.CustomerID = O1.CustomerID
JOIN Orders O2 
ON C.CustomerID = O2.CustomerID
WHERE O2.OrderDate > O1.OrderDate               
  AND DATEDIFF(DAY, O1.OrderDate, O2.OrderDate) > 60   
  AND O2.TotalAmount > 1000;                   
