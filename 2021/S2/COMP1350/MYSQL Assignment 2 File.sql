CREATE DATABASE meraki_db;
USE meraki_db;


-- Question 1
CREATE TABLE TruckMake (
	TruckMakeID CHAR(3) NOT NULL,
    TruckMakeName VARCHAR(30),
    PRIMARY KEY(TruckMakeID)
);

CREATE TABLE TruckModel (
	TruckMakeID CHAR(3) NOT NULL,
    TruckModelID CHAR(3) NOT NULL,
    TruckModelName VARCHAR(30),
    PRIMARY KEY(TruckMakeID, TruckModelID),
    FOREIGN KEY(TruckMakeID) REFERENCES TruckMake(TruckMakeID)
);

CREATE TABLE Truck (
	TruckVINNum CHAR(4) NOT NULL,
    TruckMakeID CHAR(3) NOT NULL,
    TruckModelID CHAR(3) NOT NULL,
    TruckColour VARCHAR(15),
    TruckPurchaseDate DATE,
    TruckCost DECIMAL(10, 2),
    PRIMARY KEY(TruckVINNum),
    FOREIGN KEY(TruckMakeID, TruckModelID) REFERENCES TruckModel(TruckMakeID, TruckModelID)
);

CREATE TABLE Service (
	TransportID CHAR(2) NOT NULL,
    TransportName VARCHAR(30),
    TransportCost DECIMAL(10, 2),
    TransportMaxDist DECIMAL(10, 2),
    PRIMARY KEY(TransportID)
);

CREATE TABLE Allocation (
	TruckVINNum CHAR(4) NOT NULL,
    TransportID CHAR(2) NOT NULL,
    FromDate DATE,
    ToDate DATE,
    FOREIGN KEY(TruckVINNum) REFERENCES Truck(TruckVINNum),
    FOREIGN KEY(TransportID) REFERENCES Service(TransportID)
);


INSERT INTO TruckMake (TruckMakeID, TruckMakeName)
VALUES ('TM1', 'Volvo'),
	   ('TM2', 'Mercedes'),
	   ('TM3', 'Isuzu'),
	   ('TM4', 'Mack'),
	   ('TM5', 'Kenworth');
       
INSERT INTO TruckModel (TruckMakeID, TruckModelID, TruckModelName)
VALUES ('TM1', 'M01', 'Big Truck'),
	   ('TM1', 'M02', 'Biggest Truck'),
	   ('TM2', 'M01', 'Half Truck'),
	   ('TM2', 'M02', 'Small Truck'),
       ('TM2', 'M03', 'Smallest Truck'),
	   ('TM3', 'M01', 'Semi Truck'),
	   ('TM4', 'M01', 'Demi Truck'),
       ('TM4', 'M02', 'Drilling Truck'),
	   ('TM5', 'M01', 'Cement Truck');
       
INSERT INTO Truck (TruckVINNum, TruckMakeID, TruckModelID, TruckColour, TruckPurchaseDate, TruckCost)
VALUES ('V023', 'TM1', 'M01', 'Red', '1998-07-16', 25000),
	   ('V054', 'TM1', 'M02', 'Red', '2009-11-11', 24999.85),
	   ('V635', 'TM2', 'M02', 'White', '2016-01-16', 16500),
	   ('V999', 'TM4', 'M02', 'Yellow', '2016-01-16', 4000),
	   ('V998', 'TM5', 'M01', 'Black', '2020-05-03', 14000.95);
       
INSERT INTO Truck (TruckVINNum, TruckMakeID, TruckModelID, TruckColour, TruckPurchaseDate, TruckCost)
VALUES ('V111', 'TM4', 'M01', 'Red', '1999-07-16', 140000.80);

INSERT INTO Service (TransportID, TransportName, TransportCost, TransportMaxDist)
VALUES ('T1', 'Coal Delivery', 5000, 1000),
	   ('T2', 'Iron Ore Delivery', 1000, 1500),
	   ('T3', 'Large Quantity Delivery', 3000, 250),
	   ('T4', 'National Shipment', 10000, 750),
	   ('T5', 'International Shipment', 2000, 1200);
       
