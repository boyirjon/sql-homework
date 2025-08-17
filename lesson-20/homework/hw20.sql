-- Task 1

SELECT DISTINCT s.CustomerName
FROM #Sales s
WHERE EXISTS (
    SELECT 1
    FROM #Sales sub
    WHERE sub.CustomerName = s.CustomerName
      AND sub.SaleDate >= '2024-03-01'
      AND sub.SaleDate < '2024-04-01'
)

-- Task 2

SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRev)
    FROM (
        SELECT Product, SUM(Quantity * Price) AS TotalRev
        FROM #Sales
        GROUP BY Product
    ) AS Sub
)

-- Task 3

SELECT MAX(SaleAmount) AS SecondHighestSale
FROM (
    SELECT Quantity * Price AS SaleAmount
    FROM #Sales
) AS Sub
WHERE SaleAmount < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
)

-- Task 4

SELECT 
    DATENAME(MONTH, SaleDate) AS MonthName,
    YEAR(SaleDate) AS YearNumber,
    (SELECT SUM(s2.Quantity)
     FROM #Sales s2
     WHERE MONTH(s2.SaleDate) = MONTH(s1.SaleDate)
       AND YEAR(s2.SaleDate) = YEAR(s1.SaleDate)
    ) AS TotalQuantity
FROM #Sales s1
GROUP BY YEAR(SaleDate), MONTH(SaleDate), DATENAME(MONTH, SaleDate)
ORDER BY YearNumber, MONTH(SaleDate);

-- Task 5

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s1.Product = s2.Product
      AND s1.CustomerName <> s2.CustomerName
);

-- Task 6

SELECT Name, 
       ISNULL([Apple], 0) AS Apple,
       ISNULL([Orange], 0) AS Orange,
       ISNULL([Banana], 0) AS Banana
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS SourceTable
PIVOT (
    COUNT(Fruit)
    FOR Fruit IN ([Apple], [Orange], [Banana])
) AS PivotTable;

-- Task 7

WITH FamilyTree AS (
    -- Boshlang'ich daraja (to'g'ridan-to'g'ri ota-bola)
    SELECT ParentId, ChildID
    FROM Family

    UNION ALL

    -- Rekursiv qism (bolaning bolasi ham avlod bo'ladi)
    SELECT f.ParentId, ft.ChildID
    FROM Family f
    INNER JOIN FamilyTree ft
        ON f.ChildID = ft.ParentId
)
SELECT ParentId AS PID, ChildID AS CHID
FROM FamilyTree
ORDER BY PID, CHID;

-- Task 8

SELECT o.CustomerID, o.OrderID, o.DeliveryState, o.Amount
FROM #Orders o
WHERE o.DeliveryState = 'TX'
  AND EXISTS (
      SELECT 1
      FROM #Orders c
      WHERE c.CustomerID = o.CustomerID
        AND c.DeliveryState = 'CA'
  );

-- Task 9

UPDATE r
SET fullname = SUBSTRING(address, CHARINDEX('name=', address) + 5, 
               CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - (CHARINDEX('name=', address) + 5))
FROM #residents r
WHERE (fullname IS NULL OR fullname = '')
  AND address LIKE '%name=%';

-- Task 10

WITH RoutePaths AS (
    SELECT 
        DepartureCity,
        ArrivalCity,
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'

    UNION ALL

    SELECT 
        rp.DepartureCity,
        r.ArrivalCity,
        CAST(rp.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)) AS Route,
        rp.Cost + r.Cost
    FROM RoutePaths rp
    INNER JOIN #Routes r
        ON rp.ArrivalCity = r.DepartureCity
    WHERE CHARINDEX(r.ArrivalCity, rp.Route) = 0   
)
SELECT TOP 1 WITH TIES Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY 
    CASE 
        WHEN Cost = (SELECT MIN(Cost) FROM RoutePaths WHERE ArrivalCity='Khorezm') THEN 0
        WHEN Cost = (SELECT MAX(Cost) FROM RoutePaths WHERE ArrivalCity='Khorezm') THEN 1
    END,
    Cost;

-- Task 11

WITH Groups AS
(
    SELECT 
        ID,
        Vals,
        SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
            OVER (ORDER BY ID ROWS UNBOUNDED PRECEDING) AS grp
    FROM #RankingPuzzle
)
SELECT 
    ID,
    Vals,
    ROW_NUMBER() OVER (PARTITION BY grp ORDER BY ID) AS rank_in_group
FROM Groups
WHERE Vals <> 'Product'
ORDER BY ID;

-- Task 12

SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    SalesAmount,
    SalesMonth,
    SalesYear
FROM (
    SELECT *,
           AVG(SalesAmount) OVER (PARTITION BY Department, SalesMonth, SalesYear) AS DeptAvg
    FROM #EmployeeSales
) t
WHERE SalesAmount > DeptAvg
ORDER BY Department, SalesMonth;

-- Task 13

SELECT DISTINCT e.emp_id, e.emp_name
FROM Employees e
WHERE EXISTS (
    SELECT 1
    FROM Sales s1
    WHERE s1.emp_id = e.emp_id
      AND s1.amount = (
          SELECT MAX(s2.amount)
          FROM Sales s2
          WHERE MONTH(s2.sale_date) = MONTH(s1.sale_date)
            AND YEAR(s2.sale_date) = YEAR(s1.sale_date)
      )
);

-- Task 14

-- List of all months where sales happened
WITH Months AS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales
    WHERE SalesYear = 2024
)
SELECT DISTINCT e.EmployeeName
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM Months m
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales s
        WHERE s.EmployeeName = e.EmployeeName
          AND s.SalesMonth = m.SalesMonth
          AND s.SalesYear = 2024
    )
);

-- Task 15

SELECT product_name
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- Task 16

SELECT product_name, stock
FROM Products
WHERE stock < (
    SELECT MAX(stock)
    FROM Products
);

-- Task 17

SELECT product_name
FROM Products
WHERE category_id = (
    SELECT category_id
    FROM Products
    WHERE product_name = 'Laptop'
);

-- Task 18

SELECT product_name, price, category
FROM Products
WHERE price > (
    SELECT MIN(price)
    FROM Products
    WHERE category = 'Electronics'
);

-- Task 19

SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE p.Price > (
    SELECT AVG(p2.Price)
    FROM Products p2
    WHERE p2.Category = p.Category
);

-- Task 20

SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-- Task 21

SELECT p.ProductID, p.Name, SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(TotalQty) 
    FROM (
        SELECT SUM(Quantity) AS TotalQty
        FROM Orders
        GROUP BY ProductID
    ) AS Sub
);

-- Task 22

SELECT p.ProductID, p.Name, p.Category, p.Price
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-- Task 23

SELECT TOP 1 
    p.ProductID,
    p.Name,
    SUM(o.Quantity) AS TotalQuantity
FROM Products p
JOIN Orders o
    ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY SUM(o.Quantity) DESC;
