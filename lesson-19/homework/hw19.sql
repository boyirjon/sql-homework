-- Task 1

CREATE PROCEDURE GetEmployeeBonus
AS
BEGIN
    IF OBJECT_ID('tempdb..#EmployeeBonus') IS NOT NULL
        DROP TABLE #EmployeeBonus;

    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );

    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        e.EmployeeID,
        e.FirstName + ' ' + e.LastName AS FullName,
        e.Department,
        e.Salary,
        (e.Salary * db.BonusPercentage / 100) AS BonusAmount
    FROM Employees e
    INNER JOIN DepartmentBonus db
        ON e.Department = db.Department;

    SELECT * FROM #EmployeeBonus;
END;
GO
EXEC GetEmployeeBonus

-- Task 2

CREATE PROCEDURE UpdateDepartmentSalary
    @DeptName NVARCHAR(50),
    @IncreasePct DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePct / 100)
    WHERE Department = @DeptName;

    SELECT EmployeeID, FirstName, LastName, Department, Salary
    FROM Employees
    WHERE Department = @DeptName;
END;
GO
EXEC UpdateDepartmentSalary @DeptName = 'Sales', @IncreasePct = 5

-- Task 3

MERGE Products_Current AS target
USING Products_New AS source
    ON target.ProductID = source.ProductID

WHEN MATCHED THEN
    UPDATE SET 
        target.ProductName = source.ProductName,
        target.Price = source.Price

WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (source.ProductID, source.ProductName, source.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current

-- Task 4

SELECT 
    t.id,
    CASE 
        WHEN t.p_id IS NULL THEN 'Root'
        WHEN t.id IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
        ELSE 'Leaf'
    END AS type
FROM Tree t
ORDER BY t.id

-- Task 5

SELECT 
    s.user_id,
    COALESCE(
        ROUND(SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) * 1.0 
              / NULLIF(COUNT(c.action), 0), 2), 
        0
    ) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c
    ON s.user_id = c.user_id
GROUP BY s.user_id
ORDER BY s.user_id

-- Task 6

SELECT id, name, salary
FROM employees
WHERE salary = (
    SELECT MIN(salary)
    FROM employees
)

-- Task 7

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantity,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s
        ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName;
END;
GO
EXEC GetProductSalesSummary @ProductID = 1;
EXEC GetProductSalesSummary @ProductID = 15;
EXEC GetProductSalesSummary @ProductID = 20;
EXEC GetProductSalesSummary @ProductID = 12; 
