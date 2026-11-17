
-- Day 6 - Set 3: Telecom Reporting

-- Create database
USE master;
GO

IF DB_ID('NexoraTelecomDB') IS NULL
    CREATE DATABASE NexoraTelecomDB;
GO

USE NexoraTelecomDB;
GO

-- Create tables
CREATE TABLE Subscribers (
    SubscriberID INT PRIMARY KEY,
    SubscriberName VARCHAR(100),
    Circle VARCHAR(50),
    PlanID INT
);

CREATE TABLE Plans (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(100),
    DataLimitGB DECIMAL(10,2),
    MonthlyPrice DECIMAL(10,2)
);

CREATE TABLE Call_Records (
    CallID INT PRIMARY KEY,
    SubscriberID INT,
    CallDate DATETIME,
    CallMinutes DECIMAL(8,2),
    DataUsedGB DECIMAL(8,2) NULL,
    CellTower VARCHAR(50),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID)
);

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    SubscriberID INT,
    InvoiceDate DATE,
    DueDate DATE,
    Amount DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID)
);
GO

-- Add plans
INSERT INTO Plans VALUES
(1, 'Basic Plan', 5, 299),
(2, 'Standard Plan', 15, 499),
(3, 'Premium Plan', 30, 799),
(4, 'Unlimited Plan', 100, 999);

-- Add subscribers
INSERT INTO Subscribers VALUES
(1, 'Arun Kumar', 'Chennai', 1),
(2, 'Priya S', 'Coimbatore', 2),
(3, 'Karthik R', 'Chennai', 3),
(4, 'Divya M', 'Bengaluru', 2),
(5, 'Rahul P', 'Madurai', 4),
(6, 'Meena K', 'Hyderabad', 1),
(7, 'Vijay S', 'Chennai', 3),
(8, 'Nithya R', 'Coimbatore', 2),
(9, 'Anitha P', 'Bengaluru', 4),
(10, 'Sanjay V', 'Madurai', 1);

-- Add call and data usage
INSERT INTO Call_Records VALUES
(1, 1, '2026-10-01 09:00', 20, 2.5, 'Tower-A'),
(2, 1, '2026-10-02 10:00', 15, 3.0, 'Tower-A'),
(3, 2, '2026-10-03 11:00', 30, 5.0, 'Tower-B'),
(4, 2, '2026-10-05 12:00', 25, 4.0, 'Tower-B'),
(5, 3, '2026-10-06 13:00', 45, 12.0, 'Tower-C'),
(6, 3, '2026-11-01 14:00', 35, 20.0, 'Tower-C'),
(7, 4, '2026-11-02 15:00', 18, 6.0, 'Tower-A'),
(8, 5, '2026-11-03 16:00', 60, 35.0, 'Tower-D'),
(9, 6, '2026-11-04 17:00', 12, NULL, 'Tower-B'),
(10, 7, '2026-11-05 18:00', 50, 18.0, 'Tower-C'),
(11, 8, '2026-11-06 19:00', 22, 8.0, 'Tower-A'),
(12, 9, '2026-11-07 20:00', 40, 45.0, 'Tower-D');

-- Add invoices
INSERT INTO Invoices VALUES
(1001, 1, '2026-10-01', '2026-10-15', 299, 'Paid'),
(1002, 2, '2026-10-01', '2026-10-15', 499, 'Paid'),
(1003, 3, '2026-10-01', '2026-10-15', 799, 'Unpaid'),
(1004, 4, '2026-10-01', '2026-10-15', 499, 'Paid'),
(1005, 5, '2026-10-01', '2026-10-15', 999, 'Unpaid'),
(1006, 6, '2026-11-01', '2026-11-15', 299, 'Paid'),
(1007, 7, '2026-11-01', '2026-11-15', 799, 'Unpaid'),
(1008, 8, '2026-11-01', '2026-11-15', 499, 'Paid'),
(1009, 9, '2026-11-01', '2026-11-15', 999, 'Paid'),
(1010, 10, '2026-11-01', '2026-11-15', 299, 'Unpaid');
GO