INSERT INTO Service (TransportID, TransportName, TransportCost, TransportMaxDist)
VALUES ('T6', 'Plane Delivery', 160000, 1200);

INSERT INTO Allocation (TruckVINNum, TransportID, FromDate, ToDate)
VALUES ('V023', 'T3', '2020-08-17', '2020-08-18'),
	   ('V023', 'T4', '2020-06-05', '2020-06-08'),
	   ('V635', 'T4', '2020-08-17', '2020-08-20'),
	   ('V999', 'T5', '2020-06-17', '2020-06-30'),
	   ('V054', 'T2', '2020-01-03', '2020-01-04'),
       ('V635', 'T3', '2019-12-17', '2019-12-25'),
       ('V023', 'T5', '2019-12-17', '2019-12-25'),
       ('V023', 'T1', '2019-01-17', '2019-01-25'),
	   ('V635', 'T2', '2021-09-05', '2021-09-08'),
       ('V023', 'T1', '2019-01-17', '2019-01-25'),
	   ('V635', 'T2', '2021-09-05', '2021-09-08'),
       ('V999', 'T5', '2021-09-05', '2021-09-08'),
       ('V054', 'T2', '2021-09-05', '2021-09-08');

INSERT INTO Allocation (TruckVINNum, TransportID, FromDate, ToDate)
VALUES ('V054', 'T6', '2021-08-17', '2021-08-18');


-- Question 2
SELECT TruckVINNum, TruckColour, CONCAT('$', TruckCost) AS 'Cost' FROM Truck
ORDER BY TruckCost DESC;




-- Question 3
SELECT TruckVINNum, TransportID, FromDate, ToDate, DATEDIFF(ToDate, FromDate) AS 'Number of Days' FROM Allocation;




-- Question 4
SELECT t.TruckVINNum, model.TruckModelName
FROM Truck t, TruckMake make, TruckModel model
WHERE t.TruckMakeID = make.TruckMakeID AND t.TruckModelID = model.TruckModelID AND make.TruckMakeID = model.TruckMakeID AND make.TruckMakeName = 'Volvo';




-- Question 5
SELECT DISTINCT a.TruckVINNum
FROM Allocation a JOIN Service s
USING(TransportID)
WHERE DATEDIFF(a.ToDate, a.FromDate) >= 3 && s.TransportCost BETWEEN 1500 AND 2500;




-- Question 6
SELECT s.TransportName, s.TransportCost, s.TransportMaxDist
FROM Service s
WHERE TransportID IN (
	SELECT TransportID
    FROM Allocation a
    WHERE TIMESTAMPDIFF(MONTH, a.FromDate, NOW()) <= 6
);



-- Question 7
SELECT DISTINCT s.TransportName, s.TransportCost, s.TransportMaxDist
FROM Service s JOIN Allocation a
ON s.TransportID = a.TransportID AND TIMESTAMPDIFF(MONTH, a.FromDate, NOW()) <= 6;



-- Question 8
SELECT DISTINCT s.TransportName, s.TransportMaxDist AS 'Kilometers', CAST(s.TransportMaxDist/1.609 AS DECIMAL(10,2)) AS 'Miles'
FROM Service s JOIN Allocation a JOIN Truck t
ON s.TransportID = a.TransportID AND a.TruckVINNum = t.TruckVINNum AND t.TruckColour = 'Red';



-- Question 9
SELECT t.TruckColour, COUNT(t.TruckColour) AS 'Number of Trucks'
FROM Truck t
GROUP BY t.TruckColour
ORDER BY COUNT(t.TruckColour) DESC;



-- Question 10
SELECT make.TruckMakeName, COUNT(model.TruckModelID) AS 'Number of Models'
FROM TruckModel model JOIN TruckMake make
USING(TruckMakeID)
GROUP BY make.TruckMakeName
HAVING COUNT(model.TruckModelID) > 1;



-- Question 11
SELECT *
FROM Truck
WHERE TruckVINNum NOT IN (
	SELECT TruckVINNum
    FROM Allocation
);



