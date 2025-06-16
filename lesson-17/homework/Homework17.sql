--Homework. Lesson 17
/*1)You must provide a report of all distributors and their sales by region. If a distributor did not have 
any sales for a region, rovide a zero-dollar value for that day. Assume there is at least one sale 
for each region*/

;WITH regions AS (
SELECT DISTINCT Region FROM #RegionSales),
distributors AS (
SELECT DISTINCT Distributor FROM #RegionSales),
New_reg_sales AS (
SELECT Region,Distributor FROM regions
CROSS JOIN distributors)
SELECT New_reg_sales.Region,
New_reg_sales.Distributor,
SUM(COALESCE(Sales,0)) AS Sales
FROM New_reg_sales
LEFT JOIN #RegionSales
ON New_reg_sales.Distributor=#RegionSales.Distributor AND New_reg_sales.Region=#RegionSales.Region
GROUP BY New_reg_sales.Region, New_reg_sales.Distributor
ORDER BY New_reg_sales.Region

---------------------------------------------------------------------------------------------------------------
--2)Find managers with at least five direct reports

;WITH cte AS (
SELECT managerid,
COUNT(*) AS num_reports
FROM Employee
WHERE managerid IS NOT NULL
GROUP BY managerid
HAVING COUNT(*) >= 5)
SELECT [name] FROM cte
INNER JOIN Employee
ON cte.managerid = Employee.id

---------------------------------------------------------------------------------------------------------------
/*3)Write a solution to get the names of products that have at least 100 units ordered in February 2020 
and their amount. */

SELECT 
Products.product_name,
tot_orders.tot_unit
FROM Products
INNER JOIN (
SELECT product_id,
SUM(unit) AS tot_unit
FROM Orders
WHERE YEAR(order_date) = 2020 AND MONTH(order_date) = 2
GROUP BY product_id
HAVING SUM(unit)>=100) AS tot_orders
ON Products.product_id=tot_orders.product_id
----------------------------------------------------------------------------------------------------------------
--4)Write an SQL statement that returns the vendor from which each customer has placed the most orders

;WITH cte AS (
SELECT *,
(SELECT 
SUM([Count]) AS tot_count 
FROM Orders AS ord1 
WHERE ord1.CustomerID=ord2.CustomerID AND ord1.Vendor=ord2.Vendor) AS tot_orders
FROM Orders AS ord2)
SELECT DISTINCT CustomerID, Vendor FROM cte
WHERE tot_orders = (SELECT MAX(tot_orders) FROM cte AS cte1 WHERE cte.CustomerID=cte1.CustomerID)
-----------------------------------------------------------------------------------------------------------------
/*5)You will be given a number as a variable called @Check_Prime check if this number is prime then return 
'This number is prime' else eturn 'This number is not prime' */


-----------------------------------------------------------------------------------------------------------------
/*6) Write an SQL query to return the number of locations,in which location most signals sent, and total 
number of signal for each device from the given table. */

;WITH cte AS (
SELECT*,
(SELECT COUNT(Locations) AS tot_loc FROM Device AS Dev2
WHERE Dev1.Device_id=Dev2.Device_id AND Dev1.Locations=Dev2.Locations ) AS num_loc
FROM Device AS Dev1)
SELECT DISTINCT cte.Device_id,
no_dev.no_of_locations,
Locations AS max_signal_locations,
no_dev.no_of_signals
FROM cte
INNER JOIN (
SELECT Device_id,COUNT(DISTINCT Locations) AS no_of_locations,
COUNT(Locations) AS no_of_signals
FROM Device
GROUP BY Device_id) AS no_dev
ON cte.Device_id=no_dev.Device_id
WHERE num_loc = (SELECT MAX(num_loc) AS max_loc FROM cte AS cte1 WHERE cte.Device_id=cte1.Device_id)
----------------------------------------------------------------------------------------------------------------
/*7)Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
Return EmpID, EmpName,Salary in your output */

;WITH cte AS (
SELECT DeptID,
AVG(Salary) AS avg_salary
FROM Employee
GROUP BY DeptID
)
SELECT Employee.EmpID,
Employee.EmpName,
Employee.Salary
FROM cte
INNER JOIN Employee
ON cte.DeptID=Employee.DeptID
WHERE Employee.Salary>cte.avg_salary
-----------------------------------------------------------------------------------------------------------------
/*8)You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a 
table of each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. 
If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.*/

;WITH cte AS(
SELECT *
FROM Tickets
LEFT JOIN Winning_numbers
ON Tickets.Number=Winning_numbers.Number)
SELECT * FROM cte

;WITH cte AS (
SELECT TicketID,
COUNT(Winning_numbers.Number) AS tot_num
FROM Tickets
LEFT JOIN Winning_numbers
ON Tickets.Number=Winning_numbers.Number
GROUP BY Tickets.TicketID)
SELECT
SUM(CASE 
	WHEN tot_num = 3 THEN 100
	WHEN tot_num <> 0 THEN 10
	ELSE 0
END) AS Winnings
FROM cte
---------------------------------------------------------------------------------------------------------------
/*9)Write an SQL query to find the total number of users and the total amount spent using mobile only,
desktop only and both mobile and desktop together for each date.*/

;WITH cte AS (
SELECT 
[User_id],
Spend_date,
MAX(CASE 
		WHEN [platform] ='Mobile' THEN 1 ELSE 0
	END) AS Mobile_pf,
MAX(CASE
		WHEN [platform] = 'Desktop' THEN 1 ELSE 0
	END) AS Desktop_pf,
SUM(Amount) AS tot_amount
FROM Spending
GROUP BY [User_id],Spend_date),
result AS (
SELECT spend_date,
CASE
	WHEN Mobile_pf = 1 AND Desktop_pf = 1 THEN 'Both'
	WHEN Mobile_pf = 1 AND Desktop_pf = 0 THEN 'Mobile'
	ELSE 'Desktop'
END AS [Platform]
FROM cte)
select cte.Spend_date,
result.[platform],
cte.tot_amount,
COUNT(*) AS Total_users
from cte
INNER JOIN result
ON cte.Spend_date=result.spend_date
GROUP BY cte.Spend_date,
result.[platform],
cte.tot_amount
ORDER BY Spend_date
-----------------------------------------------------------------------------------------------------------------
--10)Write an SQL Statement to de-group the following data.

;WITH cte AS (
SELECT [Product],Quantity, 1 AS num
FROM Grouped
UNION ALL
SELECT [Product],Quantity, num+1
FROM cte
WHERE num+1<=Quantity)
SELECT [product],Quantity FROM cte
ORDER BY [Product]