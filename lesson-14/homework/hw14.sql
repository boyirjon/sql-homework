-- Easy Tasks

-- Task 1

SELECT 
    LEFT(Name, CHARINDEX(',', Name) - 1) AS Name,
    RIGHT(Name, LEN(Name) - CHARINDEX(',', Name)) AS Surname
FROM TestMultipleColumns

-- Task 2

SELECT *
FROM TestPercent
WHERE CHARINDEX('%', Strs) > 0

-- Task 3

SELECT value AS Part
FROM Splitter
CROSS APPLY STRING_SPLIT(Vals, '.')

-- Task 4

SELECT 
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE(
    REPLACE('1234ABC123456XYZ1234567890ADS', '0', 'X')
    , '1', 'X'), '2', 'X'), '3', 'X'), '4', 'X'),
    '5', 'X'), '6', 'X'), '7', 'X'), '8', 'X'), '9', 'X') 
AS ReplacedText

-- Task 5

SELECT *
FROM testDots
WHERE LEN(Vals) - LEN(REPLACE(Vals, '.', '')) > 2

-- Task 6

SELECT 
    texts,
    LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces

-- Task 7

SELECT e.Name AS EmployeeName, e.Salary AS EmployeeSalary, m.Name AS ManagerName, m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m ON e.ManagerId = m.Id
WHERE e.Salary > m.Salary

-- Task 8

SELECT
	EMPLOYEE_ID,
	FIRST_NAME,
	LAST_NAME,
	HIRE_DATE,
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS YearsOfService
FROM
	EmployeeS
WHERE
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 10 
    AND DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 15

-- Medium Tasks

-- Task 1

WITH Numbers AS (
    SELECT TOP (LEN('rtcfvty34redt'))
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values
),
Chars AS (
    SELECT 
        SUBSTRING('rtcfvty34redt', n, 1) AS ch
    FROM Numbers
)
SELECT
    'rtcfvty34redt' AS OriginalText,
    (SELECT STRING_AGG(ch, '') 
     FROM Chars 
     WHERE ch LIKE '[A-Za-z]') AS OnlyLetters,
    (SELECT STRING_AGG(ch, '') 
     FROM Chars 
     WHERE ch LIKE '[0-9]') AS OnlyDigits

-- Task 2

SELECT w1.Id
FROM weather w1
JOIN weather w2
  ON w1.RecordDate = DATEADD(DAY, 1, w2.RecordDate)
WHERE w1.Temperature > w2.Temperature

-- Task 3

SELECT 
    player_id,
    MIN(event_date) AS first_login_date
FROM 
    Activity
GROUP BY 
    player_id

-- Task 4

WITH SplitFruit AS (
    SELECT 
        value,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM fruits
    CROSS APPLY STRING_SPLIT(fruit_list, ',')
)
SELECT value AS third_fruit
FROM SplitFruit
WHERE rn = 3

-- Task 5

DECLARE @str VARCHAR(MAX) = 'sdgfhsdgfhs@121313131';

WITH Numbers AS (
    SELECT TOP (LEN(@str))
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM sys.all_objects 
),
Chars AS (
    SELECT 
        SUBSTRING(@str, n, 1) AS character
    FROM Numbers
)
SELECT * 
INTO SplitCharacters 
FROM Chars

-- Task 6

SELECT 
    p1.id,
    CASE 
        WHEN p1.code = 0 THEN p2.code
        ELSE p1.code
    END AS code
FROM p1
JOIN p2 ON p1.id = p2.id

-- Task 7

SELECT 
    employee_id,
    hire_date,
    DATEDIFF(YEAR, hire_date, GETDATE()) AS years_worked,
    CASE 
        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) BETWEEN 6 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) BETWEEN 11 AND 20 THEN 'Senior'
        ELSE 'Veteran'
    END AS employment_stage
FROM Employees

-- Task 8

SELECT 
    Vals,
    LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'a') - 1) AS StartInteger
FROM GetIntegers
WHERE PATINDEX('%[0-9]%', Vals) = 1

-- Difficult Tasks

-- Task 1

SELECT 
    vals,
    STUFF(vals, 1, 2, SUBSTRING(vals, 2, 1) + SUBSTRING(vals, 1, 1)) AS swapped_val
FROM MultipleVals

-- Task 2

WITH RankedLogins AS (
    SELECT 
        player_id,
        device_id,
        event_date,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date ASC) AS rn
    FROM Activity
)
SELECT 
    player_id,
    device_id
FROM RankedLogins
WHERE rn = 1

-- Task 3

WITH SalesWithWeek AS (
    SELECT
        area,
        sale_date,
        DATEPART(ISO_WEEK, sale_date) AS week_num,
        DATEPART(YEAR, sale_date) AS year,
        sales
    FROM WeekPercentagePuzzle
),
WeeklyTotals AS (
    SELECT
        area,
        year,
        week_num,
        SUM(sales) AS weekly_total
    FROM SalesWithWeek
    GROUP BY area, year, week_num
),
PercentagePerDay AS (
    SELECT
        s.area,
        s.sale_date,
        s.week_num,
        s.year,
        s.sales,
        w.weekly_total,
        CAST(s.sales * 100.0 / w.weekly_total AS DECIMAL(5,2)) AS sales_percentage
    FROM SalesWithWeek s
    JOIN WeeklyTotals w
      ON s.area = w.area AND s.week_num = w.week_num AND s.year = w.year
)
SELECT 
    area,
    sale_date,
    year,
    week_num,
    sales,
    weekly_total,
    sales_percentage
FROM PercentagePerDay
ORDER BY area, year, week_num, sale_date