-- Question 12
SELECT DISTINCT s.*
FROM Service s
WHERE s.TransportCost > 5000 AND TransportID IN (
	SELECT TransportID
    FROM Allocation a
    WHERE 
    EXTRACT(MONTH FROM a.FromDate) = 1 AND EXTRACT(MONTH FROM a.ToDate) = 1
    OR
    EXTRACT(YEAR FROM a.FromDate) = 2020 AND EXTRACT(YEAR FROM a.ToDate) = 2020
    OR
    EXTRACT(YEAR FROM a.FromDate) = 2021 AND EXTRACT(YEAR FROM a.ToDate) = 2021
);



-- Question 13
SELECT DISTINCT t.TruckVINNum, make.TruckMakeName, model.TruckModelName
FROM Truck t, TruckMake make, TruckModel model, Allocation a
WHERE t.TruckMakeID = make.TruckMakeID AND t.TruckModelID = model.TruckModelID AND model.TruckMakeID = make.TruckMakeID AND t.TruckVINNum = a.TruckVINNum AND t.TruckColour = 'Red';








-- ////////////////////////////////////////////////////////////////////////
-- PRACTICE EXAM
-- ////////////////////////////////////////////////////////////////////////


-- 1
SELECT aircraftid, aircraftpurdate 
FROM aircraft a
WHERE a.aircraftseatcap > 150 AND (
	EXTRACT(MONTH FROM a.aircraftpurdate) = 10 
    OR 
    EXTRACT(YEAR FROM a.aircraftpurdate) = 2014
    OR 
    EXTRACT(YEAR FROM a.aircraftpurdate) = 2015
    OR 
    EXTRACT(YEAR FROM a.aircraftpurdate) = 2016)
ORDER BY a.aircraftseatcap DESC;


-- 2
SELECT a.aircraftid 
FROM aircraft a JOIN aircrafttype a_type
USING(aircrafttypeid)
WHERE a_type.aircrafttypename = 'Airbus';


-- 3
SELECT DISTINCT a.aircraftid, a_type.aircrafttypename
FROM aircraft a JOIN aircrafttype a_type JOIN service s
ON a_type.aircrafttypeid = a.aircrafttypeid AND a.aircraftid = s.aircraftid AND s.hangarid = 'H4'
ORDER BY a_type.aircrafttypename;


-- 4
-- ASSUMPTION QUARTER REFERS TO AUSTRALIAN FINANCIAL YEAR QUARTER (i.e. JAN, FEB, MAR)
SELECT s.*
FROM service s
WHERE EXTRACT(YEAR FROM s.servicedate) = 2019 
AND 
(EXTRACT(MONTH FROM s.servicedate) >= 1 AND EXTRACT(MONTH FROM s.servicedate) <= 3)
AND 
hangarid IN (
	SELECT hangarid 
	FROM hangar h
	WHERE h.hangarlocation = 'NSW'
);



-- 5
-- ASSUMPTION QUARTER REFERS TO AUSTRALIAN FINANCIAL YEAR QUARTER (i.e. JAN, FEB, MAR)
SELECT s.*
FROM service s JOIN hangar h
USING(hangarid)
WHERE EXTRACT(YEAR FROM s.servicedate) = 2019
AND (EXTRACT(MONTH FROM s.servicedate) >= 1 AND EXTRACT(MONTH FROM s.servicedate) <= 3)
AND h.hangarlocation = 'NSW';


-- 6
SELECT st.teamid, st.teamlevel, COUNT(st.teamid) AS 'Number of Services'
FROM serviceteam st 
LEFT JOIN service s
ON st.teamid = s.teamid AND (st.teamlevel = 1 OR st.teamlevel = 3)
GROUP BY st.teamid
HAVING COUNT(st.teamid) < 4
ORDER BY COUNT(st.teamid) DESC;


-- 7
SELECT COUNT(s.serviceid)
FROM service s JOIN aircraft a
USING(aircraftid)
WHERE EXTRACT(YEAR FROM a.aircraftpurdate) > 2017 OR a.aircraftseatcap != 104;







