--Homework. Lesson 18
/*1) Create a temporary table named MonthlySales to store the total quantity sold and total revenue for 
each product in the current month.*/

SELECT
Products.ProductID,
SUM(Sales.Quantity) AS TotalQuantity,
SUM(Sales.Quantity*Price) AS TotalRevenue
INTO #MonthlySales
FROM Products
INNER JOIN Sales
ON Products.ProductID = Sales.ProductID
WHERE MONTH(SaleDate) = MONTH(GETDATE())
GROUP BY Products.ProductID

-----------------------------------------------------------------------------------------------------------------
/*2)Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity 
across all time.*/ --Return: ProductID, ProductName, Category, TotalQuantitySold

CREATE VIEW vw_ProductSalesSummary AS (
SELECT 
Products.ProductID,
ProductName,
Category,
SUM(Quantity) AS TotalQuantitySold
FROM Products
INNER JOIN Sales
ON Products.ProductID = Sales.ProductID
GROUP BY Products.ProductID,ProductName,Category)
-----------------------------------------------------------------------------------------------------------------
--3)Create a function named fn_GetTotalRevenueForProduct(@ProductID INT).Return: total revenue for the given product ID

CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS TABLE AS
RETURN (
SELECT
Products.ProductID,
SUM(Sales.Quantity*Price) AS TotalRevenue
FROM Products
INNER JOIN Sales
ON Products.ProductID = Sales.ProductID
WHERE Products.ProductID = @ProductID
GROUP BY Products.ProductID)
-----------------------------------------------------------------------------------------------------------------
/*4)Create an function fn_GetSalesByCategory(@Category VARCHAR(50)).
Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.*/

CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE AS
RETURN (
SELECT 
ProductName,
SUM(Quantity) AS TotalQuantity,
SUM(Quantity * Price) AS TotalRevenue
FROM Products
INNER JOIN Sales
ON Products.ProductID = Sales.ProductID
WHERE Category = @Category
GROUP BY ProductName)
----------------------------------------------------------------------------------------------------------------
/*5)You have to create a function that get one argument as input from user and the function should 
return 'Yes' if the input number is a prime number and 'No' otherwise. */

CREATE FUNCTION dbo.fn_IsPrime (@Number INT)
RETURNS VARCHAR(3) AS 
BEGIN
DECLARE @checker INT = 2
WHILE @checker<@Number
BEGIN
	IF @number%@checker = 0
	RETURN 'No'
	SET @checker=@checker+1
END
	RETURN 'Yes'
END

SELECT dbo.fn_isPrime(10)
----------------------------------------------------------------------------------------------------------------
/*6) Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:*/

CREATE FUNCTION fn_GetNumbersBetween(@Start INT,@End INT)
RETURNS @Numbers TABLE (Numbers INT) AS
BEGIN
DECLARE @checker INT = @Start
WHILE @checker<=@End
	BEGIN 
	INSERT INTO @Numbers 
	VALUES (@checker)
	SET @checker = @checker + 1
	END
	RETURN
END

----------------------------------------------------------------------------------------------------------------
/*7)Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are 
fewer than N distinct salaries, return NULL. */

CREATE FUNCTION fn_GetNthHighestSalary (@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;

    SELECT @Result = Salary
    FROM (
        SELECT DISTINCT Salary, 
               DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM Employee
    ) AS RankedSalaries
    WHERE SalaryRank = @N;

    RETURN @Result;
END;

SELECT dbo.fn_GetNthHighestSalary(2) AS getNthHighestSalary;
----------------------------------------------------------------------------------------------------------------
/*8)Write a SQL query to find the person who has the most friends.
Return: Their id, The total number of friends they have.*/

CREATE VIEW all_friends AS(
SELECT *
FROM RequestAccepted AS a
UNION ALL
SELECT accepter_id,
requester_id,
accept_date
FROM RequestAccepted AS b)

;WITH cte AS (
SELECT
requester_id AS id,
COUNT(accepter_id) AS num
FROM all_friends
GROUP BY requester_id)
SELECT * FROM cte
WHERE num = (SELECT MAX(num) FROM cte)
----------------------------------------------------------------------------------------------------------------
--9)Create a View for Customer Order Summary.

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id),
    order_date DATE,
    amount DECIMAL(10,2)
);

-- Customers
INSERT INTO Customers (customer_id, name, city)
VALUES
(1, 'Alice Smith', 'New York'),
(2, 'Bob Jones', 'Chicago'),
(3, 'Carol White', 'Los Angeles');

-- Orders
INSERT INTO Orders (order_id, customer_id, order_date, amount)
VALUES
(101, 1, '2024-12-10', 120.00),
(102, 1, '2024-12-20', 200.00),
(103, 1, '2024-12-30', 220.00),
(104, 2, '2025-01-12', 120.00),
(105, 2, '2025-01-20', 180.00);

CREATE VIEW vw_CustomerOrderSummary AS

SELECT 
Customers.customer_id,
Customers.[name],
COUNT(order_id) AS TotalOrders,
SUM(amount) AS TotalAmount,
MAX(order_date) AS Last_order_date
FROM Customers
INNER JOIN Orders
ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.customer_id,Customers.[name]
-----------------------------------------------------------------------------------------------------------------
/*10)Write an SQL statement to fill in the missing gaps. You have to write only select statement, 
no need to modify the table.*/

SELECT RowNumber, (SELECT TOP 1 TestCase
FROM Gaps g2
WHERE g2.RowNumber<=g1.Rownumber AND g2.TestCase IS NOT NULL
ORDER BY g2.RowNumber  DESC) AS TestCase
FROM Gaps g1
ORDER BY g1.RowNumber

