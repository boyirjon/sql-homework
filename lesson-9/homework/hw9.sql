--Easy-Level Tasks 

-- Task 1

select Products.ProductName, Suppliers.SupplierName
from Products
cross join Suppliers

-- Task 2

SELECT 
    d.DepartmentName,
    e.Name
FROM 
    Departments d
CROSS JOIN 
    Employees e

-- Task 3

select 
    Suppliers.SupplierName, 
    Products.ProductName
from 
    Products
inner join
    Suppliers 
on 
    Products.SupplierID = Suppliers.SupplierID

-- Task 4

select 
	c.FirstName, c.LastName,
	o.OrderID
from
	Customers c
inner join
	Orders o
on
	c.CustomerID = o.CustomerID

-- Task 5

select
	s.Name,
	c.CourseName
from
	Students s
cross join
	Courses c

-- Task 6

select
	p.ProductName,
	o.OrderID
from
	Orders o
join
	Products p
on
	o.ProductID = p.ProductID 

-- Task 7

select
	e.Name,
	d.DepartmentName
from 
	Employees e
join
	Departments d
on
	    e.DepartmentID = d.DepartmentID

-- Task 8

select
	s.Name,
	e.CourseID
from
	Students s
join
	Enrollments e
on
	s.StudentID = e.StudentID

-- Task 9

SELECT 
    Orders.OrderID,
    Payments.PaymentID,
    Payments.PaymentDate,
    Payments.Amount
FROM 
    Orders
INNER JOIN 
    Payments
ON 
    Orders.OrderID = Payments.OrderID

-- Task 10

SELECT 
    Orders.OrderID,
    Products.ProductName,
    Products.Price
FROM 
    Orders
INNER JOIN 
    Products
ON 
    Orders.ProductID = Products.ProductID
WHERE 
    Products.Price > 100

-- Medium Level

-- Task 11

SELECT 
    Employees.Name,
    Departments.DepartmentName,
    Employees.DepartmentID AS EmployeeDeptID,
    Departments.DepartmentID AS DepartmentDeptID
FROM 
    Employees
CROSS JOIN 
    Departments
WHERE 
    Employees.DepartmentID <> Departments.DepartmentID

-- Task 12

SELECT 
    Orders.OrderID,
    Products.ProductName,
    Orders.Quantity AS OrderedQuantity,
    Products.StockQuantity
FROM 
    Orders
INNER JOIN 
    Products 
ON 
    Orders.ProductID = Products.ProductID
WHERE 
    Orders.Quantity > Products.StockQuantity

-- Task 13

SELECT 
    Customers.FirstName + ' ' + LastName FullName,
    Sales.ProductID,
    Sales.SaleAmount
FROM 
    Customers
INNER JOIN 
    Sales
ON 
    Customers.CustomerID = Sales.CustomerID
WHERE 
    Sales.SaleAmount >= 500

-- Task 14

select
	Students.Name,
	Courses.CourseName
from
	Enrollments e
INNER JOIN Students ON e.StudentID = Students.StudentID
INNER JOIN Courses ON e.CourseID = Courses.CourseID
	
-- Task 15

select
	Suppliers.SupplierName,
	Products.ProductName
from
	Suppliers
join 
	Products
on
	Products.SupplierID = Suppliers.SupplierID
where
	SupplierName like '%Tech%'

-- Task 16

SELECT 
    Orders.OrderID,
    Orders.TotalAmount,
    Payments.Amount AS PaymentAmount
FROM 
    Orders
INNER JOIN 
    Payments 
ON 
    Orders.OrderID = Payments.OrderID
WHERE 
    Payments.Amount < Orders.TotalAmount

-- Task 17

SELECT 
    Employees.Name,
    Departments.DepartmentName
FROM 
    Employees
INNER JOIN 
    Departments 
ON 
    Employees.DepartmentID = Departments.DepartmentID

-- Task 18

SELECT 
    Products.ProductName,
    Categories.CategoryName
FROM 
    Products
INNER JOIN 
    Categories 
ON 
    Products.Category = Categories.CategoryID
WHERE 
    Categories.CategoryName IN ('Electronics', 'Furniture')

-- Task 19

SELECT 
    Sales.SaleID,
    Sales.ProductID,
    Sales.SaleAmount,
    Customers.FirstName + ' ' + LastName FullName,
    Customers.Country
FROM 
    Sales
INNER JOIN 
    Customers 
ON 
    Sales.CustomerID = Customers.CustomerID
WHERE 
    Customers.Country = 'USA'

-- Task 20

SELECT 
    Orders.OrderID,
    Customers.FirstName + ' ' + LastName FullName,
    Customers.Country,
    Orders.TotalAmount
FROM 
    Orders
INNER JOIN 
    Customers 
ON 
    Orders.CustomerID = Customers.CustomerID
WHERE 
    Customers.Country = 'Germany'
    AND Orders.TotalAmount > 100

-- Hard Level

-- Task 21

SELECT 
    e1.Name AS Employee1,
    e2.Name AS Employee2,
    e1.DepartmentID AS Dept1,
    e2.DepartmentID AS Dept2
FROM 
    Employees e1
JOIN 
    Employees e2 
ON 
    e1.DepartmentID <> e2.DepartmentID
    AND e1.EmployeeID < e2.EmployeeID

-- Task 22

SELECT 
    Payments.PaymentID,
    Payments.OrderID,
    Payments.Amount AS PaidAmount,
    Orders.Quantity,
    Products.Price,
    (Orders.Quantity * Products.Price) AS ExpectedAmount
FROM 
    Payments
INNER JOIN 
    Orders ON Payments.OrderID = Orders.OrderID
INNER JOIN 
    Products ON Orders.ProductID = Products.ProductID
WHERE 
    Payments.Amount <> Orders.Quantity * Products.Price

-- Task 23

SELECT 
    Students.StudentID,
    Students.Name
FROM 
    Students
LEFT JOIN 
    Enrollments 
ON 
    Students.StudentID = Enrollments.StudentID
WHERE 
    Enrollments.StudentID IS NULL

-- Task 24

SELECT 
    e1.EmployeeID AS ManagerID,
    e1.Name AS ManagerName,
    e1.Salary AS ManagerSalary,
    e2.EmployeeID AS EmployeeID,
    e2.Name AS EmployeeName,
    e2.Salary AS EmployeeSalary
FROM 
    Employees e1
JOIN 
    Employees e2 
ON 
    e1.EmployeeID = e2.ManagerID
WHERE 
    e1.Salary <= e2.Salary

-- Task 25

SELECT 
    Customers.CustomerID,
    Customers.FirstName,
    Orders.OrderID
FROM 
    Orders
INNER JOIN 
    Customers ON Orders.CustomerID = Customers.CustomerID
LEFT JOIN 
    Payments ON Orders.OrderID = Payments.OrderID
WHERE 
    Payments.OrderID IS NULL
