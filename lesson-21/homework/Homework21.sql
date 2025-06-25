--Homework. Lesson 21
--1)Write a query to assign a row number to each sale based on the SaleDate.

SELECT *,
ROW_NUMBER() OVER(ORDER BY SaleDate) AS row_num
FROM ProductSales
-----------------------------------------------------------------------------------------------------------------
--2)Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.

;WITH cte AS(
SELECT ProductName,
SUM(Quantity) AS Total_Quantity
FROM ProductSales
GROUP BY ProductName
)
SELECT *,
DENSE_RANK() OVER(ORDER BY Total_Quantity DESC) AS Ranking
FROM cte
------------------------------------------------------------------------------------------------------------------
--3)Write a query to identify the top sale for each customer based on the SaleAmount.

;WITH cte AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS sales_each_cust
FROM ProductSales)
SELECT * FROM cte
WHERE sales_each_cust = 1
---------------------------------------------------------------------------------------------------------------
--4)Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.

SELECT *,
LEAD(SaleAmount) OVER(ORDER BY SaleDate) AS next_sale_amount
FROM ProductSales
---------------------------------------------------------------------------------------------------------------
--5)Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

SELECT *,
LAG(SaleAmount) OVER(ORDER BY SaleDate) AS previous_sale_amount
FROM ProductSales
---------------------------------------------------------------------------------------------------------------
--6)Write a query to identify sales amounts that are greater than the previous sale's amount

;WITH cte AS (
SELECT *,
LAG(SaleAmount) OVER(ORDER BY SaleDate) AS previous_sale_amount
FROM ProductSales )
SELECT * FROM cte
WHERE SaleAmount > previous_sale_amount
----------------------------------------------------------------------------------------------------------------
--7)Write a query to calculate the difference in sale amount from the previous sale for every product

;WITH cte AS (
SELECT *,
LAG(SaleAmount) OVER(PARTITION BY ProductName ORDER BY SaleDate) AS previous_sale_amount
FROM ProductSales)
SELECT *,
(SaleAmount - ISNULL(previous_sale_amount,0)) AS [difference]
FROM cte
-----------------------------------------------------------------------------------------------------------------
--8)Write a query to compare the current sale amount with the next sale amount in terms of percentage change.

;WITH cte AS (
SELECT *,
LEAD(SaleAmount) OVER(ORDER BY SaleDate) AS next_sale_amount
FROM ProductSales)
SELECT *,
CAST(ISNULL(next_sale_amount,0)*100/SaleAmount AS DECIMAL(10,2)) AS [difference]
FROM cte
-----------------------------------------------------------------------------------------------------------------
--9)Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.

;WITH cte AS(
SELECT *,
LAG(SaleAmount) OVER(PARTITION BY ProductName ORDER BY SaleDate) AS previous_sale_amount
FROM ProductSales)
SELECT *,
CAST(SaleAmount/previous_sale_amount AS DECIMAL(10,3)) AS ratio
FROM cte
------------------------------------------------------------------------------------------------------------------
--10)Write a query to calculate the difference in sale amount from the very first sale of that product.

;WITH cte AS (
SELECT *,
FIRST_VALUE(SaleAmount) OVER(PARTITION BY ProductName ORDER BY SaleDate) AS first_sale
FROM ProductSales)
SELECT *,
(SaleAmount - first_sale) AS [difference]
FROM cte
-----------------------------------------------------------------------------------------------------------------
/*11)Write a query to find sales that have been increasing continuously for a product 
(i.e., each sale amount is greater than the previous sale amount for that product).*/

;WITH cte AS
(SELECT *,
LAG(SaleAmount) OVER(PARTITION BY ProductName ORDER BY SaleDate) AS previous_amount 
FROM ProductSales)
SELECT *
FROM cte
WHERE SaleAmount > previous_amount
------------------------------------------------------------------------------------------------------------------
/*12)Write a query to calculate a "closing balance"(running total) for sales amounts which adds 
the current sale amount to a running total of previous sales.*/

SELECT *,
SUM(SaleAmount) OVER(PARTITION BY ProductName ORDER BY SaleDate) AS running_total
FROM ProductSales
------------------------------------------------------------------------------------------------------------------
--13)Write a query to calculate the moving average of sales amounts over the last 3 sales.

SELECT *,
AVG(SaleAmount) OVER(ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS avg_3_amt
FROM ProductSales
------------------------------------------------------------------------------------------------------------------
--14)Write a query to show the difference between each sale amount and the average sale amount.

;WITH cte AS (
SELECT *,
AVG(SaleAmount) OVER() AS avg_sale
FROM ProductSales
)
SELECT *,
(SaleAmount - avg_sale) AS [difference]
FROM cte
------------------------------------------------------------------------------------------------------------------
--15)Find Employees Who Have the Same Salary Rank

;WITH cte AS (
SELECT *,
DENSE_RANK() OVER(ORDER BY salary desc) AS ranking
FROM Employees1
)
SELECT * FROM cte
WHERE ranking>=2
-----------------------------------------------------------------------------------------------------------------
--16)Identify the Top 2 Highest Salaries in Each Department

;WITH cte AS (
SELECT *,
DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) AS ranking
FROM Employees1)
SELECT  * FROM cte
WHERE ranking <= 2
------------------------------------------------------------------------------------------------------------------
--17)Find the Lowest-Paid Employee in Each Department

SELECT *,
LAST_VALUE(Salary) OVER(PARTITION BY Department ORDER BY Salary DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest_paid_salary
FROM Employees1
------------------------------------------------------------------------------------------------------------------
--18)Calculate the Running Total of Salaries in Each Department

SELECT *,
SUM(Salary) OVER(PARTITION BY Department ORDER BY Salary DESC) AS running_total
FROM Employees1
------------------------------------------------------------------------------------------------------------------
--19)Find the Total Salary of Each Department Without GROUP BY

SELECT *,
SUM(Salary) OVER(PARTITION BY Department) AS tot_salary_each_dept
FROM Employees1
------------------------------------------------------------------------------------------------------------------
--20)Calculate the Average Salary in Each Department Without GROUP BY

SELECT *,
AVG(Salary) OVER(PARTITION BY Department) AS avg_salary_each_dept
FROM Employees1
------------------------------------------------------------------------------------------------------------------
--21)Find the Difference Between an Employee’s Salary and Their Department’s Average

;WITH cte AS (
SELECT *,
AVG(Salary) OVER(PARTITION BY Department) AS avg_salary_each_dept
FROM Employees1
)
SELECT *,
(Salary - avg_salary_each_dept) AS [difference]
FROM cte
-------------------------------------------------------------------------------------------------------------------
--22)Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)

SELECT *, 
AVG(Salary) OVER(ORDER BY Salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS moving_avg_salary
FROM Employees1
------------------------------------------------------------------------------------------------------------------
--23)Find the Sum of Salaries for the Last 3 Hired Employees

SELECT *, 
SUM(Salary) OVER(ORDER BY HireDate DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS sum_3_emp_salary
FROM Employees1