
-- Day 5 - Set 2: Bank Accounts

-- Create database
USE master;
GO

IF DB_ID('NexoraBankDB') IS NULL
    CREATE DATABASE NexoraBankDB;
GO

USE NexoraBankDB;
GO

-- Create tables

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Phone VARCHAR(15) UNIQUE
);
GO

CREATE TABLE Branches (
    BranchID INT IDENTITY(1,1) PRIMARY KEY,
    BranchName VARCHAR(100) NOT NULL,
    City VARCHAR(60) NOT NULL
);
GO

CREATE TABLE Managers (
    ManagerID INT IDENTITY(1,1) PRIMARY KEY,
    ManagerName VARCHAR(100) NOT NULL,
    Phone VARCHAR(15)
);
GO

CREATE TABLE Accounts (
    AccountID INT IDENTITY(1,1) PRIMARY KEY,
    AccountNumber VARCHAR(20) NOT NULL UNIQUE,
    CustomerID INT NOT NULL,
    BranchID INT NOT NULL,
    ManagerID INT NOT NULL,
    AccountType VARCHAR(20) NOT NULL,
    Balance DECIMAL(12,2) NOT NULL,
    OpenedDate DATE NOT NULL,

    CONSTRAINT CK_Account_Balance
        CHECK (AccountType <> 'Savings' OR Balance >= 0),

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID),

    FOREIGN KEY (BranchID)
        REFERENCES Branches(BranchID),

    FOREIGN KEY (ManagerID)
        REFERENCES Managers(ManagerID)
);
GO

-- Joint account holders
CREATE TABLE CustomerAccounts (
    CustomerID INT NOT NULL,
    AccountID INT NOT NULL,

    PRIMARY KEY (CustomerID, AccountID),

    FOREIGN KEY (CustomerID)
        REFERENCES Customers(CustomerID) ON DELETE CASCADE,

    FOREIGN KEY (AccountID)
        REFERENCES Accounts(AccountID) ON DELETE CASCADE
);
GO

-- Insert branch details
INSERT INTO Branches (BranchName, City) VALUES
('Main Branch', 'Chennai'),
('City Branch', 'Coimbatore'),
('Central Branch', 'Bengaluru'),
('North Branch', 'Hyderabad'),
('South Branch', 'Madurai');

-- Insert managers
INSERT INTO Managers (ManagerName, Phone) VALUES
('Arun Kumar', '9001100101'),
('Priya Sharma', '9001100102'),
('Karthik Raj', '9001100103'),
('Divya S', '9001100104'),
('Rahul M', '9001100105');

-- Insert customers
INSERT INTO Customers (CustomerName, Address, Phone) VALUES
('Anand Kumar', 'Chennai', '9001100201'),
('Priya R', 'Coimbatore', '9001100202'),
('Vijay S', 'Bengaluru', '9001100203'),
('Meena K', 'Hyderabad', '9001100204'),
('Arun P', 'Madurai', '9001100205'),
('Divya M', 'Chennai', '9001100206'),
('Karthik R', 'Coimbatore', '9001100207'),
('Nithya S', 'Bengaluru', '9001100208'),
('Rahul V', 'Hyderabad', '9001100209'),
('Anitha P', 'Madurai', '9001100210');

-- Insert account details
INSERT INTO Accounts
(AccountNumber, CustomerID, BranchID, ManagerID, AccountType, Balance, OpenedDate)
VALUES
('NXB1001', 1, 1, 1, 'Savings', 25000, '2026-07-05'),
('NXB1002', 2, 2, 2, 'Current', 45000, '2026-07-12'),
('NXB1003', 3, 3, 3, 'Savings', 32000, '2026-07-20'),
('NXB1004', 4, 4, 4, 'Savings', 18000, '2026-08-03'),
('NXB1005', 5, 5, 5, 'Current', 60000, '2026-08-15'),
('NXB1006', 6, 1, 1, 'Savings', 15000, '2026-08-22'),
('NXB1007', 7, 2, 2, 'Current', 52000, '2026-09-02'),
('NXB1008', 8, 3, 3, 'Savings', 28000, '2026-09-10'),
('NXB1009', 9, 4, 4, 'Savings', 35000, '2026-09-18'),
('NXB1010', 10, 5, 5, 'Current', 70000, '2026-09-25');

-- Add account holders
INSERT INTO CustomerAccounts (CustomerID, AccountID)
SELECT CustomerID, AccountID FROM Accounts;

-- View inserted records
SELECT * FROM Customers;
SELECT * FROM Branches;
SELECT * FROM Managers;
SELECT * FROM Accounts;
SELECT * FROM CustomerAccounts;
GO

-- Update account balance
UPDATE Accounts
SET Balance = 30000
WHERE AccountNumber = 'NXB1001';

-- Delete one account
-- Related customer links are removed automatically
DELETE FROM Accounts
WHERE AccountNumber = 'NXB1010';

-- View updated records
SELECT * FROM Accounts;
GO

-- Filter accounts using WHERE conditions
-- Accounts opened in the last quarter with balance above 20000
SELECT *
FROM Accounts
WHERE OpenedDate BETWEEN '2026-07-01' AND '2026-09-30'
AND Balance > 20000;

-- Use OR condition
SELECT *
FROM Accounts
WHERE AccountType = 'Savings'
OR Balance > 50000;

-- Use IN condition
SELECT *
FROM Accounts
WHERE BranchID IN (1, 2, 3);

-- Use AND condition
SELECT *
FROM Accounts
WHERE AccountType = 'Savings'
AND Balance > 20000;
GO

-- Test DELETE, TRUNCATE and DROP

CREATE TABLE AccountTest (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    TestName VARCHAR(50)
);

INSERT INTO AccountTest (TestName)
VALUES ('First'), ('Second'), ('Third');

-- DELETE removes rows but keeps the table
DELETE FROM AccountTest;

INSERT INTO AccountTest (TestName)
VALUES ('After Delete');

SELECT * FROM AccountTest;
-- Identity continues from the previous value

-- TRUNCATE removes all rows and resets identity
TRUNCATE TABLE AccountTest;

INSERT INTO AccountTest (TestName)
VALUES ('After Truncate');

SELECT * FROM AccountTest;
-- Identity starts again from 1

-- DROP removes the table
DROP TABLE AccountTest;
GO

-- Test rollback behaviour
CREATE TABLE RollbackTest (
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    TestName VARCHAR(50)
);

INSERT INTO RollbackTest (TestName)
VALUES ('Original');

-- DELETE can be rolled back
BEGIN TRANSACTION;
DELETE FROM RollbackTest;
ROLLBACK TRANSACTION;

SELECT * FROM RollbackTest;

-- TRUNCATE can also be rolled back
BEGIN TRANSACTION;
TRUNCATE TABLE RollbackTest;
ROLLBACK TRANSACTION;

SELECT * FROM RollbackTest;

-- DROP can be rolled back inside a transaction
BEGIN TRANSACTION;
DROP TABLE RollbackTest;
ROLLBACK TRANSACTION;

SELECT * FROM RollbackTest;
GO
