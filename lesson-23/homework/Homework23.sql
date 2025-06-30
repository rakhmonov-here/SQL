--Homework. Lesson 23
/*Puzzle 1: In this puzzle you have to extract the month from the dt column and then append zero single 
digit month if any. Please check out sample input and expected output.*/

SELECT *,
FORMAT(Dt,'MM') AS MonthPrefixedWithZero
FROM Dates
------------------------------------------------------------------------------------------------------------
/*Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. 
You also have to find out the SUM of Max values of vals columns for each Id and RId. 
For more details please see the sample input and expected output.*/

;WITH cte AS(
	SELECT
		Id,
		rID,
		MAX(Vals) OVER(PARTITION BY Id) AS max_vals
	FROM MyTabel
)
SELECT DISTINCT
	COUNT(DISTINCT Id) AS distinct_ids,
	rID,
	SUM(DISTINCT max_vals) AS TotalOfMaxVals
FROM cte
GROUP BY rID
-------------------------------------------------------------------------------------------------------------
/*Puzzle 3: In this puzzle you have to get records with at least 6 characters and maximum 10 characters. 
Please see the sample input and expected output.*/

;WITH cte AS(
	SELECT 
		Id,
		Vals,
		MIN(LEN(Vals)) OVER(PARTITION BY Id) AS min_vals,
		MAX(LEN(Vals)) OVER(PARTITION BY Id) AS max_vals
	FROM TestFixLengths
)
SELECT
	Id,
	Vals
FROM cte
WHERE min_vals >= 6 AND max_vals <=10
---------------------------------------------------------------------------------------------------------------
/*Puzzle 4: In this puzzle you have to find the maximum value for each Id and then get the Item for that Id 
and Maximum value. Please check out sample input and expected output.*/

;WITH cte AS(
	SELECT 
		ID,
		Item,
		Vals,
		MAX(Vals) OVER(PARTITION BY ID) AS max_vals
	FROM TestMaximum
)
SELECT 
	ID,
	Item,
	Vals
FROM cte
WHERE Vals = max_vals
------------------------------------------------------------------------------------------------------
/*Puzzle 5: In this puzzle you have to first find the maximum value for each Id and DetailedNumber, 
and then Sum the data using Id only. Please check out sample input and expected output.*/

;WITH cte AS(
	SELECT
		DetailedNumber,
		Id,
		MAX(Vals) AS max_vals
	FROM SumOfMax
	GROUP BY DetailedNumber,Id
)
SELECT 
	Id,
	SUM(max_vals) AS SumOfMax
FROM cte
GROUP BY Id
----------------------------------------------------------------------------------------------------------------
/*In this puzzle you have to find difference between a and b column between each row and if the difference 
is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.
Please check the sample input and the expected output.*/

;WITH cte AS(
	SELECT 
		Id,
		a,
		b,
		CAST((a - b) AS VARCHAR) AS diff
	FROM TheZeroPuzzle
)
SELECT
	Id,
	a,
	b,
	CASE 
		WHEN diff = '0' THEN ''
		ELSE diff
	END AS [OUTPUT]
FROM cte
----------------------------------------------------------------------------------------------------------------
--7)What is the total revenue generated from all sales?
SELECT 
	SUM(QuantitySold * UnitPrice) AS tot_revenue
FROM Sales
-------------------------------------------------------------------------------------
--8)What is the average unit price of products?
SELECT
	AVG(UnitPrice) AS avg_prc
FROM Sales
-------------------------------------------------------------------------------------
--9)How many sales transactions were recorded?
SELECT
	COUNT(*) AS tot_transactions
FROM Sales
-------------------------------------------------------------------------------------
--10)What is the highest number of units sold in a single transaction?
SELECT 
	MAX(QuantitySold) AS max_unt_sold
FROM Sales
-------------------------------------------------------------------------------------
--11)How many products were sold in each category?
SELECT 
	Category,
	SUM(QuantitySold) AS tot_sold_per_cat
