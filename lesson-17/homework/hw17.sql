-- Task 1

WITH Regions AS (
    SELECT DISTINCT Region FROM #RegionSales
),
Distributors AS (
    SELECT DISTINCT Distributor FROM #RegionSales
)
SELECT 
    r.Region,
    d.Distributor,
    ISNULL(rs.Sales, 0) AS Sales
FROM Regions r
CROSS JOIN Distributors d
LEFT JOIN #RegionSales rs
    ON rs.Region = r.Region
   AND rs.Distributor = d.Distributor
ORDER BY d.Distributor, r.Region

-- Task 2

SELECT m.name
FROM Employee e
JOIN Employee m
    ON e.managerId = m.id
GROUP BY m.id, m.name
HAVING COUNT(e.id) >= 5

-- Task 3

SELECT 
    p.product_name,
    SUM(o.unit) AS unit
FROM Orders o
JOIN Products p
    ON o.product_id = p.product_id
WHERE o.order_date >= '2020-02-01'
  AND o.order_date < '2020-03-01'
GROUP BY p.product_name
HAVING SUM(o.unit) >= 100

-- Task 4

WITH VendorCount AS (
    SELECT 
        CustomerID,
        Vendor,
        COUNT(*) AS OrderCount,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM Orders
    GROUP BY CustomerID, Vendor
)
SELECT CustomerID, Vendor
FROM VendorCount
WHERE rn = 1

-- Task 5

DECLARE @Check_Prime INT = 91;  
DECLARE @i INT = 2;
DECLARE @isPrime BIT = 1;  

IF @Check_Prime <= 1
BEGIN
    SET @isPrime = 0;
END
ELSE
BEGIN
    WHILE @i <= SQRT(@Check_Prime)
    BEGIN
        IF @Check_Prime % @i = 0
        BEGIN
            SET @isPrime = 0;
            BREAK; 
        END
        SET @i = @i + 1;
    END
END

IF @isPrime = 1
    PRINT 'This number is prime'
ELSE
    PRINT 'This number is not prime'

-- Task 6

WITH LocationCount AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS signals_per_location
    FROM Device
    GROUP BY Device_id, Locations
),
Ranked AS (
    SELECT 
        Device_id,
        Locations,
        signals_per_location,
        ROW_NUMBER() OVER (PARTITION BY Device_id ORDER BY signals_per_location DESC) AS rn
    FROM LocationCount
),
TotalAgg AS (
    SELECT 
        Device_id,
        COUNT(DISTINCT Locations) AS no_of_location,
        SUM(signals_per_location) AS no_of_signals
    FROM LocationCount
    GROUP BY Device_id
)
SELECT 
    t.Device_id,
    t.no_of_location,
    r.Locations AS max_signal_location,
    t.no_of_signals
FROM TotalAgg t
JOIN Ranked r
  ON t.Device_id = r.Device_id
 AND r.rn = 1

 -- Task 7

SELECT EmpID, EmpName, Salary
FROM Employee e
WHERE Salary > (
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
)

-- Task 8

WITH MatchCount AS (
    SELECT 
        t.TicketID,
        COUNT(DISTINCT t.Number) AS total_picked,
        SUM(CASE WHEN n.Number IS NOT NULL THEN 1 ELSE 0 END) AS matched
    FROM Tickets t
    LEFT JOIN Numbers n
        ON t.Number = n.Number
    GROUP BY t.TicketID
)
SELECT 
    SUM(
        CASE 
            WHEN matched = (SELECT COUNT(*) FROM Numbers) THEN 100  -- all winning numbers
            WHEN matched > 0 THEN 10                                -- partial match
            ELSE 0
        END
    ) AS Total_Winnings
FROM MatchCount

-- Task 9

WITH user_summary AS (
    SELECT 
        User_id,
        Spend_date,
        SUM(CASE WHEN Platform = 'Mobile' THEN Amount ELSE 0 END) AS mobile_amt,
        SUM(CASE WHEN Platform = 'Desktop' THEN Amount ELSE 0 END) AS desktop_amt
    FROM Spending
    GROUP BY User_id, Spend_date
),
classified AS (
    SELECT
        Spend_date,
        CASE 
            WHEN mobile_amt > 0 AND desktop_amt > 0 THEN 'Both'
            WHEN mobile_amt > 0 AND desktop_amt = 0 THEN 'Mobile'
            WHEN desktop_amt > 0 AND mobile_amt = 0 THEN 'Desktop'
        END AS PlatformType,
        (mobile_amt + desktop_amt) AS total_amount,
        User_id
    FROM user_summary
)
SELECT 
    Spend_date,
    PlatformType AS Platform,
    SUM(total_amount) AS Total_Amount,
    COUNT(DISTINCT User_id) AS Total_users
FROM classified
GROUP BY Spend_date, PlatformType
UNION ALL
SELECT 
    s.Spend_date,
    'Both' AS Platform,
    0 AS Total_Amount,
    0 AS Total_users
FROM (SELECT DISTINCT Spend_date FROM Spending) s
WHERE NOT EXISTS (
    SELECT 1 FROM classified c WHERE c.Spend_date = s.Spend_date AND c.PlatformType = 'Both'
)
ORDER BY Spend_date, 
         CASE Platform
            WHEN 'Mobile' THEN 1
            WHEN 'Desktop' THEN 2
            WHEN 'Both' THEN 3
         END

-- Task 10

WITH Numbers AS
(
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.objects
)
SELECT g.Product, 1 AS Quantity
FROM Grouped g
CROSS APPLY
(
    SELECT n FROM Numbers WHERE n <= g.Quantity
) t
