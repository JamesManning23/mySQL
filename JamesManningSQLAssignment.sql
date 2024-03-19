-- Task 1:
CREATE DATABASE breakdowncompany;
USE breakdowncompany;

CREATE TABLE Members (
    MemberID VARCHAR(30) PRIMARY KEY NOT NULL,
    MemberFName VARCHAR(30) NOT NULL,
    MemberLName VARCHAR(30) NOT NULL,
    MemberLocation VARCHAR(30) NOT NULL
);

CREATE TABLE Vehicle (
    VehicleReg VARCHAR(30) PRIMARY KEY NOT NULL,
    VehicleMake VARCHAR(30) NOT NULL,
    VehicleModel VARCHAR(30) NOT NULL,
    MemberID VARCHAR(30) NOT NULL 
);

CREATE TABLE Engineer (
    EngineerID INT PRIMARY KEY NOT NULL,
    EngineerFName VARCHAR(20) NOT NULL,
    EngineerLName VARCHAR(20) NOT NULL
);

CREATE TABLE Breakdown (
    BreakdownID INT PRIMARY KEY AUTO_INCREMENT,
    VehicleReg VARCHAR(30) NOT NULL,
    EngineerID INT NOT NULL,
    BreakdownDATE DATE NOT NULL,
    BreakdownTIME TIME NOT NULL,
    BreakdownLocation VARCHAR(30) NOT NULL
);

ALTER TABLE Vehicle ADD FOREIGN KEY(MemberID) REFERENCES Members(MemberID);
ALTER TABLE Breakdown ADD FOREIGN KEY(VehicleReg) REFERENCES Vehicle(VehicleReg);
ALTER TABLE Breakdown ADD FOREIGN KEY(EngineerID) REFERENCES Engineer(EngineerID);

-- Task 2:

INSERT INTO Members (MemberID, MemberFName, MemberLName, MemberLocation)
VALUES 
    ('1','James','Manning','London'),
    ('2','Sofia','Garcia','Barcelona'),
    ('3','Ethan','Kim','Seoul'),
    ('4','Isabella','Rossi','Rome'),
    ('5','Olivia','Smith','Sydney');

INSERT INTO Vehicle (VehicleReg, VehicleMake, VehicleModel, MemberID) 
VALUES
    ('ABC123','Toyota','Camry','1'),
    ('XYZ789','Honda','Cvic','2'),
    ('DEF456','Ford','Mustang','3'),
    ('GHI789','Bmw','X5','4'),
    ('JKL012','Mercedes-benz','C-class','5'),
    ('MNO345','Chevrolet','Silverado','1'),
    ('PQR678','Nissan','Altima','4'),
    ('STU901','Toyota','Corola','2');    
  
INSERT INTO Engineer (EngineerID, EngineerFName, EngineerLName)
VALUES 
     (1,'John','Smith'),
     (2,'Sarah','Johnson'),
     (3,'Michael','Williams');
INSERT INTO Breakdown (VehicleReg, EngineerID, BreakdownDATE, BreakdownTIME, BreakdownLocation)
VALUES
     ('ABC123', 1, '2024-01-10', '08:00:00','Street A'),
     ('XYZ789', 2, '2024-01-10', '10:30:00', 'Street B'),
     ('DEF456', 3, '2024-02-15', '12:45:00', 'Street C'),
     ('GHI789', 1, '2024-02-15', '14:20:00', 'Street D'),
     ('JKL012', 2, '2024-03-20', '09:10:00', 'Street E'),
     ('MNO345', 3, '2024-03-20', '11:25:00', 'Street F'),
     ('PQR678', 1, '2024-03-20', '13:40:00', 'Street G'),
     ('STU901', 2, '2024-04-25', '16:00:00', 'Street H'),
     ('ABC123', 3, '2024-05-05', '08:30:00', 'Street G'),
     ('XYZ789', 1, '2024-05-05', '10:45:00', 'Street J'),
     ('ABC123', 2, '2024-03-17', '12:15:00', 'Street K'),
     ('ABC123', 3, '2024-06-15', '14:30:00', 'Street L');


-- Task 3:

-- The names of members who live in a location
SELECT MemberFName, MemberLName FROM Members WHERE MemberLocation IS NOT NULL;
-- All cars registered with the company e.g. all Nissan cars.
SELECT * FROM Vehicle WHERE VehicleMake = 'Nissan';
-- The number of engineers that work for the company.
SELECT COUNT(EngineerID) AS 'Number of Engineers' FROM Engineer;
-- The number of members registered.
SELECT COUNT(MemberID) FROM Members;
-- All the breakdown after a particular date
SELECT * FROM Breakdown WHERE BreakdownDate >= '2024-03-25';
-- All the breakdown between 2 dates
SELECT * FROM Breakdown WHERE BreakdownDate BETWEEN '2024-01-01' AND '2024-02-15';
-- The number of time a particular vehicle has broken down
SELECT COUNT(*) FROM Breakdown WHERE VehicleReg = 'XYZ789';
-- The number of vehicles broken down more than once
SELECT COUNT(*) AS `Count`, VehicleReg FROM Breakdown GROUP BY VehicleReg HAVING `Count` > 1;

-- Task 4:

-- All the vehicles a member owns. For example, Matt
SELECT 
    m.MemberID,
    m.MemberFName,
    m.MemberLName,
    v.VehicleReg,
    v.VehicleMake,
    v.VehicleModel
FROM Members AS m
INNER JOIN Vehicle AS v ON v.MemberID = m.MemberID 
WHERE m.MemberFName = 'James';

