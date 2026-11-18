
/*
DAY 7 - SET 2
BANK LOAN PORTFOLIO ANALYSIS
*/

IF DB_ID('NexoraBankLoansDB') IS NULL
    CREATE DATABASE NexoraBankLoansDB;
GO

USE NexoraBankLoansDB;
GO

DROP TABLE IF EXISTS dbo.LoanInstallments;
DROP TABLE IF EXISTS dbo.Repayments;
DROP TABLE IF EXISTS dbo.LoanGuarantors;
DROP TABLE IF EXISTS dbo.Loans;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Branches;
GO

-- 1. CREATE TABLES

CREATE TABLE dbo.Branches (
    BranchID INT IDENTITY PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(80) NOT NULL,
    Region VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE,
    City VARCHAR(80) NOT NULL
);

CREATE TABLE dbo.Loans (
    LoanID INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    LoanType VARCHAR(50) NOT NULL,
    LoanAmount DECIMAL(12,2) NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    LoanDate DATE NOT NULL,
    LoanStatus VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID),
    FOREIGN KEY (BranchID) REFERENCES dbo.Branches(BranchID)
);

CREATE TABLE dbo.LoanGuarantors (
    GuarantorID INT IDENTITY PRIMARY KEY,
    LoanID INT NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES dbo.Loans(LoanID),
    FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);

CREATE TABLE dbo.Repayments (
    RepaymentID INT IDENTITY PRIMARY KEY,
    LoanID INT NOT NULL,
    RepaymentDate DATE NOT NULL,
    AmountPaid DECIMAL(12,2) NOT NULL,
    FOREIGN KEY (LoanID) REFERENCES dbo.Loans(LoanID)
);

