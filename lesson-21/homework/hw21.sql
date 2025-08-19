-- Task 1

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    Quantity,
    CustomerID,
    ROW_NUMBER() OVER (ORDER BY SaleDate) AS RowNum
FROM ProductSales

-- Task 2

SELECT 
    ProductName,
    SUM(Quantity) AS TotalQuantity,
    DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS RankPosition
FROM ProductSales
GROUP BY ProductName

-- Task 3

SELECT
    SaleID,
    CustomerID,
    ProductName,
    SaleDate,
    SaleAmount,
    Quantity
FROM (
    SELECT 
        SaleID,
        CustomerID,
        ProductName,
        SaleDate,
        SaleAmount,
        Quantity,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS rn
    FROM ProductSales
) AS RankedSales
WHERE rn = 1

-- Task 4

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextSaleAmount
FROM ProductSales
ORDER BY SaleDate

-- Task 5

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
FROM ProductSales
ORDER BY SaleDate

-- Task 6

WITH SalesWithPrev AS (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount
    FROM ProductSales
)
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    PreviousSaleAmount
FROM SalesWithPrev
WHERE SaleAmount > PreviousSaleAmount
ORDER BY SaleDate

-- Task 7

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount,
    SaleAmount - LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DifferenceFromPrevious
FROM ProductSales
ORDER BY ProductName, SaleDate

-- Task 8

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS NextSaleAmount,
    CASE 
        WHEN LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) IS NULL 
             THEN NULL
        ELSE 
             ((LEAD(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) - SaleAmount) 
              * 100.0 / SaleAmount)
    END AS PercentageChange
FROM ProductSales
ORDER BY ProductName, SaleDate

-- Task 9

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PreviousSaleAmount,
    CASE 
        WHEN LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) IS NULL 
             THEN NULL
        ELSE 
             SaleAmount * 1.0 / LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate)
    END AS RatioToPrevious
FROM ProductSales
ORDER BY ProductName, SaleDate

-- Task 10

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS FirstSaleAmount,
    SaleAmount - FIRST_VALUE(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS DifferenceFromFirst
FROM ProductSales
ORDER BY ProductName, SaleDate

-- Task 11

WITH SalesCTE AS (
    SELECT 
        SaleID,
        ProductName,
        SaleDate,
        SaleAmount,
        LAG(SaleAmount) OVER (PARTITION BY ProductName ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
)
SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    PrevAmount
FROM SalesCTE
WHERE PrevAmount IS NOT NULL
  AND SaleAmount > PrevAmount
ORDER BY ProductName, SaleDate;

-- Task 12

SELECT 
    SaleID,
    ProductName,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (
        PARTITION BY ProductName 
        ORDER BY SaleDate, SaleID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS ClosingBalance
FROM ProductSales
ORDER BY ProductName, SaleDate, SaleID

-- Task 13

SELECT 
    SaleID,
    SaleDate,
    SaleAmount,
    AVG(SaleAmount) OVER (
        ORDER BY SaleDate 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS MovingAvg_Last3
FROM ProductSales
ORDER BY SaleDate

-- Task 14

SELECT 
    SaleID,
    SaleDate,
    SaleAmount,
    SaleAmount - (SELECT AVG(SaleAmount) FROM ProductSales) AS DifferenceFromAvg
FROM ProductSales

-- Task 15

WITH SalaryRanks AS (
    SELECT 
        EmployeeID,
        Name,
        Department,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM Employees1
)
SELECT *
FROM SalaryRanks
WHERE SalaryRank IN (
    SELECT SalaryRank
    FROM SalaryRanks
    GROUP BY SalaryRank
    HAVING COUNT(*) > 1
)
ORDER BY SalaryRank, Salary DESC

-- Task 16

SELECT 
    Department,
    EmployeeID,
    Salary
FROM (
    SELECT 
        Department,
        EmployeeID,
        Salary,
        ROW_NUMBER() OVER (
            PARTITION BY Department 
            ORDER BY Salary DESC
        ) AS RowNum
    FROM Employees1
) AS Ranked
WHERE RowNum <= 2
ORDER BY Department, Salary DESC

-- Task 17

SELECT e.EmployeeID, e.EmployeeID, e.Department, e.Salary
FROM Employees1 e
WHERE e.Salary = (
    SELECT MIN(Salary)
    FROM Employees1
    WHERE Department = e.Department
)

-- Task 18

SELECT 
    EmployeeID,
    EmployeeID,
    Department,
    Salary,
    SUM(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary, EmployeeID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningTotalSalary
FROM Employees1

-- Task 19

SELECT 
    e.EmployeeID,
    e.Name,
    e.Department,
    e.Salary,
    SUM(e.Salary) OVER (PARTITION BY e.Department) AS TotalDepartmentSalary
FROM Employees1 e

-- Task 20

SELECT 
    employeeid,
    name,
    department,
    salary,
    AVG(salary) OVER(PARTITION BY department) AS avg_salary_per_department
FROM Employees1

-- Task 21

SELECT 
    employeeid,
    name,
    department,
    salary,
    AVG(salary) OVER(PARTITION BY department) AS dept_avg_salary,
    salary - AVG(salary) OVER(PARTITION BY department) AS diff_from_avg
FROM Employees1

-- Task 22

SELECT 
    employeeid,
    department,
    salary,
    AVG(salary) OVER (
        ORDER BY employeeid 
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_salary
FROM Employees1

-- Task 23

SELECT SUM(salary) AS last_3_hired_total_salary
FROM (
    SELECT TOP 3 salary
    FROM Employees1
    ORDER BY hiredate DESC
) AS last3
