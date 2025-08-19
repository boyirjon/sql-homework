-- Task 1

CREATE TABLE Dates (
    Id INT,
    Dt DATETIME
);
INSERT INTO Dates VALUES
(1,'2018-04-06 11:06:43.020'),
(2,'2017-12-06 11:06:43.020'),
(3,'2016-01-06 11:06:43.020'),
(4,'2015-11-06 11:06:43.020'),
(5,'2014-10-06 11:06:43.020');

SELECT 
    Id,
    Dt,
    FORMAT(Dt, 'MM') AS MonthPrefixedWithZero
FROM Dates

-- Task 2

CREATE TABLE MyTabel (
    Id INT,
    rID INT,
    Vals INT
);
INSERT INTO MyTabel VALUES
(121, 9, 1), (121, 9, 8),
(122, 9, 14), (122, 9, 0), (122, 9, 1),
(123, 9, 1), (123, 9, 2), (123, 9, 10);

SELECT
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVal) AS TotalOfMaxVals
FROM
(
    SELECT
        Id,
        rID,
        MAX(Vals) AS MaxVal
    FROM MyTabel
    GROUP BY Id, rID
) AS Sub
GROUP BY rID

-- Task 3

SELECT 
    Id,
    Vals
FROM TestFixLengths
WHERE LEN(Vals) BETWEEN 6 AND 10

CREATE TABLE TestFixLengths (
    Id INT,
    Vals VARCHAR(100)
);
INSERT INTO TestFixLengths VALUES
(1,'11111111'), (2,'123456'), (2,'1234567'), 
(2,'1234567890'), (5,''), (6,NULL), 
(7,'123456789012345');

-- Task 4

CREATE TABLE TestMaximum (
    ID INT,
    Item VARCHAR(20),
    Vals INT
);
INSERT INTO TestMaximum VALUES
(1, 'a1',15), (1, 'a2',20), (1, 'a3',90),
(2, 'q1',10), (2, 'q2',40), (2, 'q3',60), (2, 'q4',30),
(3, 'q5',20);

SELECT 
    t.ID,
    t.Item,
    t.Vals
FROM TestMaximum t
INNER JOIN 
(
    SELECT 
        ID, 
        MAX(Vals) AS MaxVal
    FROM TestMaximum
    GROUP BY ID
) AS m
ON t.ID = m.ID AND t.Vals = m.MaxVal
ORDER BY t.ID

-- Task 5

CREATE TABLE SumOfMax (
    DetailedNumber INT,
    Vals INT,
    Id INT
);
INSERT INTO SumOfMax VALUES
(1,5,101), (1,4,101), (2,6,101), (2,3,101),
(3,3,102), (4,2,102), (4,3,102);

SELECT 
    Id,
    SUM(MaxVal) AS SumOfMax
FROM
(
    SELECT 
        Id,
        DetailedNumber,
        MAX(Vals) AS MaxVal
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS Sub
GROUP BY Id
ORDER BY Id

-- Task 6

CREATE TABLE TheZeroPuzzle (
    Id INT,
    a INT,
    b INT
);
INSERT INTO TheZeroPuzzle VALUES
(1,10,4), (2,10,10), (3,1, 10000000), (4,15,15);

SELECT
    Id,
    a,
    b,
    CASE 
        WHEN a - b = 0 THEN ''
        ELSE CAST(a - b AS VARCHAR(20))
    END AS OUTPUT
FROM TheZeroPuzzle

-- Task 7

SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales

-- Task 8

SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales;

-- Task 9

SELECT COUNT(*) AS TotalTransactions
FROM Sales;

-- Task 10

SELECT MAX(QuantitySold) AS HighestUnitsSold
FROM Sales;

-- Task 11

SELECT 
    Category,
    SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category;

-- Task 12

SELECT
    Region,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

-- Task 13

SELECT TOP 1
    Product,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- Task 14

SELECT 
    SaleDate,
    Product,
    QuantitySold * UnitPrice AS Revenue,
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
ORDER BY SaleDate;

-- Task 15

SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
    ROUND(100.0 * SUM(QuantitySold * UnitPrice) / 
          (SELECT SUM(QuantitySold * UnitPrice) FROM Sales), 2) AS RevenueSharePercent
FROM Sales
GROUP BY Category;

-- Task 17

SELECT 
    s.SaleID,
    s.Product,
    s.QuantitySold,
    s.UnitPrice,
    s.SaleDate,
    s.Region,
    c.CustomerName
FROM Sales s
INNER JOIN Customers c
    ON s.CustomerID = c.CustomerID
ORDER BY s.SaleID;

-- Task 18

SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Sales s
    ON c.CustomerID = s.CustomerID
WHERE s.SaleID IS NULL;

-- Task 19

SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
INNER JOIN Sales s
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- Task 20

SELECT TOP 1
    c.CustomerID,
    c.CustomerName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Customers c
INNER JOIN Sales s
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- Task 21

SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(s.SaleID) AS TotalSales
FROM Customers c
LEFT JOIN Sales s
    ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSales DESC;

-- Task 22

SELECT DISTINCT p.ProductName
FROM Products p
INNER JOIN Sales s
    ON p.ProductName = s.Product;

-- Task 23

SELECT TOP 1 *
FROM Products
ORDER BY SellingPrice DESC;

-- Task 24

SELECT *
FROM Products p
WHERE SellingPrice > 
      (SELECT AVG(SellingPrice)
       FROM Products
       WHERE Category = p.Category);