CREATE TABLE dbo.LoanInstallments (
    InstallmentID INT IDENTITY PRIMARY KEY,
    LoanID INT NOT NULL,
    DueDate DATE NOT NULL,
    AmountDue DECIMAL(12,2) NOT NULL,
    AmountPaid DECIMAL(12,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (LoanID) REFERENCES dbo.Loans(LoanID)
);
GO

-- 2. INSERT BRANCHES

INSERT INTO dbo.Branches
(BranchName, City, Region) VALUES
('Chennai Main','Chennai','South'),
('Bengaluru Branch','Bengaluru','South'),
('Hyderabad Branch','Hyderabad','South'),
('Mumbai Central','Mumbai','West'),
('Delhi Branch','Delhi','North'),
('Pune Branch','Pune','West');

-- 3. INSERT CUSTOMERS

INSERT INTO dbo.Customers
(CustomerName, Email, City) VALUES
('Arun Kumar','arun@example.com','Chennai'),
('Priya Sharma','priya@example.com','Bengaluru'),
('Rahul Verma','rahul@example.com','Hyderabad'),
('Meena Raj','meena@example.com','Mumbai'),
('Karthik Das','karthik@example.com','Pune'),
('Divya Nair','divya@example.com','Delhi');

-- 4. INSERT LOANS

INSERT INTO dbo.Loans
(CustomerID,BranchID,LoanType,LoanAmount,
 InterestRate,LoanDate,LoanStatus) VALUES
(1,1,'Home Loan',2500000,8.50,'2025-01-10','Active'),
(2,2,'Personal Loan',500000,11.00,'2025-02-15','Active'),
(3,3,'Car Loan',800000,9.25,'2025-03-20','Active'),
(4,4,'Home Loan',3000000,8.25,'2025-04-05','Active'),
(5,6,'Education Loan',600000,7.50,'2025-05-12','Active'),
(6,5,'Personal Loan',400000,12.00,'2025-06-18','Active'),
(1,2,'Car Loan',900000,9.00,'2025-07-01','Active'),
(3,4,'Business Loan',1500000,10.50,'2025-08-10','Active'),
(5,1,'Personal Loan',350000,11.50,'2025-09-15','Closed'),
(2,3,'Education Loan',700000,7.75,'2025-10-20','Active');

-- 5. INSERT GUARANTORS

INSERT INTO dbo.LoanGuarantors
(LoanID,CustomerID) VALUES
(1,2),(2,3),(3,1),(4,5),(5,6),
(6,4),(7,3),(8,1),(9,2),(10,4);

-- 6. INSERT REPAYMENTS

INSERT INTO dbo.Repayments
(LoanID,RepaymentDate,AmountPaid) VALUES
(1,'2026-09-01',25000),
(1,'2026-10-01',25000),
(2,'2026-10-05',12000),
(3,'2026-08-15',18000),
(4,'2026-09-10',30000),
(5,'2026-10-12',10000),
(6,'2026-07-20',9000),
(7,'2026-09-15',15000),
(8,'2026-08-25',22000),
(10,'2026-10-01',11000);

-- 7. INSERT INSTALLMENTS

INSERT INTO dbo.LoanInstallments
(LoanID,DueDate,AmountDue,AmountPaid) VALUES
(1,'2026-07-01',25000,0),
(1,'2026-08-01',25000,0),
(1,'2026-09-01',25000,25000),
(1,'2026-10-01',25000,25000),
(2,'2026-08-01',12000,12000),
(2,'2026-09-01',12000,0),
(3,'2026-09-01',18000,18000),
(4,'2026-10-01',30000,30000),
(5,'2026-10-01',10000,10000),
(6,'2026-08-01',9000,0);
GO

-- 8. BUSINESS QUERIES

-- QUERY 1: Loans with more than three overdue installments

SELECT l.LoanID,c.CustomerName,
       COUNT(i.InstallmentID) AS OverdueInstallments
FROM dbo.Loans l
JOIN dbo.Customers c ON c.CustomerID=l.CustomerID
JOIN dbo.LoanInstallments i ON i.LoanID=l.LoanID
WHERE i.DueDate < '2026-11-18'
AND i.AmountPaid < i.AmountDue
GROUP BY l.LoanID,c.CustomerName
HAVING COUNT(i.InstallmentID)>3;

-- QUERY 2: Customers having loans in multiple branches

SELECT c.CustomerID,c.CustomerName,
       COUNT(DISTINCT l.BranchID) AS BranchCount
FROM dbo.Customers c
JOIN dbo.Loans l ON l.CustomerID=c.CustomerID
GROUP BY c.CustomerID,c.CustomerName
HAVING COUNT(DISTINCT l.BranchID)>1;

-- QUERY 3: Guarantors who are also borrowers

SELECT DISTINCT c.CustomerID,c.CustomerName
FROM dbo.Customers c
JOIN dbo.LoanGuarantors g ON g.CustomerID=c.CustomerID
JOIN dbo.Loans l ON l.CustomerID=c.CustomerID;

-- QUERY 4: Branches without any loans

SELECT b.BranchID,b.BranchName
FROM dbo.Branches b
LEFT JOIN dbo.Loans l ON l.BranchID=b.BranchID
WHERE l.LoanID IS NULL;

-- QUERY 5: Loan details with customer and branch

SELECT l.LoanID,c.CustomerName,
       b.BranchName,l.LoanType,
       l.LoanAmount,l.InterestRate,l.LoanStatus
FROM dbo.Loans l
JOIN dbo.Customers c ON c.CustomerID=l.CustomerID
JOIN dbo.Branches b ON b.BranchID=l.BranchID;

-- QUERY 6: Branch-wise total loan exposure (correlated subquery)

SELECT b.BranchName,
       (SELECT SUM(l.LoanAmount)
        FROM dbo.Loans l
        WHERE l.BranchID=b.BranchID) AS TotalExposure
FROM dbo.Branches b;

-- QUERY 7: Branch-wise exposure using JOIN

SELECT b.BranchName,
       COALESCE(SUM(l.LoanAmount),0) AS TotalExposure
FROM dbo.Branches b
LEFT JOIN dbo.Loans l ON l.BranchID=b.BranchID
GROUP BY b.BranchName;

-- QUERY 8: Loans with no repayment in the last 60 days

SELECT l.LoanID,l.LoanAmount,l.LoanStatus
FROM dbo.Loans l
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Repayments r
    WHERE r.LoanID=l.LoanID
    AND r.RepaymentDate >= DATEADD(DAY,-60,'2026-11-18')
);

-- QUERY 9: Branches whose maximum loan is greater than
-- the average of all branch maximum loans

WITH BranchMaximum AS (
    SELECT BranchID,MAX(LoanAmount) AS MaximumLoan
    FROM dbo.Loans
    GROUP BY BranchID
)
SELECT b.BranchName,bm.MaximumLoan
FROM BranchMaximum bm
JOIN dbo.Branches b ON b.BranchID=bm.BranchID
WHERE bm.MaximumLoan > (
    SELECT AVG(MaximumLoan * 1.0)
    FROM BranchMaximum
);

-- QUERY 10: Loans greater than every loan in Branch 1

SELECT LoanID,LoanAmount,LoanType
FROM dbo.Loans
WHERE LoanAmount > ALL (
    SELECT LoanAmount
    FROM dbo.Loans
    WHERE BranchID=1
);
GO
