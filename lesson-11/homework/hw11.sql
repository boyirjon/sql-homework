-- Easy-Level Tasks

-- Task 1

select
	o.OrderID,
	c.FirstName + ' ' + LastName as FullName,
	o.OrderDate
from
	Orders o
join
	Customers c
on
	o.CustomerID = c.CustomerID
where
	o.OrderDate > '2022-12-31'

-- Task 2

select
	e.Name,
	d.DepartmentName 
from
	Employees e
join
	Departments d
on
	e.DepartmentID  = d.DepartmentID 
where
	d.DepartmentName in ('Sales', 'Marketing') 

-- Task 3

select
	d.DepartmentName,
	MAX(e.Salary) AS MaxSalary
from
	Departments d
join
	Employees e
on
	e.DepartmentID  = d.DepartmentID 
group by
	d.DepartmentName

-- Task 4

select
	c.FirstName + ' ' + LastName as FullName,
	o.OrderID,
	o.OrderDate
from 
	Customers c
join
	Orders o
on 
	c.CustomerID = o.CustomerID
where
	c.Country = 'USA' and YEAR(o.OrderDate) = 2023

-- Task 5

select
	c.FirstName + ' ' + LastName as FullName,
	COUNT(o.OrderID) as TotalAmount
from
	Customers c
join
	Orders o
on
	c.CustomerID = o.CustomerID
group by
	c.FirstName + ' ' + LastName

-- Task 6

select
	p.ProductName,
	s.SupplierName
from
	Products p
join
	Suppliers s
on
	p.SupplierID = s.SupplierID
where
	s.SupplierName in ('SupplierName', 'Clothing Mart')

-- Task 7

select
	c.FirstName + ' ' + LastName as FullName,
	MAX(o.OrderDate) as MostRecentOrderDate 
from
	Customers c
left join
	Orders o
on
	c.CustomerID = o.CustomerID
group by
	c.FirstName + ' ' + LastName

-- Medium-Level Tasks 

-- Task 8

select
	c.FirstName + ' ' + LastName as FullName,
	o.TotalAmount
from
	Customers c
join
	Orders o
on 
	c.CustomerID = o.CustomerID
where
	o.TotalAmount > 500

-- Task 9

select
	p.ProductName,
	s.SaleDate,
	s.SaleAmount
from
	Products p
join
	Sales s
on
	p.ProductID = s.ProductID
where
	year(s.SaleDate) = 2022 or s.SaleAmount > 400

-- Task 10

select
	p.ProductName,
	sum(s.SaleAmount) as TotalSalesAmount
from
	Products p
join
	Sales s
on
	p.ProductID = s.ProductID
group by
	p.ProductName

-- Task 11

select
	e.Name,
	d.DepartmentName,
	e.Salary
from
	Employees e
join
	Departments d
on
	e.DepartmentID = d.DepartmentID
where
	d.DepartmentName = 'HR' and e.salary > 60000

-- Task 12

select
	p.ProductName,
	s.SaleDate,
	p.StockQuantity
from
	Products p
join
	Sales s
on
	p.ProductID = s.ProductID
where
	year(s.SaleDate) = 2023 and p.StockQuantity > 100

-- Task 13

select
	e.Name,
	d.DepartmentName,
	e.Hiredate
from
	Employees e
join
	Departments d
on
	e.DepartmentID = d.DepartmentID
where
	d.DepartmentName = 'Sales' or HireDate > '2020-12-31'

-- Hard-Level Tasks

-- Task 14

select
	c.FirstName + ' ' + LastName as FullName,
	o.OrderID,
	c.Address,
	o.OrderDate
from
	Customers c
join
	Orders o
on
	c.CustomerID = o.CustomerID
where
	c.Country = 'USA' and c.Address like '[0-9][0-9][0-9][0-9]%' 

-- Task 15

select
	p.ProductName,
	p.Category,
	s.SaleAmount
from
	Products p
join
	Sales s
on
	p.ProductID = s.ProductID
where
	p.Category in 'Electronics' or s.SaleAmount > 350

-- Task 16

select
	c.CategoryName,
	count(p.ProductID) as ProductCount
from
	Categories c
join
	Products p
on
	p.Category = c.CategoryID
group by
	c.CategoryName

-- Task 17

select
	c.FirstName + ' ' + LastName as FullName,
	c.City,
	o.OrderID,
	o.TotalAmount
from
	Customers c
join
	Orders o
on
	c.CustomerID = o.CustomerID
where
	c.City = 'Los Angeles' and o.TotalAmount > 300

-- Task 18

select
	e.Name,
	d.DepartmentName
from
	Employees e
join
	Departments d
on
	e.DepartmentID = d.DepartmentID
where
	d.DepartmentName in ('HR', 'Finance') 
	    OR (
        LEN(Name) 
        - LEN(REPLACE(LOWER(Name), 'a', ''))
        + LEN(Name) - LEN(REPLACE(LOWER(Name), 'e', ''))
        + LEN(Name) - LEN(REPLACE(LOWER(Name), 'i', ''))
        + LEN(Name) - LEN(REPLACE(LOWER(Name), 'o', ''))
        + LEN(Name) - LEN(REPLACE(LOWER(Name), 'u', ''))
    ) >= 4

-- Task 19

SELECT 
    Employees.Name,
    Departments.DepartmentName,
    Employees.Salary
FROM 
    Employees
JOIN 
    Departments ON Employees.DepartmentID = Departments.DepartmentID
WHERE 
    Departments.DepartmentName IN ('Sales', 'Marketing')
    AND Employees.Salary > 60000
