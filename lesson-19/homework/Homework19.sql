--Homework. Lesson 19
--Part 1: Stored Procedure Tasks
/*Task 1: Create a stored procedure that:
	Creates a temp table #EmployeeBonus
	Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
	(BonusAmount = Salary * BonusPercentage / 100)
	Then, selects all data from the temp table.*/

CREATE PROC usp_emp_bonus
AS
BEGIN
	CREATE TABLE #EmployeeBonus (
	EmployeeId INT,
	FullName VARCHAR(30),
	Department VARCHAR(30),
	Salary DECIMAL(10,2),
	BonusAmount DECIMAL(10,2)
	)
	
	INSERT INTO #EmployeeBonus (EmployeeId,FullName,Department,Salary,BonusAmount)
	SELECT 
	EmployeeID,
	CONCAT(FirstName,' ',LastName) AS FullName,
	Employees.Department,
	Salary,
	(Salary*BonusPercentage/100) AS BonusAmount
	FROM Employees
	INNER JOIN DepartmentBonus
	ON Employees.Department = DepartmentBonus.Department
	
	SELECT * FROM #EmployeeBonus
END
-----------------------------------------------------------------------------------------------------------
/*Task 2: Create a stored procedure that:
	Accepts a department name and an increase percentage as parameters
	Update salary of all employees in the given department by the given percentage
	Returns updated employees from that department.*/

CREATE PROC usp_upd_emp
@Department VARCHAR(30),
@IncreasePercentage INT
AS
BEGIN
	UPDATE Employees
	SET Salary = Salary + (Salary * @IncreasePercentage/100)
	WHERE Department = @Department

	SELECT * FROM Employees
	WHERE Department = @Department
END
-----------------------------------------------------------------------------------------------------------------
--Part 2: MERGE Tasks
/*Task 3: Perform a MERGE operation that:
	Updates ProductName and Price if ProductID matches
	Inserts new products if ProductID does not exist
	Deletes products from Products_Current if they are missing in Products_New
	Return the final state of Products_Current after the MERGE.*/

MERGE INTO Products_Current AS TARGET
USING Products_New AS SOURCE
ON TARGET.ProductID = SOURCE.ProductID

--Updates ProductName and Price if ProductID matches
WHEN MATCHED THEN
	 UPDATE SET TARGET.ProductName = SOURCE.ProductName,
				TARGET.Price = SOURCE.Price

--Inserts new products if ProductID does not exist
WHEN NOT MATCHED THEN
INSERT (ProductID,ProductName,Price) VALUES (SOURCE.ProductID,SOURCE.ProductName,SOURCE.Price)

--Deletes products from Products_Current if they are missing in Products_New
WHEN NOT MATCHED BY SOURCE THEN
DELETE;
--------------------------------------------------------------------------------------------------------------
/*Task 4: Tree Node
	Each node in the tree can be one of three types:
	"Leaf": if the node is a leaf node.
	"Root": if the node is the root of the tree.
	"Inner": If the node is neither a leaf node nor a root node.
Write a solution to report the type of each node in the tree. */

SELECT
id,
CASE 
	WHEN p_id IS NULL THEN 'Root'
	WHEN id IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Inner'
	ELSE 'Leaf'
END AS type
FROM Tree
ORDER BY id
---------------------------------------------------------------------------------------------------------------
/*Task 5:Confirmation Rate
	Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.*/
	
;WITH cte AS (
	SELECT 
	signups.[user_id],
	COUNT([action]) AS all_actions,
	SUM(CASE WHEN [action] = 'confirmed' THEN 1 ELSE 0 END) AS confirmed_action 
	FROM Signups
	LEFT JOIN Confirmations
	ON Signups.[user_id] = Confirmations.[user_id]
	GROUP BY Signups.[user_id]
	)
SELECT 
[user_id],
CASE 
	WHEN confirmed_action = 0 THEN 0
	ELSE confirmed_action * 100 / all_actions
END AS Confirmation_Rate
FROM cte

----------------------------------------------------------------------------------------------------------------
--Task 6: Find employees with the lowest salary

SELECT * FROM Employees
WHERE Salary = (SELECT MIN(Salary) FROM Employees)
---------------------------------------------------------------------------------------------------------------
/*Task 7: Get Product Sales Summary
	Create a stored procedure called GetProductSalesSummary that:
	
	Accepts a @ProductID input
	Returns:
	ProductName
	Total Quantity Sold
	Total Sales Amount (Quantity × Price)
	First Sale Date
	Last Sale Date
	If the product has no sales, return NULL for quantity, total amount, first date, and last date, but 
	still return the product name.*/

CREATE PROC GetProductSalesSummary
@ProductID INT
AS
BEGIN
	SELECT 
	ProductName,
	SUM(Quantity) AS TotalQuantitySold,
	SUM(Price * Quantity) AS TotalSalesAmount,
	MIN(SaleDate) AS FirstSaleDate,
	MAX(Saledate) AS LastSaleDate
	FROM Products
	LEFT JOIN Sales
	ON Products.ProductID = Sales.ProductID
	WHERE Products.ProductID = @ProductID
	GROUP BY ProductName
END