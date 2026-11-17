-- Create database
USE master;
GO

IF DB_ID('NexoraInsuranceDB') IS NULL
    CREATE DATABASE NexoraInsuranceDB;
GO

USE NexoraInsuranceDB;
GO

-- Create tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    DateOfBirth DATE
);

CREATE TABLE InsuranceProducts (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100)
);

CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    AgentName VARCHAR(100)
);

CREATE TABLE Policies (
    PolicyID INT PRIMARY KEY,
    PolicyNumber VARCHAR(30) UNIQUE,
    CustomerID INT,
    ProductID INT,
    AgentID INT,
    StartDate DATE,
    ExpiryDate DATE,
    PremiumAmount DECIMAL(10,2),
    Status VARCHAR(20),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES InsuranceProducts(ProductID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY,
    PolicyID INT,
    ClaimAmount DECIMAL(10,2),
    ClaimDate DATE,
    SettlementDate DATE,
    Status VARCHAR(30),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);
GO

-- Add customers
INSERT INTO Customers VALUES
(1, 'Arun Kumar', '1990-05-12'),
(2, 'Priya S', '1985-08-20'),
(3, 'Karthik R', '2000-02-15'),
(4, 'Divya M', '1995-11-10'),
(5, 'Rahul P', '1978-04-25'),
(6, 'Meena K', '1998-07-18'),
(7, 'Vijay S', '1982-09-05'),
(8, 'Nithya R', '2002-01-30');

-- Add insurance products
INSERT INTO InsuranceProducts VALUES
(101, 'Health Insurance'),
(102, 'Life Insurance'),
(103, 'Vehicle Insurance'),
(104, 'Travel Insurance');

-- Add agents
INSERT INTO Agents VALUES
(1, 'Anand'),
(2, 'Kavitha'),
(3, 'Ramesh'),
(4, 'Suresh'),
(5, 'Divya');

-- Add policies
INSERT INTO Policies VALUES
(1, 'POL1001', 1, 101, 1, '2025-01-01', DATEADD(DAY, 10, GETDATE()), 12000, 'Active'),
(2, 'POL1002', 1, 102, 1, '2025-03-01', DATEADD(DAY, 20, GETDATE()), 18000, 'Active'),
(3, 'POL1003', 2, 101, 2, '2025-05-01', DATEADD(DAY, 45, GETDATE()), 15000, 'Active'),
(4, 'POL1004', 3, 103, 2, '2025-07-01', DATEADD(DAY, 5, GETDATE()), 9000, 'Active'),
(5, 'POL1005', 4, 102, 3, '2025-08-01', '2027-08-01', 20000, 'Active'),
(6, 'POL1006', 5, 103, 3, '2026-01-01', '2027-01-01', 11000, 'Active'),
(7, 'POL1007', 6, 104, 4, '2026-02-01', '2027-02-01', 6000, 'Active'),
(8, 'POL1008', 7, 101, 4, '2026-03-01', '2027-03-01', 14000, 'Active'),
(9, 'POL1009', 8, 104, 5, '2026-04-01', '2027-04-01', 7500, 'Expired'),
(10, 'POL1010', 2, 103, 5, '2026-05-01', '2027-05-01', 10000, 'Active');

-- Add claims
INSERT INTO Claims VALUES
(1, 1, 5000, '2026-01-10', '2026-01-20', 'Settled'),
(2, 3, 7000, '2026-02-15', '2026-03-01', 'Settled'),
(3, 4, 3000, '2026-04-10', '2026-04-25', 'Settled'),
(4, 5, 8000, '2026-05-15', NULL, 'Pending'),
(5, 6, 4000, '2026-06-20', '2026-07-05', 'Settled'),
(6, 8, 2000, '2026-07-10', NULL, 'Pending');
GO

-- 1. Policies expiring in the next 30 days
SELECT PolicyNumber, ExpiryDate
FROM Policies
WHERE ExpiryDate BETWEEN CAST(GETDATE() AS DATE)
AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE));

-- 2. Premium collected per product
SELECT IP.ProductName,
       SUM(P.PremiumAmount) AS TotalPremium
FROM Policies P
JOIN InsuranceProducts IP ON P.ProductID = IP.ProductID
WHERE P.Status = 'Active'
GROUP BY IP.ProductName;

-- 3. Customers with more than one active policy
SELECT C.CustomerName, COUNT(*) AS ActivePolicies
FROM Customers C
JOIN Policies P ON C.CustomerID = P.CustomerID
WHERE P.Status = 'Active'
GROUP BY C.CustomerName
HAVING COUNT(*) > 1;

-- 4. Claim ratio per product
SELECT IP.ProductName,
       SUM(C.ClaimAmount) AS TotalClaims,
       SUM(P.PremiumAmount) AS TotalPremium,
       ROUND(
           SUM(C.ClaimAmount) * 100.0 /
           NULLIF(SUM(P.PremiumAmount), 0), 2
       ) AS ClaimRatio
FROM InsuranceProducts IP
JOIN Policies P ON IP.ProductID = P.ProductID
LEFT JOIN Claims C ON P.PolicyID = C.PolicyID
GROUP BY IP.ProductName;

-- 5. Policies without claims
SELECT P.PolicyNumber, P.Status
FROM Policies P
LEFT JOIN Claims C ON P.PolicyID = C.PolicyID
WHERE C.ClaimID IS NULL;

-- 6. Average premium by customer age band
SELECT
    CASE
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 30 THEN 'Below 30'
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) BETWEEN 30 AND 49 THEN '30-49'
        ELSE '50 and above'
    END AS AgeBand,
    ROUND(AVG(P.PremiumAmount), 2) AS AveragePremium
FROM Customers C
JOIN Policies P ON C.CustomerID = P.CustomerID
GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) < 30 THEN 'Below 30'
        WHEN DATEDIFF(YEAR, C.DateOfBirth, GETDATE()) BETWEEN 30 AND 49 THEN '30-49'
        ELSE '50 and above'
    END;

-- 7. Monthly new policies
SELECT
    FORMAT(StartDate, 'yyyy-MM') AS PolicyMonth,
    COUNT(*) AS NewPolicies
FROM Policies
GROUP BY FORMAT(StartDate, 'yyyy-MM')
ORDER BY PolicyMonth;

-- 8. Top five agents by premium
SELECT TOP 5
    A.AgentName,
    SUM(P.PremiumAmount) AS TotalPremium
FROM Agents A
JOIN Policies P ON A.AgentID = P.AgentID
GROUP BY A.AgentName
ORDER BY TotalPremium DESC;

-- Mask policy numbers
SELECT
    CONCAT('XXXX', RIGHT(PolicyNumber, 4)) AS MaskedPolicyNumber,
    DATEDIFF(DAY, StartDate, GETDATE()) AS PolicyAgeDays
FROM Policies;

-- WHERE filters individual rows before grouping.
-- HAVING filters grouped results after aggregation.
SELECT CustomerID, COUNT(*) AS ActivePolicies
FROM Policies
WHERE Status = 'Active'
GROUP BY CustomerID
HAVING COUNT(*) > 1;
GO
