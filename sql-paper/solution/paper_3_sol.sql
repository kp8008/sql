use kp
--=======

--paper-3--
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
    Price DECIMAL(10,2) NOT NULL, -- Price at time of order
    TotalOrderAmount DECIMAL(10,2) NOT NULL,
    OrderStatus VARCHAR(20) CHECK (OrderStatus IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);


-----
-- Insert Sample Customers
INSERT INTO Customers (Name, JoinDate) VALUES
('Arun Kumar', '2023-01-10'),
('Bhavna Gupta', '2023-01-10'), -- Q9: Same JoinDate
('Chetan Shah', '2023-02-15'),
('Divya Iyer', '2023-03-20'),
('Elina Dsouza', '2023-04-05'),
('Farhan Malik', '2023-05-12'),
('Gita Verma', '2024-01-20'),   -- Q3: First order in 2024
('Harish Reddy', '2024-06-01'); -- Q1: No orders

-- Insert Sample Products
INSERT INTO Products (ProductName, Category, Price, StockQuantity) VALUES
('Laptop', 'Electronics', 1200.00, 10), -- 2nd Highest Price
('Smartphone', 'Electronics', 1000.00, 20),
('Wireless Mouse', 'Electronics', 25.00, 50), -- Q2: Ordered by 6 customers
('Coffee Maker', 'Appliances', 80.00, 30),
('Gaming PC', 'Electronics', 1500.00, 5),  -- Highest Price
('Desk Chair', 'Furniture', 150.00, 15),
('Old Model TV', 'Electronics', 300.00, 0),  -- Q6: Out of stock
('Blender', 'Appliances', 45.00, 0); -- Never ordered, out of stock

-- Insert Sample Orders
-- Assume current date is 2025-11-17
INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity, Price, TotalOrderAmount, OrderStatus) VALUES
-- Q2: Wireless Mouse (ProductID 3) ordered by 6 customers
(1, 3, '2024-02-10', 1, 25.00, 25.00, 'Delivered'),
(2, 3, '2024-03-15', 2, 25.00, 50.00, 'Delivered'),
(3, 3, '2024-04-01', 1, 25.00, 25.00, 'Delivered'),
(4, 3, '2024-05-10', 1, 25.00, 25.00, 'Shipped'),
(5, 3, '2024-06-15', 1, 25.00, 25.00, 'Pending'),
(6, 3, '2024-07-01', 1, 25.00, 25.00, 'Delivered'),

INSERT INTO Orders (CustomerID, ProductID, OrderDate, Quantity, Price, TotalOrderAmount, OrderStatus) VALUES(6, 3, '2025-11-19', 1, 25.00, 25.00, 'Delivered')

-- Q3: Gita (Cust 7) first order in 2024
(7, 4, '2024-02-20', 1, 80.00, 80.00, 'Delivered'),
(7, 2, '2024-05-25', 1, 1000.00, 1000.00, 'Shipped'), -- Q7: Multiple categories

-- Q3: Arun (Cust 1) first order in 2024, but also has 2025 order
(1, 1, '2024-01-15', 1, 1200.00, 1200.00, 'Delivered'), -- Q3: First order
(1, 5, '2025-01-20', 1, 1500.00, 1500.00, 'Delivered'), -- Q5: Latest order
(1, 4, '2024-11-30', 1, 80.00, 80.00, 'Delivered'), -- Q7: Multiple categories

-- Q6: Old Model TV (ProductID 7) ordered but stock is 0
(2, 7, '2024-03-18', 1, 300.00, 300.00, 'Delivered'),

-- Q8: No orders in last 6 months (i.e., after 2025-05-17)
(3, 6, '2025-01-10', 1, 150.00, 150.00, 'Delivered'), -- This order is old

-- Q4: Top revenue products (Laptop, Smartphone, Gaming PC)
(4, 2, '2025-02-01', 2, 1000.00, 2000.00, 'Delivered'),
(5, 5, '2025-02-15', 1, 1500.00, 1500.00, 'Shipped'),
(6, 1, '2025-03-01', 1, 1200.00, 1200.00, 'Delivered');


--===================================================================================================================
--Question 1: List customers who have never placed any order.
SELECT
    C.CustomerID,
    C.Name,
    C.JoinDate
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;
--or
select * from Customers
where CustomerID not in (select customerid from Orders)

--Question 2: List products ordered by more than 5 different customers.
select p.productname,count(distinct o.customerid)
from products p join Orders o
on p.ProductID=o.ProductID
group by p.productname
having COUNT(distinct o.customerid) > 5

--Question 3: List customers whose first order was placed in 2024.
select min(o.orderdate) , c.name
from customers c join orders o
on c.CustomerID=o.CustomerID
group by c.name
having min(o.orderdate) >= '2024-01-01' and min(o.orderdate) < '2025-01-01'

--Question 4: List top 3 products with the highest total revenue.
select top 3 p.productname,sum(o.quantity * o.price) as revenue
from Products p join orders o
on p.ProductID=o.ProductID
group by p.productname 
order by sum(o.quantity * o.price) desc

--Question 5: Find the latest order placed for each customer.
select c.name,max(o.orderdate) as latest_order
from customers  c join Orders o
on c.CustomerID=o.CustomerID
group by c.name

--Question 6: List products that have been ordered but are currently out of stock.
select p.productname, p.stockquantity
from Products p join orders o
on p.ProductID=o.ProductID
where p.StockQuantity=0

--Question 7: List customers who placed orders in more than one product category.
select c.name, count(distinct p.category) uniquecategory
from customers c
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Products P ON O.ProductID = P.ProductID
group by c.name
having count(distinct p.category) > 1


--Question 8: List products with no orders in the last 6 months.
select p.ProductName
from products p
left join orders o
on p.productid=o.ProductID
and OrderDate>'2025-05-17'
where o.OrderID is null

select * from Products

--Question 9: Find Customers having Same JoinDate.
select c.name,c.joindate
from customers c
where joindate in(
		select joindate from customers c
		group by JoinDate
		having count(*) > 1
		)
	order by c.name,c.joindate

--Question 10: Find the product whose price is second highest.
select p.productname,p.price
from Products p  
where p.price in (
		select max(p.price) as maxprice from products p

		where p.price< (select max(p.price) from Products p)
		)

