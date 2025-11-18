--📜 Paper 2: Table & Data Generation Scripts

--1. Table Generation Script (DDL)

-- Create color Table
CREATE TABLE color (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    extra_fee DECIMAL(5,2) DEFAULT 0
);

-- Create customer Table
CREATE TABLE customer (
    id INT PRIMARY KEY IDENTITY(1,1),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    favorite_color_id INT FOREIGN KEY REFERENCES color(id)
);

-- Create category Table
CREATE TABLE category (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) NOT NULL,
    parent_id INT FOREIGN KEY REFERENCES category(id) NULL
);

-- Create clothing Table
CREATE TABLE clothing (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    size VARCHAR(5) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    color_id INT FOREIGN KEY REFERENCES color(id),
    category_id INT FOREIGN KEY REFERENCES category(id)
);

-- Create clothing_order Table
CREATE TABLE clothing_order (
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY REFERENCES customer(id),
    clothing_id INT FOREIGN KEY REFERENCES clothing(id),
    items INT NOT NULL,
    order_date DATE NOT NULL
);

--2. Sample Data Insertion (DML)

-- Insert Sample Colors
INSERT INTO color (name, extra_fee) VALUES
('Red', 5.00),    -- has extra fee
('Green', 0.00),
('Blue', 0.00),
('Black', 5.00),  -- has extra fee
('White', 0.00);

-- Insert Sample Customers
INSERT INTO customer (first_name, last_name, favorite_color_id) VALUES
('Jay', 'Patel', 1),     -- Favorite is Red
('Dhruv', 'Shah', 2),    -- Favorite is Green
('Amit', 'Verma', 1),    -- Favorite is Red
('Priya', 'Mehta', 3),   -- Favorite is Blue
('Ravi', 'Singh', NULL), -- No favorite color
('Meera', 'Das', 5);     -- Customer with no purchases

-- Insert Sample Categories
INSERT INTO category (name, parent_id) VALUES
('Mens', NULL),          -- Main category
('Womens', NULL),        -- Main category
('T-Shirt', 1),          -- Subcategory of Mens
('Joggers', 1),          -- Subcategory of Mens
('Hoodie', 1),           -- Subcategory of Mens
('T-Shirt', 2),          -- Subcategory of Womens
('Joggers', 2);          -- Subcategory of Womens

