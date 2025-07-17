SELECT 
    p.firstName,
    p.lastName,
    a.city,
    a.state
FROM 
    Person p
LEFT JOIN 
    Address a
ON 
    p.personId = a.personId
-- 2. Employees Earning More Than Their Managers
SELECT 
    e.name AS Employee
FROM 
    Employee e
JOIN 
    Employee m 
ON 
    e.managerId = m.id
WHERE 
    e.salary > m.salary
-- 3. Duplicate Emails
SELECT 
    email
FROM 
    Person_
GROUP BY 
    email
HAVING 
    COUNT(*) > 1
-- 4. Delete Duplicate Emails
DELETE FROM Person_
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person_
    GROUP BY email
)
-- 5. Find those parents who has only girls.
SELECT DISTINCT g.ParentName AS ParentName
FROM girls g
WHERE g.ParentName NOT IN (
    SELECT DISTINCT ParentName FROM boys
)
-- 6. Total over 50 and least
SELECT 
    custid,
    SUM(CASE WHEN weight > 50 THEN qty * price ELSE 0 END) AS TotalSalesOver50,
    MIN(weight) AS LeastWeight
FROM 
    Sales.Orders
GROUP BY 
    custid
-- 7. Carts
SELECT Item
FROM Cart1
INTERSECT
SELECT Item
FROM Cart2
-- 8. Customers Who Never Order
SELECT name AS Customers
FROM Customers
WHERE id NOT IN (
    SELECT customerId FROM Orders
)
-- 9. Students and Examinations
SELECT 
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects sub
LEFT JOIN 
    Examinations e
    ON s.student_id = e.student_id AND sub.subject_name = e.subject_name
GROUP BY 
    s.student_id, s.student_name, sub.subject_name
ORDER BY 
    s.student_id, sub.subject_name


