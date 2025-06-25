create database vazifa

create table employees (id int, name varchar(50), salary decimal(10,2))

INSERT INTO employees (ID, Name, Salary)
VALUES (1, 'John Smith', 50000.00)
GO
INSERT INTO Employees
VALUES (2, 'Sarah Johnson', 65000.50)
GO
INSERT INTO Employees (ID, Name, Salary)
VALUES 
    (3, 'Michael Brown', 72000.75),
    (4, 'Emily Davis', 58000.00),
    (5, 'Robert Wilson', 63000.25)

SELECT * FROM StaffMembers

SELECT Name, Salary 
FROM Employees 
WHERE ID = 1

UPDATE Employees
SET Salary = 7000
WHERE ID = 1

SELECT * FROM Employees 
WHERE ID = 2

DELETE FROM Employees
WHERE ID = 2


---DELETE, TRUNCATE va DROP Farqlari (SQL Server)
---Bu 3 buyruq ham malumotlarni ohiradi, lekin ularning ishlashi va tasiri turlicha:
---
---1. DELETE
---Vazifasi: Jadvaldagi malum qatorlarni olib tashlaydi.
---
---WHERE sharti bilan ishlaydi: Faqat kerakli qatorlarni ochirish mumkin.
---
---Transaction logga yoziladi: Har bir ochirilgan qator logga yoziladi, shuning uchun qaytarish (ROLLBACK) mumkin.
---
---Disk joyini boshatmaydi: Malumotlar indekslari va tuzilishi qoladi.
---
---Sekinroq: Katta jadvallarda samarali emas.
---
---Misol:
---DELETE FROM Employees WHERE EmpID = 2;  -- Faqat ID=2 bo'lgan xodim o'chadi

---2. TRUNCATE
---Vazifasi: Jadvaldagi BARCHA qatorlarni tozab tashlaydi.
---
---WHERE sharti bilan ISHLAMAYDI: Hammasini ochiradi.
---
---Tezroq: DELETEga qaraganda tez ishlaydi, chunki har bir qator logga yozilmaydi.
---
---Identity (Auto-increment) ni qayta boshlaydi: Agar IDENTITY ustun bolsa, 1 dan boshlanadi.
---
---Disk joyini boshatadi: Malumotlar bloklari tozalanadi.
---
---ROLLBACK qilish mumkin, lekin bazi SQL versiyalarida cheklovlar bor.
---
---Misol:
---TRUNCATE TABLE Employees;  -- Barcha xodimlar ochadi, lekin jadval qoladi

---3. DROP
---Vazifasi: Butun JADVALNI (yoki bazani) tarkibi bilan ochiradi.
---
---Malumotlar + Struktura yoqoladi: Indekslar, cheklovlar, triggerlar ham ochadi.
---
---Disk joyi tozalab tashlanadi.
---
---Qaytarib bolmaydi (Agar backup bolmasa).
---
---Jadval mavjud emas boladi.
---
---Misol:
---DROP TABLE Employees;  -- Butun Employees jadvali o'chiriladi
---
---Qaysi Birini Ishlatish Kerak?
---Bir necha qator ochirish kerak bolsa → DELETE
---
---Butun jadvalni tozalash kerak bolsa → TRUNCATE
---
---Jadval butunlay kerak bolmasa → DROP


ALTER TABLE Employees
ALTER COLUMN Name VARCHAR(100)

ALTER TABLE Employees
ADD Department VARCHAR(50)

ALTER TABLE Employees
ALTER COLUMN Salary Float

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL
)

TRUNCATE TABLE Employees

INSERT INTO Departments (DepartmentID, DepartmentName)
SELECT 1, 'Engineering' UNION ALL
SELECT 2, 'Marketing' UNION ALL
SELECT 3, 'Human Resources' UNION ALL
SELECT 4, 'Finance' UNION ALL
SELECT 5, 'Operations'

SELECT * FROM Departments

UPDATE Departments
SET Department = 'Management'
WHERE Salary > 5000

TRUNCATE TABLE Departments
DELETE FROM Departments

ALTER TABLE Employees
DROP COLUMN Department

EXEC sp_rename 'Employees', 'StaffMembers'

DROP TABLE Departments


CREATE TABLE Products (ID INT PRIMARY KEY, Name VARCHAR(30), Category VARCHAR(20), Price DECIMAL(10,2))

SELECT * FROM Inventory

ALTER TABLE Products
ADD CONSTRAINT CHK_PricePositive CHECK (Price > 0)

ALTER TABLE Products
ADD StockQuantity INT NOT NULL DEFAULT 50

EXEC sp_rename 'Products.Category', 'ProductCategory', 'COLUMN'

INSERT INTO Products (ID, Name, ProductCategory, Price)
VALUES 
    (101, 'Wireless Mouse', 'Electronics', 24.99),
    (102, 'Bluetooth Speaker', 'Electronics', 59.99),
    (103, 'Desk Lamp', 'Home Office', 34.50),
    (104, 'Notebook', 'Stationery', 5.99),
    (105, 'Coffee Mug', 'Kitchenware', 12.75)

SELECT * 
INTO Products_Backup
FROM Products

EXEC sp_rename 'Products', 'Inventory'

ALTER TABLE Inventory
ALTER COLUMN Price FLOAT

SELECT 
    IDENTITY(INT, 1000, 5) AS ProductCode,
    ProductID,
    ProductName,
    ProductCategory,
    Price,
    StockQuantity,
    LastUpdated
INTO Inventory_New
FROM Inventory

DROP TABLE Inventory

EXEC sp_rename 'Inventory_New', 'Inventory'

ALTER TABLE Inventory 
ADD CONSTRAINT PK_Inventory PRIMARY KEY (ProductID)
