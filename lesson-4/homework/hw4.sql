create table employees (empolyee_id int primary key, full_name varchar(50), position varchar(50), salary decimal(10,2), department_id int)

INSERT INTO employees (empolyee_id, full_name, position, salary, department_id) VALUES
(1, 'Ali Karimov', 'Dasturchi', 8000.00, 1),
(2, 'Dilnoza Ismoilova', 'Grafik Dizayner', 6000.00, 2),
(3, 'Javohir Toshpulatov', 'Sotuv Menejeri', 7000.00, 3),
(4, 'Aziza Rashidova', 'HR Mutaxassisi', 6500.00, 4),
(5, 'Shahzod Sobirov', 'Tizim Administrator', 7500.00, 1),
(6, 'Gulbahor Saidova', 'Marketing Mutaxassisi', 6200.00, 3),
(7, 'Zafar Mirzayev', 'Bosh Hisobchi', 9000.00, 2),
(8, 'Nilufar Mamatova', 'Loyiha Rahbari', 9500.00, 1),
(9, 'Bobur Alimov', 'Yordamchi Muhandis', 5800.00, 4),
(10, 'Madina Ergasheva', 'Kontent Menedjer', 6100.00, 3)

select * from Employees

select top 5 * from Employees



CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
);
go
INSERT INTO products (product_id, product_name, price) VALUES
(1, 'Smartfon Samsung Galaxy A54', 350.00),
(2, 'Erkaklar futbolkasi', 25.00),
(3, 'Lego Classic to‘plami', 40.00),
(4, 'Changyutkich LG', 120.00),
(5, 'Basketbol to‘pi', 30.00),
(6, 'Motivatsion kitob - “Sening kuching”', 15.00),
(7, 'Tonal krem L’Oreal', 22.00),
(8, 'Makaron (500g)', 2.00),
(9, 'Yotoqxona karovati', 300.00),
(10, 'Avtomobil akkumulyatori', 95.00);

select distinct category_id from products

select * from products

select * from products
where price > 100

SELECT product_name, price
FROM Products
WHERE Price > 100



CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    city VARCHAR(50)
);

INSERT INTO customers (customer_id, first_name, last_name, email, phone, city) VALUES
(1, 'Alisher', 'Karimov', 'alisher.karimov@gmail.com', '+998901234567', 'Toshkent'),
(2, 'Aziza', 'Islomova', 'aziza.islomova@mail.ru', '+998933456789', 'Andijon'),
(3, 'Bobur', 'Qodirov', 'bobur.qodirov@yahoo.com', '+998912223344', 'Farg‘ona'),
(4, 'Dilshod', 'Raxmatov', 'dilshod.r@gmail.com', '+998907654321', 'Samarqand'),
(5, 'Gulbahor', 'To‘raeva', 'gulbahor.t@example.com', '+998936789012', 'Namangan'),
(6, 'Anvar', 'Aliyev', 'anvar.aliyev@gmail.com', '+998909998877', 'Buxoro'),
(7, 'Malika', 'Nazarova', 'malika.nazarova@mail.com', '+998934567890', 'Xorazm'),
(8, 'Shahzod', 'Ergashev', 'shahzod.e@hotmail.com', '+998935551122', 'Navoiy'),
(9, 'Aminaxon', 'Yusupova', 'aminaxon.yusupova@gmail.com', '+998939991111', 'Toshkent'),
(10, 'Temur', 'Muminov', 'temur.muminov@mail.uz', '+998938888777', 'Qarshi');

select * from Customers
where first_name like 'A%'

SELECT *
FROM customers
WHERE LOWER(first_name) LIKE 'a%';

select * from products
order by price asc

select * from Employees
where salary >= 6000
and department = 'HR'

select ISNULL (email, 'noemail@example.com') as email from Employees

SELECT *
FROM Products
WHERE Price BETWEEN 50 AND 100;

select distinct category, product_name from products

select distinct category, product_name
from products
order by product_name desc



select top 10 * from products
order by price desc

SELECT COALESCE(first_name, last_name) AS FullName
FROM Employees

select distinct category, price from products

select * from Employees
where (age between 30 and 40)
OR Department = 'Marketing'

select * from Employees
order by salary desc
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY

SELECT *
FROM Products
WHERE Price <= 1000
  AND Stock > 50
ORDER BY Stock ASC

select * from products
where product_name like '%e%'

select * from Employees
where department in ('HR', 'IT', 'Finance')

SELECT *
FROM customers
ORDER BY City ASC, PostalCode DESC

select top 5 * from products
order by sales_amount desc

SELECT FirstName + ' ' + LastName AS FullName
FROM Employees

SELECT DISTINCT Category, Product_name, Price
FROM Products
WHERE Price > 50

SELECT *
FROM Products
WHERE Price < (SELECT AVG(Price) * 0.10 FROM Products)

SELECT *
FROM Employees
WHERE Age < 30
  AND Department IN ('HR', 'IT')

SELECT *
FROM customers
WHERE Email LIKE '%@gmail.com'

SELECT *
FROM Employees
WHERE Salary > ALL (
    SELECT Salary
    FROM Employees
    WHERE Department = 'Sales'
)

SELECT *
FROM Orders
WHERE LATEST_DATE BETWEEN DATEADD(DAY, -180, GETDATE()) AND GETDATE()
