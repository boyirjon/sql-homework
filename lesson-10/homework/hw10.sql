-- Easy-Level Tasks

-- Task 1

select
	e.Name,
	e.Salary,
	d.DepartmentName
from
	Employees e
join
	Departments d on e.DepartmentID = d.DepartmentID
where
	Salary > 50000

-- Task 2

select
	Customers.FirstName, 
	Customers.LastName, 
	Orders.OrderDate
from
	Customers
join
	Orders on Customers.CustomerID = Orders.CustomerID
where
    YEAR(Orders.OrderDate) = 2023

-- Task 3

SELECT 
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
LEFT JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID

-- Task 4

select
	Suppliers.SupplierName, 
	Products.ProductName
from 
	Suppliers
left join 
	Products on Suppliers.SupplierID = Products.SupplierID

-- Task 5

SELECT 
    Orders.OrderID,
    Orders.OrderDate,
    Payments.PaymentDate,
    Payments.Amount
FROM 
    Orders
FULL OUTER JOIN 
    Payments ON Orders.OrderID = Payments.OrderID

-- Task 6

SELECT 
    E.Name,
    M.Name AS ManagerName
FROM 
    Employees E
LEFT JOIN 
    Employees M ON E.ManagerID = M.EmployeeID

-- Task 7

SELECT 
    Students.Name,
    Courses.CourseName
FROM 
    Students
JOIN 
    Enrollments ON Students.StudentID = Enrollments.StudentID
JOIN 
    Courses ON Enrollments.CourseID = Courses.CourseID
WHERE 
    Courses.CourseName = 'Math 101'

-- Task 8

SELECT 
    Customers.FirstName,
    Customers.LastName,
    Orders.Quantity
FROM 
    Customers
JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
WHERE 
    Orders.Quantity > 3

-- Task 9

SELECT 
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE 
    Departments.DepartmentName = 'Human Resources'

--Medium-Level Tasks 

-- Task 10

SELECT 
    Departments.DepartmentName,
    COUNT(Employees.EmployeeID) AS EmployeeCount
FROM 
    Employees
JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
GROUP BY 
    Departments.DepartmentName
HAVING 
    COUNT(Employees.EmployeeID) > 5

-- Task 11

SELECT 
    Products.ProductID,
    Products.ProductName
FROM 
    Products
LEFT JOIN 
    Sales ON Products.ProductID = Sales.ProductID
WHERE 
    Sales.ProductID IS NULL

-- Task 12

SELECT 
    Customers.FirstName,
    Customers.LastName,
    COUNT(Orders.OrderID) AS TotalOrders
FROM 
    Customers
JOIN 
    Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY 
    Customers.FirstName, Customers.LastName
HAVING 
    COUNT(Orders.OrderID) >= 1

-- Task 13

SELECT 
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
INNER JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID

-- Task 14

SELECT 
    E1.Name AS Employee1,
    E2.Name AS Employee2,
    E1.ManagerID
FROM 
    Employees E1
JOIN 
    Employees E2 ON 
        E1.ManagerID = E2.ManagerID AND 
        E1.EmployeeID < E2.EmployeeID
WHERE 
    E1.ManagerID IS NOT NULL

-- Task 15

SELECT 
    Orders.OrderID,
    Orders.OrderDate,
    Customers.FirstName,
    Customers.LastName
FROM 
    Orders
JOIN 
    Customers ON Orders.CustomerID = Customers.CustomerID
WHERE 
    YEAR(Orders.OrderDate) = 2022

-- Task 16

SELECT 
    Employees.Name,
    Employees.Salary,
    Departments.DepartmentName
FROM 
    Employees
JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE 
    Departments.DepartmentName = 'Sales'
    AND Employees.Salary > 60000

-- Task 17

SELECT 
    Orders.OrderID,
    Orders.OrderDate,
    Payments.PaymentDate,
    Payments.Amount
FROM 
    Orders
INNER JOIN 
    Payments ON Orders.OrderID = Payments.OrderID

-- Task 18

SELECT 
    Products.ProductID,
    Products.ProductName
FROM 
    Products
LEFT JOIN 
    Orders ON Products.ProductID = Orders.ProductID
WHERE 
    Orders.ProductID IS NULL

--Hard-Level Tasks

-- Task 19

SELECT 
    E.Name,
    E.Salary
FROM 
    Employees E
WHERE 
    E.Salary > (
        SELECT 
            AVG(Salary)
        FROM 
            Employees
        WHERE 
            DepartmentID = E.DepartmentID
    )

-- Task 20

SELECT 
    Orders.OrderID,
    Orders.OrderDate
FROM 
    Orders
LEFT JOIN 
    Payments ON Orders.OrderID = Payments.OrderID
WHERE 
    Orders.OrderDate < '2020-01-01'
    AND Payments.OrderID IS NULL

-- Task 21

SELECT 
    Products.ProductID,
    Products.ProductName
FROM 
    Products
LEFT JOIN 
    Categories ON Products.Category = Categories.CategoryID
WHERE 
    Categories.CategoryID IS NULL

-- Task 22

SELECT 
    E1.Name AS Employee1,
    E2.Name AS Employee2,
    E1.ManagerID,
    E1.Salary AS Salary1,
    E2.Salary AS Salary2
FROM 
    Employees E1
JOIN 
    Employees E2 
    ON E1.ManagerID = E2.ManagerID
    AND E1.EmployeeID < E2.EmployeeID
WHERE 
    E1.Salary > 60000
    AND E2.Salary > 60000

-- Task 23

SELECT 
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE 
    Departments.DepartmentName LIKE 'M%'

-- Task 24

SELECT 
    Sales.SaleID,
    Products.ProductName,
    Sales.SaleAmount
FROM 
    Sales
JOIN 
    Products ON Sales.ProductID = Products.ProductID
WHERE 
    Sales.SaleAmount > 500

-- Task 25

SELECT 
    S.StudentID,
    S.Name
FROM 
    Students S
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM Enrollments E
        JOIN Courses C ON E.CourseID = C.CourseID
        WHERE 
            E.StudentID = S.StudentID
            AND C.CourseName = 'Math 101'
    )

-- Task 26

SELECT 
    Orders.OrderID,
    Orders.OrderDate,
    Payments.PaymentID
FROM 
    Orders
LEFT JOIN 
    Payments ON Orders.OrderID = Payments.OrderID
WHERE 
    Payments.PaymentID IS NULL

-- Task 27

SELECT 
    Products.ProductID,
    Products.ProductName,
    Categories.CategoryName
FROM 
    Products
JOIN 
    Categories ON Products.Category = Categories.CategoryID
WHERE 
    Categories.CategoryName IN ('Electronics', 'Furniture')