-- Insert Sample Clothing
INSERT INTO clothing (name, size, price, color_id, category_id) VALUES
('Basic Tee', 'M', 20.00, 5, 3),        -- White, Mens T-Shirt
('V-Neck Tee', 'L', 25.00, 3, 3),        -- Blue, Mens T-Shirt (for Jay's order)
('Performance Jogger', 'L', 45.00, 4, 4), -- Black, Mens Joggers
('Cuffed Jogger', 'M', 40.00, 2, 4),      -- Green, Mens Joggers
('Graphic Hoodie', 'XL', 60.00, 1, 5),    -- Red, Mens Hoodie
('Womens Basic Tee', 'S', 20.00, 5, 6),   -- White, Womens T-Shirt
('Womens Lounge Jogger', 'M', 50.00, 4, 7); -- Black, Womens Joggers

-- Insert Sample Orders
INSERT INTO clothing_order (customer_id, clothing_id, items, order_date) VALUES
-- Jay's order for T-Shirt after 1st April 2024
(1, 2, 2, '2024-05-15'), -- Jay, V-Neck Tee, Qty 2

-- Order for financial year 2024-25
(2, 4, 1, '2024-06-10'), -- Dhruv, Cuffed Jogger, Qty 1

-- Order of favorite color
(1, 5, 1, '2024-07-01'), -- Jay, Graphic Hoodie (Red), Qty 1. Jay's fav color is Red.

-- Customer who wears XL
(4, 5, 1, '2024-08-01'), -- Priya, Graphic Hoodie (XL), Qty 1

-- Multiple orders for customer totals
(1, 3, 1, '2024-09-05'), -- Jay, Performance Jogger, Qty 1
(2, 7, 1, '2023-11-20'), -- Dhruv, Womens Lounge Jogger, Qty 1
(3, 1, 3, '2024-10-10'); -- Amit, Basic Tee, Qty 3

--Question 1: List the customers whose favorite color is Red or Green and name is Jay or Dhruv.
select  CU.first_name , CU.last_name , CO.name
FROM Customer as CU JOIN Color CO
on CU.favorite_color_id = CO.id
WHERE CU.first_name IN('Jay','Dhruv') AND
CO.name in('Red','Green')

--Question 2: List the different types of Joggers with their sizes.
SELECT CA.name , CL.size 
FROM category as CA inner join clothing as CL
ON  CA.id = CL.category_id 
WHERE CA.name = 'Joggers'


--Question 3: List the orders of Jay of T-Shirt after 1st April 2024.

SELECT CU.first_name,CL.name AS clothing_name,CLO.items,CLO.order_date
FROM customer AS CU
JOIN clothing_order AS CLO
ON CU.id = CLO.customer_id
JOIN clothing AS CL
ON CL.id = CLO.clothing_id
JOIN category AS CA
ON CA.id = CL.category_id
WHERE CU.first_name = 'Jay'
  AND CA.name = 'T-Shirt'
  AND CLO.order_date > '2024-04-01';

--Question 4: List the customer whose favorite color is charged extra.
SELECT CU.first_name,CU.last_name,CO.name AS favorite_color,CO.extra_fee
FROM customer AS CU
JOIN color AS CO
ON CU.favorite_color_id = CO.id
WHERE CO.extra_fee > 0;

--Question 5: List category wise clothing's maximum price, minimum price, average price and number of clothing items.
SELECT CA.name AS category_name,COUNT(CL.id) AS num_items,
MAX(CL.price) AS max_price,MIN(CL.price) AS min_price,
AVG(CL.price) AS avg_price
FROM category AS CA
JOIN clothing AS CL
ON CA.id = CL.category_id
GROUP BY CA.name;

--Question 6: List the customers with no purchases at all.
SELECT CU.first_name,CU.last_name
FROM customer AS CU
LEFT JOIN clothing_order AS CLO
ON CU.id = CLO.customer_id
WHERE CLO.id IS NULL;

--Question 7: List the orders of favorite color with all the details.
SELECT CLO.id AS order_id,
CU.first_name + ' ' + CU.last_name AS customer_name,
CL.name AS clothing_name,CO.name AS color_name,
CLO.items,CLO.order_date
FROM customer AS CU
JOIN clothing_order AS CLO
ON CU.id = CLO.customer_id
JOIN clothing AS CL
ON CL.id = CLO.clothing_id
JOIN color AS CO
ON CO.id = CL.color_id
WHERE CU.favorite_color_id = CL.color_id;

--Question 8: List the customers with total purchase value, number of orders and number of items purchased.
SELECT CU.first_name + ' ' + CU.last_name AS customer_name,
COUNT(CLO.id) AS num_orders,SUM(CLO.items) AS total_items,
SUM(CL.price * CLO.items) AS total_purchase_value
FROM customer AS CU
JOIN clothing_order AS CLO
ON CU.id = CLO.customer_id
JOIN clothing AS CL
ON CL.id = CLO.clothing_id
GROUP BY CU.first_name, CU.last_name;


--Question 9: List the Clothing item, Size, Order Value and Number of items sold during financial year 2024-25.
SELECT CL.name AS clothing_name,CL.size,
SUM(CLO.items) AS items_sold,SUM(CL.price * CLO.items) AS order_value
FROM clothing_order AS CLO
JOIN clothing AS CL
ON CL.id = CLO.clothing_id
WHERE CLO.order_date BETWEEN '2024-04-01' AND '2025-03-31'
GROUP BY CL.name, CL.size;

--Question 10: List the customers who wears XL size.
SELECT DISTINCT CU.first_name,CU.last_name,CL.size
FROM customer AS CU
JOIN clothing_order AS CLO
ON CU.id = CLO.customer_id
JOIN clothing AS CL
ON CL.id = CLO.clothing_id
WHERE CL.size = 'XL';
