--Homework. Lesson 22
CREATE TABLE sales_data (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    customer_name VARCHAR(100),
    product_category VARCHAR(50),
    product_name VARCHAR(100),
    quantity_sold INT,
    unit_price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

INSERT INTO sales_data VALUES
    (1, 101, 'Alice', 'Electronics', 'Laptop', 1, 1200.00, 1200.00, '2024-01-01', 'North'),
    (2, 102, 'Bob', 'Electronics', 'Phone', 2, 600.00, 1200.00, '2024-01-02', 'South'),
    (3, 103, 'Charlie', 'Clothing', 'T-Shirt', 5, 20.00, 100.00, '2024-01-03', 'East'),
    (4, 104, 'David', 'Furniture', 'Table', 1, 250.00, 250.00, '2024-01-04', 'West'),
    (5, 105, 'Eve', 'Electronics', 'Tablet', 1, 300.00, 300.00, '2024-01-05', 'North'),
    (6, 106, 'Frank', 'Clothing', 'Jacket', 2, 80.00, 160.00, '2024-01-06', 'South'),
    (7, 107, 'Grace', 'Electronics', 'Headphones', 3, 50.00, 150.00, '2024-01-07', 'East'),
    (8, 108, 'Hank', 'Furniture', 'Chair', 4, 75.00, 300.00, '2024-01-08', 'West'),
    (9, 109, 'Ivy', 'Clothing', 'Jeans', 1, 40.00, 40.00, '2024-01-09', 'North'),
    (10, 110, 'Jack', 'Electronics', 'Laptop', 2, 1200.00, 2400.00, '2024-01-10', 'South'),
    (11, 101, 'Alice', 'Electronics', 'Phone', 1, 600.00, 600.00, '2024-01-11', 'North'),
    (12, 102, 'Bob', 'Furniture', 'Sofa', 1, 500.00, 500.00, '2024-01-12', 'South'),
    (13, 103, 'Charlie', 'Electronics', 'Camera', 1, 400.00, 400.00, '2024-01-13', 'East'),
    (14, 104, 'David', 'Clothing', 'Sweater', 2, 60.00, 120.00, '2024-01-14', 'West'),
    (15, 105, 'Eve', 'Furniture', 'Bed', 1, 800.00, 800.00, '2024-01-15', 'North'),
    (16, 106, 'Frank', 'Electronics', 'Monitor', 1, 200.00, 200.00, '2024-01-16', 'South'),
    (17, 107, 'Grace', 'Clothing', 'Scarf', 3, 25.00, 75.00, '2024-01-17', 'East'),
    (18, 108, 'Hank', 'Furniture', 'Desk', 1, 350.00, 350.00, '2024-01-18', 'West'),
    (19, 109, 'Ivy', 'Electronics', 'Speaker', 2, 100.00, 200.00, '2024-01-19', 'North'),
    (20, 110, 'Jack', 'Clothing', 'Shoes', 1, 90.00, 90.00, '2024-01-20', 'South'),
    (21, 111, 'Kevin', 'Electronics', 'Mouse', 3, 25.00, 75.00, '2024-01-21', 'East'),
    (22, 112, 'Laura', 'Furniture', 'Couch', 1, 700.00, 700.00, '2024-01-22', 'West'),
    (23, 113, 'Mike', 'Clothing', 'Hat', 4, 15.00, 60.00, '2024-01-23', 'North'),
    (24, 114, 'Nancy', 'Electronics', 'Smartwatch', 1, 250.00, 250.00, '2024-01-24', 'South'),
    (25, 115, 'Oscar', 'Furniture', 'Wardrobe', 1, 1000.00, 1000.00, '2024-01-25', 'East')

--Easy Questions
--1)Compute Running Total Sales per Customer

SELECT *,
SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM sales_data
--------------------------------------------------------------------------------------------
--2)Count the Number of Orders per Product Category

SELECT *, 
COUNT(*) OVER(PARTITION BY product_category) AS num_of_orders
FROM sales_data
--------------------------------------------------------------------------------------------
--3)Find the Maximum Total Amount per Product Category

SELECT *,
MAX(total_amount) OVER(PARTITION BY product_category) AS max_amount_per_category
FROM sales_data
--------------------------------------------------------------------------------------------
--4)Find the Minimum Price of Products per Product Category

SELECT *,
MIN(total_amount) OVER(PARTITION BY product_category) AS min_amount_per_category
FROM sales_data
--------------------------------------------------------------------------------------------
--5)Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)

SELECT *,
AVG(total_amount) OVER(ORDER BY order_date ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS avg_3days
FROM sales_data
----------------------------------------------------------------------------------------------------
--6)Find the Total Sales per Region

SELECT *,
SUM(total_amount) OVER(PARTITION BY region) AS tot_sales_per_region
FROM sales_data
----------------------------------------------------------------------------------------------------
--7)Compute the Rank of Customers Based on Their Total Purchase Amount

;WITH cte AS(
	SELECT *,
	SUM(total_amount) OVER(PARTITION BY customer_id) AS tot_sales_per_customer
	FROM sales_data)
SELECT *,
DENSE_RANK() OVER(ORDER BY tot_sales_per_customer DESC) AS rnk_cust
FROM cte
--------------------------------------------------------------------------------------------------------------
--8)Calculate the Difference Between Current and Previous Sale Amount per Customer

;WITH cte AS(
	SELECT *,
	LAG(total_amount,1,0) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_sale
	FROM sales_data)
SELECT *,
total_amount - previous_sale AS [difference]
FROM cte
-------------------------------------------------------------------------------------------------------------
--9)Find the Top 3 Most Expensive Products in Each Category

;WITH cte AS(
	SELECT *,
	RANK() OVER(PARTITION BY product_category ORDER BY total_amount DESC) AS rnk
	FROM sales_data)
