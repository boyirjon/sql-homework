-- Task 1

CREATE TABLE #MonthlySales (
    ProductID INT,
    TotalQuantity INT,
    TotalRevenue DECIMAL(10,2)
);

INSERT INTO #MonthlySales (ProductID, TotalQuantity, TotalRevenue)
SELECT 
    s.ProductID,
    SUM(s.Quantity) AS TotalQuantity,
    SUM(s.Quantity * p.Price) AS TotalRevenue
FROM Sales s
JOIN Products p ON s.ProductID = p.ProductID
WHERE YEAR(s.SaleDate) = YEAR(GETDATE())
  AND MONTH(s.SaleDate) = MONTH(GETDATE())
GROUP BY s.ProductID;

SELECT * FROM #MonthlySales

-- Task 2

CREATE VIEW vw_ProductSalesSummary AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    COALESCE(SUM(s.Quantity), 0) AS TotalQuantitySold
FROM Products p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
GROUP BY p.ProductID, p.ProductName, p.Category

-- Task 3

CREATE FUNCTION fn_GetTotalRevenueForProduct (@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(18,2);

    SELECT @TotalRevenue = SUM(s.Quantity * p.Price)
    FROM Sales s
    INNER JOIN Products p ON s.ProductID = p.ProductID
    WHERE s.ProductID = @ProductID;

    RETURN ISNULL(@TotalRevenue, 0);
END;

SELECT dbo.fn_GetTotalRevenueForProduct(1) AS TotalRevenue;

SELECT 
    p.ProductID,
    p.ProductName,
    dbo.fn_GetTotalRevenueForProduct(p.ProductID) AS TotalRevenue
FROM Products p;

-- Task 4

CREATE FUNCTION fn_GetSalesByCategory (@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.ProductName,
        COALESCE(SUM(s.Quantity), 0) AS TotalQuantity,
        COALESCE(SUM(s.Quantity * p.Price), 0) AS TotalRevenue
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.Category = @Category
    GROUP BY p.ProductName
)

SELECT * FROM dbo.fn_GetSalesByCategory('Electronics')

SELECT * FROM dbo.fn_GetSalesByCategory('Groceries')

-- Task 5

CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @Result VARCHAR(3);

    IF @Number < 2
        SET @Result = 'No';
    ELSE IF @Number = 2
        SET @Result = 'Yes';
    ELSE
    BEGIN
        DECLARE @i INT = 2;
        SET @Result = 'Yes';

        WHILE @i <= SQRT(@Number)
        BEGIN
            IF @Number % @i = 0
            BEGIN
                SET @Result = 'No';
                BREAK;
            END
            SET @i = @i + 1;
        END
    END

    RETURN @Result;
END

SELECT dbo.fn_IsPrime(7)   AS Result1
SELECT dbo.fn_IsPrime(10)  AS Result2
SELECT dbo.fn_IsPrime(2)   AS Result3
SELECT dbo.fn_IsPrime(1)   AS Result4

-- Task 6

CREATE FUNCTION fn_GetNumbersBetween (@Start INT, @End INT)
RETURNS @Numbers TABLE (Number INT)
AS
BEGIN
    ;WITH NumberSeries AS
    (
        SELECT @Start AS Num
        UNION ALL
        SELECT Num + 1
        FROM NumberSeries
        WHERE Num + 1 <= @End
    )
    INSERT INTO @Numbers
    SELECT Num FROM NumberSeries
    OPTION (MAXRECURSION 0);

    RETURN;
END;

SELECT * FROM dbo.fn_GetNumbersBetween(3, 10);

-- Task 7

-- Example 1

CREATE FUNCTION getNthHighestSalary(@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    ;WITH RankedSalaries AS (
        SELECT DISTINCT salary,
               DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
        FROM Employee
    )
    SELECT @Result = salary
    FROM RankedSalaries
    WHERE rnk = @N;

    RETURN @Result;
END;

SELECT dbo.getNthHighestSalary(2) AS HighestNSalary

-- Example 2

DECLARE @N INT = 2;

SELECT 
    CASE 
        WHEN COUNT(DISTINCT salary) < @N THEN NULL
        ELSE (
            SELECT DISTINCT salary
            FROM Employee
            ORDER BY salary DESC
            OFFSET (@N - 1) ROWS FETCH NEXT 1 ROWS ONLY
        )
    END AS HighestNSalary
FROM Employee

-- Task 8

SELECT TOP 1
    id,
    COUNT(*) AS num
FROM (
    SELECT requester_id AS id, accepter_id AS friend
    FROM RequestAccepted
    UNION ALL
    SELECT accepter_id AS id, requester_id AS friend
    FROM RequestAccepted
) AS AllFriends
GROUP BY id
ORDER BY COUNT(*) DESC

-- Task 9

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_amount,
    MAX(o.order_date) AS last_order_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name

-- Task 10

SELECT 
    RowNumber,
    LAST_VALUE(TestCase) IGNORE NULLS 
        OVER (ORDER BY RowNumber
              ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Workflow
FROM Gaps
