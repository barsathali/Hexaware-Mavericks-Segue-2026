/*
DAY 7 - SET 1
LOGISTICS SHIPMENT ANALYSIS
*/

IF DB_ID('NexoraLogisticsDB') IS NULL
    CREATE DATABASE NexoraLogisticsDB;
GO

USE NexoraLogisticsDB;
GO

DROP TABLE IF EXISTS dbo.DeliveryEvents;
DROP TABLE IF EXISTS dbo.Shipments;
DROP TABLE IF EXISTS dbo.Employees;
DROP TABLE IF EXISTS dbo.Carriers;
DROP TABLE IF EXISTS dbo.Customers;
DROP TABLE IF EXISTS dbo.Hubs;
GO

-- 1. CREATE TABLES

CREATE TABLE dbo.Hubs (
    HubID INT IDENTITY PRIMARY KEY,
    HubName VARCHAR(80) NOT NULL UNIQUE,
    City VARCHAR(80) NOT NULL,
    Region VARCHAR(50) NOT NULL
);

CREATE TABLE dbo.Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    City VARCHAR(80) NOT NULL,
    Email VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE dbo.Carriers (
    CarrierID INT IDENTITY PRIMARY KEY,
    CarrierName VARCHAR(100) NOT NULL UNIQUE,
    ContactNumber VARCHAR(20)
);

CREATE TABLE dbo.Employees (
    EmployeeID INT IDENTITY PRIMARY KEY,
    EmployeeName VARCHAR(100) NOT NULL,
    JobTitle VARCHAR(60) NOT NULL,
    SupervisorID INT NULL,
    FOREIGN KEY (SupervisorID)
        REFERENCES dbo.Employees(EmployeeID)
);

CREATE TABLE dbo.Shipments (
    ShipmentID INT IDENTITY PRIMARY KEY,
    TrackingNumber VARCHAR(30) NOT NULL UNIQUE,
    CustomerID INT NOT NULL,
    CarrierID INT NOT NULL,
    OriginHubID INT NOT NULL,
    DestinationHubID INT NOT NULL,
    HandledByEmployeeID INT NULL,
    ShipDate DATE NOT NULL,
    PromisedDeliveryDate DATE NOT NULL,
    ActualDeliveryDate DATE NULL,
    ShippingCost DECIMAL(10,2) NOT NULL
        CHECK (ShippingCost >= 0),
    Status VARCHAR(20) NOT NULL,

    FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID),

    FOREIGN KEY (CarrierID)
        REFERENCES dbo.Carriers(CarrierID),

    FOREIGN KEY (OriginHubID)
        REFERENCES dbo.Hubs(HubID),

    FOREIGN KEY (DestinationHubID)
        REFERENCES dbo.Hubs(HubID),

    FOREIGN KEY (HandledByEmployeeID)
        REFERENCES dbo.Employees(EmployeeID)
);

CREATE TABLE dbo.DeliveryEvents (
    EventID INT IDENTITY PRIMARY KEY,
    ShipmentID INT NOT NULL,
    EventType VARCHAR(50) NOT NULL,
    EventDateTime DATETIME2 NOT NULL,
    EventLocation VARCHAR(100) NOT NULL,
    Notes VARCHAR(250),

    FOREIGN KEY (ShipmentID)
        REFERENCES dbo.Shipments(ShipmentID)
);
GO

-- 2. INSERT HUBS

INSERT INTO dbo.Hubs (HubName, City, Region) VALUES
('Chennai Central','Chennai','South'),
('Bengaluru Hub','Bengaluru','South'),
('Hyderabad Hub','Hyderabad','South'),
('Mumbai Hub','Mumbai','West'),
('Pune Hub','Pune','West'),
('Delhi Hub','Delhi','North');

-- 3. INSERT CUSTOMERS

INSERT INTO dbo.Customers (CustomerName, City, Email) VALUES
('Aarav Traders','Chennai','aarav@example.com'),
('Bright Stores','Bengaluru','bright@example.com'),
('City Mart','Hyderabad','citymart@example.com'),
('Delta Retail','Mumbai','delta@example.com'),
('Evergreen Shop','Pune','evergreen@example.com'),
('Fresh Basket','Delhi','fresh@example.com');

-- 4. INSERT CARRIERS

INSERT INTO dbo.Carriers (CarrierName, ContactNumber) VALUES
('SwiftMove','9000000001'),
('RoadRunner','9000000002'),
('BlueDartline','9000000003'),
('CargoLink','9000000004');

-- 5. INSERT EMPLOYEES

INSERT INTO dbo.Employees
(EmployeeName, JobTitle, SupervisorID) VALUES
('Meera Kumar','Operations Manager',NULL),
('Arun Raj','Hub Supervisor',1),
('Divya Shah','Hub Supervisor',1),
('Kavin Das','Shipment Coordinator',2),
('Nisha Rao','Shipment Coordinator',2),
('Rahul Sen','Shipment Coordinator',3);

