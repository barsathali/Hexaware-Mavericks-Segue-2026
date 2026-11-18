
/*
DAY 7 - SET 3
RETAIL RETURNS AND REFUNDS ANALYSIS
*/

IF DB_ID('NexoraRetailReturnsDB') IS NULL
    CREATE DATABASE NexoraRetailReturnsDB;
GO

USE NexoraRetailReturnsDB;
GO

-- DROP EXISTING TABLES
DROP TABLE IF EXISTS dbo.Refunds;
DROP TABLE IF EXISTS dbo.Returns;
DROP TABLE IF EXISTS dbo.OrderItems;
DROP TABLE IF EXISTS dbo.Orders;
DROP TABLE IF EXISTS dbo.ReturnReasons;
DROP TABLE IF EXISTS dbo.Products;
DROP TABLE IF EXISTS dbo.Customers;
GO

-- 1. CREATE TABLES

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE,
    City VARCHAR(80) NOT NULL
);

CREATE TABLE dbo.Products (
    ProductID INT IDENTITY PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(60) NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE dbo.Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    OrderStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);

CREATE TABLE dbo.OrderItems (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID),
    FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID)
);

CREATE TABLE dbo.ReturnReasons (
    ReasonID INT IDENTITY PRIMARY KEY,
    ReasonName VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE dbo.Returns (
    ReturnID INT IDENTITY PRIMARY KEY,
    OrderItemID INT NOT NULL,
    ReasonID INT NOT NULL,
    ReturnDate DATE NOT NULL,
    ReturnQuantity INT NOT NULL,
    ReturnStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (OrderItemID)
        REFERENCES dbo.OrderItems(OrderItemID),
    FOREIGN KEY (ReasonID)
        REFERENCES dbo.ReturnReasons(ReasonID)
);

CREATE TABLE dbo.Refunds (
    RefundID INT IDENTITY PRIMARY KEY,
    ReturnID INT NOT NULL,
    RefundDate DATE NOT NULL,
    RefundAmount DECIMAL(10,2) NOT NULL,
    RefundMethod VARCHAR(40) NOT NULL,
    FOREIGN KEY (ReturnID)
        REFERENCES dbo.Returns(ReturnID)
);
GO

-- 2. INSERT CUSTOMERS

INSERT INTO dbo.Customers
(CustomerName,Email,City) VALUES
('Arun Kumar','arun@gmail.com','Chennai'),
('Priya Sharma','priya@gmail.com','Bengaluru'),
('Rahul Verma','rahul@gmail.com','Hyderabad'),
('Meena Raj','meena@gmail.com','Mumbai'),
('Karthik Das','karthik@gmail.com','Pune'),
('Divya Nair','divya@gmail.com','Delhi');

-- 3. INSERT PRODUCTS

INSERT INTO dbo.Products
(ProductName,Category,UnitPrice) VALUES
('Laptop','Electronics',55000),
('Smartphone','Electronics',25000),
('Headphones','Accessories',2500),
('Office Chair','Furniture',8000),
('Keyboard','Accessories',1500),
('Monitor','Electronics',12000),
('Table','Furniture',6000),
('Mouse','Accessories',800);

-- 4. INSERT ORDERS

INSERT INTO dbo.Orders
(CustomerID,OrderDate,OrderStatus) VALUES
(1,'2026-09-01','Delivered'),
(2,'2026-09-03','Delivered'),
(3,'2026-09-05','Delivered'),
(4,'2026-09-08','Delivered'),
(5,'2026-09-10','Delivered'),
(6,'2026-09-12','Delivered'),
(1,'2026-10-01','Delivered'),
(2,'2026-10-05','Delivered'),
(3,'2026-10-08','Delivered'),
(4,'2026-10-12','Delivered');

-- 5. INSERT ORDER ITEMS

INSERT INTO dbo.OrderItems
(OrderID,ProductID,Quantity,UnitPrice) VALUES
(1,1,1,55000),
(1,5,2,1500),
(2,2,1,25000),
(2,3,1,2500),
(3,4,1,8000),
(3,8,2,800),
(4,6,1,12000),
(5,7,1,6000),
(6,3,2,2500),
(7,1,1,55000),
(8,2,1,25000),
(9,5,1,1500),
(10,4,1,8000);

-- 6. INSERT RETURN REASONS

INSERT INTO dbo.ReturnReasons
(ReasonName) VALUES
('Damaged Product'),
('Wrong Item Delivered'),
('Product Not as Described'),
('Size or Compatibility Issue'),
('Changed Mind');

-- 7. INSERT RETURNS

INSERT INTO dbo.Returns
(OrderItemID,ReasonID,ReturnDate,ReturnQuantity,ReturnStatus)
VALUES
(1,1,'2026-09-05',1,'Approved'),
(3,3,'2026-09-08',1,'Approved'),
(5,2,'2026-09-12',1,'Approved'),
(7,1,'2026-09-15',1,'Approved'),
(8,5,'2026-09-18',1,'Pending'),
(9,4,'2026-09-20',1,'Approved'),
(10,3,'2026-10-05',1,'Approved'),
(11,2,'2026-10-09',1,'Rejected'),
(12,1,'2026-10-12',1,'Approved'),
(13,5,'2026-10-15',1,'Pending');

-- 8. INSERT REFUNDS

INSERT INTO dbo.Refunds
(ReturnID,RefundDate,RefundAmount,RefundMethod)
VALUES
(1,'2026-09-07',55000,'Original Payment'),
(2,'2026-09-10',25000,'Bank Transfer'),
(3,'2026-09-14',8000,'Original Payment'),
(4,'2026-09-17',12000,'Bank Transfer'),
(6,'2026-09-22',2500,'Original Payment'),
(7,'2026-10-07',55000,'Bank Transfer'),
(9,'2026-10-14',1500,'Original Payment');
GO

-- 9. BUSINESS QUERIES

-- QUERY 1: Return details with customer and product information

SELECT r.ReturnID,
       c.CustomerName,
       p.ProductName,
       r.ReturnDate,
       rr.ReasonName,
       r.ReturnStatus
FROM dbo.Returns r
JOIN dbo.OrderItems oi
    ON oi.OrderItemID=r.OrderItemID
JOIN dbo.Orders o
    ON o.OrderID=oi.OrderID
JOIN dbo.Customers c
    ON c.CustomerID=o.CustomerID
JOIN dbo.Products p
    ON p.ProductID=oi.ProductID
JOIN dbo.ReturnReasons rr
    ON rr.ReasonID=r.ReasonID;

-- QUERY 2: Products that have never been returned

SELECT p.ProductID,p.ProductName
FROM dbo.Products p
LEFT JOIN dbo.OrderItems oi
    ON oi.ProductID=p.ProductID
LEFT JOIN dbo.Returns r
    ON r.OrderItemID=oi.OrderItemID
WHERE r.ReturnID IS NULL
GROUP BY p.ProductID,p.ProductName;

-- QUERY 3: Customers and their total return counts

SELECT c.CustomerName,
       COUNT(r.ReturnID) AS TotalReturns
FROM dbo.Customers c
LEFT JOIN dbo.Orders o
    ON o.CustomerID=c.CustomerID
LEFT JOIN dbo.OrderItems oi
    ON oi.OrderID=o.OrderID
LEFT JOIN dbo.Returns r
    ON r.OrderItemID=oi.OrderItemID
GROUP BY c.CustomerName;

-- QUERY 4: Total refund amount by refund method

SELECT RefundMethod,
       SUM(RefundAmount) AS TotalRefund
FROM dbo.Refunds
GROUP BY RefundMethod;

-- QUERY 5: Return count by reason

SELECT rr.ReasonName,
       COUNT(r.ReturnID) AS ReturnCount
FROM dbo.ReturnReasons rr
LEFT JOIN dbo.Returns r
    ON r.ReasonID=rr.ReasonID
GROUP BY rr.ReasonName;

-- QUERY 6: Customers who have made at least one return (EXISTS)

SELECT c.CustomerID,c.CustomerName
FROM dbo.Customers c
WHERE EXISTS (
    SELECT 1
    FROM dbo.Orders o
    JOIN dbo.OrderItems oi
        ON oi.OrderID=o.OrderID
    JOIN dbo.Returns r
        ON r.OrderItemID=oi.OrderItemID
    WHERE o.CustomerID=c.CustomerID
);

-- QUERY 7: Returns whose refund amount is above average

SELECT r.ReturnID,
       rf.RefundAmount,
       c.CustomerName
FROM dbo.Refunds rf
JOIN dbo.Returns r
    ON r.ReturnID=rf.ReturnID
JOIN dbo.OrderItems oi
    ON oi.OrderItemID=r.OrderItemID
JOIN dbo.Orders o
    ON o.OrderID=oi.OrderID
JOIN dbo.Customers c
    ON c.CustomerID=o.CustomerID
WHERE rf.RefundAmount > (
    SELECT AVG(RefundAmount)
    FROM dbo.Refunds
);

-- QUERY 8: Products with return quantities greater than average

SELECT p.ProductName,
       SUM(r.ReturnQuantity) AS TotalReturned
FROM dbo.Products p
JOIN dbo.OrderItems oi
    ON oi.ProductID=p.ProductID
JOIN dbo.Returns r
    ON r.OrderItemID=oi.OrderItemID
GROUP BY p.ProductName
HAVING SUM(r.ReturnQuantity) > (
    SELECT AVG(ReturnQuantity * 1.0)
    FROM dbo.Returns
);

-- QUERY 9: Customers whose orders contain returned products

SELECT DISTINCT c.CustomerName,
       o.OrderID,
       o.OrderDate
FROM dbo.Customers c
JOIN dbo.Orders o
    ON o.CustomerID=c.CustomerID
JOIN dbo.OrderItems oi
    ON oi.OrderID=o.OrderID
JOIN dbo.Returns r
    ON r.OrderItemID=oi.OrderItemID;

-- QUERY 10: Return details with refund information

SELECT r.ReturnID,
       p.ProductName,
       r.ReturnStatus,
       rf.RefundAmount,
       rf.RefundMethod
FROM dbo.Returns r
JOIN dbo.OrderItems oi
    ON oi.OrderItemID=r.OrderItemID
JOIN dbo.Products p
    ON p.ProductID=oi.ProductID
LEFT JOIN dbo.Refunds rf
    ON rf.ReturnID=r.ReturnID;
GO
