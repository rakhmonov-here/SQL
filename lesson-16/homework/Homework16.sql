--Homework. Lesson 16
--Easy Tasks
--1)Create a numbers table using a recursive query from 1 to 1000.

; WITH cte AS(
SELECT 1 AS num
UNION ALL
SELECT num+1 AS num FROM cte
WHERE num<1000
)
SELECT * FROM cte
OPTION (maxrecursion 1000)

--2)Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT * FROM Employees
INNER JOIN
(
SELECT EmployeeID,
SUM(SalesAmount) AS tot_sales  --Derived table orqali har bir employee uchun umumiy savdo qiymati topildi.
FROM Sales					   
GROUP BY EmployeeID
) AS tot_sales_per_cust
ON Employees.EmployeeID = tot_sales_per_cust.EmployeeID

--3)Create a CTE to find the average salary of employees.(Employees)

; WITH cte AS (
SELECT 
AVG(salary) AS avg_salary
FROM Employees
)
SELECT * FROM cte

--4)Write a query using a derived table to find the highest sales for each product.(Sales, Products)

SELECT * FROM Products
INNER JOIN 
(
SELECT ProductID,
MAX(SalesAmount) AS max_sales     --Derived table orqali har bir mahsulot uchun eng yuqori savdo qiymati topildi.
FROM Sales
GROUP BY ProductID) AS highest_sales
ON Products.ProductID=highest_sales.ProductID

/*5)Beginning at 1, write a statement to double the number for each record, the max value you get should be 
less than 1000000.*/

; WITH cte AS(
SELECT 1 AS num
UNION ALL
SELECT num*2 AS num FROM cte
WHERE num*2<=1000000
)
SELECT * FROM cte

--6)Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

;WITH cte AS(
SELECT EmployeeID,
COUNT(*) AS tot_sales
FROM Sales
GROUP BY EmployeeID
)
SELECT Employees.FirstName, 
Employees.LastName,cte.tot_sales
FROM cte
INNER JOIN Employees
ON cte.EmployeeID=Employees.EmployeeID
WHERE tot_sales>5

--7)Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

;WITH cte AS (
SELECT ProductID,
SalesAmount FROM Sales
WHERE SalesAmount>500)
SELECT cte.ProductID, cte.SalesAmount
FROM cte
INNER JOIN Products
ON cte.ProductID=Products.ProductID

--8)Create a CTE to find employees with salaries above the average salary.(Employees)
;WITH cte AS(
SELECT
AVG(Salary) AS avg_salary
FROM Employees
)
SELECT Employees.EmployeeID, Employees.Salary
FROM Employees
INNER JOIN cte
ON Employees.Salary>cte.avg_salary
-----------------------------------------------------------------------------------------------------------
--Medium Tasks
--1)Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

SELECT TOP 5 * FROM Employees
INNER JOIN
(SELECT EmployeeID, 
COUNT(salesid) AS Num_ord
FROM Sales
GROUP BY EmployeeID) AS num_ord_each_emp
ON Employees.EmployeeID=num_ord_each_emp.EmployeeID

--2)Write a query using a derived table to find the sales per product category.(Sales, Products)

SELECT Products.CategoryID,
SUM(Sales_amt.SalesAmount) AS sales
FROM ( 
SELECT ProductId, SalesAmount
FROM Sales) AS Sales_amt
INNER JOIN Products
ON Products.ProductID=Sales_amt.ProductID
GROUP BY Products.CategoryID

--3)Write a script to return the factorial of each value next to it.(Numbers1)
WITH CTE AS (
SELECT number,
number AS n,
1 AS fact
FROM Numbers1
WHERE number > 0
UNION ALL
SELECT CTE.number,
n - 1,
fact * n
FROM CTE
WHERE n > 1
)
SELECT number,
MAX(fact) AS Factorial
FROM CTE
GROUP BY number
ORDER BY number;

--4)This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