-- 6. INSERT SHIPMENTS

INSERT INTO dbo.Shipments
(TrackingNumber, CustomerID, CarrierID,
 OriginHubID, DestinationHubID, HandledByEmployeeID,
 ShipDate, PromisedDeliveryDate, ActualDeliveryDate,
 ShippingCost, Status)
VALUES
('NX1001',1,1,1,2,4,'2026-10-01','2026-10-03','2026-10-06',850,'Delivered'),
('NX1002',2,2,2,3,5,'2026-10-02','2026-10-04','2026-10-04',620,'Delivered'),
('NX1003',3,1,3,4,6,'2026-10-03','2026-10-05','2026-10-09',1100,'Delivered'),
('NX1004',4,3,4,5,4,'2026-10-04','2026-10-07','2026-10-07',740,'Delivered'),
('NX1005',5,4,5,6,5,'2026-10-05','2026-10-08','2026-10-12',980,'Delivered'),
('NX1006',6,2,6,1,6,'2026-10-06','2026-10-09','2026-10-10',1250,'Delivered'),
('NX1007',1,3,1,3,4,'2026-10-07','2026-10-10','2026-10-10',540,'Delivered'),
('NX1008',2,4,2,4,5,'2026-10-08','2026-10-11','2026-10-15',1350,'Delivered'),
('NX1009',3,1,3,5,6,'2026-10-09','2026-10-12','2026-10-12',760,'Delivered'),
('NX1010',4,2,4,6,4,'2026-10-10','2026-10-13',NULL,690,'In Transit'),
('NX1011',5,3,5,1,5,'2026-10-11','2026-10-14','2026-10-16',920,'Delivered'),
('NX1012',6,4,6,2,6,'2026-10-12','2026-10-15','2026-10-15',1050,'Delivered'),
('NX1013',1,1,1,4,4,'2026-10-13','2026-10-16','2026-10-20',1450,'Delivered'),
('NX1014',2,2,2,5,5,'2026-10-14','2026-10-17','2026-10-17',880,'Delivered'),
('NX1015',3,3,3,6,6,'2026-10-15','2026-10-18','2026-10-18',1150,'Delivered');

-- 7. INSERT DELIVERY EVENTS

INSERT INTO dbo.DeliveryEvents
(ShipmentID, EventType, EventDateTime, EventLocation, Notes)
VALUES
(1,'Picked Up','2026-10-01T09:00:00','Chennai Central','Shipment collected'),
(1,'In Transit','2026-10-02T14:30:00','Bengaluru Hub','Arrived at transit hub'),
(1,'Delivered','2026-10-06T11:15:00','Bengaluru Hub','Delivered to customer'),
(2,'Picked Up','2026-10-02T10:00:00','Bengaluru Hub','Shipment collected'),
(2,'Delivered','2026-10-04T16:00:00','Hyderabad Hub','Delivered on time'),
(3,'Picked Up','2026-10-03T08:30:00','Hyderabad Hub','Shipment collected'),
(3,'Delayed','2026-10-07T12:00:00','Mumbai Hub','Vehicle delay'),
(3,'Delivered','2026-10-09T17:20:00','Mumbai Hub','Delivered'),
(4,'Picked Up','2026-10-04T09:10:00','Mumbai Hub','Shipment collected'),
(4,'Delivered','2026-10-07T13:00:00','Pune Hub','Delivered on time'),
(5,'Picked Up','2026-10-05T10:00:00','Pune Hub','Shipment collected'),
(5,'Delayed','2026-10-11T15:00:00','Delhi Hub','Weather delay'),
(5,'Delivered','2026-10-12T12:00:00','Delhi Hub','Delivered'),
(6,'Picked Up','2026-10-06T08:00:00','Delhi Hub','Shipment collected'),
(6,'Delivered','2026-10-10T18:00:00','Chennai Central','Delivered'),
(8,'Delayed','2026-10-14T13:00:00','Mumbai Hub','Sorting delay'),
(8,'Delivered','2026-10-15T15:00:00','Mumbai Hub','Delivered'),
(10,'Picked Up','2026-10-10T11:00:00','Mumbai Hub','Shipment collected');
GO

-- 8. BUSINESS QUERIES

-- QUERY 1: Shipments delayed by more than two days

SELECT s.TrackingNumber, c.CarrierName,
       s.PromisedDeliveryDate, s.ActualDeliveryDate,
       DATEDIFF(DAY,s.PromisedDeliveryDate,
                     s.ActualDeliveryDate) AS DelayDays
FROM dbo.Shipments s
INNER JOIN dbo.Carriers c
ON c.CarrierID=s.CarrierID
WHERE s.ActualDeliveryDate >
      DATEADD(DAY,2,s.PromisedDeliveryDate);

