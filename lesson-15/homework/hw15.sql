-- Level 1: Basic Subqueries

-- Task 1

SELECT *
FROM Employees
WHERE Salary = (SELECT MIN(Salary) FROM Employees)

-- Task 2

SELECT *
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)

-- Level 2: Nested Subqueries with Conditions

-- Task 3

SELECT *
FROM employees
WHERE department_id IN (
    SELECT id
    FROM departments
    WHERE department_name IN (
        SELECT department_name
        FROM departments
        WHERE department_name = 'Sales'
    )
)

-- Task 4

SELECT *
FROM customers
WHERE customer_id NOT IN (
    SELECT customer_id
    FROM orders
    WHERE customer_id IS NOT NULL
)

-- Level 3: Aggregation and Grouping in Subqueries

-- Task 5

SELECT *
FROM products p
WHERE price = (
    SELECT MAX(price)
    FROM products
    WHERE category_id = p.category_id
)

-- Task 6

SELECT *
FROM employees
WHERE department_id = (
    SELECT TOP 1 department_id
    FROM employees
    GROUP BY department_id
    ORDER BY AVG(salary) DESC
)

-- Level 4: Correlated Subqueries

-- Task 7

SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
    WHERE department_id = e.department_id
)

-- Task 8

SELECT *
FROM grades g
WHERE grade = (
    SELECT MAX(grade)
    FROM grades
    WHERE course_id = g.course_id
)

-- Level 5: Subqueries with Ranking and Complex Conditions

-- Task 9

SELECT *
FROM products p
WHERE price = (
    SELECT DISTINCT price
    FROM products
    WHERE category_id = p.category_id
    ORDER BY price DESC
    OFFSET 2 ROWS FETCH NEXT 1 ROW ONLY
)

-- Task 10

SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
)
AND salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = e.department_id
)
