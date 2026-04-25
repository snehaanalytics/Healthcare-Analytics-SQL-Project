CREATE DATABASE HealthcareDB;
USE HealthcareDB;

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    FullName VARCHAR(100),
    Age INT,
    Gender VARCHAR(10),
    Address VARCHAR(255)
);

CREATE TABLE Hospitals (
    HospitalID INT PRIMARY KEY,
    HospitalName VARCHAR(100),
    Location VARCHAR(100),
    Capacity INT
);

CREATE TABLE Admissions (
    AdmissionID INT PRIMARY KEY,
    PatientID INT,
    HospitalID INT,
    AdmissionDate DATE,
    DischargeDate DATE,
    ReasonForAdmission VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (HospitalID) REFERENCES Hospitals(HospitalID)
);

CREATE TABLE Treatments (
    TreatmentID INT PRIMARY KEY,
    AdmissionID INT,
    ProcedureName VARCHAR(100),
    Cost DECIMAL(10,2),
    Outcome VARCHAR(50),
    FOREIGN KEY (AdmissionID) REFERENCES Admissions(AdmissionID)
);

INSERT INTO Patients (PatientID, FullName, Age, Gender, Address) VALUES
(1, 'John Doe', 45, 'Male', '123 Elm Street'),
(2, 'Jane Smith', 34, 'Female', '456 Oak Avenue'),
(3, 'Sam Brown', 29, 'Male', '789 Pine Road'),
(4, 'Lisa White', 52, 'Female', '321 Maple Lane'),
(5, 'Tom Green', 67, 'Male', '654 Birch Blvd'),
(6, 'Alice Johnson', 40, 'Female', '987 Willow Court'),
(7, 'Robert Black', 60, 'Male', '564 Cypress Road'),
(8, 'Emily Davis', 25, 'Female', '321 Cedar Avenue'),
(9, 'Michael Scott', 50, 'Male', '742 Birch Lane'),
(10, 'Sarah Taylor', 33, 'Female', '159 Spruce Drive');

INSERT INTO Hospitals (HospitalID, HospitalName, Location, Capacity) VALUES
(1, 'General Hospital', 'New York', 500),
(2, 'City Clinic', 'Los Angeles', 200),
(3, 'Central Medical Center', 'Chicago', 300),
(4, 'Regional Health Facility', 'Houston', 150),
(5, 'Sunrise Hospital', 'Phoenix', 400);

INSERT INTO Admissions (AdmissionID, PatientID, HospitalID, AdmissionDate, DischargeDate, ReasonForAdmission) VALUES
(1, 1, 1, '2024-11-01', '2024-11-05', 'Surgery'),
(2, 2, 2, '2024-11-03', '2024-11-08', 'Therapy'),
(3, 3, 3, '2024-11-10', '2024-11-15', 'Accident'),
(4, 4, 4, '2024-11-12', '2024-11-19', 'Routine Checkup'),
(5, 5, 5, '2024-12-01', '2024-12-08', 'Infection'),
(6, 6, 1, '2024-12-01', NULL, 'Surgery'),
(7, 7, 2, '2024-12-02', '2024-12-05', 'Fracture Repair'),
(8, 8, 3, '2024-12-03', NULL, 'Chronic Illness'),
(9, 9, 4, '2024-12-03', '2024-12-18', 'Therapy'),
(10, 10, 5, '2024-12-04', '2024-12-18', 'Infection');

INSERT INTO Treatments (TreatmentID, AdmissionID, ProcedureName, Cost, Outcome) VALUES
(1, 1, 'Appendectomy', 1500.00, 'Successful'),
(2, 2, 'Physical Therapy', 800.00, 'Ongoing'),
(3, 3, 'Fracture Repair', 3000.00, 'Successful'),
(4, 4, 'Blood Test', 200.00, 'Pending'),
(5, 5, 'Antibiotics', 500.00, 'Improved'),
(6, 6, 'Gallbladder Surgery', 4000.00, 'Successful'),
(7, 7, 'X-Ray', 300.00, 'Successful'),
(8, 8, 'Chemotherapy', 5000.00, 'Ongoing'),
(9, 9, 'MRI Scan', 1200.00, 'Pending'),
(10, 10, 'Diabetes Treatment', 700.00, 'Improved');

SELECT Gender, COUNT(*) AS TotalPatients, AVG(Age) AS AvgAge
FROM Patients
GROUP BY Gender;

SELECT h.HospitalName, COUNT(a.AdmissionID) AS TotalAdmissions
FROM Hospitals h
JOIN Admissions a ON h.HospitalID = a.HospitalID
GROUP BY h.HospitalName
ORDER BY TotalAdmissions DESC;

SELECT h.HospitalName, SUM(t.Cost) AS TotalCost
FROM Hospitals h
JOIN Admissions a ON h.HospitalID = a.HospitalID
JOIN Treatments t ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalName;

SELECT h.HospitalName,
       AVG(DATEDIFF(DischargeDate, AdmissionDate)) AS AvgStay
FROM Hospitals h
JOIN Admissions a ON h.HospitalID = a.HospitalID
GROUP BY h.HospitalName;

SELECT p.FullName, a.AdmissionDate, a.DischargeDate
FROM Patients p
JOIN Admissions a ON p.PatientID = a.PatientID
WHERE DATEDIFF(a.DischargeDate, a.AdmissionDate) > 7;

SELECT ProcedureName, COUNT(*) AS Frequency
FROM Treatments
GROUP BY ProcedureName
HAVING COUNT(*) > 5;

SELECT p.FullName, h.HospitalName, a.AdmissionDate, a.DischargeDate,
       t.ProcedureName, t.Cost, t.Outcome
FROM Patients p
JOIN Admissions a ON p.PatientID = a.PatientID
JOIN Hospitals h ON a.HospitalID = h.HospitalID
JOIN Treatments t ON a.AdmissionID = t.AdmissionID;

SELECT FullName, ReasonForAdmission
FROM Patients p
JOIN Admissions a ON p.PatientID = a.PatientID
WHERE ReasonForAdmission = 'Surgery'

UNION

SELECT FullName, ReasonForAdmission
FROM Patients p
JOIN Admissions a ON p.PatientID = a.PatientID
WHERE ReasonForAdmission = 'Therapy';

SELECT HospitalName
FROM Hospitals
WHERE HospitalID = (
    SELECT a.HospitalID
    FROM Admissions a
    JOIN Treatments t ON a.AdmissionID = t.AdmissionID
    GROUP BY a.HospitalID
    ORDER BY AVG(t.Cost) DESC
    LIMIT 1
);

CREATE VIEW HospitalPerformance AS
SELECT h.HospitalName,
       COUNT(a.AdmissionID) AS TotalAdmissions,
       AVG(DATEDIFF(a.DischargeDate, a.AdmissionDate)) AS AvgStay,
       SUM(t.Cost) AS TotalRevenue
FROM Hospitals h
JOIN Admissions a ON h.HospitalID = a.HospitalID
JOIN Treatments t ON a.AdmissionID = t.AdmissionID
GROUP BY h.HospitalName;

SELECT HospitalName, TotalRevenue,
       RANK() OVER (ORDER BY TotalRevenue DESC) AS HospitalRank
FROM HospitalPerformance;

SELECT ProcedureName,
       COUNT(*) AS Frequency,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS TreatmentRank
FROM Treatments
GROUP BY ProcedureName;
