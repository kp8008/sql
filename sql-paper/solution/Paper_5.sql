-- Create Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(50) NOT NULL,
    JoinDate DATE NOT NULL
); 

-- Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL
); 

-- Create Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    OrderDate DATE NOT NULL,
    Quantity INT NOT NULL,
    TotalOrderAmount DECIMAL(10,2) NOT NULL,
    Price DECIMAL(10,2) NOT NULL, -- Price at the time of sale
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
); 

--Question 1: List top 5 highest amount orders with Customer Name & Product Name. 
SELECT TOP 5 C.Name,P.ProductName,O.TotalOrderAmount
FROM Customers  C JOIN Orders O
ON C.CustomerID = O.CustomerID
JOIN Products P
ON P.ProductID = O.ProductID
ORDER BY O.TotalOrderAmount DESC

--Question 2: List Products with Category which are never ordered.
SELECT Category,ProductName
FROM Products
WHERE ProductID NOT IN (
	SELECT ProductID FROM Orders
);

--Question 3: List Category wise total orders, total ordered quantity and total order amount. 
SELECT P.Category,COUNT(O.OrderID) AS total_orders , SUM(O.Quantity) AS total_quantity,
SUM(O.TotalOrderAmount) AS total_order_amount
FROM Products P JOIN Orders O
ON P.ProductID = O.ProductID
GROUP BY P.Category

--Question 4: List Products with Average Price of "Computer" Category. 
SELECT ProductName,AVG(Price) AS Average_Price
FROM Products
WHERE Category = 'Computer'
GROUP BY ProductName

--OR
SELECT ProductName,Price
FROM Products 
WHERE Price > (
	SELECT AVG(Price) AS AVG_PRICE
	FROM Products
	WHERE Category = 'Computer'
)

--Question 5: Find Customers who ordered the same product more than once. (repeat buyers) [cite: 316, 317]
SELECT C.Name,P.ProductName,COUNT(O.CustomerID)
FROM Customers  C JOIN Orders O
ON C.CustomerID = O.CustomerID
JOIN Products P
ON P.ProductID = O.ProductID
GROUP BY C.Name,P.ProductName
HAVING COUNT(O.CustomerID) > 1

--Question 6: Which Product is highest selling in terms of quantity? [cite: 318]
SELECT TOP 1 P.ProductName,COUNT(O.Quantity)
FROM Products P JOIN Orders O
ON P.ProductID = O.ProductID
GROUP BY ProductName
ORDER BY COUNT(O.Quantity) DESC

--Question 7: Delete those orders which are Cancelled and placed before '2024-01-01'. [cite: 320]
DELETE FROM Orders
WHERE OrderStatus = 'Cancelled'
AND OrderDate < '2024-01-01'

--Question 8: List products whose current stock is less than current pending orders. [cite: 321]
SELECT P.ProductName,P.StockQuantity,COUNT(O.Quantity)
FROM Products P JOIN Orders O
ON P.ProductID = O.ProductID
WHERE O.OrderStatus  = 'pending'
GROUP BY ProductName,P.StockQuantity
HAVING P.StockQuantity > COUNT(O.Quantity)

--Question 9: List Top 10 Customers with highest total order amount of Category "Mobile". [cite: 322]
SELECT TOP 10 C.Name,O.TotalOrderAmount
FROM Customers  C JOIN Orders O
ON C.CustomerID = O.CustomerID
JOIN Products P
ON P.ProductID = O.ProductID
WHERE P.Category = 'Mobile'
ORDER BY O.TotalOrderAmount DESC

--Question 10: List Date wise Total Order Amount. [cite: 324]
SELECT OrderDate,SUM(TotalOrderAmount)
FROM Orders
GROUP BY OrderDate