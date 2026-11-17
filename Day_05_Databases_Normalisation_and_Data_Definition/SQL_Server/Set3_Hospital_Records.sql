
-- Day 5 - Set 3: Hospital Records

-- Create database
USE master;
GO

IF DB_ID('NexoraHospitalDB') IS NULL
    CREATE DATABASE NexoraHospitalDB;
GO

USE NexoraHospitalDB;
GO

-- Create department table
CREATE TABLE Department (
    DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE
);
GO

-- Create patient table
CREATE TABLE Patient (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    PatientName VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL,
    Phone VARCHAR(15) UNIQUE
);
GO

-- Create doctor table
CREATE TABLE Doctor (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
    DoctorName VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    FOREIGN KEY (DepartmentID)
        REFERENCES Department(DepartmentID)
);
GO

-- Create visit table
CREATE TABLE Visit (
    VisitID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    VisitDate DATE NOT NULL,
    Diagnosis VARCHAR(200) NOT NULL,
    Prescription VARCHAR(300),
    Notes VARCHAR(500),

    CONSTRAINT CK_Visit_Date
        CHECK (VisitDate <= CAST(GETDATE() AS DATE)),

    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),

    FOREIGN KEY (DoctorID)
        REFERENCES Doctor(DoctorID)
);
GO

-- Create billing table
CREATE TABLE Billing (
    BillID INT IDENTITY(1,1) PRIMARY KEY,
    VisitID INT NOT NULL UNIQUE,
    BillAmount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(20) NOT NULL DEFAULT 'Open',

    CONSTRAINT CK_Bill_Amount CHECK (BillAmount >= 0),

    FOREIGN KEY (VisitID)
        REFERENCES Visit(VisitID)
);
GO

-- Insert departments
INSERT INTO Department (DepartmentName) VALUES
('Cardiology'),
('Neurology'),
('Orthopedics'),
('Dermatology'),
('Pediatrics');

-- Insert patients
INSERT INTO Patient (PatientName, Address, Phone) VALUES
('Arun Kumar', 'Chennai', '9001100301'),
('Priya S', 'Coimbatore', '9001100302'),
('Karthik R', 'Bengaluru', '9001100303'),
('Divya M', 'Hyderabad', '9001100304'),
('Rahul P', 'Madurai', '9001100305'),
('Meena K', 'Chennai', '9001100306'),
('Vijay S', 'Coimbatore', '9001100307'),
('Nithya R', 'Bengaluru', '9001100308'),
('Anitha P', 'Hyderabad', '9001100309'),
('Sanjay V', 'Madurai', '9001100310');

-- Insert doctors
INSERT INTO Doctor (DoctorName, DepartmentID) VALUES
('Dr. Ravi', 1),
('Dr. Priya', 2),
('Dr. Kumar', 3),
('Dr. Meena', 4),
('Dr. Anand', 5);

-- Insert visits
INSERT INTO Visit
(PatientID, DoctorID, VisitDate, Diagnosis, Prescription, Notes)
VALUES
(1, 1, '2026-10-02', 'Blood Pressure', 'Regular medication', 'Follow-up required'),
(2, 2, '2026-10-05', 'Migraine', 'Pain relief tablets', 'Review after one week'),
(3, 3, '2026-10-08', 'Joint Pain', 'Physiotherapy', 'Avoid heavy exercise'),
(4, 4, '2026-10-10', 'Skin Allergy', 'Skin cream', 'Apply twice daily'),
(5, 5, '2026-10-12', 'Fever', 'Fever medicine', 'Rest recommended'),
(6, 1, '2026-10-15', 'Heart Checkup', 'Regular medication', 'Routine checkup'),
(7, 2, '2026-10-18', 'Headache', 'Pain relief tablets', 'Monitor symptoms'),
(8, 3, '2026-10-20', 'Back Pain', 'Physiotherapy', 'Follow-up required'),
(9, 4, '2026-10-22', 'Acne', 'Skin cream', 'Review after two weeks'),
(10, 5, '2026-10-25', 'Cold', 'Basic medication', 'Rest recommended');

-- Insert billing records
INSERT INTO Billing (VisitID, BillAmount) VALUES
(1, 1500),
(2, 1200),
(3, 2000),
(4, 900),
(5, 500),
(6, 1800),
(7, 700),
(8, 1600),
(9, 1000),
(10, 600);
GO

-- View records
SELECT * FROM Department;
SELECT * FROM Patient;
SELECT * FROM Doctor;
SELECT * FROM Visit;
SELECT * FROM Billing;
GO

-- Update a bill
UPDATE Billing
SET BillAmount = 1700
WHERE BillID = 1;

-- Delete a billing record
DELETE FROM Billing
WHERE BillID = 10;

-- View changes
SELECT * FROM Billing;
GO

-- Add insurance column
ALTER TABLE Patient
ADD insurance_id VARCHAR(30);

-- Rename the Visit table
EXEC sp_rename 'Visit', 'PatientVisit';

-- Drop the notes constraint
ALTER TABLE PatientVisit
DROP CONSTRAINT CK_Visit_Date;
GO

-- Find patients visited during October 2026
SELECT P.PatientName, V.VisitDate, V.Diagnosis
FROM Patient P
INNER JOIN PatientVisit V ON P.PatientID = V.PatientID
WHERE V.VisitDate >= '2026-10-01'
AND V.VisitDate < '2026-11-01';
GO

-- Find doctors in the Cardiology department
SELECT D.DoctorName, DP.DepartmentName
FROM Doctor D
INNER JOIN Department DP
ON D.DepartmentID = DP.DepartmentID
WHERE DP.DepartmentName LIKE '%Cardio%';
GO