-- 1. Total call minutes per plan
SELECT
    P.PlanName,
    SUM(CR.CallMinutes) AS TotalCallMinutes
FROM Plans P
JOIN Subscribers S ON P.PlanID = S.PlanID
JOIN Call_Records CR ON S.SubscriberID = CR.SubscriberID
GROUP BY P.PlanName;

-- 2. Subscribers exceeding their data limit
SELECT
    S.SubscriberName,
    P.PlanName,
    P.DataLimitGB,
    SUM(CR.DataUsedGB) AS TotalDataUsed
FROM Subscribers S
JOIN Plans P ON S.PlanID = P.PlanID
JOIN Call_Records CR ON S.SubscriberID = CR.SubscriberID
GROUP BY S.SubscriberName, P.PlanName, P.DataLimitGB
HAVING SUM(CR.DataUsedGB) > P.DataLimitGB;

-- 3. Month-wise revenue
SELECT
    FORMAT(InvoiceDate, 'yyyy-MM') AS InvoiceMonth,
    SUM(Amount) AS MonthlyRevenue
FROM Invoices
GROUP BY FORMAT(InvoiceDate, 'yyyy-MM')
ORDER BY InvoiceMonth;

-- 4. Invoices overdue by more than 15 days
SELECT
    InvoiceID,
    SubscriberID,
    DueDate,
    DATEDIFF(DAY, DueDate, GETDATE()) AS DaysOverdue
FROM Invoices
WHERE Status = 'Unpaid'
AND DueDate < DATEADD(DAY, -15, CAST(GETDATE() AS DATE));

-- 5. Subscribers with no usage
SELECT S.SubscriberID, S.SubscriberName
FROM Subscribers S
LEFT JOIN Call_Records CR
ON S.SubscriberID = CR.SubscriberID
WHERE CR.CallID IS NULL;

-- 6. Average revenue per user by circle
SELECT
    S.Circle,
    ROUND(AVG(I.Amount), 2) AS AverageRevenuePerUser
FROM Subscribers S
JOIN Invoices I ON S.SubscriberID = I.SubscriberID
GROUP BY S.Circle;

-- 7. Plan popularity
SELECT
    P.PlanName,
    COUNT(S.SubscriberID) AS TotalSubscribers
FROM Plans P
LEFT JOIN Subscribers S ON P.PlanID = S.PlanID
GROUP BY P.PlanName
ORDER BY TotalSubscribers DESC;

-- 8. Top ten data consumers
SELECT TOP 10
    S.SubscriberName,
    SUM(CR.DataUsedGB) AS TotalDataUsed
FROM Subscribers S
JOIN Call_Records CR ON S.SubscriberID = CR.SubscriberID
GROUP BY S.SubscriberName
ORDER BY TotalDataUsed DESC;

-- Format invoice number and show due status
SELECT
    CONCAT('INV-', RIGHT(CONCAT('0000', InvoiceID), 4)) AS InvoiceNumber,
    FORMAT(InvoiceDate, 'dd-MMM-yyyy') AS InvoiceDate,
    CASE
        WHEN Status = 'Paid' THEN 'Paid'
        WHEN DueDate < CAST(GETDATE() AS DATE) THEN 'Overdue'
        ELSE 'Due Soon'
    END AS DueStatus
FROM Invoices;

-- NULL behaviour in SUM and AVG
SELECT
    COUNT(*) AS TotalUsageRows,
    COUNT(DataUsedGB) AS RowsWithData,
    SUM(DataUsedGB) AS TotalData,
    AVG(DataUsedGB) AS AverageData
FROM Call_Records;

-- SUM and AVG ignore NULL values.
-- COUNT(*) includes every row.
GO
