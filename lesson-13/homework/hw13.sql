-- Easy Tasks

-- Task 1

SELECT 
    CONCAT(emp_id, '-', first_name, ' ', last_name) AS full_info
FROM 
    employees
WHERE 
    emp_id = 100

-- Task 2

UPDATE employees
SET phone_number = REPLACE(phone_number, '124', '999')
WHERE phone_number LIKE '%124%'

-- Task 3

SELECT 
    first_name AS [First Name], 
    LEN(first_name) AS [Name Length]
FROM 
    employees
WHERE 
    LEFT(first_name, 1) IN ('A', 'J', 'M')
ORDER BY 
    first_name

-- Task 4

SELECT 
    manager_id,
    SUM(salary) AS total_salary
FROM 
    employees
GROUP BY 
    manager_id

-- Task 5

SELECT 
    year,
    GREATEST(Max1, Max2, Max3) AS Highest_Value
FROM 
    TestMax

-- the second method is with  CASE

SELECT 
    year,
    CASE
        WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1
        WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2
        ELSE Max3
    END AS Highest_Value
FROM 
    TestMax

-- Task 6

SELECT *
FROM cinema
WHERE 
    id % 2 = 1 
    AND description NOT LIKE '%boring%'

-- Task 7

SELECT *
FROM SingleOrder
ORDER BY 
    IIF(id = 0, 1, 0), id

-- Task 8

SELECT 
    COALESCE(ssn, passportid, itin) AS first_non_null
FROM 
    person

-- Medium Tasks

-- Task 1

SELECT
    FullName,
    LEFT(FullName, CHARINDEX(' ', FullName) - 1) AS Firstname,

    SUBSTRING(
        FullName,
        CHARINDEX(' ', FullName) + 1,
        CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) - CHARINDEX(' ', FullName) - 1
    ) AS Middlename,

    RIGHT(
        FullName,
        LEN(FullName) - CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1)
    ) AS Lastname

FROM Students

-- Task 2

SELECT *
FROM Orders
WHERE 
    delivery_state = 'Texas'
    AND customer_id IN (
        SELECT customer_id
        FROM Orders
        WHERE delivery_state = 'California'
    )

-- Task 3

SELECT 
    category,
    STRING_AGG(item, ', ') AS items
FROM 
    DMLTable
GROUP BY 
    category

-- Task 4

SELECT *
FROM employees
WHERE LEN(CONCAT(first_name, last_name)) 
     - LEN(REPLACE(CONCAT(first_name, last_name), 'a', '')) >= 3;

-- Task 5

SELECT 
    department_id,
    COUNT(*) AS total_employees,
    SUM(CASE 
            WHEN DATEDIFF(YEAR, hire_date, GETDATE()) > 3 THEN 1 
            ELSE 0 
        END) AS employees_over_3_years,
    CAST(
        100.0 * SUM(CASE 
                        WHEN DATEDIFF(YEAR, hire_date, GETDATE()) > 3 THEN 1 
                        ELSE 0 
                   END) / COUNT(*) AS DECIMAL(5,2)
    ) AS percent_over_3_years
FROM employees
GROUP BY department_id
ORDER BY department_id

-- Task 6

-- Most experienced
SELECT TOP 1 WITH TIES
    SpacemanID,
    JobDescription,
    MissionCount,
    'Most Experienced' AS ExperienceLevel
FROM Personal
ORDER BY JobDescription, MissionCount DESC

-- Least experienced
SELECT TOP 1 WITH TIES
    SpacemanID,
    JobDescription,
    MissionCount,
    'Least Experienced' AS ExperienceLevel
FROM Personal
ORDER BY JobDescription, MissionCount ASC

-- Difficult Tasks

-- Task 1

DECLARE @input VARCHAR(100) = 'tf56sd#%OqH';

WITH Tally (n) AS (
    SELECT TOP (LEN(@input)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
    FROM sys.all_objects
),
Chars AS (
    SELECT 
        SUBSTRING(@input, n, 1) AS ch
    FROM Tally
),
Separated AS (
    SELECT 
        ch,
        CASE 
            WHEN ch LIKE '[A-Z]' THEN 'Uppercase'
            WHEN ch LIKE '[a-z]' THEN 'Lowercase'
            WHEN ch LIKE '[0-9]' THEN 'Number'
            ELSE 'Other'
        END AS Category
    FROM Chars
)
SELECT
    (SELECT STRING_AGG(ch, '') FROM Separated WHERE Category = 'Uppercase') AS UppercaseLetters,
    (SELECT STRING_AGG(ch, '') FROM Separated WHERE Category = 'Lowercase') AS LowercaseLetters,
    (SELECT STRING_AGG(ch, '') FROM Separated WHERE Category = 'Number') AS Numbers,
    (SELECT STRING_AGG(ch, '') FROM Separated WHERE Category = 'Other') AS OtherCharacters

-- Task 2

SELECT *, SUM(Grade) OVER (ORDER BY StudentID) AS RunningTotal
FROM Students

-- Task 3

-- Create temp table for result
CREATE TABLE #Results (
    ID INT,
    Equation VARCHAR(100),
    Result INT
)

-- Declare variables
DECLARE @ID INT, @Equation VARCHAR(100), @SQL NVARCHAR(200), @Result INT

-- Cursor to loop through the Equations table
DECLARE cur CURSOR FOR
SELECT ID, Equation FROM Equations

OPEN cur
FETCH NEXT FROM cur INTO @ID, @Equation

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Build dynamic SQL to evaluate the expression
    SET @SQL = 'SELECT @ResultOut = ' + @Equation

    -- Execute and capture result
    EXEC sp_executesql @SQL, N'@ResultOut INT OUTPUT', @ResultOut = @Result OUTPUT

    -- Insert into result table
    INSERT INTO #Results VALUES (@ID, @Equation, @Result)

    FETCH NEXT FROM cur INTO @ID, @Equation
END

CLOSE cur
DEALLOCATE cur

-- Final result
SELECT * FROM #Results

-- Clean up
DROP TABLE #Results

-- Task 4

SELECT 
    FORMAT(BirthDate, 'MM-dd') AS Birthday,
    COUNT(*) AS StudentCount
FROM 
    Student
GROUP BY 
    FORMAT(BirthDate, 'MM-dd')
HAVING 
    COUNT(*) > 1

-- Task 5

SELECT 
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerA 
        ELSE PlayerB 
    END AS Player1,
    
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerB 
        ELSE PlayerA 
    END AS Player2,

    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerA 
        ELSE PlayerB 
    END,
    
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerB 
        ELSE PlayerA 
    END
