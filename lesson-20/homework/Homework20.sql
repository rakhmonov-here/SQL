--Homework. Lesson 20.
--1)Find customers who purchased at least one item in March 2024 using EXISTS

SELECT 
CustomerName,
SaleDate
FROM #Sales AS a
WHERE EXISTS (SELECT SaleDate FROM #Sales AS b WHERE a.CustomerName = b.CustomerName AND b.SaleDate >= '2024/03/01' AND b.SaleDate <'2024/03/31')
---------------------------------------------------------------------------------------------------------------

--2)Find the product with the highest total sales revenue using a subquery.

SELECT TOP 1 WITH TIES [Product]
FROM (
SELECT 
[Product],
SUM(Quantity*Price) AS tot_sales_revenue
FROM #Sales
GROUP BY [Product]
) AS Sales_with_revenue
ORDER BY tot_sales_revenue DESC
-----------------------------------------------------------------------------------------------------------------

--3)Find the second highest sale amount using a subquery
;WITH cte AS
(SELECT [Product],
(Quantity * Price) AS SaleAmount
FROM #Sales
)
SELECT 
TOP 1 [Product],
SaleAmount
FROM cte
WHERE SaleAmount < (SELECT MAX(SaleAmount) FROM cte)
ORDER BY SaleAmount DESC
----------------------------------------------------------------------------------------------------------------

--4)Find the total quantity of products sold per month using a subquery

SELECT 
DISTINCT FORMAT(saleDate, 'yyyy-MMM') AS sale_month,
(
SELECT SUM(s.quantity)
FROM #Sales s
WHERE FORMAT(s.SaleDate, 'yyyy-MMM') = FORMAT(#Sales.SaleDate, 'yyyy-MMM')
) AS total_quantity
FROM #Sales
---------------------------------------------------------------------------------------------------------------

--5)Find customers who bought same products as another customer using EXISTS

SELECT 
CustomerName,
[Product]
FROM #Sales
WHERE EXISTS (SELECT 1 FROM #Sales AS s1 WHERE s1.CustomerName <> #Sales.CustomerName AND s1.[Product] = #Sales.[Product] )
ORDER BY [Product]
-----------------------------------------------------------------------------------------------------------------

--6)Return how many fruits does each person have in individual fruit level

	SELECT [Name],
	SUM(CASE WHEN Fruit = 'Apple' THEN 1 ELSE 0 END) AS Apple,
	SUM(CASE WHEN Fruit = 'Orange' THEN 1 ELSE 0 END) AS Orange,
	SUM(CASE WHEN Fruit = 'Banana' THEN 1 ELSE 0 END) AS Banana	
	FROM Fruits
	GROUP BY [Name]
-----------------------------------------------------------------------------------------------------

--7)Return older people in the family with younger ones

WITH cte AS (
    SELECT ParentId AS PID, ChildID AS CHID
    FROM Family
    UNION ALL
    SELECT cte.PID, f.ChildID
    FROM cte
    JOIN Family f ON cte.CHID = f.ParentId
)
SELECT *
FROM cte
ORDER BY PID, CHID
-----------------------------------------------------------------------------------------------------
/*8)Write an SQL statement given the following requirements. For every customer that had a 
delivery to California, provide a result set of the customer orders that were delivered to Texas*/

SELECT *
FROM #Orders
WHERE DeliveryState = 'TX'
AND CustomerID IN (
SELECT 
DISTINCT CustomerID
FROM #Orders
WHERE DeliveryState = 'CA'
)
------------------------------------------------------------------------------------------------------

--9)Insert the names of residents if they are missing

SELECT *,
CASE 
	WHEN CHARINDEX('name=',[address]) = 0 THEN STUFF([address],CHARINDEX('age=',[address])-1,0,CONCAT(' name=',fullname))
	ELSE [address]
END AS address_edited
FROM #residents
------------------------------------------------------------------------------------------------------

/*10)Write a query to return the route to reach from Tashkent to Khorezm. The result should 
include the cheapest and the most expensive routes*/

;WITH cte AS(
SELECT CONCAT_WS('-',first_city.DepartureCity,first_city.ArrivalCity,second_city.ArrivalCity,third_city.ArrivalCity,fourth_city.ArrivalCity) AS Road_map,
ISNULL(first_city.Cost,0)+ISNULL(second_city.Cost,0)+ISNULL(third_city.Cost,0)+ISNULL(fourth_city.cost,0) AS Total_cost
FROM (SELECT * FROM #Routes WHERE DepartureCity='Tashkent') AS first_city
LEFT JOIN #Routes AS second_city
ON first_city.ArrivalCity=second_city.DepartureCity
LEFT JOIN #Routes AS third_city
ON second_city.ArrivalCity=third_city.DepartureCity
LEFT JOIN #Routes AS fourth_city
ON third_city.ArrivalCity=fourth_city.DepartureCity
)
SELECT * FROM cte
WHERE Total_cost=(SELECT MIN(total_cost) FROM cte) OR Total_cost=(SELECT MAX(total_cost) FROM cte)
--------------------------------------------------------------------------------------------------------------
--11)Rank products based on their order of insertion.
CREATE TABLE #RankingPuzzle
(
     ID INT
    ,Vals VARCHAR(10)
)

 
INSERT INTO #RankingPuzzle VALUES
(1,'Product'),
(2,'a'),
(3,'a'),
(4,'a'),
(5,'a'),
(6,'Product'),
(7,'b'),
(8,'b'),
(9,'Product'),
(10,'c')

