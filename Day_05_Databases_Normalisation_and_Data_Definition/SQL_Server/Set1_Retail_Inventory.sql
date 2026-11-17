
-- DAY 5 - SET 1: RETAIL INVENTORY MANAGEMENT
-- DATABASE AND TABLE CREATION

USE master;
GO

IF DB_ID('NexoraRetailDB') IS NULL
BEGIN
    CREATE DATABASE NexoraRetailDB;
END;
GO

USE NexoraRetailDB;
GO

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(80) NOT NULL UNIQUE,
    CategoryDescription VARCHAR(200)
);
GO

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    SupplierPhone VARCHAR(15) NOT NULL UNIQUE,
    SupplierEmail VARCHAR(120)
);
GO

CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(60) NOT NULL
);
GO

CREATE TABLE Products (
    SKU VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(120) NOT NULL,
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    IsDiscontinued BIT NOT NULL DEFAULT 0,
    CONSTRAINT CK_Product_Price CHECK (UnitPrice >= 0),
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID) ON DELETE NO ACTION,
    CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID) ON DELETE NO ACTION
);
GO

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    SKU VARCHAR(20) NOT NULL,
    WarehouseID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    ReorderLevel INT NOT NULL DEFAULT 5,
    CONSTRAINT UQ_Stock_Location UNIQUE (SKU, WarehouseID),
    CONSTRAINT CK_Inventory_Quantity CHECK (Quantity >= 0),
    CONSTRAINT CK_Inventory_Reorder CHECK (ReorderLevel >= 0),
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (SKU)
        REFERENCES Products(SKU) ON DELETE CASCADE,
    CONSTRAINT FK_Inventory_Warehouse FOREIGN KEY (WarehouseID)
        REFERENCES Warehouses(WarehouseID) ON DELETE NO ACTION
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO


-- DAY 5 - SET 1: RETAIL INVENTORY MANAGEMENT
-- DATABASE AND TABLE CREATION

USE master;
GO

IF DB_ID('NexoraRetailDB') IS NULL
BEGIN
    CREATE DATABASE NexoraRetailDB;
END;
GO

USE NexoraRetailDB;
GO

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(80) NOT NULL UNIQUE,
    CategoryDescription VARCHAR(200)
);
GO

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    SupplierPhone VARCHAR(15) NOT NULL UNIQUE,
    SupplierEmail VARCHAR(120)
);
GO

CREATE TABLE Warehouses (
    WarehouseID INT PRIMARY KEY,
    WarehouseName VARCHAR(100) NOT NULL UNIQUE,
    City VARCHAR(60) NOT NULL
);
GO

CREATE TABLE Products (
    SKU VARCHAR(20) PRIMARY KEY,
    ProductName VARCHAR(120) NOT NULL,
    CategoryID INT NOT NULL,
    SupplierID INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    IsDiscontinued BIT NOT NULL DEFAULT 0,
    CONSTRAINT CK_Product_Price CHECK (UnitPrice >= 0),
    CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID) ON DELETE NO ACTION,
    CONSTRAINT FK_Product_Supplier FOREIGN KEY (SupplierID)
        REFERENCES Suppliers(SupplierID) ON DELETE NO ACTION
);
GO

CREATE TABLE Inventory (
    InventoryID INT IDENTITY(1,1) PRIMARY KEY,
    SKU VARCHAR(20) NOT NULL,
    WarehouseID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    ReorderLevel INT NOT NULL DEFAULT 5,
    CONSTRAINT UQ_Stock_Location UNIQUE (SKU, WarehouseID),
    CONSTRAINT CK_Inventory_Quantity CHECK (Quantity >= 0),
    CONSTRAINT CK_Inventory_Reorder CHECK (ReorderLevel >= 0),
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (SKU)
        REFERENCES Products(SKU) ON DELETE CASCADE,
    CONSTRAINT FK_Inventory_Warehouse FOREIGN KEY (WarehouseID)
        REFERENCES Warehouses(WarehouseID) ON DELETE NO ACTION
);
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO



-- validation testing 


-- DAY 5 - SET 1: CONSTRAINT VALIDATION TESTS

USE NexoraRetailDB;
GO

-- TEST 1: DUPLICATE PRIMARY KEY
INSERT INTO Categories (CategoryID, CategoryName, CategoryDescription)
VALUES (1, 'Duplicate Category', 'Testing duplicate primary key');
GO

-- TEST 2: MISSING PARENT RECORD
INSERT INTO Products (SKU, ProductName, CategoryID, SupplierID, UnitPrice)
VALUES ('NX-TEST-101', 'Invalid Product', 99, 1, 1500);
GO

-- TEST 3: NEGATIVE INVENTORY QUANTITY
INSERT INTO Inventory (SKU, WarehouseID, Quantity, ReorderLevel)
VALUES ('NX-ELE-001', 2, -20, 5);
GO

-- TEST 4: NULL IN MANDATORY COLUMN
INSERT INTO Suppliers (SupplierID, SupplierName, SupplierPhone, SupplierEmail)
VALUES (11, NULL, '9001100011', 'test@nexora.example');
GO



-- DAY 5 - SET 1: SELECT, UPDATE AND DELETE OPERATIONS

USE NexoraRetailDB;
GO

-- DISPLAY ALL TABLE RECORDS
SELECT * FROM Categories;
SELECT * FROM Suppliers;
SELECT * FROM Warehouses;
SELECT * FROM Products;
SELECT * FROM Inventory;
GO

-- DISPLAY PRODUCT DETAILS WITH CATEGORY AND SUPPLIER
SELECT P.SKU, P.ProductName, C.CategoryName, S.SupplierName, P.UnitPrice
FROM Products P
INNER JOIN Categories C ON P.CategoryID = C.CategoryID
INNER JOIN Suppliers S ON P.SupplierID = S.SupplierID;
GO

-- DISPLAY INVENTORY DETAILS
SELECT I.InventoryID, P.ProductName, W.WarehouseName, I.Quantity, I.ReorderLevel
FROM Inventory I
INNER JOIN Products P ON I.SKU = P.SKU
INNER JOIN Warehouses W ON I.WarehouseID = W.WarehouseID;
GO

-- UPDATE SUPPLIER PHONE NUMBER
SELECT SupplierID, SupplierName, SupplierPhone
FROM Suppliers WHERE SupplierID = 1;

UPDATE Suppliers
SET SupplierPhone = '9876500001'
WHERE SupplierID = 1;

SELECT SupplierID, SupplierName, SupplierPhone
FROM Suppliers WHERE SupplierID = 1;
GO

-- MARK PRODUCT AS DISCONTINUED
SELECT SKU, ProductName, IsDiscontinued
FROM Products WHERE SKU = 'NX-OUT-010';

UPDATE Products
SET IsDiscontinued = 1
WHERE SKU = 'NX-OUT-010';

SELECT SKU, ProductName, IsDiscontinued
FROM Products WHERE SKU = 'NX-OUT-010';
GO

-- DELETE DISCONTINUED PRODUCT
DELETE FROM Products
WHERE SKU = 'NX-OUT-010'
AND IsDiscontinued = 1;

SELECT * FROM Products WHERE SKU = 'NX-OUT-010';
SELECT * FROM Inventory WHERE SKU = 'NX-OUT-010';
GO

-- DISPLAY PRODUCTS BELOW REORDER LEVEL
SELECT P.ProductName, I.Quantity, I.ReorderLevel
FROM Products P
INNER JOIN Inventory I ON P.SKU = I.SKU
WHERE I.Quantity <= I.ReorderLevel;
GO
