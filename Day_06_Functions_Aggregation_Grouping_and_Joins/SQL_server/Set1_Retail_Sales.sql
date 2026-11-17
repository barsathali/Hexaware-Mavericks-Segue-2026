
-- Day 6 - Set 1: Retail Sales Reporting

-- Create database
USE master;
GO

IF DB_ID('NexoraRetailSalesDB') IS NULL
    CREATE DATABASE NexoraRetailSalesDB;
GO

USE NexoraRetailSalesDB;
GO

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Order_Items (
    ItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    Amount DECIMAL(10,2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
GO

-- Add customer details
INSERT INTO Customers VALUES
(1, 'Arun Kumar', 'Chennai', 'arun@email.com'),
(2, 'Priya S', 'Coimbatore', 'priya@email.com'),
(3, 'Karthik R', 'Chennai', 'karthik@email.com'),
(4, 'Divya M', 'Bengaluru', 'divya@email.com'),
(5, 'Rahul P', 'Madurai', 'rahul@email.com'),
(6, 'Meena K', 'Hyderabad', 'meena@email.com');

-- Add products
INSERT INTO Products VALUES
(101, 'Laptop', 'Electronics', 50000),
(102, 'Mobile', 'Electronics', 20000),
(103, 'Chair', 'Furniture', 5000),
(104, 'Table', 'Furniture', 8000),
(105, 'Headphones', 'Accessories', 2000);

-- Add orders
INSERT INTO Orders VALUES
(1001, 1, '2026-10-01'),
(1002, 1, '2026-10-05'),
(1003, 1, '2026-10-10'),
(1004, 1, '2026-11-02'),
(1005, 2, '2026-10-12'),
(1006, 2, '2026-11-05'),
(1007, 3, '2026-11-10'),
(1008, 4, '2026-11-12');

-- Add order items
INSERT INTO Order_Items VALUES
(1, 1001, 101, 1, 50000),
(2, 1001, 105, 2, 2000),
(3, 1002, 102, 1, 20000),
(4, 1002, 103, 2, 5000),
(5, 1003, 101, 1, 50000),
(6, 1004, 104, 2, 8000),
(7, 1005, 102, 2, 20000),
(8, 1006, 105, 3, 2000),
(9, 1007, 103, 1, 5000),
(10, 1008, 104, 1, 8000);

-- Add payment details
INSERT INTO Payments VALUES
(1, 1001, '2026-10-01', 54000),
(2, 1002, '2026-10-05', 30000),
(3, 1003, '2026-10-10', 50000),
(4, 1005, '2026-10-12', 40000),
(5, 1007, '2026-11-10', 5000);
GO

-- 1. Top five products by revenue
SELECT TOP 5
    P.ProductName,
    SUM(OI.Quantity * OI.UnitPrice) AS Revenue
FROM Products P
JOIN Order_Items OI ON P.ProductID = OI.ProductID
GROUP BY P.ProductName
ORDER BY Revenue DESC;

-- 2. Month-wise sales
SELECT
    FORMAT(O.OrderDate, 'yyyy-MM') AS SalesMonth,
    SUM(OI.Quantity * OI.UnitPrice) AS MonthlySales
FROM Orders O
JOIN Order_Items OI ON O.OrderID = OI.OrderID
GROUP BY FORMAT(O.OrderDate, 'yyyy-MM')
ORDER BY SalesMonth;

-- 3. Customers with more than three orders
SELECT
    C.CustomerName,
    COUNT(O.OrderID) AS TotalOrders
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerName
HAVING COUNT(O.OrderID) > 3;

-- 4. Average basket value per city
SELECT
    C.City,
    ROUND(AVG(OrderTotal), 2) AS AverageBasketValue
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS OrderTotal
    FROM Order_Items
    GROUP BY OrderID
) T ON O.OrderID = T.OrderID
GROUP BY C.City;

-- 5. Orders without payment
SELECT O.OrderID, O.OrderDate, P.PaymentID
FROM Orders O
LEFT JOIN Payments P ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL;

-- 6. Customers with no orders
SELECT C.CustomerID, C.CustomerName
FROM Customers C
LEFT JOIN Orders O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

-- 7. Revenue share by product category
SELECT
    P.Category,
    SUM(OI.Quantity * OI.UnitPrice) AS CategoryRevenue,
    ROUND(
        SUM(OI.Quantity * OI.UnitPrice) * 100.0 /
        (SELECT SUM(Quantity * UnitPrice) FROM Order_Items), 2
    ) AS RevenuePercentage
FROM Products P
JOIN Order_Items OI ON P.ProductID = OI.ProductID
GROUP BY P.Category;

-- 8. Day with the highest sales
SELECT TOP 1
    O.OrderDate,
    SUM(OI.Quantity * OI.UnitPrice) AS DailySales
FROM Orders O
JOIN Order_Items OI ON O.OrderID = OI.OrderID
GROUP BY O.OrderDate
ORDER BY DailySales DESC;

-- Customer-friendly output using SQL functions
SELECT
    UPPER(C.CustomerName) AS CustomerName,
    CONCAT(C.City, ' - ', C.Email) AS CustomerDetails,
    FORMAT(O.OrderDate, 'dd-MMM-yyyy') AS OrderDate,
    DATEDIFF(DAY, O.OrderDate, GETDATE()) AS DaysSinceOrder,
    ROUND(SUM(OI.Quantity * OI.UnitPrice), 2) AS OrderAmount
FROM Customers C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Order_Items OI ON O.OrderID = OI.OrderID
GROUP BY C.CustomerName, C.City, C.Email, O.OrderDate;

-- NULL behaviour example
SELECT
    COUNT(*) AS TotalRows,
    COUNT(Amount) AS PaymentsWithAmount,
    AVG(Amount) AS AveragePayment
FROM Payments;

-- COUNT(*) counts all rows.
-- COUNT(Amount) ignores NULL values.
-- AVG(Amount) also ignores NULL values.
GO