SELECT *,
ROW_NUMBER() OVER(ORDER BY ID) AS insertion
FROM #RankingPuzzle
-----------------------------------------------------------------------------------------------------------------

--12)Find employees whose sales were higher than the average sales in their department

;WITH cte AS(
SELECT Department,
AVG(SalesAmount) AS avg_sales
FROM #EmployeeSales
GROUP BY Department
)
SELECT 
emp.EmployeeName,
emp.Department,
emp.SalesAmount
FROM cte
INNER JOIN #EmployeeSales AS emp
ON cte.Department = emp.Department
WHERE emp.SalesAmount > avg_sales
----------------------------------------------------------------------------------------------------------------
--13)Find employees who had the highest sales in any given month using EXISTS

SELECT DISTINCT e1.EmployeeID, e1.EmployeeName, e1.SalesMonth, e1.SalesYear, e1.SalesAmount
FROM #EmployeeSales e1
WHERE NOT EXISTS (
SELECT 1 FROM #EmployeeSales e2
WHERE e2.SalesMonth = e1.SalesMonth AND e2.SalesYear = e1.SalesYear AND e2.EmployeeID <> e1.EmployeeID
AND e2.SalesAmount > e1.SalesAmount
)
-----------------------------------------------------------------------------------------------------------------
--14)Find employees who made sales in every month using NOT EXISTS

SELECT DISTINCT e1.EmployeeID, e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT 1
    FROM (
        SELECT DISTINCT SalesMonth
        FROM #EmployeeSales
    ) AS AllMonths)
-------------------------------------------------------------------------------------------------------------------
--15)Retrieve the names of products that are more expensive than the average price of all products.

CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

;WITH cte AS
(SELECT *,
AVG(Price) OVER() AS avg_price
FROM Products)
SELECT * FROM cte
WHERE Price > avg_price
------------------------------------------------------------------------------------------------------------------
--16)Find the products that have a stock count lower than the highest stock count.

;WITH cte AS (
SELECT *,
MAX(Stock) OVER() AS Max_stock
FROM Products)
SELECT * FROM cte
WHERE Stock < Max_stock
------------------------------------------------------------------------------------------------------------------
--17)Get the names of products that belong to the same category as 'Laptop'.

SELECT [name]
FROM Products
WHERE Category = (SELECT Category FROM Products WHERE [Name]='Laptop')
------------------------------------------------------------------------------------------------------------------
--18)Retrieve products whose price is greater than the lowest price in the Electronics category.

SELECT *,[name]
FROM Products
WHERE Price > (SELECT MIN(Price) FROM Products WHERE Category = 'Electronics')
------------------------------------------------------------------------------------------------------------------
--19) Find the products that have a higher price than the average price of their respective category.

;WITH cte AS(
SELECT *,
AVG(Price) OVER(PARTITION BY Category) AS avg_price_by_category
FROM Products)
SELECT * FROM cte
WHERE Price > avg_price_by_category
------------------------------------------------------------------------------------------------------------------
--20) Find the products that have a higher price than the average price of their respective category.

CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

;WITH cte AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY OrderDate) AS num_orders
FROM Orders)
SELECT ProductID,
OrderDate
FROM cte
WHERE num_orders >=1
------------------------------------------------------------------------------------------------------------------
--21)Retrieve the names of products that have been ordered more than the average quantity ordered.

;WITH cte AS(
SELECT ProductID,
AVG(Quantity) AS avg_quantity
FROM Orders
GROUP BY ProductID)
SELECT cte.ProductID FROM cte
INNER JOIN Orders
ON cte.ProductID = Orders.ProductID
WHERE Orders.Quantity > cte.avg_quantity
------------------------------------------------------------------------------------------------------------------
--22)Find the products that have never been ordered.

SELECT * FROM Products
WHERE ProductID NOT IN (SELECT ProductID FROM Orders)
------------------------------------------------------------------------------------------------------------------
--23)Retrieve the product with the highest total quantity ordered.

SELECT * FROM Orders
WHERE Quantity = (SELECT MAX(Quantity) FROM Orders
------------------------------------------------------------------------------------------------------------------
