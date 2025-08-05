-- Easy Tasks

-- Task 1

WITH Numbers AS (
    SELECT 1 AS number
    UNION ALL
    SELECT number + 1
    FROM Numbers
    WHERE number < 1000
)
SELECT number
FROM Numbers
OPTION (MAXRECURSION 1000)

-- Task 2

SELECT e.EmployeeID, CONCAT(FirstName, ' ' ,LastName) AS FullName, s.TotalSales
FROM Employees e
JOIN (
    SELECT EmployeeID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID
) s
ON e.EmployeeID = s.EmployeeID

-- Task 3

WITH EmployeeSalaries AS (
    SELECT Salary
    FROM Employees
)
SELECT AVG(Salary) AS AverageSalary
FROM EmployeeSalaries

-- Task 4

SELECT p.ProductID, p.ProductName, s.MaxSale
FROM Products p
JOIN (
    SELECT ProductID, MAX(salesAmount) AS MaxSale
    FROM Sales
    GROUP BY ProductID
) s
ON p.ProductID = s.ProductID

-- Task 5

WITH Doubles AS (
    SELECT 1 AS num
    UNION ALL
    SELECT num * 2
    FROM Doubles
    WHERE num * 2 < 1000000
)
SELECT num
FROM Doubles
OPTION (MAXRECURSION 1000)

-- Task 6

WITH SalesCount AS (
    SELECT EmployeeID, COUNT(*) AS SaleCount
    FROM Sales
    GROUP BY EmployeeID
)
SELECT e.EmployeeID, FirstName, s.SaleCount
FROM Employees e
JOIN SalesCount s
    ON e.EmployeeID = s.EmployeeID
WHERE s.SaleCount > 5

-- Task 7

with CTE as (
	select productid, sum(salesamount) as totalamount
	from sales
	group by productid
)
select p.productid, p.productname, totalamount
from products p
join CTE c
on p.productid = c.productid
where c.totalamount > 500

-- Task 8

WITH AvgSalary AS (
    SELECT AVG(Salary) AS AverageSalary
    FROM Employees
)
SELECT e.EmployeeID, e.FirstName, e.Salary
FROM Employees e
CROSS JOIN AvgSalary a
WHERE e.Salary > a.AverageSalary

-- Medium Tasks

-- Task 1

SELECT TOP 5 e.EmployeeID, e.FirstName, e.LastName, s.OrderCount
FROM Employees e
JOIN (
    SELECT EmployeeID, COUNT(*) AS OrderCount
    FROM Sales
    GROUP BY EmployeeID
) s
ON e.EmployeeID = s.EmployeeID
ORDER BY s.OrderCount DESC

-- Task 2

SELECT p.CategoryID, SUM(s.TotalSales) AS CategorySales
FROM Products p
JOIN (
    SELECT ProductID, SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY ProductID
) s
ON p.ProductID = s.ProductID
GROUP BY p.CategoryID

-- Task 3

WITH FactorialCTE AS (
    SELECT Number AS Number, 1 AS Counter, 1 AS Factorial
    FROM Numbers1 n
    UNION ALL
    SELECT f.Number, f.Counter + 1,
           f.Factorial * (f.Counter + 1)
    FROM FactorialCTE f
    WHERE f.Counter + 1 <= f.Number
)
SELECT Number, MAX(Factorial) AS Factorial
FROM FactorialCTE
GROUP BY Number
ORDER BY Number

-- Task 4

DECLARE @str NVARCHAR(100) = 'Example';

WITH SplitCTE AS (
    SELECT 1 AS Position,
           SUBSTRING(@str, 1, 1) AS Character
    
    UNION ALL
    
    SELECT Position + 1,
           SUBSTRING(@str, Position + 1, 1)
    FROM SplitCTE
    WHERE Position + 1 <= LEN(@str)
)
SELECT Character
FROM SplitCTE
OPTION (MAXRECURSION 100)

-- Task 5

WITH MonthlySales AS (
    SELECT 
        YEAR(SaleDate) AS SaleYear,
        MONTH(SaleDate) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    SaleYear,
    SaleMonth,
    TotalSales,
    TotalSales - LAG(TotalSales, 1) OVER (ORDER BY SaleYear, SaleMonth) AS SalesDifference
FROM MonthlySales
ORDER BY SaleYear, SaleMonth

-- Task 6

SELECT e.EmployeeID, e.FirstName, s.SaleQuarter, s.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        DATEPART(QUARTER, SaleDate) AS SaleQuarter,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
) s
    ON e.EmployeeID = s.EmployeeID
WHERE s.TotalSales > 45000
ORDER BY e.EmployeeID, s.SaleQuarter

-- Difficult Tasks

-- Task 1

WITH FibonacciCTE AS (
    SELECT 0 AS a, 1 AS b

    UNION ALL

    SELECT b, a + b
    FROM FibonacciCTE
    WHERE b < 1000
)
SELECT a AS Fibonacci
FROM FibonacciCTE
OPTION (MAXRECURSION 100);

-- Task 2

SELECT Vals
FROM FindSameCharacters
WHERE LEN(Vals) > 1
  AND Vals NOT LIKE REPLACE(Vals, LEFT(Vals,1), '')

 -- Task 3

DECLARE @n INT = 5;

WITH NumbersCTE AS (
    SELECT 
        1 AS num,
        CAST('1' AS VARCHAR(50)) AS sequence   

    UNION ALL

    SELECT 
        num + 1,
        CAST(sequence + CAST(num + 1 AS VARCHAR(50)) AS VARCHAR(50)) 
    FROM NumbersCTE
    WHERE num + 1 <= @n
)
SELECT sequence
FROM NumbersCTE
OPTION (MAXRECURSION 100)

-- Task 4

SELECT e.EmployeeID, e.FirstName, s.TotalSales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    WHERE SaleDate >= DATEADD(MONTH, -6, GETDATE()) 
    GROUP BY EmployeeID
) s
    ON e.EmployeeID = s.EmployeeID
ORDER BY s.TotalSales DESC

-- Task 5

SELECT 
    PawanName,
    TRANSLATE(PawanName, '0123456789', '          ') AS TempWithSpaces,
    REPLACE(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(PawanName, '0','')
                                    ,'1','')
                                ,'2','')
                            ,'3','')
                        ,'4','')
                    ,'5','')
                ,'6','')
            ,'7','')
        ,'8','')
    ,'9','') AS CleanName
FROM RemoveDuplicateIntsFromNames