-- The number of vehicles each member has – sort the data based on the number of car from highest to lowest.
SELECT 
    m.MemberID,
    m.MemberFName,
    m.MemberLName,
    COUNT(v.VehicleReg) AS `Count`
FROM Members AS m
INNER JOIN Vehicle AS v ON v.MemberID = m.MemberID
GROUP BY m.MemberID
ORDER BY `Count` DESC;

-- All vehicles that have broken down in a particular location along with member details.
SELECT
    b.BreakdownID,
    b.VehicleReg,
    b.BreakdownLocation,
    m.MemberID,
    m.MemberFName,
    m.MemberLName,
    v.VehicleMake,
    v.VehicleModel
FROM Breakdown AS b
INNER JOIN Vehicle AS v ON v.VehicleReg = b.VehicleReg
INNER JOIN Members AS m ON m.MemberID = v.MemberID
WHERE b.BreakdownLocation = 'Street G';

-- A list of all breakdown along with member and engineer details between two dates.
SELECT
    b.BreakdownID,
    b.VehicleReg,
    b.BreakdownLocation,
    b.BreakdownDATE,
    b.BreakdownTIME,
    m.MemberID,
    m.MemberFName,
    m.MemberLName,
    e.EngineerID,
    e.EngineerFName,
    e.EngineerLName
FROM Breakdown AS b
INNER JOIN Engineer AS e ON e.EngineerID = b.EngineerID
INNER JOIN Vehicle AS v ON v.VehicleReg = b.VehicleReg
INNER JOIN Members AS m ON m.MemberID = v.MemberID 
WHERE b.BreakdownDATE BETWEEN '2024-03-01' AND '2024-05-01';

-- A further 3 relational queries of your choice that are meaningful to the company

-- 1. Get a list of all jobs done by an engineer in a week.
SELECT 
    e.EngineerID,
    e.EngineerFName,
    e.EngineerLName,
    b.BreakdownID,
    b.BreakdownDATE,
    b.BreakdownTIME,
    b.BreakdownLocation
FROM Engineer AS e
LEFT JOIN Breakdown AS b ON b.EngineerID = e.EngineerID
WHERE 
    e.EngineerID = '2'
    AND b.BreakdownDATE BETWEEN '2024-03-16' AND '2024-03-23';

-- 2. The location where the most breakdowns occur.
SELECT 
    BreakdownLocation,
    COUNT(BreakdownLocation) AS `Count`
FROM Breakdown 
GROUP BY BreakdownLocation 
ORDER BY `Count` DESC;

-- 3. The Make and model of the car which has broken down the most.
SELECT
    v.VehicleMake,
    v.VehicleModel,
    COUNT(b.BreakdownID) AS `Count`    
FROM Vehicle AS v
LEFT JOIN Breakdown AS b ON b.VehicleReg = v.VehicleReg
GROUP BY v.VehicleMake, v.VehicleModel
ORDER BY `Count` DESC, v.VehicleMake ASC, v.VehicleModel ASC; 

-- Task 5:
-- Research the following functions – AVG, MAX, MIN, SUM. Explain with examples how each one is used.

-- The AVG() Function will return the median value from a given set of Numeric Data.
-- For Example:
CREATE TABLE AverageSalary (
    Age INT NOT NULL,
    Salary INT NOT NULL
);

INSERT INTO AverageSalary VALUES (23, 41000), (45, 60000), (32, 23000);

SELECT AVG(Age) AS AverageAge FROM AverageSalary;
SELECT AVG(Salary) AS AverageSalary FROM AverageSalary;

-- The MAX() Function will return the maximum set of values in a set of values.
-- For Example:
SELECT MAX(Age) FROM AverageSalary;
SELECT MAX(Salary) FROM AverageSalary;

-- The MIN() Function will return the Minimum set of values in a given set of values.
-- For Example:
SELECT MIN(Age) FROM AverageSalary;
SELECT MIN(Salary) FROM AverageSalary;

-- The SUM() Function will calculate the total amount from a given set of values.
-- For Example:
SELECT SUM(Age) FROM AverageSalary;
SELECT SUM(Salary) FROM AverageSalary;

-- Task 6:

-- 6.1 If a member has more than one vehicle, then display multi-car policy
SELECT
    m.MemberID,
    m.MemberFName,
    m.MemberLName,
    m.MemberLocation,
    CASE
        WHEN COUNT(*) > 1 THEN CONCAT('This member has ', COUNT(*), ' cars')
        ELSE NULL
    END AS NumberofCars
FROM
    Vehicle AS v
LEFT JOIN
    Members AS m ON m.MemberID = v.MemberID
GROUP BY
    m.MemberID,
    m.MemberFName,
    m.MemberLName,
    m.MemberLocation
HAVING NumberofCars IS NOT NULL;

-- 6.2 Create a stored procedure which will display the number of cars for any member whose first name and last name you are passing as an argument while calling the stored procedure!
DELIMITER $$$
CREATE PROCEDURE membervehicle (
    IN memberfirstname VARCHAR(30),
    IN memberlastname VARCHAR(30)
)
BEGIN
    SELECT
        COUNT(v.VehicleReg) AS `Count`
    FROM
        Members AS m 
    INNER JOIN
        Vehicle AS v ON m.MemberID = v.MemberID
    WHERE
        m.MemberFName = memberfirstname 
        AND m.MemberLName = memberlastname
    GROUP BY
        m.MemberFName,
        m.MemberLName;
END $$$
DELIMITER ;

CALL membervehicle('James', 'Manning');



    