;WITH cte AS (
SELECT ID,
1 AS checker,
SUBSTRING(string,1,1) AS letter,
String
FROM Example
UNION ALL
SELECT  ID,
checker+1,
SUBSTRING(string,checker+1,1),
string
FROM cte
WHERE checker+1<=LEN(String)
) 
SELECT ID,letter FROM cte
ORDER BY ID

--5)Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
WITH MonthlySales AS (
SELECT 
FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
SUM(SalesAmount) AS TotalSales
FROM Sales
GROUP BY FORMAT(SaleDate, 'yyyy-MM')
),
MonthlyDiff AS (
SELECT SaleMonth,
TotalSales,
LAG(TotalSales) OVER (ORDER BY SaleMonth) AS PrevMonthSales
FROM MonthlySales
)
SELECT 
SaleMonth,
TotalSales,
PrevMonthSales,
TotalSales - ISNULL(PrevMonthSales, 0) AS SalesDifference
FROM MonthlyDiff

----------------------------------------------------------------------------------------------------------------
--Difficult Tasks
--1)This script uses recursion to calculate Fibonacci numbers
;WITH Fibonacci AS (
SELECT 0 AS PrevN, 1 AS N
UNION ALL
SELECT N, PrevN + N
FROM Fibonacci
WHERE N < 1000000000
)
SELECT PrevN AS Fibonacci
FROM Fibonacci

--2)Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT FindSameCharacters.* FROM FindSameCharacters
INNER JOIN
(
SELECT id,
REPLACE(Vals,SUBSTRING(Vals,1,1),'') AS not_same 
FROM FindSameCharacters) AS same_char
ON FindSameCharacters.Id=same_char.Id
WHERE LEN(Vals) > 1 AND LEN(REPLACE(Vals,SUBSTRING(Vals,1,1),'') )=0

/*3)Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the 
next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345) */

DECLARE @n INT = 5

;WITH cte AS (
SELECT 1 AS num,
CAST('1' AS VARCHAR(MAX)) AS int_to_str
UNION ALL
SELECT num+1,
int_to_str + CAST(num+1 AS VARCHAR)
FROM cte
WHERE num+1<=@n
)
SELECT int_to_str
FROM cte

/*4)Write a query using a derived table to find the employees who have made the most sales in the 
last 6 months.(Employees,Sales)*/

SELECT 
MAX(Tot_sales) AS most_sales
FROM employees
INNER JOIN 
(
SELECT employees.EmployeeID,
Employees.FirstName,
sum_sales.Tot_sales
FROM Employees
INNER JOIN (
SELECT EmployeeID, 
SUM(Sales.SalesAmount) AS Tot_sales
FROM Sales
WHERE SaleDate >= DATEADD(MONTH,-6,GETDATE())
GROUP BY EmployeeID
) AS sum_sales
ON Employees.EmployeeID=sum_sales.EmployeeID
) AS most_sales_6month
ON Employees.EmployeeID=most_sales_6month.EmployeeID

/*5)Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, 
remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)*/

DECLARE @pavanname INT=1
DECLARE @checker INT=1
DECLARE @temp_name VARCHAR(30)=''

WHILE @pavanname<=(SELECT MAX(pawanname) FROM RemoveDuplicateIntsFromNames) 
BEGIN
SET @temp_name=(SELECT Pawan_slug_name FROM RemoveDuplicateIntsFromNames WHERE PawanName=@pavanname)
    WHILE @checker<=LEN(@temp_name)
    BEGIN
      
        IF ASCII(SUBSTRING(@temp_name,@checker,1)) BETWEEN 48 AND 57
        BEGIN
        SET @temp_name=REPLACE(@temp_name,SUBSTRING(@temp_name,@checker,1),'')
        END
        ELSE 
        BEGIN
        SET @checker=@checker+1
        END
    END


UPDATE RemoveDuplicateIntsFromNames
SET Pawan_slug_name=@temp_name
WHERE PawanName=@pavanname
SET @pavanname=@pavanname+1
SET @checker=1
END

SELECT * FROM RemoveDuplicateIntsFromNames