FROM Sales
GROUP BY Category
-------------------------------------------------------------------------------------
--12)What is the total revenue for each region?
SELECT
	Region,
	SUM(QuantitySold * UnitPrice) AS tot_revenue_per_region
FROM Sales
GROUP BY Region
------------------------------------------------------------------------------------
--13)Which product generated the highest total revenue?
;WITH cte AS(
	SELECT 
		[Product],
		SUM(QuantitySold * UnitPrice) AS tot_revenue
	FROM Sales
	GROUP BY [Product]
)
SELECT TOP 1 [Product] FROM cte
ORDER BY tot_revenue DESC
-------------------------------------------------------------------------------------
--14)Compute the running total of revenue ordered by sale date.
SELECT *,
SUM(QuantitySold * UnitPrice) OVER(ORDER BY Saledate) AS running_total
FROM Sales
--------------------------------------------------------------------------------------
--15)How much does each category contribute to total sales revenue?
;WITH cte AS(
	SELECT *,
	SUM(QuantitySold * UnitPrice) OVER(PARTITION BY Category) AS tot_rev_per_cat,
	SUM(QuantitySold * UnitPrice) OVER() AS tot_rev
	FROM Sales
)
SELECT *,
CAST((tot_rev_per_cat * 100/tot_rev) AS DECIMAL(10,2)) AS each_cat_contribute 
FROM cte
-------------------------------------------------------------------------------------------
--17)Show all sales along with the corresponding customer names
SELECT 
Customers.CustomerName,
Sales.*
FROM Customers
INNER JOIN Sales
ON Customers.CustomerID = Sales.CustomerID
----------------------------------------------------------------------------------
--18)List customers who have not made any purchases
SELECT 
	CustomerName
FROM Customers
WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales)
----------------------------------------------------------------------------------
--19)Compute total revenue generated from each customer
SELECT
	Customers.CustomerID,
	Customers.CustomerName,
	SUM(QuantitySold * UnitPrice) AS tot_revenue
FROM Sales
INNER JOIN Customers
ON Sales.CustomerID = Customers.CustomerID
GROUP BY Customers.CustomerID,Customers.CustomerName
--------------------------------------------------------------------------------------
--20)Find the customer who has contributed the most revenue
;WITH cte AS(
	SELECT 
	Customers.CustomerName,
	Sales.*,
	SUM(QuantitySold * UnitPrice) OVER(PARTITION BY Sales.CustomerID) AS tot_revenue_per_cust 
	FROM Sales
	INNER JOIN Customers
	ON Sales.CustomerID = Customers.CustomerID
)
SELECT TOP 1 *
FROM cte
ORDER BY tot_revenue_per_cust DESC
--------------------------------------------------------------------------------------------------------
--21)Calculate the total sales per customer
SELECT 
	CustomerName,
	tot_sale
FROM Customers
INNER JOIN (
	SELECT 
		CustomerID,
		SUM(QuantitySold * UnitPrice) AS tot_sale
	FROM Sales
	GROUP BY CustomerID) AS tot_sale_per_cust
ON Customers.CustomerID = tot_sale_per_cust.CustomerID
-----------------------------------------------------------------------------------------
--22)List all products that have been sold at least once
SELECT 
	ProductName
FROM Products
WHERE ProductName IN (SELECT [PRODUCT] FROM Sales)
---------------------------------------------------------------------------------
--23)Find the most expensive product in the Products table
SELECT TOP 1
	ProductID,
	ProductName,
	Category,
	SellingPrice
FROM Products
ORDER BY SellingPrice DESC
----------------------------------------------------------------------------------
--24)Find all products where the selling price is higher than the average selling price in their category
;WITH cte AS(
	SELECT
		ProductID,
		ProductName,
		Category,
		SellingPrice,
		AVG(SellingPrice) OVER(PARTITION BY Category) AS avg_selling_price_per_cat
	FROM Products
)
SELECT * FROM cte
WHERE SellingPrice > avg_selling_price_per_cat
-----------------------------------------------------------------------------------------------