SELECT * FROM cte
WHERE rnk <=3
-------------------------------------------------------------------------------------------------------------
--10)Compute the Cumulative Sum of Sales Per Region by Order Date

SELECT *,
SUM(total_amount) OVER(PARTITION BY region ORDER BY order_date) AS cum_sum
FROM sales_data
-------------------------------------------------------------------------------------------------------------
--Medium Questions
--11)Compute Cumulative Revenue per Product Category

SELECT *,
SUM(total_amount) OVER(PARTITION BY product_category ORDER BY order_date) AS cum_revenue
FROM sales_data
------------------------------------------------------------------------------------------------
--12)Here you need to find out the sum of previous values. Please go through the sample input and expected output.

SELECT *,
SUM(ID) OVER(ORDER BY id) AS SumPreValues
FROM sample_input
-----------------------------------------------------------------------------
--13)Sum of Previous Values to Current Value

;WITH cte AS (
	SELECT *,
	LAG([Value],1,0) OVER(ORDER BY [Value]) AS [previous]
	FROM OneColumn)
SELECT
	[Value],
	[Value] + previous AS [Sum of previous]
FROM cte
-----------------------------------------------------------------------------------------------------
--14)Find customers who have purchased items from more than one product_category

;WITH unique_cust AS (
    SELECT DISTINCT customer_id, product_category
    FROM sales_data
),
cust_more_2 AS (
    SELECT 
        customer_id,
        COUNT(*) OVER (PARTITION BY customer_id) AS tot_category
    FROM unique_cust
)
SELECT DISTINCT customer_id
FROM cust_more_2
WHERE tot_category > 1

---------------------------------------------------------------------------------------------
--15)Find Customers with Above-Average Spending in Their Region

;WITH cte AS (
	SELECT *,
	AVG(total_amount) OVER(PARTITION BY region) AS avg_by_region,
	SUM(total_amount) OVER(PARTITION BY customer_id) AS cust_spending
	FROM sales_data)
SELECT DISTINCT
	customer_id,
	customer_name,
	region
FROM cte
WHERE cust_spending > avg_by_region
ORDER BY region
-------------------------------------------------------------------------------------------------
/*16)Rank customers based on their total spending (total_amount) within each region. 
If multiple customers have the same spending, they should receive the same rank.*/

;WITH cte AS(
	SELECT *,
	SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY region) AS tot_amount
	FROM sales_data)
SELECT *,
	RANK() OVER(PARTITION BY region ORDER BY tot_amount) AS ranking
FROM cte
-------------------------------------------------------------------------------------------------
--17)Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

SELECT *,
SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS cumulative_sales
FROM sales_data
--------------------------------------------------------------------------------------------------
--18)Calculate the sales growth rate (growth_rate) for each month compared to the previous month.

;WITH monthly_sales AS (
    SELECT
        DATEADD(MONTH,0, order_date) AS sale_month,
        SUM(total_amount) AS monthly_total
    FROM sales_data
    GROUP BY DATEADD(MONTH,0, order_date) 
),
with_growth AS (
    SELECT
        sale_month,
        monthly_total,
        LAG(monthly_total) OVER (ORDER BY sale_month) AS prev_month_total
    FROM monthly_sales
)
SELECT
    sale_month,
    monthly_total,
    100 * (monthly_total - prev_month_total) / NULLIF(prev_month_total, 0)
    AS growth_rate_percent
FROM with_growth;
---------------------------------------------------------------------------------------------------
--19)Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)

;WITH cte AS(
	SELECT *,
	LAG(total_amount) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_total_amount
	FROM sales_data)
SELECT * FROM cte
WHERE total_amount>previous_total_amount
-----------------------------------------------------------------------------------------------------------
--Hard Questions
--20)Identify Products that prices are above the average product price

;WITH cte AS(
	SELECT *,
	AVG(unit_price) OVER() AS avg_price
	FROM sales_data)
SELECT * FROM cte
WHERE unit_price > avg_price
-------------------------------------------------------------------------------------------------
/*21)In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning
of the group in the new column. The challenge here is to do this in a single select. For more details please 
see the sample input and expected output.*/

SELECT *,
CASE
	WHEN Id=FIRST_VALUE(Id) OVER(PARTITION BY Grp ORDER BY Id) THEN SUM(Val1) OVER(PARTITION BY Grp) + SUM(Val2) OVER(PARTITION BY Grp)
	ELSE NULL
END AS Tot
FROM MyData
-----------------------------------------------------------------------------------------------------------------
/*22)Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are 
different then we have to add those values.Please go through the sample input and expected output for details.*/

CREATE TABLE TheSumPuzzle (
    ID INT, Cost INT, Quantity INT
);
INSERT INTO TheSumPuzzle VALUES
(1234,12,164), (1234,13,164), (1235,100,130), (1235,100,135), (1236,12,136);

SELECT * FROM TheSumPuzzle
----------------------------------------------------------------------------------------------------
--23)From following set of integers, write an SQL statement to determine the expected outputs
CREATE TABLE Seats 
( 
SeatNumber INTEGER 
); 

INSERT INTO Seats VALUES 
(7),(13),(14),(15),(27),(28),(29),(30), 
(31),(32),(33),(34),(35),(52),(53),(54); 

;WITH cte AS(
	SELECT 
		SeatNumber,
		(SeatNumber - ROW_NUMBER() OVER(ORDER BY SeatNumber)) AS grp
	FROM Seats
)
SELECT
	SeatNumber,
	MIN(SeatNumber) OVER(PARTITION BY grp),
	MAX(SeatNumber) OVER(PARTITION BY grp)
FROM cte
-----------------------------------------------------------------------------------------------------------