-- QUERY 2: Hubs without outbound shipments

SELECT h.HubID,h.HubName
FROM dbo.Hubs h
LEFT JOIN dbo.Shipments s
ON s.OriginHubID=h.HubID
WHERE s.ShipmentID IS NULL;

-- QUERY 3: Employees and their supervisors (SELF JOIN)

SELECT e.EmployeeName AS Employee,
       e.JobTitle,
       sup.EmployeeName AS Supervisor
FROM dbo.Employees e
LEFT JOIN dbo.Employees sup
ON sup.EmployeeID=e.SupervisorID;

-- QUERY 4: Hubs and their outbound shipment counts

SELECT h.HubName,
       COUNT(s.ShipmentID) AS OutboundShipmentCount
FROM dbo.Hubs h
FULL OUTER JOIN dbo.Shipments s
ON s.OriginHubID=h.HubID
GROUP BY h.HubName;

-- QUERY 5: Shipment details with customer and hubs

SELECT s.TrackingNumber,
       cu.CustomerName,
       oh.HubName AS OriginHub,
       dh.HubName AS DestinationHub,
       s.Status
FROM dbo.Shipments s
INNER JOIN dbo.Customers cu
ON cu.CustomerID=s.CustomerID
INNER JOIN dbo.Hubs oh
ON oh.HubID=s.OriginHubID
INNER JOIN dbo.Hubs dh
ON dh.HubID=s.DestinationHubID;

-- QUERY 6: Customers who shipped to every hub (NOT EXISTS)

SELECT cu.CustomerID,cu.CustomerName
FROM dbo.Customers cu
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.Hubs h
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.Shipments s
        WHERE s.CustomerID=cu.CustomerID
        AND s.DestinationHubID=h.HubID
    )
);

-- QUERY 7: Carriers whose average delivery delay
-- is greater than the overall average delay

WITH CarrierDelays AS (
    SELECT CarrierID,
           AVG(CAST(DATEDIFF(DAY,PromisedDeliveryDate,
                ActualDeliveryDate) AS DECIMAL(10,2))) AS AvgDelay
    FROM dbo.Shipments
    WHERE ActualDeliveryDate IS NOT NULL
    GROUP BY CarrierID
),
OverallDelay AS (
    SELECT AVG(CAST(DATEDIFF(DAY,PromisedDeliveryDate,
                ActualDeliveryDate) AS DECIMAL(10,2))) AS AvgDelay
    FROM dbo.Shipments
    WHERE ActualDeliveryDate IS NOT NULL
)
SELECT c.CarrierName,cd.AvgDelay
FROM CarrierDelays cd
JOIN dbo.Carriers c
ON c.CarrierID=cd.CarrierID
WHERE cd.AvgDelay > ALL (
    SELECT AvgDelay FROM OverallDelay
);

-- QUERY 8: Customers with at least one shipment
-- Subquery rewritten as JOIN

SELECT DISTINCT cu.CustomerID,cu.CustomerName
FROM dbo.Customers cu
INNER JOIN dbo.Shipments s
ON s.CustomerID=cu.CustomerID;

-- QUERY 9: Carriers handling delayed shipments

SELECT DISTINCT c.CarrierID,c.CarrierName
FROM dbo.Carriers c
INNER JOIN dbo.Shipments s
ON s.CarrierID=c.CarrierID
WHERE s.ActualDeliveryDate >
      DATEADD(DAY,2,s.PromisedDeliveryDate);

-- QUERY 10: Second-highest distinct shipping cost per hub

SELECT h.HubName,
       costs.SecondHighestShippingCost
FROM dbo.Hubs h
OUTER APPLY (
    SELECT MAX(x.ShippingCost) AS SecondHighestShippingCost
    FROM dbo.Shipments x
    WHERE x.OriginHubID=h.HubID
    AND x.ShippingCost < (
        SELECT MAX(y.ShippingCost)
        FROM dbo.Shipments y
        WHERE y.OriginHubID=h.HubID
    )
) costs;

-- Additional examples of IN, EXISTS, ANY and ALL

SELECT CustomerID,CustomerName
FROM dbo.Customers
WHERE CustomerID IN (
    SELECT CustomerID FROM dbo.Shipments
);

SELECT h.HubID,h.HubName
FROM dbo.Hubs h
WHERE EXISTS (
    SELECT 1 FROM dbo.Shipments s
    WHERE s.DestinationHubID=h.HubID
);

SELECT TrackingNumber,ShippingCost
FROM dbo.Shipments
WHERE ShippingCost > ANY (
    SELECT ShippingCost FROM dbo.Shipments
    WHERE OriginHubID=1
);

SELECT TrackingNumber,ShippingCost
FROM dbo.Shipments
WHERE ShippingCost > ALL (
    SELECT ShippingCost FROM dbo.Shipments
    WHERE OriginHubID=1
);
GO