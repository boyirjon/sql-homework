-- Task 1

SELECT 
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM sales_data
ORDER BY customer_id, order_date, sale_id

-- Task 2

SELECT 
    product_category,
    COUNT(*) AS order_count
FROM sales_data
GROUP BY product_category
ORDER BY order_count DESC

-- Task 3

SELECT 
    product_category,
    MAX(total_amount) AS max_total_amount
FROM sales_data
GROUP BY product_category
ORDER BY max_total_amount DESC

-- Task 4

SELECT 
    product_category,
    MIN(unit_price) AS min_price
FROM sales_data
GROUP BY product_category
ORDER BY min_price ASC

-- Task 5

SELECT 
    order_date,
    total_amount,
    AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_3days
FROM sales_data
ORDER BY order_date

-- Task 6

SELECT 
    region,
    SUM(total_amount) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC

-- Task 7

SELECT 
    customer_id,
    customer_name,
    SUM(total_amount) AS total_purchase,
    RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank_position
FROM sales_data
GROUP BY customer_id, customer_name
ORDER BY rank_position

-- Task 8

SELECT 
    sale_id,
    customer_id,
    customer_name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date, sale_id
    ) AS prev_amount,
    total_amount - COALESCE(
        LAG(total_amount) OVER (
            PARTITION BY customer_id 
            ORDER BY order_date, sale_id
        ), 0
    ) AS diff_from_prev
FROM sales_data
ORDER BY customer_id, order_date, sale_id

-- Task 9

SELECT 
    product_category,
    product_name,
    unit_price,
    customer_name,
    order_date
FROM (
    SELECT 
        product_category,
        product_name,
        unit_price,
        customer_name,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY product_category 
            ORDER BY unit_price DESC
        ) AS rn
    FROM sales_data
) t
WHERE rn <= 3
ORDER BY product_category, unit_price DESC

-- Task 10

SELECT 
    region,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY region
        ORDER BY order_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM sales_data
ORDER BY region, order_date, sale_id

-- Task 11

SELECT 
    product_category,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date, sale_id
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM sales_data
ORDER BY product_category, order_date, sale_id

-- Task 12

SELECT 
    ID,
    SUM(ID) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SumPreValues
FROM SampleTable

-- Task 13

SELECT 
    Value,
    SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
        AS [Sum of Previous]
FROM OneColumn

-- Task 14

SELECT 
    customer_id
FROM Orders
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category) > 1

-- Task 15

SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    SUM(od.quantity * od.unit_price) AS total_spending
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
JOIN OrderDetails od 
    ON o.order_id = od.order_id
JOIN Products p 
    ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.region
HAVING SUM(od.quantity * od.unit_price) >
(
    SELECT AVG(region_spending) 
    FROM (
        SELECT c2.region, c2.customer_id, 
               SUM(od2.quantity * od2.unit_price) AS region_spending
        FROM Customers c2
        JOIN Orders o2 
            ON c2.customer_id = o2.customer_id
        JOIN OrderDetails od2 
            ON o2.order_id = od2.order_id
        GROUP BY c2.region, c2.customer_id
    ) AS region_avg
    WHERE region_avg.region = c.region
)

-- Task 16

SELECT 
    c.customer_id,
    c.customer_name,
    c.region,
    SUM(o.total_amount) AS total_spending,
    RANK() OVER (
        PARTITION BY c.region
        ORDER BY SUM(o.total_amount) DESC
    ) AS spending_rank
FROM Customers c
JOIN Orders o 
    ON c.customer_id = o.customer_id
GROUP BY 
    c.customer_id, 
    c.customer_name, 
    c.region;

-- Task 17

SELECT 
    customer_id,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM Orders
ORDER BY customer_id, order_date;

-- Task 18

WITH monthly_sales AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS month,
        SUM(total_amount) AS monthly_sales
    FROM Sales
    GROUP BY FORMAT(order_date, 'yyyy-MM')
)
SELECT 
    month,
    monthly_sales,
    LAG(monthly_sales) OVER (ORDER BY month) AS prev_month_sales,
    ROUND(
        (CAST(monthly_sales AS FLOAT) - LAG(monthly_sales) OVER (ORDER BY month)) 
        / NULLIF(LAG(monthly_sales) OVER (ORDER BY month), 0) * 100, 2
    ) AS growth_rate
FROM monthly_sales
ORDER BY month

-- Task 19

WITH sales_with_prev AS (
    SELECT customer_id,
           order_id,
           order_date,
           total_amount,
           LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount
    FROM sales_data
)
SELECT customer_id, order_id, order_date, total_amount, prev_amount
FROM sales_with_prev
WHERE total_amount > prev_amount

-- Task 20

SELECT 
    product_id,
    product_name,
    price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products)

-- Task 21

SELECT 
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER(PARTITION BY Grp ORDER BY Id) = 1
        THEN SUM(Val1 + Val2) OVER(PARTITION BY Grp)
    END AS Tot
FROM MyData
ORDER BY Grp, Id;

-- Task 22

SELECT 
    ID,
    SUM(Cost) AS Cost,
    CASE 
        WHEN COUNT(DISTINCT Quantity) = 1 THEN MAX(Quantity)
        ELSE SUM(Quantity)
    END AS Quantity
FROM TheSumPuzzle
GROUP BY ID
ORDER BY ID

-- Task 23

WITH SeatRange AS (
    SELECT MIN(SeatNumber) AS MinSeat, MAX(SeatNumber) AS MaxSeat
    FROM Seats
),
AllNumbers AS (
    SELECT MinSeat AS Seat
    FROM SeatRange
    UNION ALL
    SELECT Seat + 1
    FROM AllNumbers, SeatRange
    WHERE Seat < MaxSeat
),
MissingSeats AS (
    SELECT Seat
    FROM AllNumbers
    WHERE Seat NOT IN (SELECT SeatNumber FROM Seats)
),
GroupedGaps AS (
    SELECT Seat, Seat - ROW_NUMBER() OVER(ORDER BY Seat) AS grp
    FROM MissingSeats
)
SELECT MIN(Seat) AS [Gap Start], MAX(Seat) AS [Gap End]
FROM GroupedGaps
GROUP BY grp
ORDER BY [Gap Start]
OPTION (MAXRECURSION 0);
